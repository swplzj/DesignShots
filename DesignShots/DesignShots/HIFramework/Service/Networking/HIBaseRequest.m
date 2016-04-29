//
//  HIBaseRequest.m
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HIBaseRequest.h"
#import "HINetworkAgent.h"
#import "HINetworkPrivate.h"


@implementation HIBaseRequest

- (void)requestCompleteFilter {
    
}

- (void)requestFailedFilter {
    
}

- (NSString *)requestURL {
    return self.requestURL;
}

- (NSString *)cdnURL {
    return @"";
}

- (NSString *)baseURL {
    return kBaseApiUrl;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (id)requestParameter {
    return self.requestParameter;
}

- (id)cacheFileNameFilterForRequestParameter:(id)parameter {
    return parameter;
}

- (HIRequestMethod)requestMethod {
    return self.requestMethod;
}

- (HIRequestSerializerType)requestSerializerType {
    return HIRequestSerializerTypeHTTP;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomURLRequest {
    return nil;
}

- (BOOL)isUseCDN {
    return NO;
}

- (id)JSONValidator {
    return nil;
}

- (BOOL)isStatusCodeNormal {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <= 299) {
        return YES;
    } else {
        return NO;
    }
}

- (AFFormDataConstructingBlock)formDataConstructingBodyBlock {
    return nil;
}

- (void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[HINetworkAgent sharedInstance] addRequest:self];
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[HINetworkAgent sharedInstance] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (BOOL)isExecuting {
    return self.requestOperation.isExecuting;
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(HIBaseRequest *))success
                                    failure:(void (^)(HIBaseRequest *))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(HIBaseRequest *))success
                              failure:(void (^)(HIBaseRequest *))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // 设为nil防止循环引用
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

-(id)responseJSONObject {
    return self.requestOperation.responseObject;
}

-(id)responseError {
    NSString *status = [self.requestOperation.responseObject objectForKey:@"success"];
    if ([status isEqualToString:@"true"]) {
        return nil;
    }else{
        return self.requestOperation.responseObject[@"error"];
    }
}
-(id)error {
    return self.requestOperation.error;
}
-(id)responseObject {
    NSString *status = [self.requestOperation.responseObject objectForKey:@"success"];
    if ([status isEqualToString:@"true"]) {
        return self.requestOperation.responseObject;
    }else{
        return nil;
   }
}
- (NSString *)responseString {
    return self.requestOperation.responseString;
}

- (NSInteger)responseStatusCode {
    return self.requestOperation.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.requestOperation.response.allHeaderFields;
}

#pragma mark - Request Accessories

- (void)addAccessory:(id<HIRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

#pragma mark - private method
- (NSMutableURLRequest *)getRequestByUrlString:(NSString *)pStrUrl
{
    NSString *baseUrl = self.baseURL;
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, pStrUrl]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:self.requestTimeoutInterval];
 
    return request;
}
@end
