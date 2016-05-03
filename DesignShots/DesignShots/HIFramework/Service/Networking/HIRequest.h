//
//  HIRequest.h
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HIBaseRequest.h"
#import "HIBatchRequest.h"

@interface HIRequest : HIBaseRequest

@property (assign, nonatomic) BOOL ignorCache;

// 返回当前缓存的对象
- (id)cacheJSON;

// 是否当前的数据是从缓存中获得
- (BOOL)isDataFromCache;

// 返回当前缓存是否需要更新
- (BOOL)isCacheVersionExpired;

// 强制更新缓存
- (void)startWithoutCache;

// 手动将其他请求的 JSONReponse 写入该请求的缓存
- (void)saveJSONResponseToCacheFile:(id)JSONResponse;

// 子类需要覆盖重写
- (NSInteger)cacheTimeInSeconds;
- (long long) cacheVersion;
- (id)cacheSensitiveData;

@end
