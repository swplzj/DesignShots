//
//  UIViewController+HITabBar.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIViewController+HITabBar.h"

@implementation UIViewController (HITabBar)

-(void) setTabBarItemImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    // UITabBarItem只是一个载体,用来传递默认图与高亮图,然后在UITabBarController中取出
    UITabBarItem * item = [[UITabBarItem alloc]  initWithTitle:@"" image:image selectedImage:highlightedImage];
    self.tabBarItem = item;
}

-(UIViewController *) hiddenBottomBarWhenPushed:(BOOL)yesOrNo
{
    self.hidesBottomBarWhenPushed = yesOrNo;
    return self;
}

@end
