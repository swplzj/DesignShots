//
//  HINetworkPrivate.m
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HINetworkPrivate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HINetworkPrivate

+ (BOOL)checkJSON:(id)JSON withValidator:(id)validatorJSON {
    if ([JSON isKindOfClass:[NSDictionary class]] && [validatorJSON isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = JSON;
        NSDictionary *validator = validatorJSON;
        BOOL result = YES;
        NSEnumerator *enumerator = [validator keyEnumerator];
        NSString *key;
        while (key = [enumerator nextObject]) {
            id value = dic[key];
            id format = validator[key];
            if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                result = [self checkJSON:value withValidator:format];
                if (!result) {
                    break;
                }
            } else {
                if (![value isKindOfClass:format] && ![value isKindOfClass:[NSNull class]]) {
                    result = NO;
                    break;
                }
            }
        }
        return result;
    } else if ([JSON isKindOfClass:[NSArray class]] && [validatorJSON isKindOfClass:[NSArray class]]) {
        NSArray *validatorArray = (NSArray *)validatorJSON;
        if (validatorArray.count > 0) {
            NSArray *array = JSON;
            NSDictionary *validator = validatorJSON[0];
            for (id item in array) {
                BOOL result = [self checkJSON:item withValidator:validator];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([JSON isKindOfClass:validatorJSON]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)URLStringWithOriginURLString:(NSString *)originURLString appendParameters:(NSDictionary *)parameters {
    NSString *filteredURL = originURLString;
    NSString *paramterURLString = [self URLParametersStringFromParameters:parameters];
    if (paramterURLString && paramterURLString.length > 0) {
        if ([originURLString rangeOfString:@"?"].location != NSNotFound) {
            filteredURL = [filteredURL stringByAppendingString:paramterURLString];
        } else {
            filteredURL = [filteredURL stringByAppendingFormat:@"?%@", [paramterURLString substringFromIndex:1]];
        }
        return filteredURL;
    } else {
        return originURLString;
    }
}

+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"Error to set do not backup attribute, error = %@", error);
    }
}

+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)URLParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *parameterURLString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@", value];
            value = [self URLEncode:value];
            [parameterURLString appendFormat:@"&%@=%@", key, value];
        }
    }
    return parameterURLString;
}

+ (NSString *)URLEncode:(NSString *)str {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}

@end

@implementation HIBaseRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
            [accessory requestWillStart:self];
        }
    }
}

- (void)toggleAccessoriesWillStopCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
            [accessory requestWillStop:self];
        }
    }
}

- (void)toggleAccessoriesDidStopCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
            [accessory requestDidStop:self];
        }
    }
}

@end

@implementation HIBatchRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
            [accessory requestWillStart:self];
        }
    }
}

- (void)toggleAccessoriesWillStopCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
            [accessory requestWillStop:self];
        }
    }
}

- (void)toggleAccessoriesDidStopCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
            [accessory requestDidStop:self];
        }
    }
}

@end

@implementation HIChainRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
            [accessory requestWillStart:self];
        }
    }
}

- (void)toggleAccessoriesWillStopCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
            [accessory requestWillStop:self];
        }
    }
}

- (void)toggleAccessoriesDidStopCallBack {
    for (id<HIRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
            [accessory requestDidStop:self];
        }
    }
}

@end
