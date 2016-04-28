//
//  HIFileCache.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIFileCache : NSObject

@property (nonatomic, copy) NSString *	cachePath;
@property (nonatomic, copy) NSString *	cacheUser;

- (NSString *)fileNameForKey:(NSString *)key;

- (id)serialize:(id)obj;
- (id)unserialize:(id)data;

- (BOOL)hasObjectForKey:(id)key;

- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

@end
