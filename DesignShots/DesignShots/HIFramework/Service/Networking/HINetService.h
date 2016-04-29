//
//  HINetService.h
//  HIFramework
//
//  Created by lizhenjie on 3/31/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^HINetServiceResultBlock)(NSError *error, id responseError, id responseObject);

@interface HINetService : NSObject

@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> *requestSerialization;

/**
 *  @author lizhenjie, 15-03-31 15:03:21
 *
 *  AF基于URL进行POST网络请求
 *
 *  @param url        请求URL
 *  @param parameters 请求参数
 *  @param block      结果处理
 *
 *  @return 请求操作
 */
+ (AFHTTPRequestOperation *)requestWithUrlString:(NSString *)url
                                      parameters:(id)parameters
                               completionHandler:(HINetServiceResultBlock)block;
/**
 *  @author lizhenjie, 15-03-31 17:03:14
 *
 *  基于URL进行表单网络请求，用于图片上传
 *
 *  @param url        请求URL
 *  @param parameters 请求参数
 *  @param block      请求结果处理
 *
 *  @return 表单请求操作
 */
+ (AFHTTPRequestOperation *)formDataRequestWithUrlString:(NSString *)url
                                              parameters:(id)parameters
                                       completionHandler:(HINetServiceResultBlock)block;
+ (AFHTTPRequestOperation *)uploadImageArrayRequestWithUrlString:(NSString *)url
                                              parameters:(id)parameters
                                       completionHandler:(HINetServiceResultBlock)block;

+ (AFHTTPRequestOperation *)requestUploadImageWithRequestBody:(NSString*)strUrl
                                                   parameters:(NSDictionary *)bodyDic
                                            completionHandler:(HINetServiceResultBlock)block;
+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
              completionHandler:(HINetServiceResultBlock)block;

+ (void)uploadPhoneAddressList:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params withUrl:(NSString*)pStrURL completionHandler:(HINetServiceResultBlock)block;

+ (void)askToken:(NSString*)pStrURl withBody:(NSDictionary*)pBodyDic withType:(int)nType
completionHandler:(HINetServiceResultBlock)block;
+ (NSMutableURLRequest *)getRequestByUrlString:(NSString *)pStrUrl;
+ (BOOL)getCurNetStatus;
+ (AFHTTPRequestOperation *)setResequest:(NSURLRequest *)request completionHandler:(HINetServiceResultBlock)block
                                     parameters:(NSDictionary *)bodyDic
                                        withURL:(NSString*)strUrl withType:(int)nType;

+(AFSecurityPolicy * )getAFSecurityPolicy;
@end
