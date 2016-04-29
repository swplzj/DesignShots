
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
#import "UCRefreshTokenApi.h"
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

    if(![request isKindOfClass:[UCRefreshTokenApi class]]){
        _requestNormal = request;
    }
    // 打印
    NSLog(@"*******************  RequestData   *******************\n** URL:%@%@\n** Parameter:\n%@\n\n** Resoponse:\n%@\n*******************  End   *******************\n\n", [request baseURL], [request requestURL], [request requestParameter], [request responseJSONObject]);

    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            [request toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];
            if (request.delegate != nil) {
                [request.delegate requestFinished:request];
            }
            
            NSDictionary *bodyDic = (NSDictionary *)[request responseJSONObject];
            NSString *status = [bodyDic objectForKey:@"success"];
            //当业务正常
            if ([status isEqualToString:@"true"]) {
                if (request.successCompletionBlock) {
                    request.successCompletionBlock(request);
                }
            //当业务错误
            }else{
                NSDictionary *errorDic = [bodyDic objectForKey:@"error"];
                //校验token是否失效
                BOOL bTag = [self checkTokenIsInvalid:errorDic withRequest:_requestNormal];
                if(bTag == FALSE){
                    if (request.successCompletionBlock) {
                        request.successCompletionBlock(request);
                    }
                }else{
                    [request toggleAccessoriesDidStopCallBack];
                    return;
                }
            }
           
            [request toggleAccessoriesDidStopCallBack];
            return;
        } else {
            NSLog(@"Request %@ failed, status code = %ld",
                   NSStringFromClass([request class]), (long)request.responseStatusCode);
            
            NSDictionary *bodyErrorDic = (NSDictionary *)(operation.responseObject);
            NSDictionary *errorDic = [bodyErrorDic objectForKey:@"error"];
            //校验token是否失效
            BOOL bTag = [self checkTokenIsInvalid:errorDic withRequest:_requestNormal];
            if(bTag == FALSE){
                [request toggleAccessoriesWillStopCallBack];
                [request requestFailedFilter];
                if (request.delegate != nil) {
                    [request.delegate requestFailed:request];
                }
                if (request.failureCompletionBlock) {
                    request.failureCompletionBlock(request);
                }
                [request toggleAccessoriesDidStopCallBack];
            }else{
                return;
            }
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

#pragma mark - private method
- (AFSecurityPolicy * )getAFSecurityPolicy{
    AFSecurityPolicy * securityPolicy;
    NSString *pStrDoubleCheck = [[NSUserDefaults standardUserDefaults] objectForKey:HTTPS_DOUBLE_CHECK];
    if([pStrDoubleCheck isEqualToString:@"YES"] == YES){
        //AFSSLPinningModeCertificate
        //这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名/有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName，是否需要验证域名，默认为YES；
        securityPolicy.validatesDomainName = NO;
        //validatesCertificateChain,为YES,表示不校验证书链
        securityPolicy.validatesCertificateChain = NO;
        
    }else{
        securityPolicy = [AFSecurityPolicy new];
        securityPolicy.allowInvalidCertificates = YES;
    }
    return securityPolicy;
}

- (BOOL)checkTokenIsInvalid:(NSDictionary*)errorDic withRequest:(HIBaseRequest*)requestBackUp{
    if([errorDic isKindOfClass:[NSDictionary class]] == YES){
        NSString *pStrCode = [errorDic objectForKey:@"code"];

        if([pStrCode isKindOfClass:[NSString class]] == YES){
            //当token错误，或者失效,重新请求token
            if([pStrCode isEqualToString:@"4001"] == YES){
                [self askToken:requestBackUp];
                return TRUE;
            }else if([pStrCode isEqualToString:@"402"] == YES){
                [UCUITools exitSystem];
                return NO;
            }else if([pStrCode isEqualToString:@"401"] == YES){
                [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                    [UCUITools exitSystem];
                }];
                return NO;
            }
        }
        return FALSE;
    }
     return FALSE;
}

- (void)askToken:(HIBaseRequest*)requestBackUp{
    
    UCRefreshTokenApi *requestToken = [[UCRefreshTokenApi alloc] init];
    HIBaseRequest *requestLast = requestBackUp;

    [requestToken startWithCompletionBlockWithSuccess:^(HIBaseRequest *request) {
        UCRefreshTokenApi *requestTemp = (UCRefreshTokenApi *)request;
        //当是业务错误，直接回调到页面
        if(requestTemp.responseError){
              [UCUITools exitSystem];
//            if (requestLast.successCompletionBlock) {
//                requestLast.successCompletionBlock(request);
//            }
        //当请求完token,重新请求数据
        }else{
            [requestTemp saveRefreshTokenData];
            [self requestLastAgain:requestLast];
        }
       
    } failure:^(HIBaseRequest *request) {
        if (requestLast.failureCompletionBlock) {
            requestLast.failureCompletionBlock(request);
        }

    }];
}

- (void)requestLastAgain:(HIBaseRequest *)requestLast{
    [requestLast setCompletionBlockWithSuccess:requestLast.successCompletionBlock failure:requestLast.failureCompletionBlock];
    [requestLast start];
}
@end