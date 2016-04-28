//
//  HIUIActivityIndicatorView.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIActivityIndicatorView.h"

@implementation HIUIActivityIndicatorView


+(HIUIActivityIndicatorView *) whiteActivityIndicatorView
{
    return [[HIUIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

+(HIUIActivityIndicatorView *) grayActivityIndicatorView
{
    return [[HIUIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (id)init
{
    self = [super initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    if ( self ) {
        [self initSelf];
    }
    return self;
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    self = [super initWithActivityIndicatorStyle:style];
    if ( self ) {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    self.hidden = YES;
    self.hidesWhenStopped = YES;
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

- (BOOL)animating
{
    return self.isAnimating;
}

- (void)setAnimating:(BOOL)flag
{
    if ( flag ) {
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}

- (void)startAnimating
{
    if ( self.isAnimating )
        return;
    
    self.hidden = NO;
    self.alpha = 1.0f;
    
    [super startAnimating];
}

- (void)stopAnimating
{
    if ( NO == self.isAnimating )
        return;
    
    self.hidden = YES;
    self.alpha = 0.0f;
    
    [super stopAnimating];    
}

@end
