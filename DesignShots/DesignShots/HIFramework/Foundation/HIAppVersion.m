//
//  HIAppVersion.m
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIAppVersion.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#pragma mark -

static NSString *const appVersionAppLookupURLFormat = @"http://itunes.apple.com/%@/lookup";

#pragma mark -

@implementation NSString(HIAppVersion)

- (NSComparisonResult)compareVersion:(NSString *)version
{
    return [self compare:version options:NSNumericSearch];
}

- (NSComparisonResult)compareVersionDescending:(NSString *)version
{
    switch ([self compareVersion:version])
    {
        case NSOrderedAscending:
        {
            return NSOrderedDescending;
        }
        case NSOrderedDescending:
        {
            return NSOrderedAscending;
        }
        default:
        {
            return NSOrderedSame;
        }
    }
}

@end

#pragma mark -

@interface HIAppVersion ()
{
    HIUINavigationNotificationView * notificationView;
    AFHTTPRequestOperation *checkUpdateVersionRequestOperation;
}

@property (assign, nonatomic) BOOL isForceUpdate; // 是否为强制更新：NO：两个按钮；YES：确认更新

@end

#pragma mark -

@implementation HIAppVersion


-(void) dealloc
{
    self.checkFinishBlock = nil;
    self.updateButtonClickBlock = nil;
    [self unobserveNotification:HIUINavigationNofiticationTapReceivedNotification];
}

-(HIAppVersion *) init
{
    HI_SUPER_INIT({
        
        self.applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        if ([self.applicationVersion length] == 0) {
            self.applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        }
        
        self.appStoreCountry = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        
        self.autoPresentedUpdateAlert = YES;
        
        self.hasNewVersion = NO;
        self.theNewVersionDetails = nil;
        self.theNewVersionNumber = nil;
        self.theNewVersionURL = nil;
        
        self.alertStyle = HI_APPVERSION_ALERT_STYLE_ALERT;
        self.updateButtonTitle = @"立即升级";
        self.cancelButtonTitle = @"暂不升级";
        
        [self observeNotification:HIUINavigationNofiticationTapReceivedNotification];
    });
}

+(void) checkForNewVersion
{
    [[HIAppVersion HIInstance] checkForNewVersion];
}

-(void) checkForNewVersion
{
    if ([checkUpdateVersionRequestOperation isExecuting]) {
        [checkUpdateVersionRequestOperation cancel];
        checkUpdateVersionRequestOperation = nil;
    }
    
}

-(void) showNewVersionUpdateAlert
{
    if (!self.hasNewVersion) {
        return;
    }
    
    if (self.alertStyle == HI_APPVERSION_ALERT_STYLE_ALERT) {
        HIUIAlertView *alertView;
        __block HIAppVersion * nRetainSelf = self;
        
        if (self.isForceUpdate) {
            alertView = [HIUIAlertView showAlertWithTitle:HI_NSSTRING_FORMAT(@"%@:%@", @"发现新版本",self.theNewVersionNumber)
                                                  message:self.theNewVersionDetails
                                              cancelTitle:@"取消"
                                               otherTitle:@"确认"
                                               completion:nil];
        } else {
            alertView = [HIUIAlertView showAlertWithTitle:HI_NSSTRING_FORMAT(@"%@:%@", @"发现新版本",self.theNewVersionNumber)
                                                  message:self.theNewVersionDetails
                                              cancelTitle:self.cancelButtonTitle
                                               otherTitle:self.updateButtonTitle
                                               completion:nil];
        }
        
        alertView.clickBlock = ^(BOOL cancel, NSInteger clickIndex){
            
            if (clickIndex == 0) {
                if (self.isForceUpdate) {
                    [nRetainSelf exitApplication];
                }
            } else {
                [nRetainSelf startUpdateAppNewerVersion];
            }
        };
        
    } else if (self.alertStyle == HI_APPVERSION_ALERT_STYLE_NOTIFICATION){
        
        notificationView = [HIUINavigationNotificationView notifyWithText:HI_NSSTRING_FORMAT(@"%@:%@", @"发现新版本", self.theNewVersionNumber) detail:self.theNewVersionDetails andDuration:5];
        
        [notificationView.imageView setImageWithURL:[NSURL URLWithString:self.theNewVersionIconURL]];
    }
}

- (void)startUpdateAppNewerVersion
{
    if (self.updateButtonClickBlock) {
        self.updateButtonClickBlock(self);
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.theNewVersionURL]];
    // 添加动画，优化在 iOS9 以上关闭应用黑屏问题
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}

#pragma mark -

-(void) handleNotification:(NSNotification *)notification
{
    if ([notification is:HIUINavigationNofiticationTapReceivedNotification] && notification.object == notificationView) {
        
        if (_updateButtonClickBlock) {
            _updateButtonClickBlock(self);
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.theNewVersionURL]];
    }
}

#pragma mark -

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    [self resizeAlertView:alertView];
}

- (void)resizeAlertView:(UIAlertView *)alertView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) &&
        [[UIDevice currentDevice].systemVersion floatValue] < 7.0f)
    {
        CGFloat max = alertView.window.bounds.size.height - alertView.frame.size.height - 10.0f;
        CGFloat offset = 0.0f;
        for (UIView *view in alertView.subviews)
        {
            CGRect frame = view.frame;
            if ([view isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)view;
                if ([label.text isEqualToString:alertView.message])
                {
                    label.lineBreakMode = NSLineBreakByWordWrapping;
                    label.numberOfLines = 0;
                    label.textAlignment = NSTextAlignmentLeft;
                    label.alpha = 1.0f;
                    [label sizeToFit];
                    offset = label.frame.size.height - frame.size.height;
                    frame.size.height = label.frame.size.height;
                    if (offset > max)
                    {
                        frame.size.height -= (offset - max);
                        offset = max;
                    }
                    if (offset > max - 10.0f)
                    {
                        frame.size.height -= (offset - max - 10);
                        frame.origin.y += (offset - max - 10) / 2.0f;
                    }
                }
            }
            else if ([view isKindOfClass:[UITextView class]])
            {
                view.alpha = 0.0f;
            }
            else if ([view isKindOfClass:[UIControl class]])
            {
                frame.origin.y += offset;
            }
            view.frame = frame;
        }
        CGRect frame = alertView.frame;
        frame.origin.y -= roundf(offset/2.0f);
        frame.size.height += offset;
        alertView.frame = frame;
    }else{
        ;
    }
}

#pragma mark -

//-------------------------------- 退出程序 -----------------------------------------//
- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0)
    {
       exit(0);
    }
}
@end
