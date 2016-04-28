//
//  CALayer+HIShake.m
//  HIFramework
//
//  Created by lizhenjie on 4/16/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "CALayer+HIShake.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@implementation CALayer (HIShake)

- (void)addShakeAnimation
{
    CGPoint posLbl = [self position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [self addAnimation:animation forKey:nil];
}

@end
