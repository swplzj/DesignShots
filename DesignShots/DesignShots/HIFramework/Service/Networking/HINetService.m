//
//  HINetService.m
//  HIFramework
//
//  Created by lizhenjie on 3/31/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HINetService.h"
#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "UCStringTools.h"
#import "UCOSTools.h"
#import "UCUDIDTools.h"
#import "AppDelegate.h"
#import "UCUITools.h"
static NSString * const WFHTTPURL = @"https://api.ucredit.com/v1/makecontract/get/regagreement";

#define EncodeUTF8(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation HINetService

+ (AFHTTPRequestOperation *)requestWithUrlString:(NSString *)url
                                      parameters:(id)parameters
                               completionHandler:(HINetServiceResultBlock)block
{

//    NSDictionary *bodyDic = @{
//                              @"header": [self requestHeaders],
//                              @"request": @[[self requestBodyWithUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters]]
//                              };

    NSDictionary *bodyDic = parameters;
    
    return [self requestOperationWithRequestBody:bodyDic completionHandler:block withURL:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (AFHTTPRequestOperation *)formDataRequestWithUrlString:(NSString *)url parameters:(id)parameters completionHandler:(HINetServiceResultBlock)block
{
    if (parameters) {
        NSMutableDictionary *tmpDic = [NSMutableDictionary new];
        for (NSString *tmpKey in [parameters allKeys]) {
            if (![tmpKey isEqualToString:@"pic"]) {
                [tmpDic setObject:parameters[tmpKey] forKey:tmpKey];
            }
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
#ifdef  HTTPS
        manager.securityPolicy = [self getAFSecurityPolicy];
#endif
        NSString *pStrAuthorzation = [NSString stringWithFormat:@"Bearer %@", [UCUserInfo getLocalUserInfo].secret_AccessToken];
        
         AFHTTPRequestOperation *requestOperation = [manager POSTUplodaDataRequestFile:url parameters:[parameters copy]  withToken:pStrAuthorzation withClientID:[UCUDIDTools UDID] constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            for (int i = 0; i < [parameters[@"pic"] count]; i++) {
                [formData appendPartWithFileData:parameters[@"pic"][i] name:[NSString stringWithFormat:@"photo%d", i] fileName:@"userPhoto" mimeType:@"image/png, image/jpeg, image/jpg, multipart/form-data"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject:%@", responseObject);
            
            NSDictionary *bodyErrorDic = (NSDictionary *)(operation.responseObject);
            NSDictionary *errorDic = [bodyErrorDic objectForKey:@"error"];
            if([errorDic isKindOfClass:[NSDictionary class]] == YES){
                NSString *pStrCode = [errorDic objectForKey:@"code"];
                if([pStrCode isKindOfClass:[NSString class]] == YES){
                    //当token错误，或者失效,重新请求token
                    if([pStrCode isEqualToString:@"4001"] == YES){
                        [HINetService askToken:url withBody:parameters  withType:5 completionHandler:block];
                        return;
                    }else if([pStrCode isEqualToString:@"402"] == YES){
                        [UCUITools exitSystem];
                        return;
                    }else if([pStrCode isEqualToString:@"401"] == YES){
                        [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                            [UCUITools exitSystem];
                        }];
                    }
                }
            }
            
            if (![operation isCancelled]) {
                block(nil, nil, responseObject);
            }

            return ;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ %@", error, operation.responseString);
            NSDictionary *bodyErrorDic = (NSDictionary *)(operation.responseObject);
            NSDictionary *errorDic = [bodyErrorDic objectForKey:@"error"];
            if([errorDic isKindOfClass:[NSDictionary class]] == YES){
                NSString *pStrCode = [errorDic objectForKey:@"code"];
                if([pStrCode isKindOfClass:[NSString class]] == YES){
                    //当token错误，或者失效,重新请求token
                    if([pStrCode isEqualToString:@"4001"] == YES){
                        [HINetService askToken:url withBody:parameters  withType:5 completionHandler:block];
                        return;
                    }else if([pStrCode isEqualToString:@"402"] == YES){
                        [UCUITools exitSystem];
                        return;
                    }else if([pStrCode isEqualToString:@"401"] == YES){
                        [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                            [UCUITools exitSystem];
                        }];
                    }
                }
            }
            
            if (![operation isCancelled]) {
                if (block) {
                    block(error, nil, nil);
                }
                
                return;
            }

        }];
        [requestOperation start];
        return requestOperation;
    } else {// 参数为空
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                timeoutInterval:30.0f];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
#ifdef  HTTPS
        manager.securityPolicy = [self getAFSecurityPolicy];
#endif
        AFHTTPRequestOperation *requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            NSLog(@"%@", operation.responseString);
            if (![operation isCancelled]) {
                block(nil, nil, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ %@", error, operation.responseString);
            if (![operation isCancelled]) {
                block(error, nil, nil);
            }
        }];
        
        requestOperation.responseSerializer = [AFImageResponseSerializer new];
        [requestOperation start];
        return requestOperation;
    }
}

+ (AFHTTPRequestOperation *)uploadImageArrayRequestWithUrlString:(NSString *)url parameters:(id)parameters completionHandler:(HINetServiceResultBlock)block
{
    if (parameters) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
#ifdef  HTTPS
       //manager.securityPolicy = [self getAFSecurityPolicy];
        
#endif
        NSString *pStrAuthorzation = [NSString stringWithFormat:@"%@", [UCUserInfo getLocalUserInfo].secret_AccessToken];
        AFHTTPRequestOperation *requestOperation = [manager POSTUplodaFile:url parameters:[parameters copy]  withToken:pStrAuthorzation withClientID:[UCUDIDTools UDID] constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            
            int nCountFile = (int)[parameters[@"file"] count];
            int nCount = (int)[parameters[@"pic"] count];
            for (int i = 0; i < nCount; i++) {
                UIImage *pImage = parameters[@"pic"][i];
                NSData* imageData = UIImageJPEGRepresentation(pImage, 0);
                NSString *pStr = [NSString stringWithFormat:@"%d.png",nCount - i];
                NSString *pStrName = @"file";
                if(nCountFile == [parameters[@"pic"] count]){
                    pStrName =  parameters[@"file"][i];
                    //pStr =[NSString stringWithFormat:@"%@.png",pStrName];
                }
                [formData appendPartWithFileData:imageData name:pStrName fileName:pStr mimeType:@"image/png, image/jpeg, image/jpg, multipart/form-data"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *bodyDic = (NSDictionary *)responseObject;
            BOOL bTag = [bodyDic objectForKey:@"success"];
            if (bTag == YES) {
                if (![operation isCancelled]) {
                    if (block) {
                        block(nil, nil, responseObject);
                    }
                }
                return ;
            } else if(bTag == NO) {
                NSDictionary *errorDic = [bodyDic objectForKey:@"error"];
                if([errorDic isKindOfClass:[NSDictionary class]] == YES){
                    NSString *pStrCode = [errorDic objectForKey:@"code"];
                    if([pStrCode isKindOfClass:[NSString class]] == YES){
                        //当token错误，或者失效,重新请求token
                        if([pStrCode isEqualToString:@"4001"] == YES){
                            [HINetService askToken:url withBody:parameters withType:3 completionHandler:block];
                            return;
                        }else if([pStrCode isEqualToString:@"402"] == YES){
                            [UCUITools exitSystem];
                            return;
                        }else if([pStrCode isEqualToString:@"401"] == YES){
                            [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                [UCUITools exitSystem];
                            }];
                        }
                    }
                }
                if (![operation isCancelled]) {
                    if (block) {
                        block(nil, responseObject[@"error"], nil);
                    }
                }
                return;
            }

            
            NSLog(@"responseObject:%@", responseObject);
            if (![operation isCancelled]) {
                block(nil, nil, responseObject);
            }
            return ;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ %@", error, operation.responseString);
            NSDictionary *bodyErrorDic = (NSDictionary *)(operation.responseObject);
            NSDictionary *errorDic = [bodyErrorDic objectForKey:@"error"];
            if([errorDic isKindOfClass:[NSDictionary class]] == YES){
                NSString *pStrCode = [errorDic objectForKey:@"code"];
                if([pStrCode isKindOfClass:[NSString class]] == YES){
                    //当token错误，或者失效,重新请求token
                    if([pStrCode isEqualToString:@"4001"] == YES){
                        [HINetService askToken:url withBody:parameters withType:3 completionHandler:block];
                        return;
                    }else if([pStrCode isEqualToString:@"402"] == YES){
                        [UCUITools exitSystem];
                        return;
                    }else if([pStrCode isEqualToString:@"401"] == YES){
                        [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                            [UCUITools exitSystem];
                        }];
                    }
                }
            }

            if (![operation isCancelled]) {
                block(error, nil, nil);
            }
            return ;
        }];
        [requestOperation start];
        return requestOperation;
    } else {// 参数为空
        return NULL;
    }
}

