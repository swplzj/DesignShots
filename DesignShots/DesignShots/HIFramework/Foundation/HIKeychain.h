//
//  HIKeychain.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

@interface HIKeychain : NSObject

+ (BOOL)setObject:(id)object forKey:(id)key;

+ (id)objectForKey:(id)key;

+ (BOOL)removeObjectForKey:(id)key;

@end
