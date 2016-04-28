//
//  HIUITabBar.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

@interface HIUITabBarItem : UIButton

+(HIUITabBarItem *) tabBarItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

-(void) setHighlighted:(BOOL)highlighted;

@end

#pragma mark -

@interface HIUITabBar : UIImageView

@property (nonatomic, retain) NSArray * items;
@property (nonatomic, assign) NSInteger	selectedIndex;

-(HIUITabBar *) initWithTabBarItems:(NSArray *)items;

@end