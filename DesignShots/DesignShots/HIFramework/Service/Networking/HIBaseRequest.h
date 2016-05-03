//
//  HIBaseRequest.h
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum : NSUInteger {
    HIRequestMethodGet = 0,
    HIRequestMethodPost,
    HIRequestMethodHead,
    HIRequestMethodPut,
    HIRequestMethodDelete,
    HIRequestMethodPatch,
} HIRequestMethod;

typedef enum : NSUInteger {
    HIRequestSerializerTypeHTTP = 0,
    HIRequestSerializerTypeJSON,
} HIRequestSerializerType;

typedef void(^AFFormDataConstructingBlock)(id<AFMultipartFormData> forData);


@class HIBaseRequest;

@protocol HIRequestDelegate <NSObject>

- (void)requestFinished:(HIBaseRequest *)request;
- (void)requestFailed:(HIBaseRequest *)request;

@optional

- (void)clearRequest;

@end

@protocol HIRequestAccessory <NSObject>

@optional

- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

@interface HIBaseRequest : NSObject

@property (assign, nonatomic) NSInteger tag;

@property (strong, nonatomic) NSDictionary *userInfo;

@property (strong, nonatomic) AFHTTPRequestOperation *requestOperation;

@property (weak, nonatomic) id<HIRequestDelegate> delegate;

@property (strong, nonatomic, readonly) NSDictionary *responseHeaders;

@property (strong, nonatomic, readonly) NSString *responseString;

@property (strong, nonatomic, readonly) id responseJSONObject;
@property (strong, nonatomic, readonly) id responseObject;
@property (strong, nonatomic, readonly) id responseError;
@property (strong, nonatomic, readonly) id error;
@property (assign, nonatomic, readonly) NSInteger responseStatusCode;

@property (copy, nonatomic) void (^successCompletionBlock)(HIBaseRequest *);

@property (copy, nonatomic) void (^failureCompletionBlock)(HIBaseRequest *);

@property (strong, nonatomic) NSMutableArray *requestAccessories;

// 加入请求队列
- (void)start;

// 从请求队列中移除
- (void)stop;

// 判断是否正在请求
- (BOOL)isExecuting;

// Block 回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(HIBaseRequest *request))success
                                    failure:(void (^)(HIBaseRequest *request))failure;
- (void)setCompletionBlockWithSuccess:(void (^)(HIBaseRequest *request))success
                              failure:(void (^)(HIBaseRequest * request))failure;

// 把 block 置为 nil 来打破循环引用
- (void)clearCompletionBlock;

// Request Accessory, 可以 hook Request 的 start 和 stop
- (void)addAccessory:(id<HIRequestAccessory>)accessory;

// 以下方法由子类来覆盖默认值

// 请求成功的回调
- (void)requestCompleteFilter;

// 请求失败的回调
- (void)requestFailedFilter;

// 请求的URL
- (NSString *)requestURL;

// 请求的 CDN URL
- (NSString *)cdnURL;

// 请求的 BaseURL
- (NSString *)baseURL;

// 请求的连接超时时间，默认为60s
- (NSTimeInterval)requestTimeoutInterval;

// 请求的参数列表
- (id)requestParameter;

// 用于在 cache 结果，计算 cache 文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestParameter:(id)parameter;

// HTTP 请求的方法
- (HIRequestMethod)requestMethod;

// 请求的 SerializerType
- (HIRequestSerializerType)requestSerializerType;

// 请求的Server用户名和密码
- (NSArray *)requestAuthorizationHeaderFieldArray;

// 在 HTTP 报头添加的自定义参数
- (NSDictionary *)requestHeaderFieldValueDictionary;

// 构建自定义的 URLRequest
// 若这个方法返回非nil对象，会忽略 requestURL， requestParameter, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomURLRequest;

// 是否使用 CDN 的 host 地址
- (BOOL)isUseCDN;

// 用于检查 JSON 是否是合法的对象
- (id)JSONValidator;

// 用于检查 status code 是否正常
- (BOOL)isStatusCodeNormal;

// 当 POST 的内容带有文件等富文本时使用
- (AFFormDataConstructingBlock)formDataConstructingBodyBlock;

@end
