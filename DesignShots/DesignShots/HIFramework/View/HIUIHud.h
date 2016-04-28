//
//  HIProgressHUD.h
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "MBProgressHUD.h"

@interface HIUIHud : MBProgressHUD

-(void) hide;

@end

@interface HIUIHudCenter : NSObject

+ (void)setDefaultMessageIcon:(UIImage *)image;
+ (void)setDefaultSuccessIcon:(UIImage *)image;
+ (void)setDefaultFailureIcon:(UIImage *)image;
+ (void)setDefaultBubble:(UIImage *)image;

- (HIUIHud *)showMessageHud:(NSString *)message inView:(UIView *)view;
- (HIUIHud *)showSuccessHud:(NSString *)message inView:(UIView *)view;
- (HIUIHud *)showFailureHud:(NSString *)message inView:(UIView *)view;
- (HIUIHud *)showLoadingHud:(NSString *)message inView:(UIView *)view;
- (HIUIHud *)showProgressHud:(NSString *)message inView:(UIView *)view;

@end
