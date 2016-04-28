//
//  HIMemeryCache.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIMemoryCache : NSObject

@property (nonatomic, assign) BOOL					clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger			maxCacheCount;
@property (nonatomic, assign) NSUInteger			cachedCount;
@property (nonatomic, retain) NSMutableArray *		cacheKeys;
@property (nonatomic, retain) NSMutableDictionary *	cacheObjs;

- (BOOL)hasObjectForKey:(id)key;

- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

@end
