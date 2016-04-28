//
//  NSObject+HISwizzle.h
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (HISwizzle)


@end

#pragma mark -

@interface NSArray (HISwizzle)

@end

#pragma mark -

@interface NSDictionary (HISwizzle)

@end

#pragma mark -

@interface NSMutableDictionary (HISwizzle)

@end

#pragma mark -

@interface NSObject (HISwizzle)

/**
 *  @author lizhenjie, 15-04-01 17:04:34
 *
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)swizzleAll;

@end


