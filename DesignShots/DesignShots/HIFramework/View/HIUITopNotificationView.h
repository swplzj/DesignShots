//
//  HIUITopNotificationView.h
//  HIFramework
//
//  Created by lizhenjie on 4/10/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HIUITopNotificationViewHeight 64.0f
#define HIUITopNotificationViewImageViewSidelength 40.0f
#define HIUITopNotificationViewDefaultShowDuration 2.0

typedef enum _HITopNotificationViewType {
    
    HITopNotificationViewTypeNone = 0,
    HITopNotificationViewTypeSuccess,
    HITopNotificationViewTypeError,
    
} HITopNotificationViewType;

@interface HIUITopNotificationView : UIView

@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, assign) float duration;

+ (HIUITopNotificationView *)showInView:(UIView *)view
                                   style:(HITopNotificationViewType)style
                                 message:(NSString *)message;

+ (HIUITopNotificationView *)showInView:(UIView *)view
                               tintColor:(UIColor*)tintColor
                                   image:(UIImage*)image
                                 message:(NSString*)message
                                duration:(NSTimeInterval)duration;

- (void) show;

@end