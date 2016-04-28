//
//  UIApplication+HIPresentViewController.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (HIPresentViewController)

-(BOOL) presentViewController:(UIViewController *)viewController animated:(BOOL)animated;

-(BOOL) dismissModalViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
