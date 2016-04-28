//
//  HIMemeryCache.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIMemoryCache.h"
#import "HIPrecompile.h"

#pragma mark -

#undef	DEFAULT_MAX_COUNT
#define DEFAULT_MAX_COUNT	(48)

@implementation HIMemoryCache

- (id)init
{
    self = [super init];
    if ( self ) {
        _clearWhenMemoryLow = YES;
        _maxCacheCount = DEFAULT_MAX_COUNT;
        _cachedCount = 0;
        
        _cacheKeys = [[NSMutableArray alloc] init];
        _cacheObjs = [[NSMutableDictionary alloc] init];
        
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        [self observeNotification:UIApplicationDidReceiveMemoryWarningNotification];
#endif
    }
    
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
    
    [_cacheObjs removeAllObjects];
    
    [_cacheKeys removeAllObjects];
}

- (BOOL)hasObjectForKey:(id)key
{
    return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key
{
    return [_cacheObjs objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key
{
    if ( nil == key )
        return;
    
    if ( nil == object )
        return;
    
    _cachedCount += 1;
    
    while ( _cachedCount >= _maxCacheCount ) {
        NSString * tempKey = [_cacheKeys objectAtIndex:0];
        
        [_cacheObjs removeObjectForKey:tempKey];
        [_cacheKeys removeObjectAtIndex:0];
        
        _cachedCount -= 1;
    }
    
    [_cacheKeys addObject:key];
    [_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    if ( [_cacheObjs objectForKey:key] ) {
        [_cacheKeys removeObjectIdenticalTo:key];
        [_cacheObjs removeObjectForKey:key];
        
        _cachedCount -= 1;
    }
}

- (void)removeAllObjects
{
    [_cacheKeys removeAllObjects];
    [_cacheObjs removeAllObjects];
    
    _cachedCount = 0;
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    if ( [notification is:UIApplicationDidReceiveMemoryWarningNotification] ) {
        if ( _clearWhenMemoryLow ) {
            [self removeAllObjects];
        }
    }
}

@end

