//
//  HINetworkConfig.m
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HINetworkConfig.h"

@implementation HINetworkConfig {
    NSMutableArray *_URLFilters;
    NSMutableArray *_cacheDirPathFilters;
}

+ (HINetworkConfig *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _URLFilters = [NSMutableArray array];
        _cacheDirPathFilters = [NSMutableArray array];
    }
    return self;
}

- (void)addURLFilters:(id<HIURLFilterProtocol>)filter {
    [_URLFilters addObject:filter];
}

- (void)addCacheDirPathFilter:(id<HICacheDirPathFilterProtocol>)filter {
    [_cacheDirPathFilters addObject:filter];
}

- (NSArray *)URLFilters {
    return [_URLFilters copy];
}

- (NSArray *)cacheDirPathFilters {
    return [_cacheDirPathFilters copy];
}

@end
