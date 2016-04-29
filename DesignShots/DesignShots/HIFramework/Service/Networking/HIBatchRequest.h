//
//  HIBatchRequest.h
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIRequest.h"

@class HIBatchRequest;

@protocol HIBatchRequestDelegate <NSObject>

- (void)batchRequestFinished:(HIBatchRequest *)batchRequest;

- (void)batchRequestFailed:(HIBatchRequest *)batchRequest;

@end

@interface HIBatchRequest : NSObject

@property (strong, nonatomic, readonly) NSArray *requestArray;

@property (weak, nonatomic) id<HIBatchRequestDelegate> delegate;

@property (nonatomic, copy) void (^successCompletionBlock)(HIBatchRequest *);

@property (nonatomic, copy) void (^failureCompletionBlock)(HIBatchRequest *);

@property (nonatomic) NSInteger tag;

@property (nonatomic, strong) NSMutableArray *requestAccessories;

- (id)initWithRequestArray:(NSArray *)requestArray;

- (void)start;

- (void)stop;

/// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(HIBatchRequest *batchRequest))success
                                    failure:(void (^)(HIBatchRequest *batchRequest))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(HIBatchRequest *batchRequest))success
                              failure:(void (^)(HIBatchRequest *batchRequest))failure;

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

/// Request Accessory，可以hook Request的start和stop
- (void)addAccessory:(id<HIRequestAccessory>)accessory;

/// 是否当前的数据从缓存获得
- (BOOL)isDataFromCache;

@end