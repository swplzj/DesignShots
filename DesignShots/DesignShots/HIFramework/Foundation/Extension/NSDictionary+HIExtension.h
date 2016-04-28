//
//  NSDictionary+HIExtension.h
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

typedef NSDictionary *          (^NSDictionaryAppendBlock)(NSString *key, id value);
typedef id                      (^NSDictionaryObjectForKeyBlock)(NSString *key);

typedef NSMutableDictionary *   (^NSMutableDictionaryAppendBlock)(NSString *key, id value);

typedef id                      (^NSMutableDictionaryObjectForKeyBlock)(NSString *key);

#pragma mark - 

#undef  CONVERT_PROPERTY_CLASS
#define CONVERT_PROPERTY_CLASS(__name, __class) \
        + (Class)convertPropertyClassFor_##__name \
        {   \
            return NSClassFromString([NSString stringWithUTF8String:#__class]); \
        }

#pragma mark -

@interface NSDictionary (HIExtension)

@property (nonatomic, readonly) NSDictionaryAppendBlock         APPEND;
@property (nonatomic, readonly) NSDictionaryObjectForKeyBlock  EXTRACT;

/**
 *  @author lizhenjie, 15-04-02
 *
 *  从allKeys中根据下标取key值
 *
 *  @param index key下标
 *
 *  @return key值
 */
- (id)allKeysSelectKeyAtIndex:(NSInteger)index;

/**
 *  @author lizhenjie, 15-04-02
 *
 *  
 *
 *  @param array <#array description#>
 *
 *  @return <#return value description#>
 */
- (id)objectOfAny:(NSArray *)array;
- (NSString *)stringOfAny:(NSArray *)array;

- (id)objectAtPath:(NSString *)path;
- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other;

- (id)objectAtPath:(NSString *)path separator:(NSString *)separator;
- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other separator:(NSString *)separator;

- (id)objectAtPath:(NSString *)path withClass:(Class)aClass;
- (id)objectAtPath:(NSString *)path withClass:(Class)aClass otherwise:(NSObject *)other;

- (BOOL)boolAtPath:(NSString *)path;
- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other;

- (NSNumber *)numberAtPath:(NSString *)path;
- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other;

- (NSString *)stringAtPath:(NSString *)path;
- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other;

- (NSArray *)arrayAtPath:(NSString *)path;
- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other;

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz;
- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSArray *)other;

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path;
- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other;

- (NSDictionary *)dictAtPath:(NSString *)path;
- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other;

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path;
- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other;

- (id)objectForClass:(Class)clazz;

- (NSInteger) length;

@end

#pragma mark -

@interface NSMutableDictionary(HIExtension)

@property (nonatomic, readonly) NSMutableDictionaryAppendBlock	APPEND;
@property (nonatomic, readonly) NSMutableDictionaryObjectForKeyBlock EXTRACT;

- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path;
- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path separator:(NSString *)separator;

- (BOOL)setKeyValues:(id)first, ...;

+ (NSMutableDictionary *)keyValues:(id)first, ...;

@end

