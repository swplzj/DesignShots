//
//  HIUIKeyBoard.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HIUIKeyBoard : NSObject

@property (nonatomic,readonly) float animationDuration;
@property (nonatomic,readonly) float height;
@property (nonatomic,readonly) BOOL isShowing;

- (void)setAccessor:(UIView *)view;

@end
