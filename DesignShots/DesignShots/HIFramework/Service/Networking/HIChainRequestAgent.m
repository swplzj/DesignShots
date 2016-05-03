//
//  HIChainRequestAgent.m
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HIChainRequestAgent.h"

@interface HIChainRequestAgent()

@property (strong, nonatomic) NSMutableArray *requestArray;

@end

@implementation HIChainRequestAgent

+ (HIChainRequestAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequest:(HIChainRequest *)request {
    [_requestArray addObject:request];
}

- (void)removeChainRequest:(HIChainRequest *)request {
    [_requestArray removeObject:request];
}

@end