//
//  NSObject+HIHud.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSObject+HIHud.h"
#import "HIPrecompile.h"

@implementation NSObject (HIHud)


- (HIUIHud *)showMessageHud:(NSString *)message
{
    UIView * container = nil;
    
    if ( [self isKindOfClass:[UIView class]] ) {
        container = (UIView *)self;
    } else if ( [self isKindOfClass:[UIViewController class]] ) {
        container = ((UIViewController *)self).view;
    } else {
        container = HI_KEYWINDOW;
    }
    
    return [[HIUIHudCenter HIInstance] showMessageHud:message inView:container];
}

- (HIUIHud *)showSuccessHud:(NSString *)message
{
    UIView * container = nil;
    
    if ( [self isKindOfClass:[UIView class]] ) {
        container = (UIView *)self;
    } else if ( [self isKindOfClass:[UIViewController class]] ) {
        container = ((UIViewController *)self).view;
    } else {
        container = HI_KEYWINDOW;
    }
    
    return [[HIUIHudCenter HIInstance] showSuccessHud:message inView:container];
}

- (HIUIHud *)showFailureHud:(NSString *)message
{
    UIView * container = nil;
    
    if ( [self isKindOfClass:[UIView class]] ) {
        container = (UIView *)self;
    } else if ( [self isKindOfClass:[UIViewController class]] ) {
        container = ((UIViewController *)self).view;
    } else {
        container = HI_KEYWINDOW;
    }
    
    return [[HIUIHudCenter HIInstance] showFailureHud:message inView:container];
}

- (HIUIHud *)showLoadingHud:(NSString *)message
{
    UIView * container = nil;
    
    if ( [self isKindOfClass:[UIView class]] ){
        container = (UIView *)self;
    } else if ( [self isKindOfClass:[UIViewController class]] ) {
        container = ((UIViewController *)self).view;
    } else {
        container = HI_KEYWINDOW;
    }
    
    return [[HIUIHudCenter HIInstance] showLoadingHud:message inView:container];
}

- (HIUIHud *)showProgressHud:(NSString *)message
{
    UIView * container = nil;
    
    if ( [self isKindOfClass:[UIView class]] ) {
        container = (UIView *)self;
    } else if ( [self isKindOfClass:[UIViewController class]] ) {
        container = ((UIViewController *)self).view;
    } else {
        container = HI_KEYWINDOW;
    }
    
    return [[HIUIHudCenter HIInstance] showProgressHud:message inView:container];
}

@end
