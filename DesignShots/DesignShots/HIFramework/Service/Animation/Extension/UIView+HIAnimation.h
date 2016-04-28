//
//  UIView+HIAnimation.h
//  HIFramework
//
//  Created by lizhenjie on 4/11/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HIUIAnimationQueue;

@interface UIView (HIAnimation)

-(void) runAnimationsQueue:(HIUIAnimationQueue *)queue;

@end