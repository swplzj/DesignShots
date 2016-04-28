//
//  UIViewController+HILayout.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIViewController+HILayout.h"
#import "HIPrecompile.h"

@implementation UIViewController (HILayout)

-(void) setEdgesForExtendedLayoutNoneStyle
{
    if (IOS7_OR_LATER) {
        [self performSelector:@selector(setEdgesForExtendedLayout:) withObject:UIRectEdgeNone];
    }
}

@end
