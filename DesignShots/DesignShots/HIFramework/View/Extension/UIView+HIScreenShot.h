//
//  UIView+HIScreenShot.h
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HIScreenShot)

@property (nonatomic, readonly) UIImage * screenshot;
@property (nonatomic, readonly) UIImage * screenshotOneLayer;

- (UIImage *)capture;
- (UIImage *)capture:(CGRect)area;

@end