#pragma mark - Private

+ (NSDictionary *)requestHeaders
{
    NSString *pStrAuthorzation = [NSString stringWithFormat:@"Authorization: Bearer %@",[UCUserInfo getLocalUserInfo].secret_AccessToken];
    return @{
             @"version": @"",   //客户端版本号
             @"device": [[UIDevice currentDevice] model],   // 设备型号
             @"platform": @"iOS",   //平台
             @"local": @"ZH_cn",
             @"Authorization":pStrAuthorzation
             };
}

+ (NSDictionary *)requestBodyWithUrl:(NSString *)method
                          parameters:(NSDictionary *)parameters
{
    if (parameters == nil) {
        parameters = @{};
    }
    return @{
             @"id": [NSString stringWithFormat:@"%ld", random()],   //随机数
             @"version": @"1.0.0",  //服务器版本号
             @"url": method,
             @"params": parameters
             
             };
}

+ (AFHTTPRequestOperation *)requestOperationWithRequestBody:(NSDictionary *)bodyDic
                                          completionHandler:(HINetServiceResultBlock)block
                                          withURL:(NSString*)strUrl
{
    NSString *jsonString = [UCStringTools jsonStringWithObject:bodyDic];
    NSData *bodyData;
    //AES加密后的串f    //当有密匙，进行加密

    NSString *pStrSecretKey = [HIUserDefaults objectForKey:SECRET_AES];
    if([UCOSTools isBlankString:pStrSecretKey] == NO){
        NSString *string = [SecurityUtil encryptAES32Data:jsonString app_key:pStrSecretKey];
        NSString *pStrUDID = [UCUDIDTools UDID];
        //“1”：以后是clenit ID
        NSString *strPost = [NSString stringWithFormat:@"UCC:%@:%@", pStrUDID,string];
        //加密
        bodyData = [strPost dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //不加密
    }else{
        bodyData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    }

    NSMutableURLRequest *request = [HINetService getRequestByUrlString:strUrl];
    request.HTTPBody = bodyData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:bodyData];
    
    AFHTTPRequestOperation *requestOperation = [HINetService setResequest:request completionHandler:block parameters:bodyDic withURL:strUrl withType:0];
    return requestOperation;
}

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(id)parameters completionHandler:(HINetServiceResultBlock)block
{
//    NSString *baseUrl = API_PURE_DOMAIN;
//    NSString *URL = [NSString stringWithFormat:@"%@%@", baseUrl, URLString];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
#ifdef  HTTPS
    manager.securityPolicy = [self getAFSecurityPolicy];

#endif
    AFHTTPRequestOperation *requestOperation = [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        INFO(@"Response = %@\n", responseObject);
        BOOL isJSON = [NSJSONSerialization isValidJSONObject:responseObject];
        if (isJSON) {
            NSDictionary *bodyDic = (NSDictionary *)responseObject;
            NSString *status = [bodyDic objectForKey:@"success"];
            if ([status isEqualToString:@"true"]) {
                if (![operation isCancelled]) {
                    if (block) {
                        NSLog(@"------responseObject = %@\n\n", responseObject);
                        block(nil, nil, responseObject);
                    }
                }
                return ;
            } else if([status isEqualToString:@"false"]) {
                NSDictionary *bodyErrorDic = (NSDictionary *)(operation.responseObject);
                NSDictionary *errorDic = [bodyErrorDic objectForKey:@"error"];
                if([errorDic isKindOfClass:[NSDictionary class]] == YES){
                    NSString *pStrCode = [errorDic objectForKey:@"code"];
                    if([pStrCode isKindOfClass:[NSString class]] == YES){
                        //当token错误，或者失效,重新请求token
                        if([pStrCode isEqualToString:@"4001"] == YES){
                            [HINetService askToken:URLString withBody:parameters  withType:4 completionHandler:block];
                            return;
                        }else if([pStrCode isEqualToString:@"402"] == YES){
                            [UCUITools exitSystem];
                            return;
                        }else if([pStrCode isEqualToString:@"401"] == YES){
                            [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                [UCUITools exitSystem];
                            }];
                        }
                    }
                }

                if (![operation isCancelled]) {
                    if (block) {
                        block(nil, responseObject[@"error"], nil);
                    }
                }
                return;
            }
        }
        
        if (![operation isCancelled]) {
            if (block) {
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1004 userInfo:nil];
                block(error, nil, nil);
            }
            return ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ %@", operation.responseString, error);
        NSLog(@"%@ %@", error, operation.responseString);
        NSDictionary *bodyErrorDic = (NSDictionary *)(operation.responseObject);
        NSDictionary *errorDic = [bodyErrorDic objectForKey:@"error"];
        if([errorDic isKindOfClass:[NSDictionary class]] == YES){
            NSString *pStrCode = [errorDic objectForKey:@"code"];
            if([pStrCode isKindOfClass:[NSString class]] == YES){
                //当token错误，或者失效,重新请求token
                if([pStrCode isEqualToString:@"4001"] == YES){
                    [HINetService askToken:URLString withBody:parameters  withType:4 completionHandler:block];
                    return;
                }else if([pStrCode isEqualToString:@"402"] == YES){
                    [UCUITools exitSystem];
                    return;
                }else if([pStrCode isEqualToString:@"401"] == YES){
                    [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                        [UCUITools exitSystem];
                    }];
                }
            }
        }

        if (block && error) {
            block(error, nil, nil);
        }
        return ;
    }];
    [requestOperation start];
    
    INFO(@"URL = %@\n ", URLString);
    
    return requestOperation;
}

