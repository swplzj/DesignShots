//
//  UIView+HITag.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIView+HITag.h"
#import <objc/runtime.h>

#define KEY_TAGSTRING	"UIView.tagString"

@implementation UIView (HITag)

@dynamic tagString;

- (NSString *)tagString
{
    NSObject * obj = objc_getAssociatedObject( self, KEY_TAGSTRING );
    if ( obj && [obj isKindOfClass:[NSString class]] )
        return (NSString *)obj;
    
    return nil;
}

- (void)setTagString:(NSString *)value
{
    objc_setAssociatedObject( self, KEY_TAGSTRING, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (UIView *)viewWithTagString:(NSString *)value
{
    if ( nil == value )
        return nil;
    
    for ( UIView * subview in self.subviews ) {
        NSString * tag = subview.tagString;
        if ( [tag isEqualToString:value] ) {
            return subview;
        }
    }
    
    return nil;
}

-(HIUIViewAppendTagStringBlock) APPEND_TAG
{
    HIUIViewAppendTagStringBlock block = ^ UIView * ( NSString * tagString ) {
        self.tagString = tagString;
        return self;
    };
    
    return [block copy];
}

-(HIUIViewWithTagBlock) FIND
{
    HIUIViewWithTagBlock block = ^ id ( NSInteger tag ) {
        return [self viewWithTag:tag];
    };
    
    return [block copy];
}

-(HIUIViewWithTagStringBlock) FIND_S
{
    HIUIViewWithTagStringBlock block = ^ id ( NSString * tagString ) {
        return [self viewWithTagString:tagString];
    };
    
    return [block copy];
}

@end