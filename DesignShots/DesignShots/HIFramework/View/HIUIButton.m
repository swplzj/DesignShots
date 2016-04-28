//
//  HIUIButton.m
//  HIFramework
//
//  Created by lizhenjie on 4/7/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIButton.h"

@implementation HIUIButton
{
    BOOL    _inited;
}

@dynamic title;
@dynamic tintColor;
@dynamic titleFont;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSelf];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    
    return self;
}

- (void)initSelf
{
    if (!_inited) {
        self.backgroundColor                = [UIColor clearColor];
        self.contentMode                    = UIViewContentModeCenter;
        self.adjustsImageWhenDisabled       = YES;
        self.adjustsImageWhenHighlighted    = YES;
        self.titleLabel.textAlignment       = NSTextAlignmentCenter;
        
        self.contentVerticalAlignment       = UIControlContentVerticalAlignmentCenter;
        self.contentHorizontalAlignment     = UIControlContentHorizontalAlignmentCenter;
        
        [self setExclusiveTouch:YES];
        
        _inited = YES;
    }
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - 

- (NSString *)title
{
    return self.currentTitle;
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
}

- (UIColor *)titleColor
{
    return self.currentTitleColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateSelected];
}

- (UIFont *)titleFont
{
    return self.titleLabel.font;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    [self.titleLabel setFont:titleFont];
}

@end
