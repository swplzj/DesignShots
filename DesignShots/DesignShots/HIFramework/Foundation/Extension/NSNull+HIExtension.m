//
//  NSNull+HIExtension.m
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSNull+HIExtension.h"

@implementation NSNull (HIExtension)

- (NSInteger)length
{
    ERROR(@"NSNull can't call length!");
    return 0;
}

- (NSInteger) integerValue
{
    ERROR(@"NSNull can't call integerValue!");
    return 0;
}

- (instancetype)objectAtIndex:(NSInteger)index
{
    ERROR(@"NSNull can't call objectAtIndex:!");
    return nil;
}

- (instancetype)objectForKey:(NSString *)key
{
    ERROR(@"NSNull can't call objectForKey:!");
    return nil;
}

- (void) setObject:(id)object forKey:(id<NSCopying>)aKey
{
    ERROR(@"NSNull can't call setObject:forKey:!");
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
    ERROR(@"NSNull can't call countByEnumeratingWithState:!");
    return 0;
}

@end
