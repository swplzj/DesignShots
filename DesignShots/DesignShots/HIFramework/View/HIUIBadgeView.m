//
//  HIBadgeView.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIBadgeView.h"
#import "HIPrecompile.h"

@implementation HIUIBadgeView

- (id)initWithFrame:(CGRect)frame valueString:(NSString *)valueString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.valueString = valueString;
    }
    return self;
}

-(void) findBadgeWithValueString:(NSString *)valueString
{
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:nil tag:0];
    item.badgeValue = valueString;
    
    tabBar.items = @[item];
    
    NSArray * tabbarSubviews = tabBar.subviews;
    
    for (UIView * viewTab in tabbarSubviews) {
        
        for (UIView * subview in viewTab.subviews) {
            
            NSString * strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
            
            if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||
                [strClassName isEqualToString:@"_UIBadgeView"]) {
                //从原视图上移除
                [subview removeFromSuperview];
                self.badgeView = subview;
                break;
            }
        }
    }
}

-(void) setValueString:(NSString *)valueString
{
    if (_valueString == valueString) {
        return;
    }
    
    if (_badgeView) {
        HI_REMOVE_FROM_SUPERVIEW(_badgeView, YES);
    }
    
    if (self.hideWhenEmpty) {
        if (_valueString.length <= 0 || [_valueString isEqualToString:@"0"]) {
            return;
        }
    }
    
    [self findBadgeWithValueString:valueString];
    
    if (_badgeView) {
        _badgeView.frame = CGRectMake(0, 0, _badgeView.frame.size.width, _badgeView.frame.size.height);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _badgeView.frame.size.width, _badgeView.frame.size.height);
        [self addSubview:_badgeView];
    } else {
        ERROR(@"%@ 该类已不适用!",[self class]);
    }
    
    [self setKawaiiBubble:_kawaiiBubble];
}

-(void) setKawaiiBubble:(BOOL)kawaiiBubble
{
    _kawaiiBubble = kawaiiBubble;
    
    if (_kawaiiBubble) {
        [self setValueString:@" "];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    } else {
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }
}

@end
