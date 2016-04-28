//
//  HIUINavigationController.m
//  HIFramework
//
//  Created by lizhenjie on 4/7/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUINavigationController.h"
#import "HIPrecompile.h"
#import <QuartzCore/QuartzCore.h>

#define TOP_VIEW    [[UIApplication sharedApplication]keyWindow].rootViewController.view

@interface HIUINavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>
{
    CGPoint     startTouch;
    UIImageView *lastScreenShotView;
    UIView      *blackMask;
}

@property (nonatomic, strong) UIView            *backgroundView;
@property (nonatomic, strong) NSMutableArray    *screenShotsList;

@property (nonatomic, assign) BOOL isMoving;

@end


@implementation HIUINavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
        self.canDragBack = YES;
    }
    
    return self;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.screenShotsList.count == 0) {
        UIImage *capturedImage = [self capture];
        if (capturedImage) {
            [self.screenShotsList addObject:capturedImage];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBarTitleTextColor:HI_UINAVIGATIONBAR_DEFAULT_TITLE_COLOR shadowColor:HI_UINAVIGATIONBAR_DEFAULT_TITLE_SHADOW_COLOR];
    
    if (IOS7_OR_LATER) {
        if (HI_UINAVIGATIONBAR_DEFAULT_IMAGE_IOS7_LATER) {
//            [self setBarBackgroundImage:HI_UINAVIGATIONBAR_DEFAULT_IMAGE_IOS7_LATER];
        }
    } else {
        if (HI_UINAVIGATIONBAR_DEFAULT_IMAGE_IOS7_BEFORE) {
//            [self setBarBackgroundImage:HI_UINAVIGATIONBAR_DEFAULT_IMAGE_IOS7_BEFORE];
        }
    }
    
    if (IOS7_OR_LATER) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.delegate = self;
            self.delegate = self;
        }
    } else {
        
    }
    
    // 添加滑动手势
    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, TOP_VIEW.frame.size.height);
    [TOP_VIEW addSubview:shadowImageView];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];

    [self hideNavigationBarShadowLine];
}

// 隐藏导航栏下方的线条
- (void)hideNavigationBarShadowLine
{
    if ([self.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

- (void)setBarTitleTextColor:(UIColor *)color shadowColor:(UIColor *)shadowColor
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
    NSMutableDictionary *dictText = [NSMutableDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil];
#else
    NSMutableDictionary *dictText = [NSMutableDictionary dictionaryWithObjectsAndKeys:color, UITextAttributeTextColor, shadowColor, UITextAttributeTextShadowColor, NA_FONT(18), UITextAttributeFont, nil];
#endif
    
    [self.navigationBar setTitleTextAttributes:dictText];
}

- (void)setBarBackgroundImage:(UIImage *)image
{
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IOS7_OR_LATER) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IOS7_OR_LATER) {
        if ([self.viewControllers count] == 1) {

        }
    }
    
    UIImage *capturedImage = [self capture];
    
    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
    }
    
    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    
    if (IOS7_OR_LATER) {
        if ([self.viewControllers count] == 2) {

        }
    }
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(TOP_VIEW.bounds.size, TOP_VIEW.opaque, 0.0);
    [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)moveViewWithX:(float)x
{
//    x = x>320?320:x;
    x = x>SCREEN_WIDTH?SCREEN_WIDTH:x;

    x = x<0?0:x;
    
    CGRect frame = TOP_VIEW.frame;
    frame.origin.x = x;
    TOP_VIEW.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1 || !self.canDragBack)
        return NO;
    
    return YES;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack)
        return;
    
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    NSLog(@"%f",touchPoint.x);
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView) {
            CGRect frame = TOP_VIEW.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    } else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
//                [self moveViewWithX:320];
                [self moveViewWithX:SCREEN_WIDTH];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = TOP_VIEW.frame;
                frame.origin.x = 0;
                TOP_VIEW.frame = frame;
                
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        }
        
        return;
    } else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

@end
