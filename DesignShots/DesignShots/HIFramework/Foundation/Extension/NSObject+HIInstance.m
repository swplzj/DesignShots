//
//  NSObject+HIInstance.m
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSObject+HIInstance.h"

static NSMutableDictionary *instenceDatasource = nil;

@implementation NSObject (HIInstance)

+ (instancetype)HIInstance
{
    NSMutableDictionary *dataSource = [[self class] shareInstanceDatasource];
    NSString *selfClass = [[self class] description];
    
    id __singleton__ = dataSource[selfClass];
    
    if (dataSource[selfClass]) {
        return __singleton__;
    }
    
    __singleton__ = [[self alloc] init];
    [[self class] setObjectToInstanceDataSource:__singleton__];
    INFO(@"[HIInstance] %@ instance init.", [__singleton__ class]);
    
    return __singleton__;
}

+ (NSMutableDictionary *)shareInstanceDatasource
{
    @synchronized(self){
        if (!instenceDatasource) {
            instenceDatasource = [[NSMutableDictionary alloc] init];
        }
    }
    
    return instenceDatasource;
}

+ (BOOL)setObjectToInstanceDataSource:(id)object
{
    NSString *objectClass = [[object class] description];
    
    if (!object) {
        ERROR(@"[HIInstance] init fail.");
        return NO;
    }
    
    if (!objectClass) {
        ERROR(@"[HIInstance] class error.");
        return NO;
    }
    
    [[[self class] shareInstanceDatasource] setObject:object forKey:objectClass];

    return YES;
}

+ (NSString *)currentInstanceInfo
{
    NSDictionary *dataSource = [NSObject shareInstanceDatasource];
    
    if (!dataSource) {
        return @"[HIInstance] No instance, or no use NSObject+HIInstance.";
    }
    
    NSMutableString *info = [NSMutableString stringWithFormat:@"    * count : %d\n", (int)(dataSource.allKeys.count)];
    for (NSString *key in dataSource.allKeys) {
        NSString *oneInfo = dataSource[key];
        [info appendFormat:@"   * %@\n", [oneInfo class]];
    }
    
    return info;
}

@end
