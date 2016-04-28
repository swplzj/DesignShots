//
//  NSNull+HIExtension.h
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

@interface NSNull (HIExtension)

- (NSInteger)integerValue;
- (NSInteger)length;

- (instancetype)objectAtIndex:(NSInteger)index;

- (instancetype)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(id<NSCopying>)aKey;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;

@end
