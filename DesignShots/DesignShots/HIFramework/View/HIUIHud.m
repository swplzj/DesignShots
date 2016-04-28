//
//  HIProgressHUD.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIHud.h"
#import "HIPrecompile.h"

#define DEFAULT_TIMEOUT_SECONDS 2

@implementation HIUIHud

-(void) hide
{
    [self hide:YES];
}

@end

@interface HIUIHudCenter ()

@property (nonatomic, retain) UIImage *	bubble;
@property (nonatomic, retain) UIImage *	messageIcon;
@property (nonatomic, retain) UIImage *	successIcon;
@property (nonatomic, retain) UIImage *	failureIcon;


@end

@implementation HIUIHudCenter

+ (void)setDefaultMessageIcon:(UIImage *)image
{
    [HIUIHudCenter HIInstance].messageIcon = image;
}

+ (void)setDefaultSuccessIcon:(UIImage *)image
{
    [HIUIHudCenter HIInstance].successIcon = image;
}

+ (void)setDefaultFailureIcon:(UIImage *)image
{
    [HIUIHudCenter HIInstance].failureIcon = image;
}

+ (void)setDefaultBubble:(UIImage *)image
{
    [HIUIHudCenter HIInstance].bubble = image;
}

- (HIUIHud *)showMessageHud:(NSString *)message inView:(UIView *)view
{
    HIUIHud * hud = [HIUIHud showHUDAddedTo:view animated:YES];
    //hud.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"left_setting"]];

    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
    hud.mode = MBProgressHUDModeText;
//    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:DEFAULT_TIMEOUT_SECONDS];
    
    if (self.messageIcon) {
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.messageIcon];
        [imageView sizeToFit];
        hud.customView = imageView;
    }
    
    if (self.bubble) {
        hud.color = [UIColor colorWithPatternImage:self.bubble];
    }
    return hud;
}

- (HIUIHud *)showSuccessHud:(NSString *)message inView:(UIView *)view;
{
    HIUIHud * hud = [HIUIHud showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
    hud.mode = MBProgressHUDModeText;
//    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:DEFAULT_TIMEOUT_SECONDS];
    
    if (self.successIcon) {
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.successIcon];
        [imageView sizeToFit];
        hud.customView = imageView;
    }
    
    if (self.bubble) {
        hud.color = [UIColor colorWithPatternImage:self.bubble];
    }
    
    return hud;
}

- (HIUIHud *)showFailureHud:(NSString *)message inView:(UIView *)view
{
    HIUIHud * hud = [HIUIHud showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
    hud.mode = MBProgressHUDModeText;
//    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:DEFAULT_TIMEOUT_SECONDS];
    
    if (self.failureIcon) {
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.failureIcon];
        [imageView sizeToFit];
        hud.customView = imageView;
    }
    
    if (self.bubble) {
        hud.color = [UIColor colorWithPatternImage:self.bubble];
    }
    
    return hud;
}

- (HIUIHud *)showLoadingHud:(NSString *)message inView:(UIView *)view
{
    HIUIHud * hud = [HIUIHud showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.color = [UIColor clearColor];
    hud.opacity = 0.5;
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:60];

    UIImage *cycle = [UIImage imageNamed:@"common_loading_progress"];
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cycle.size.width, cycle.size.height)];
    UIImageView *cycleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cycle.size.width, cycle.size.height)];
    cycleImageView.image = cycle;
    [iconView addSubview:cycleImageView];
    
    CGSize iconSize = [UIImage imageNamed:@"common_loading_icon"].size;
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake((cycle.size.width - iconSize.width) / 2, (cycle.size.height - iconSize.height) / 2, iconSize.width, iconSize.height)];
    iconImage.image = [UIImage imageNamed:@"common_loading_icon"];
    [iconView addSubview:iconImage];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1000;
    
    [cycleImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    hud.customView = iconView;
    
    if (self.bubble) {
        hud.color = [UIColor colorWithPatternImage:self.bubble];
    }
    
    return hud;
}

- (HIUIHud *)showProgressHud:(NSString *)message inView:(UIView *)view
{
    HIUIHud * hud = [HIUIHud showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    if (self.bubble) {
        hud.color = [UIColor colorWithPatternImage:self.bubble];
    }
    
    return hud;
}

@end