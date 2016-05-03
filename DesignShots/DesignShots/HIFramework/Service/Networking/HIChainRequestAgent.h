//
//  HIChainRequestAgent.h
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HIChainRequest.h"

/// ChainRequestAgent is used for caching & keeping current request.
@interface HIChainRequestAgent : NSObject

+ (HIChainRequestAgent *)sharedInstance;

- (void)addChainRequest:(HIChainRequest *)request;

- (void)removeChainRequest:(HIChainRequest *)request;

@end
