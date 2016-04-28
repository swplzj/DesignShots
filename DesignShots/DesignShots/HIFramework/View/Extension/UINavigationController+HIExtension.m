//
//  UINavigationController+HIExtension.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UINavigationController+HIExtension.h"

@implementation UINavigationController (HIExtension)

-(id) rootViewController
{
    if (!self.viewControllers || self.viewControllers.count <= 0) {
        return nil;
    }
    
    return self.viewControllers[0];
}

@end
