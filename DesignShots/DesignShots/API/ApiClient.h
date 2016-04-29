//
//  ApiClient.h
//  DesignShots
//
//  Created by lizhenjie on 4/29/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApiClientSetting;

/**
 *  ApiClient is a class that it use to request api data
 */
@interface ApiClient : NSObject

+ (instancetype)shareApiClient;

#pragma mark - Auth


@end
