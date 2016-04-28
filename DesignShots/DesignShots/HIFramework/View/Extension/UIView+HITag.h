//
//  UIView+HITag.h
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef id (^HIUIViewAppendTagStringBlock) ( NSString * tagString );
typedef id (^HIUIViewWithTagBlock) ( NSInteger tag );
typedef id (^HIUIViewWithTagStringBlock) ( NSString * tagString );

@interface UIView (HITag)

@property (nonatomic, readonly) HIUIViewAppendTagStringBlock APPEND_TAG;
@property (nonatomic, readonly) HIUIViewWithTagBlock         FIND;
@property (nonatomic, readonly) HIUIViewWithTagStringBlock   FIND_S;

@property (nonatomic, copy) NSString * tagString;

- (UIView *)viewWithTagString:(NSString *)value;

@end
