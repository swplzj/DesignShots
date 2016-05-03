//
//  HINetworkConfig.h
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIBaseRequest.h"

@protocol HIURLFilterProtocol <NSObject>

- (NSString *)filterURL:(NSString *)originURL withRequest:(HIBaseRequest *)request;

@end

@protocol HICacheDirPathFilterProtocol <NSObject>

- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(HIBaseRequest *)request;

@end

@interface HINetworkConfig : NSObject

+ (HINetworkConfig *)sharedInstance;

@property (strong, nonatomic) NSString *baseURL;

@property (strong, nonatomic) NSString *cdnURL;

@property (strong, nonatomic, readonly) NSArray *URLFilters;

@property (strong, nonatomic, readonly) NSArray *cacheDirPathFilters;

- (void)addURLFilters:(id<HIURLFilterProtocol>)filter;

- (void)addCacheDirPathFilter:(id<HICacheDirPathFilterProtocol>)filter;

@end
