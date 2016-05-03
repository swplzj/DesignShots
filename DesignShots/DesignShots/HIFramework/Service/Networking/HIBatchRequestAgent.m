//
//  HIBatchRequestAgent.m
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HIBatchRequestAgent.h"

@interface HIBatchRequestAgent()

@property (strong, nonatomic) NSMutableArray *requestArray;

@end

@implementation HIBatchRequestAgent

+ (HIBatchRequestAgent *)sharedInstance {
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

- (void)addBatchRequest:(HIBatchRequest *)request {
    [_requestArray addObject:request];
}

- (void)removeBatchRequest:(HIBatchRequest *)request {
    [_requestArray removeObject:request];
}

@end