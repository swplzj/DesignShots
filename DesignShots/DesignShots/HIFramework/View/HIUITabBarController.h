//
//  HIUITabBarController.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIPrecompile.h"

@interface HIUITabBarController : UITabBarController

@property (nonatomic, retain) HIUITabBar * bar;
@property (nonatomic, assign) NSUInteger lastSelectIndex;
@property (nonatomic, retain) NSArray * cantChangeViewControllerIndexs;

-(CGRect) tabBarControllerSetItemFrame:(HIUITabBarItem *)item;

-(void) handleTabBarItemClick:(HIUITabBarItem *)item;

@end
