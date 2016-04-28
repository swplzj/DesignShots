//
//  NSDictionary+HIExtension.m
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSDictionary+HIExtension.h"
#import <objc/runtime.h>

@implementation NSDictionary (HIExtension)

@dynamic APPEND;

- (NSDictionaryAppendBlock)APPEND
{
    NSDictionaryAppendBlock block = ^ NSDictionary *(NSString *key, id value){
        if (key && value) {
            NSString *className = [[self class] description];
            if ([self isKindOfClass:[NSMutableDictionary class]] || [className isEqualToString:@"NSMutableDictionary"] || [className isEqualToString:@"__NSDictionaryM"]) {
                [(NSMutableDictionary *)self setObject:value atPath:key];
                return self;
            } else {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
                [dict setObject:value atPath:key];
                return dict;
            }
        }
        return self;
    };
    
    return [block copy];
}

- (NSDictionaryObjectForKeyBlock)EXTRACT
{
    NSDictionaryObjectForKeyBlock block = ^ id (NSString *key){
        if (key) {
            return [self objectForKey:key];
        }
        return nil;
    };
    
    return [block copy];
}

- (id)allKeysSelectKeyAtIndex:(NSInteger)index
{
    if (index + 1 >  self.allKeys.count) {
        ERROR(@"NSDictionary+HIExtension - allKeysSelectKeyAtIndex 越界 keys count : %d index : %d", self.allKeys.count, index);
        return nil;
    }
    return [self.allKeys objectAtIndex:index];
}

- (id)objectOfAny:(NSArray *)array
{
    for (NSString *key in array) {
        NSObject *obj = [self objectForKey:key];
        if (obj) {
            return obj;
        }
    }
    return nil;
}

- (NSString *)stringOfAny:(NSArray *)array
{
    NSObject *obj = [self objectOfAny:array];
    if (nil == obj) {
        return nil;
    }
    
    return [obj asNSString];
}

- (id)objectAtPath:(NSString *)path
{
    return [self objectAtPath:path separator:nil];
}

- (id)objectAtPath:(NSString *)path separator:(NSString *)separator
{
    if (nil == separator) {
        path = [path stringByReplacingOccurrencesOfString:@"." withString:@"/"];
        separator = @"/";
    }
    
#if 1
    
    NSArray *array = [path componentsSeparatedByString:separator];
    if (0 == [array count]) {
        return nil;
    }
    
    NSObject *result = nil;
    NSDictionary *dict = nil;
    
    for (NSString *subPath in array) {
        if (0 == [subPath length]) {
            continue;
        }
        
        result = [dict objectForKey:subPath];
        if (nil == result) {
            return nil;
        }
        
        if ([array lastObject] == subPath) {
            return result;
        } else if(NO == [result isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        dict = (NSDictionary *)result;
    }
    return result == [NSNull null] ? nil : result;
    
#else
    
    NSString *	keyPath = [path stringByReplacingOccurrencesOfString:separator withString:@"."];
    NSRange		range = NSMakeRange( 0, 1 );
    
    if ( [[keyPath substringWithRange:range] isEqualToString:@"."] ) {
        keyPath = [keyPath substringFromIndex:1];
    }
    
    NSObject * result = [self valueForKeyPath:keyPath];
    return (result == [NSNull null]) ? nil : result;
    
#endif
    
}

- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other
{
    NSObject *obj = [self objectAtPath:path];
    return obj ? obj : other;
}

- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other separator:(NSString *)separator
{
    NSObject *obj = [self objectAtPath:path separator:separator];
    return obj ? obj : other;
}

- (id)objectAtPath:(NSString *)path withClass:(Class)aClass
{
    return [self objectAtPath:path withClass:aClass otherwise:nil];
}

- (id)objectAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSObject *)other
{
    NSObject * obj = [self objectAtPath:path];
    if ( obj && [obj isKindOfClass:[NSDictionary class]] )
    {
        return [clazz objectFromDictionary:obj];
    }
    
    return nil;
}

- (BOOL)boolAtPath:(NSString *)path
{
    return [self boolAtPath:path otherwise:NO];
}

- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other
{
    NSObject * obj = [self objectAtPath:path];
    if ( [obj isKindOfClass:[NSNull class]] )
    {
        return NO;
    }
    else if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return [(NSNumber *)obj intValue] ? YES : NO;
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        if ( [(NSString *)obj hasPrefix:@"y"] ||
            [(NSString *)obj hasPrefix:@"Y"] ||
            [(NSString *)obj hasPrefix:@"T"] ||
            [(NSString *)obj hasPrefix:@"t"] ||
            [(NSString *)obj isEqualToString:@"1"] )
        {
            // YES/Yes/yes/TRUE/Ture/true/1
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return other;
}

- (NSNumber *)numberAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    if ( [obj isKindOfClass:[NSNull class]] )
    {
        return nil;
    }
    else if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return (NSNumber *)obj;
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        return [NSNumber numberWithDouble:[(NSString *)obj doubleValue]];
    }
    
    return nil;
}

- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other
{
    NSNumber * obj = [self numberAtPath:path];
    return obj ? obj : other;
}

- (NSString *)stringAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    if ( [obj isKindOfClass:[NSNull class]] )
    {
        return nil;
    }
    else if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return [NSString stringWithFormat:@"%d", [(NSNumber *)obj intValue]];
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        return (NSString *)obj;
    }
    
    return nil;
}

- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other
{
    NSString * obj = [self stringAtPath:path];
    return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    return [obj isKindOfClass:[NSArray class]] ? (NSArray *)obj : nil;
}

- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other
{
    NSArray * obj = [self arrayAtPath:path];
    return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz
{
    return [self arrayAtPath:path withClass:clazz otherwise:nil];
}

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSArray *)other
{
    NSArray * array = [self arrayAtPath:path otherwise:nil];
    if ( array )
    {
        NSMutableArray * results = [NSMutableArray array];
        for ( NSObject * obj in array )
        {
            if ( [obj isKindOfClass:[NSDictionary class]] )
            {
                [results addObject:[clazz objectFromDictionary:obj]];
            }
        }
        return results;
    }
    return other;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    return [obj isKindOfClass:[NSMutableArray class]] ? (NSMutableArray *)obj : nil;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other
{
    NSMutableArray * obj = [self mutableArrayAtPath:path];
    return obj ? obj : other;
}

- (NSDictionary *)dictAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    return [obj isKindOfClass:[NSDictionary class]] ? (NSDictionary *)obj : nil;
}

- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other
{
    NSDictionary * obj = [self dictAtPath:path];
    return obj ? obj : other;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    return [obj isKindOfClass:[NSMutableDictionary class]] ? (NSMutableDictionary *)obj : nil;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other
{
    NSMutableDictionary * obj = [self mutableDictAtPath:path];
    return obj ? obj : other;
}

- (id)objectForClass:(Class)clazz
{
    id object = [[clazz alloc] init];
    if ( nil == object )
        return nil;
    
    for ( Class clazzType = clazz; clazzType != [NSObject class]; ) {
        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
        
        for ( NSUInteger i = 0; i < propertyCount; i++ ) {
            const char *	name = property_getName(properties[i]);
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            const char *	attr = property_getAttributes(properties[i]);
            NSUInteger		type = [HITypeEncoding typeOf:attr];
            
            NSObject *	tempValue = [self objectForKey:propertyName];
            NSObject *	value = nil;
            
            if ( tempValue ) {
                if ( HIEncodingType_NSNumber == type ) {
                    value = [tempValue asNSNumber];
                } else if ( HIEncodingType_NSString == type ) {
                    value = [tempValue asNSString];
                } else if ( HIEncodingType_NSDate == type ) {
                    value = [tempValue asNSDate];
                } else if ( HIEncodingType_NSArray == type ) {
                    if ( [tempValue isKindOfClass:[NSArray class]] ) {
                        SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
                        if ( [clazz respondsToSelector:convertSelector] ){
                            Class convertClass = [self performSelector:@selector(convertSelector:) withObject:propertyName];
                            //Class convertClass = [clazz performSelector:convertSelector];
                            if ( convertClass ){
                                NSMutableArray * arrayTemp = [NSMutableArray array];
                                
                                for ( NSObject * tempObject in (NSArray *)tempValue ) {
                                    if ( [tempObject isKindOfClass:[NSDictionary class]] ) {
                                        [arrayTemp addObject:[(NSDictionary *)tempObject objectForClass:convertClass]];
                                    }
                                }
                                
                                value = arrayTemp;
                            } else {
                                value = tempValue;
                            }
                        } else {
                            value = tempValue;
                        }
                    }
                } else if ( HIEncodingType_NSDictionary == type ) {
                    if ( [tempValue isKindOfClass:[NSDictionary class]] ) {
                        SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
                        if ( [clazz respondsToSelector:convertSelector] ) {
                            Class convertClass = [self performSelector:@selector(convertSelector:) withObject:propertyName];
                            //Class convertClass = [clazz performSelector:convertSelector];
                            if ( convertClass ) {
                                value = [(NSDictionary *)tempValue objectForClass:convertClass];
                            } else {
                                value = tempValue;
                            }
                        } else {
                            value = tempValue;
                        }
                    }
                } else if ( HIEncodingType_Object == type ) {
                    NSString * className = [HITypeEncoding classNameOfAttribute:attr];
                    if ( [tempValue isKindOfClass:NSClassFromString(className)] ) {
                        value = tempValue;
                    } else if ( [tempValue isKindOfClass:[NSDictionary class]] ) {
                        value = [(NSDictionary *)tempValue objectForClass:NSClassFromString(className)];
                    }
                }
            }
            if (value) {
                [object setValue:value forKey:propertyName];
            }
        }
        
        free( properties );
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
    }
    
    return object;
}
- (SEL) convertSelector:(NSString *)propertyName {
    SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
    return convertSelector;
}

- (NSInteger) length
{
    ERROR(@"NSDictionary can't call length!");
    
    return 0;
}

@end


@implementation NSMutableDictionary (HIExtension)

@dynamic APPEND;

- (NSMutableDictionaryAppendBlock)APPEND
{
    NSMutableDictionaryAppendBlock block = ^ NSMutableDictionary * ( NSString * key, id value ){
        if (key && value){
            [self setObject:value atPath:key];
        }
        
        return self;
    };
    
    return [block copy];
}

- (NSMutableDictionaryObjectForKeyBlock)EXTRACT
{
    NSMutableDictionaryObjectForKeyBlock block = ^ id ( NSString *key ){
        if (key){
            return [self objectForKey:key];
        }
        
        return nil;
    };
    
    return [block copy];
}


- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path
{
    return [self setObject:obj atPath:path separator:nil];
}

- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path separator:(NSString *)separator
{
    if (0 == [path length]) {
        return NO;
    }
    
    if (nil == separator) {
        path = [path stringByReplacingOccurrencesOfString:@"." withString:@"/"];
        separator = @"/";
    }
    
    NSArray *array = [path componentsSeparatedByString:separator];
    if (0 == [array count]) {
        [self setObject:obj forKey:path];
        return YES;
    }
    
    NSMutableDictionary *upperDict  = self;
    NSDictionary        *dict       = nil;
    NSString            *subPath    = nil;
    
    for (subPath in array) {
        if (0 == [subPath length]) {
            continue;
        }
        
        if ([array lastObject] == subPath) {
            break;
        }
        
        dict = [upperDict objectForKey:subPath];
        if (nil == dict) {
            dict = [NSMutableDictionary dictionary];
            [upperDict setObject:dict forKey:subPath];
        } else {
            if (NO == [dict isKindOfClass:[NSDictionary class]]) {
                return NO;
            }
            
            if (NO == [dict isKindOfClass:[NSMutableDictionary class]]) {
                dict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [upperDict setObject:dict forKey:subPath];
            }
        }
        
        upperDict = (NSMutableDictionary *)dict;
    }
    
    if (subPath) {
        [upperDict setObject:obj forKey:subPath];
    }
    
    return YES;
}


- (BOOL)setKeyValues:(id)first, ...
{
    va_list args;
    va_start( args, first );
    
    for ( ;; first = nil )
    {
        NSObject * key = first ? first : va_arg( args, NSObject * );
        if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        BOOL ret = [self setObject:value atPath:(NSString *)key];
        if ( NO == ret ) {
            va_end( args );
            return NO;
        }
    }
    va_end( args );
    return YES;
}

+ (NSMutableDictionary *)keyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; first = nil )
    {
        NSObject * key = first ? first : va_arg( args, NSObject * );
        if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value atPath:(NSString *)key];
    }
    va_end( args );
    return dict;
}

@end
