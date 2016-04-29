//
//  HIChainRequest.h
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIBaseRequest.h"

@class HIChainRequest;
@protocol HIChainRequestDelegate <NSObject>

- (void)chainRequestFinished:(HIChainRequest *)chainRequest;

- (void)chainRequestFailed:(HIChainRequest *)chainRequest failedBaseRequest:(HIBaseRequest*)request;

@end

typedef void (^ChainCallback)(HIChainRequest *chainRequest, HIBaseRequest *baseRequest);

@interface HIChainRequest : NSObject

@property (weak, nonatomic) id<HIChainRequestDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *requestAccessories;

/// start chain request
- (void)start;

/// stop chain request
- (void)stop;

- (void)addRequest:(HIBaseRequest *)request callback:(ChainCallback)callback;

- (NSArray *)requestArray;

/// Request Accessory，可以hook Request的start和stop
- (void)addAccessory:(id<HIRequestAccessory>)accessory;

@end