+ (AFHTTPRequestOperation *)requestUploadImageWithRequestBody:(NSString*)strUrl
                                                   parameters:(NSDictionary *)bodyDic
                                            completionHandler:(HINetServiceResultBlock)block

{
    UIImage *pImage = (UIImage*)[bodyDic objectForKey:@"file"];
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(pImage, 0);
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //得到当前key
    NSString *key = @"applyId";
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
    //添加字段的值
    NSString *pAppID = (NSString*)[bodyDic objectForKey:@"applyId"];
    [body appendFormat:@"%@\r\n",pAppID];
    
    NSLog(@"添加字段的值==%@",@"applyId:",pAppID);
    
    
    key = @"type";
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
    //添加字段的值
    NSString *pStrType = (NSString*)[bodyDic objectForKey:@"type"];
    [body appendFormat:@"%@\r\n",pStrType];
    
    NSLog(@"添加字段的值==%@",pStrType);
    
    
    ///添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    
    NSString *picFileName = @"boris.png";
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",@"file",picFileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSMutableURLRequest* request = [HINetService getRequestByUrlString:strUrl];
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", (int)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    AFHTTPRequestOperation *requestOperation = [HINetService setResequest:request completionHandler:block parameters:bodyDic withURL:strUrl withType:2];
    return requestOperation;
}

