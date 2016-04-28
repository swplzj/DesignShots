//
//  UIView+HIAnimation.m
//  HIFramework
//
//  Created by lizhenjie on 4/11/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIView+HIAnimation.h"
#import "HIUIAnimation.h"

@implementation UIView (HIAnimation)

-(void) runAnimationsQueue:(HIUIAnimationQueue *)queue
{
    [queue runAnimationsInView:self];
}

@end
