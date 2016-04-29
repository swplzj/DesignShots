//
//  HINetworkAgent.h
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIBaseRequest.h"

@interface HINetworkAgent : NSObject

+ (HINetworkAgent *)sharedInstance;

- (void)addRequest:(HIBaseRequest *)request;

- (void)cancelRequest:(HIBaseRequest *)request;

- (void)cancelAllRequests;

// 根据 request 和 networkConfig 构建 URL
- (NSString *)buildRequestURL:(HIBaseRequest *)request;

@end
