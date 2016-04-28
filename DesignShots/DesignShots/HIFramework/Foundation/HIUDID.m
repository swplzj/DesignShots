//
//  HIUDID.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUDID.h"

#define KEY_CHAIN_ADDRESS   @"HI_UDID"

@implementation HIUDID

+ (NSString *)UDID
{
    NSString *udid = [HIUDID UDIDFromKeyChain];
    
    if (!udid) {
        udid = [NSString uuid];
        [HIUDID setUDIDToKeyChain:udid];
    }
    return udid;
}


+ (NSString *)UDIDFromKeyChain
{
    return [HIKeychain objectForKey:KEY_CHAIN_ADDRESS];
}

+ (void)setUDIDToKeyChain:(NSString *)udid
{
    [HIKeychain setObject:udid forKey:KEY_CHAIN_ADDRESS];
}

@end

