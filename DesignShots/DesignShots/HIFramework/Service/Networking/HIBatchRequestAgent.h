//
//  HIBatchRequestAgent.h
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIBatchRequest.h"

@interface HIBatchRequestAgent : NSObject

+ (HIBatchRequestAgent *)sharedInstance;

- (void)addBatchRequest:(HIBatchRequest *)request;

- (void)removeBatchRequest:(HIBatchRequest *)request;

@end