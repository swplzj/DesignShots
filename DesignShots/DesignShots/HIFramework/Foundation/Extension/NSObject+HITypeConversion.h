//
//  NSObject+HITypeConversion.h
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

@interface NSObject (HITypeConversion)

- (NSNumber *)asNSNumber;
- (NSString *)asNSString;
- (NSDate *)asNSDate;
- (NSData *)asNSData;
- (NSArray *)asNSArray;
- (NSArray *)asNSArrayWithClass:(Class)clazz;
- (NSMutableArray *)asNSMutableArray;
- (NSMutableArray *)asNSMutableArrayWithClass:(Class)clazz;
- (NSDictionary *)asNSDictionary;
- (NSMutableDictionary *)asNSMutableDictionary;

@end