+ (void)uploadPhoneAddressList:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params withUrl:(NSString*)pStrURL completionHandler:(HINetServiceResultBlock)block
{
    // 文件上传
    NSArray *pKeyArray = [params allKeys];
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    /***************文件参数***************/
    // 参数开始的标志
    [body appendData:EncodeUTF8(@"--YY\r\n")];
    // name : 指定参数名(必须跟服务器端保持一致)
    // filename : 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:EncodeUTF8(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:EncodeUTF8(type)];
    
    [body appendData:EncodeUTF8(@"\r\n")];
    [body appendData:data];
    [body appendData:EncodeUTF8(@"\r\n")];
    
    // 参数开始的标志
    ////////////////////////////////////////////////////////
    [body appendData:EncodeUTF8(@"--YY\r\n")];
    NSString *pKey = [pKeyArray objectAtIndex:0];
    disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", pKey];
    [body appendData:EncodeUTF8(disposition)];
    
    [body appendData:EncodeUTF8(@"\r\n")];
    [body appendData:EncodeUTF8([params objectForKey:pKey])];
    [body appendData:EncodeUTF8(@"\r\n")];
    /////////////////////////////////////////////////////
    
    /***************参数结束***************/
    // YY--\r\n
    [body appendData:EncodeUTF8(@"--YY--\r\n")];
    ////////////////////////////////////////////////////////
    NSMutableURLRequest *request = [HINetService getRequestByUrlString:pStrURL];
    request.HTTPBody = body;
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    // 声明这个POST请求是个文件上传
    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    
    [HINetService setResequest:request completionHandler:NULL parameters:params withURL:pStrURL withType:1];

    return;
}

