//
//  UIViewController+HITabBar.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HITabBar)

- (void) setTabBarItemImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;
- (UIViewController *) hiddenBottomBarWhenPushed:(BOOL)yesOrNo;

@end
