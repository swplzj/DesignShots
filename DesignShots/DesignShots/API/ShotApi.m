//
//  ShotApi.m
//  DesignShots
//
//  Created by lizhenjie on 4/29/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "ShotApi.h"

@implementation ShotApi

- (NSString *)requestURL {
    return @"/shots";
}

- (HIRequestMethod)requestMethod {
    return HIRequestMethodGet;
}

- (id)requestParameter {
    return @{
             };
}

- (id)JSONValidator
{
    return @{
             
             };
}

@end
