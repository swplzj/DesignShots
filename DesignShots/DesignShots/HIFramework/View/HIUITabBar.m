//
//  HIUITabBar.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUITabBar.h"
#import "HIPrecompile.h"

#define HI_UITabBar_Height 49.f

#pragma mark -

@interface HIUITabBarItem ()

@property (nonatomic,retain) UIImage * image;
@property (nonatomic,retain) UIImage * selectedImage;

@end

#pragma mark -

@implementation HIUITabBarItem

+(HIUITabBarItem *) tabBarItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;
{
    HIUITabBarItem * item = [[HIUITabBarItem alloc] initWithImage:image highlightedImage:highlightedImage];
    
    return item;
    
}

-(id) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.image = image;
        self.selectedImage = highlightedImage;
        
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateHighlighted];
        
        self.clipsToBounds = NO;
    }
    
    return self;
}

-(void) setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        [self setImage:self.selectedImage forState:UIControlStateNormal];
        [self setImage:self.selectedImage forState:UIControlStateHighlighted];
    } else {
        [self setImage:self.image forState:UIControlStateNormal];
        [self setImage:self.image forState:UIControlStateHighlighted];
    }
}


@end

#pragma mark -

@implementation HIUITabBar

-(HIUITabBar *) initWithTabBarItems:(NSArray *)items
{
    CGFloat deviceWidth = [[UIScreen mainScreen] bounds].size.width;
    self = [super initWithFrame:CGRectMake(0, 0, deviceWidth, HI_UITabBar_Height)];
    
    if (self) {
        self.items = items;
        self.backgroundImage = [UIImage imageNamed:@"HI_DefaultTabbarBkg.png"];
        self.clipsToBounds = NO;
    }
    
    return self;
}

-(void) setItems:(NSArray *)items
{
    if (items == _items) {
        return;
    }
    
    if (_items) {
        for (HIUITabBarItem * item in _items) {
            if (item) {
                [item removeFromSuperview];
            }
        }
    }
    
    _items = items;
    
    if (!_items) {
        return;
    }
    
    float itemWidth = self.frame.size.width / _items.count;
    float itemHeight = self.frame.size.height;
    
    [items enumerateObjectsUsingBlock:^(HIUITabBarItem * item ,NSUInteger idx, BOOL *stop) {
         item.frame = CGRectMake(itemWidth * idx, 0, itemWidth, itemHeight);
         item.tagString = [NSString stringWithFormat:@"%ld",(unsigned long)idx];
         [self addSubview:item];
     }];
}

-(void) setSelectedIndex:(NSInteger)selectedIndex
{
    [self.items enumerateObjectsUsingBlock:^(HIUITabBarItem * item ,NSUInteger idx, BOOL *stop) {
         if (selectedIndex == idx) {
             [item setHighlighted:YES];
         } else {
             [item setHighlighted:NO];
         }
     }];
    
}

@end
