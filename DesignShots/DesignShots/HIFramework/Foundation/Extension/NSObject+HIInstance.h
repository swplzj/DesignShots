//
//  NSObject+HIInstance.h
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

@interface NSObject (HIInstance)

//performSelector

+ (instancetype) HIInstance;

+ (NSString *) currentInstanceInfo;

@end