+ (AFHTTPRequestOperation *)setResequest:(NSURLRequest *)request completionHandler:(HINetServiceResultBlock)block
                                                parameters:(NSDictionary *)parametersDic
                                        withURL:(NSString*)strUrl withType:(int)nType{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
#ifdef  HTTPS
    manager.securityPolicy = [self getAFSecurityPolicy];
#endif
    
    AFHTTPRequestOperation *requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        INFO(@"Response = %@\n", responseObject);
        
        BOOL isJSON = [NSJSONSerialization isValidJSONObject:responseObject];
        if (isJSON) {
            NSDictionary *bodyDic = (NSDictionary *)responseObject;
            NSString *status = [bodyDic objectForKey:@"success"];
            if ([status isEqualToString:@"true"]) {
                if (![operation isCancelled]) {
                    if (block) {
                        block(nil, nil, responseObject);
                    }
                }
                return ;
            } else if([status isEqualToString:@"false"]) {
                NSDictionary *errorDic = [bodyDic objectForKey:@"error"];
                if([errorDic isKindOfClass:[NSDictionary class]] == YES){
                    NSString *pStrCode = [errorDic objectForKey:@"code"];
                    if([pStrCode isKindOfClass:[NSString class]] == YES){
                        //当token错误，或者失效,重新请求token
                        if([pStrCode isEqualToString:@"4001"] == YES){
                            [HINetService askToken:strUrl withBody:parametersDic withType:nType completionHandler:block];
                            return;
                        }else if([pStrCode isEqualToString:@"402"] == YES){
                            [UCUITools exitSystem];
                            return;
                        }else if([pStrCode isEqualToString:@"401"] == YES){
                            [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                [UCUITools exitSystem];
                            }];
                        }
                    }
                }
                if (![operation isCancelled]) {
                    if (block) {
                        block(nil, responseObject[@"error"], nil);
                    }
                }
                return;
            }
            
            // error
            if (![operation isCancelled]) {
                if (block) {
                    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1004 userInfo:nil];
                    block(error, nil, nil);
                }
                return;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ %@", error, operation.responseString);
        NSDictionary *bodyErrorDic = (NSDictionary *)(operation.responseObject);
        NSDictionary *errorDic = [bodyErrorDic objectForKey:@"error"];
        if([errorDic isKindOfClass:[NSDictionary class]] == YES){
            NSString *pStrCode = [errorDic objectForKey:@"code"];
            if([pStrCode isKindOfClass:[NSString class]] == YES){
                //当token错误，或者失效,重新请求token
                if([pStrCode isEqualToString:@"4001"] == YES){
                    [HINetService askToken:strUrl withBody:parametersDic  withType:nType completionHandler:block];
                    return;
                }else if([pStrCode isEqualToString:@"402"] == YES){
                    [UCUITools exitSystem];
                    return;
                }else if([pStrCode isEqualToString:@"401"] == YES){
                    [HIUIAlertView showAlertWithTitle:@"警告" message:@"您的账号已在其他设备上登录!" cancelTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                        [UCUITools exitSystem];
                    }];
                }
            }
        }
        
        if (![operation isCancelled]) {
            if (block) {
                block(error, nil, nil);
            }
            
            return;
        }
    }];
    [requestOperation start];
    NSString *baseUrl = API_PURE_DOMAIN;
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, strUrl]];
    
    INFO(@"URL = %@\n Parameters = %@\n", URL.absoluteString, parametersDic);
    
    return requestOperation;
}

