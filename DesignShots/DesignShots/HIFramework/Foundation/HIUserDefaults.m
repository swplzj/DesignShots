//
//  HIUserDefaults.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUserDefaults.h"

#define HI_STANDAR_USER_DEFAULTS    [NSUserDefaults standardUserDefaults]
@implementation HIUserDefaults

+ (BOOL)setObject:(id)object forKey:(NSString *)key
{
    [HI_STANDAR_USER_DEFAULTS setObject:object forKey:key];
    return [HI_STANDAR_USER_DEFAULTS synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    return [HI_STANDAR_USER_DEFAULTS objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key
{
    [HI_STANDAR_USER_DEFAULTS removeObjectForKey:key];
    [HI_STANDAR_USER_DEFAULTS synchronize];
}

@end
