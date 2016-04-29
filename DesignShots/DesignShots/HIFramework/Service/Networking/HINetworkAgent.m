
//
//  HINetworkAgent.m
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HINetworkAgent.h"
#import "HINetworkConfig.h"
#import "HINetworkPrivate.h"
#import "AppDelegate.h"

@implementation HINetworkAgent {
    AFHTTPRequestOperationManager *_manager;
    HINetworkConfig *_config;
    NSMutableDictionary *_requestsRecord;
    HIBaseRequest *_requestNormal;
}

+ (HINetworkAgent *)sharedInstance {
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
        _config = [HINetworkConfig sharedInstance];
        _manager = [AFHTTPRequestOperationManager manager];
#ifdef  HTTPS
        _manager.securityPolicy = [self getAFSecurityPolicy];
#endif
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
        _requestNormal = [[HIBaseRequest alloc] init];
    }
    return self;
}

- (NSString *)buildRequestURL:(HIBaseRequest *)request {
    NSString *detailUrl = [request requestURL];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    // filter url
    NSArray *filters = [_config URLFilters];
    for (id<HIURLFilterProtocol> f in filters) {
        detailUrl = [f filterURL:detailUrl withRequest:request];
    }
    
    NSString *baseUrl;
    if ([request isUseCDN]) {
        if ([request cdnURL].length > 0) {
            baseUrl = [request cdnURL];
        } else {
            baseUrl = [_config cdnURL];
        }
    } else {
        if ([request baseURL].length > 0) {
            baseUrl = [request baseURL];
        } else {
            baseUrl = [_config baseURL];
        }
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (void)addRequest:(HIBaseRequest *)request {
    HIRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestURL:request];
    id param = request.requestParameter;
    AFFormDataConstructingBlock constructingBlock = [request formDataConstructingBodyBlock];
    
    if (request.requestSerializerType == HIRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == HIRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                   password:(NSString *)authorizationHeaderFieldArray.lastObject];
    }
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                NSLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    // if api build custom url request
    NSURLRequest *customUrlRequest= [request buildCustomURLRequest];

    if (customUrlRequest) {
     if(method == HIRequestMethodPost){
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:customUrlRequest];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
            request.requestOperation = operation;
            operation.responseSerializer = _manager.responseSerializer;
            [_manager.operationQueue addOperation:operation];
        }
      
    } else {
        if (method == HIRequestMethodGet) { // GET
            request.requestOperation = [_manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        } else if (method == HIRequestMethodPost) { // POST
            if (constructingBlock != nil) {
                request.requestOperation = [_manager POST:url parameters:param constructingBodyWithBlock:constructingBlock
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      [self handleRequestResult:operation];
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      [self handleRequestResult:operation];
                                                  }];
            } else {
                request.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation];
                }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation];
                }];
            }
        } else if (method == HIRequestMethodHead) { // HEAD
            request.requestOperation = [_manager HEAD:url parameters:param success:^(AFHTTPRequestOperation *operation) {
                [self handleRequestResult:operation];
            }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        } else if (method == HIRequestMethodPut) { // PUT
            request.requestOperation = [_manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        } else if (method == HIRequestMethodDelete) { // DELETE
            request.requestOperation = [_manager DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            }                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        } else if (method == HIRequestMethodPatch) { // PATCH
            request.requestOperation = [_manager PATCH:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        } else {
            NSLog(@"Error, unsupport method type");
            return;
        }
    }
    
    NSLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addOperation:request];
}

- (void)cancelRequest:(HIBaseRequest *)request {
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        HIBaseRequest *request = copyRecord[key];
        [request stop];
    }
}


- (BOOL)checkResult:(HIBaseRequest *)request {
    BOOL result = [request isStatusCodeNormal];
    if (!result) {
        return result;
    }
    id validator = [request JSONValidator];
    if (validator != nil) {
        id json = [request responseJSONObject];
        result = [HINetworkPrivate checkJSON:json withValidator:validator];
    }
    return result;
}


- (void)handleRequestResult:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    HIBaseRequest *request = _requestsRecord[key];

    NSLog(@"*******************  RequestData   *******************\n** URL:%@%@\n** Parameter:\n%@\n\n** Resoponse:\n%@\n*******************  End   *******************\n\n", [request baseURL], [request requestURL], [request requestParameter], [request responseJSONObject]);

    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            [request toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];
            if (request.delegate != nil) {
                [request.delegate requestFinished:request];
            }
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        } else {
            NSLog(@"Request %@ failed, status code = %ld",
                   NSStringFromClass([request class]), (long)request.responseStatusCode);
            [request toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (request.delegate != nil) {
                [request.delegate requestFailed:request];
            }
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}

- (void)addOperation:(HIBaseRequest *)request {
    if (request.requestOperation != nil) {
        NSString *key = [self requestHashKey:request.requestOperation];
        _requestsRecord[key] = request;
    }
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    [_requestsRecord removeObjectForKey:key];
    NSLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}

@end