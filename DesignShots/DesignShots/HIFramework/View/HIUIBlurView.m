//
//  HIUIBlurView.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIBlurView.h"


@interface HIUIBlurView ()

@property(nonatomic,retain) UIToolbar * toolbar;

@end

@implementation HIUIBlurView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initSelf];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initSelf];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    // If we don't clip to bounds the toolbar draws a thin shadow on top
    [self setClipsToBounds:YES];
    
    if (![self toolbar])
    {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
        [self.layer addSublayer:[self.toolbar layer]];
    }
}

- (void) setBlurTintColor:(UIColor *)blurTintColor
{
    [self.toolbar setBarTintColor:blurTintColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.toolbar setFrame:[self bounds]];
}

@end
