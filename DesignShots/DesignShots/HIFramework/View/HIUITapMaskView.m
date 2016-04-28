//
//  HIUITapMaskView.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUITapMaskView.h"
#import "HIPrecompile.h"

@implementation HIUITapMaskView

-(void) dealloc
{
    self.willHideBlock = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha = 0;
        self.backgroundColor = HI_RGBA(0, 0, 0, 0.3);
        [self addTapTarget:self selector:@selector(tapAction)];
    }
    return self;
}

-(void) show
{
    HI_FAST_ANIMATIONS(0.25, ^{
        self.alpha = 1;
    });
}

-(void) hide
{
    HI_FAST_ANIMATIONS(0.25, ^{
        self.alpha = 0;
    });
}

-(void) hide:(BOOL)animated
{
    if (animated) {
        HI_FAST_ANIMATIONS(0.25, ^{
            self.alpha = 0;
        });
        
        return;
    }
    
    self.alpha = 0;
}

-(void) tapAction
{
    if (self.willHideBlock) {
        self.willHideBlock(self);
    }
    
    [self hide];
}

@end