+ (void)askToken:(NSString*)pStrURl withBody:(NSDictionary*)pParams withType:(int)nType
completionHandler:(HINetServiceResultBlock)block{
    
    //获取为密码的加密的，MD5加密盐
    [HINetService requestWithUrlString:[UCOSTools getRequestSecondTokenUrl]
                            parameters:nil
                     completionHandler:^(NSError *error, id responseError, id responseObject) {
                         INFO(@"error = %@, responseError = %@, responseObject = %@", error, responseError, responseObject);
                         
                         //当成功
                         if(error){
                              AppDelegate *appleDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                             [UCUITools showNetError:error withView:appleDelegate.window];
                             return;
                         //业务错误
                         }else if(responseError){
                             [UCUITools exitSystem];

//                             if (block) {
//                                 block(nil, responseObject[@"error"], nil);
//                             }

                             return;
                         //正常业务
                         }else{
                             NSDictionary *bodyDic = (NSDictionary *)responseObject;
                             NSDictionary *resultDic = [bodyDic objectForKey:@"result"];
                             NSString *pStrAccessToken = [resultDic objectForKey:@"access_token"];
                             NSString *pStrRefresh_token = [resultDic objectForKey:@"refresh_token"];
                             
                             UCUserInfo *pUserInfo = [UCUserInfo getLocalUserInfo];
                             pUserInfo.secret_AccessToken = pStrAccessToken;
                             pUserInfo.secret_Refresh_token = pStrRefresh_token;
                             
                             [UCUserInfo saveLocalData:pUserInfo];
                             
                             if(nType == 0 ||nType == 2){
                                 if(pParams != NULL && block != NULL && pStrURl != NULL){
                                     if(nType == 0){
                                         [HINetService requestOperationWithRequestBody:pParams
                                                                     completionHandler:block
                                                                               withURL:pStrURl];
                                         
                                     }else{
                                         
                                         [HINetService requestUploadImageWithRequestBody:pStrURl
                                                                              parameters:pParams
                                                                       completionHandler:block];
                                         
                                     }
                                 }
                             }else if(nType == 1){
                                 
                             }else if(nType == 3){
                                 [HINetService uploadImageArrayRequestWithUrlString:pStrURl
                                                                       parameters:pParams
                                                                  completionHandler:block];
                             }else if(nType == 4){
                                 [HINetService GET:pStrURl
                                                   parameters:pParams
                                                   completionHandler:block];
                                 

                             }else if(nType == 5){
                                 [HINetService formDataRequestWithUrlString:pStrURl
                                                                 parameters:pParams
                                                          completionHandler:block];
                             }
                         }
                     }];
    
}

+ (NSMutableURLRequest *)getRequestByUrlString:(NSString *)pStrUrl
{
    NSString *baseUrl = API_PURE_DOMAIN;
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, pStrUrl]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60.0f];
    NSString *pStrAuthorzation = [NSString stringWithFormat:@"Bearer %@", [UCUserInfo getLocalUserInfo].secret_AccessToken];
    [request setValue:pStrAuthorzation forHTTPHeaderField:@"Authorization"];
    NSString *pStrUDID = [UCUDIDTools UDID];
    [request setValue:pStrUDID forHTTPHeaderField:@"Client-Id"];
    [request setHTTPMethod:@"POST"];
    
    return request;
}

+ (BOOL)getCurNetStatus{
    NSLog(@"Satate--%hhd",[AFNetworkReachabilityManager sharedManager].isReachable);
    return YES;
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+(AFSecurityPolicy * )getAFSecurityPolicy{
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

@end
