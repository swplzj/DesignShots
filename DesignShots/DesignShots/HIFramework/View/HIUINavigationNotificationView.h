//
//  HIUINavigationNotificationView.h
//  HIFramework
//
//  Created by lizhenjie on 4/10/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HIUINavigationGradientView;
@class HIUIImageView;


#define HIUINavigationNofiticationTapReceivedNotification @"HIUINavigationNofiticationTapReceivedNotification"

@interface HIUINavigationNotificationView : UIView

@property (nonatomic, strong) UILabel                       *textLabel;
@property (nonatomic, strong) UILabel                       *detailTextLabel;
@property (nonatomic, strong) UIImageView                   *imageView;
@property (nonatomic, strong) HIUINavigationGradientView    *contentView;

@property (nonatomic) NSTimeInterval duration;

+ (HIUINavigationNotificationView *) notifyWithText:(NSString*)text
                                              detail:(NSString*)detail
                                               image:(UIImage*)image
                                         andDuration:(NSTimeInterval)duration;

+ (HIUINavigationNotificationView *) notifyWithText:(NSString*)text
                                              detail:(NSString*)detail
                                         andDuration:(NSTimeInterval)duration;

+ (HIUINavigationNotificationView *) notifyWithText:(NSString*)text
                                           andDetail:(NSString*)detail;

@end
