//
//  HIUINavigationController.h
//  HIFramework
//
//  Created by lizhenjie on 4/7/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIUINavigationController : UINavigationController

/**
 *  @author lizhenjie, 15-04-13
 *
 *  是否支持右滑返回，默认为YES
 */
@property (nonatomic,assign) BOOL canDragBack;

@property (nonatomic, assign, getter=isTransitionInProgress) BOOL transitionInProgress;

- (void)setBarTitleTextColor:(UIColor *)color shadowColor:(UIColor *)shadowColor;

- (void)setBarBackgroundImage:(UIImage *)image;

@end
