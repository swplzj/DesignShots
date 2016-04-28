//
//  HIUserDefaults.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIUserDefaults : NSUserDefaults

+ (BOOL)setObject:(id)object forKey:(NSString *)key;

+ (id)objectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;

@end
