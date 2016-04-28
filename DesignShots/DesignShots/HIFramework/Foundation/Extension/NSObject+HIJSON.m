//
//  NSObject+HIJSON.m
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSObject+HIJSON.h"
#import "HIRunTime.h"

#import "NSObject+HITypeConversion.h"

@implementation NSObject (HIJSON)

+ (id)objectsFromArray:(id)arr
{
    if ( nil == arr )
        return nil;
    
    if ( NO == [arr isKindOfClass:[NSArray class]] )
        return nil;
    
    NSMutableArray * results = [NSMutableArray array];
    
    for (__strong NSObject * obj in (NSArray *)arr )
    {
        if ( [obj isKindOfClass:[NSDictionary class]] )
        {
            obj = [self objectFromDictionary:obj];
            if ( obj )
            {
                [results addObject:obj];
            }
        }
        else
        {
            [results addObject:obj];
        }
    }
    
    return results;
}

+ (id)objectFromDictionary:(id)dict
{
    if ( nil == dict )
    {
        return nil;
    }
    
    if ( NO == [dict isKindOfClass:[NSDictionary class]] )
    {
        return nil;
    }
    
    return [(NSDictionary *)dict objectForClass:[self class]];
}

+ (id)objectFromString:(id)str
{
    if ( nil == str )
    {
        return nil;
    }
    
    if ( NO == [str isKindOfClass:[NSString class]] )
    {
        return nil;
    }
    
    NSObject * obj = [(NSString *)str objectFromJSONString];
    if ( nil == obj )
    {
        return nil;
    }
    
    if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        return [(NSDictionary *)obj objectForClass:[self class]];
    }
    else if ( [obj isKindOfClass:[NSArray class]] )
    {
        NSMutableArray * array = [NSMutableArray array];
        
        for ( NSObject * elem in (NSArray *)obj )
        {
            if ( [elem isKindOfClass:[NSDictionary class]] )
            {
                NSObject * result = [(NSDictionary *)elem objectForClass:[self class]];
                if ( result )
                {
                    [array addObject:result];
                }
            }
        }
        
        return array;
    }
    else if ( [HITypeEncoding isAtomClass:[obj class]] )
    {
        return obj;
    }
    
    return nil;
}

+ (id)objectFromData:(id)data
{
    if ( nil == data )
    {
        return nil;
    }
    
    if ( NO == [data isKindOfClass:[NSData class]] )
    {
        return nil;
    }
    
    NSObject * obj = [(NSData *)data objectFromJSONData];
    if ( obj && [obj isKindOfClass:[NSDictionary class]] )
    {
        return [(NSDictionary *)obj objectForClass:[self class]];
    }
    
    return nil;
}

+ (id)objectFromAny:(id)any
{
    if ( [any isKindOfClass:[NSArray class]] )
    {
        return [self objectsFromArray:any];
    }
    else if ( [any isKindOfClass:[NSDictionary class]] )
    {
        return [self objectFromDictionary:any];
    }
    else if ( [any isKindOfClass:[NSString class]] )
    {
        return [self objectFromString:any];
    }
    else if ( [any isKindOfClass:[NSData class]] )
    {
        return [self objectFromData:any];
    }
    
    return any;
}

- (id)objectToDictionary
{
    return [self objectToDictionaryUntilRootClass:nil];
}

- (id)objectToDictionaryUntilRootClass:(Class)rootClass
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    if ( [self isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary * dict = (NSDictionary *)self;
        
        for ( NSString * key in dict.allKeys )
        {
            NSObject * obj = [dict objectForKey:key];
            if ( obj )
            {
                NSUInteger propertyType = [HITypeEncoding typeOfObject:obj];
                
                if ( HIEncodingType_NSNumber == propertyType )
                {
                    [result setObject:obj forKey:key];
                }
                else if ( HIEncodingType_NSString == propertyType )
                {
                    [result setObject:obj forKey:key];
                }
                else if ( HIEncodingType_NSArray == propertyType )
                {
                    NSMutableArray * array = [NSMutableArray array];
                    
                    for ( NSObject * elem in (NSArray *)obj )
                    {
                        NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
                        
                        if ( dict )
                        {
                            [array addObject:dict];
                        }
                        else
                        {
                            if ( [HITypeEncoding isAtomClass:[elem class]] )
                            {
                                [array addObject:elem];
                            }
                        }
                    }
                    
                    [result setObject:array forKey:key];
                }
                else if ( HIEncodingType_NSDictionary == propertyType )
                {
                    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                    
                    for ( NSString * key in ((NSDictionary *)obj).allKeys )
                    {
                        NSObject * val = [(NSDictionary *)obj objectForKey:key];
                        if ( val )
                        {
                            NSDictionary * subresult = [val objectToDictionaryUntilRootClass:rootClass];
                            if ( subresult )
                            {
                                [dict setObject:subresult forKey:key];
                            }
                            else
                            {
                                if ( [HITypeEncoding isAtomClass:[val class]] )
                                {
                                    [dict setObject:val forKey:key];
                                }
                            }
                        }
                    }
                    
                    [result setObject:dict forKey:key];
                }
                else if ( HIEncodingType_NSDate == propertyType )
                {
                    [result setObject:[obj description] forKey:key];
                }
                else
                {
                    obj = [obj objectToDictionaryUntilRootClass:rootClass];
                    if ( obj )
                    {
                        [result setObject:obj forKey:key];
                    }
                    else
                    {
                        [result setObject:[NSDictionary dictionary] forKey:key];
                    }
                }
            }
            //			else
            //			{
            //				[result setObject:[NSNull null] forKey:key];
            //			}
        }
    }
    else
    {
        for ( Class clazzType = [self class];; )
        {
            if ( rootClass )
            {
                if ( clazzType == rootClass )
                    break;
            }
            else
            {
                if ( [HITypeEncoding isAtomClass:clazzType] )
                    break;
            }
            
            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
            
            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                const char *	name = property_getName(properties[i]);
                const char *	attr = property_getAttributes(properties[i]);
                
                NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                NSUInteger		propertyType = [HITypeEncoding typeOf:attr];
                
                NSObject * obj = [self valueForKey:propertyName];
                if ( obj )
                {
                    if ( HIEncodingType_NSNumber == propertyType )
                    {
                        [result setObject:obj forKey:propertyName];
                    }
                    else if ( HIEncodingType_NSString == propertyType )
                    {
                        [result setObject:obj forKey:propertyName];
                    }
                    else if ( HIEncodingType_NSArray == propertyType )
                    {
                        NSMutableArray * array = [NSMutableArray array];
                        
                        for ( NSObject * elem in (NSArray *)obj )
                        {
                            NSUInteger elemType = [HITypeEncoding typeOfObject:elem];
                            
                            if ( HIEncodingType_NSNumber == elemType )
                            {
                                [array addObject:elem];
                            }
                            else if ( HIEncodingType_NSString == elemType )
                            {
                                [array addObject:elem];
                            }
                            else
                            {
                                NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
                                if ( dict )
                                {
                                    [array addObject:dict];
                                }
                                else
                                {
                                    if ( [HITypeEncoding isAtomClass:[elem class]] )
                                    {
                                        [array addObject:elem];
                                    }
                                }
                            }
                        }
                        
                        [result setObject:array forKey:propertyName];
                    }
                    else if ( HIEncodingType_NSDictionary == propertyType )
                    {
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                        
                        for ( NSString * key in ((NSDictionary *)obj).allKeys )
                        {
                            NSObject * val = [(NSDictionary *)obj objectForKey:key];
                            if ( val )
                            {
                                NSDictionary * subresult = [val objectToDictionaryUntilRootClass:rootClass];
                                if ( subresult )
                                {
                                    [dict setObject:subresult forKey:key];
                                }
                                else
                                {
                                    if ( [HITypeEncoding isAtomClass:[val class]] )
                                    {
                                        [dict setObject:val forKey:key];
                                    }
                                }
                            }
                        }
                        
                        [result setObject:dict forKey:propertyName];
                    }
                    else if ( HIEncodingType_NSDate == propertyType )
                    {
                        [result setObject:[obj description] forKey:propertyName];
                    }
                    else
                    {
                        obj = [obj objectToDictionaryUntilRootClass:rootClass];
                        if ( obj )
                        {
                            [result setObject:obj forKey:propertyName];
                        }
                        else
                        {
                            [result setObject:[NSDictionary dictionary] forKey:propertyName];
                        }
                    }
                }
                //				else
                //				{
                //					[result setObject:[NSNull null] forKey:propertyName];
                //				}
            }
            
            free( properties );
            
            clazzType = class_getSuperclass( clazzType );
            if ( nil == clazzType )
                break;
        }
    }
    
    return result.count ? result : nil;
}

- (id)objectZerolize
{
    return [self objectZerolizeUntilRootClass:nil];
}

- (id)objectZerolizeUntilRootClass:(Class)rootClass
{
    for ( Class clazzType = [self class];; )
    {
        if ( rootClass )
        {
            if ( clazzType == rootClass )
                break;
        }
        else
        {
            if ( [HITypeEncoding isAtomClass:clazzType] )
                break;
        }
        
        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
        
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            const char *	attr = property_getAttributes(properties[i]);
            
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            NSUInteger		propertyType = [HITypeEncoding typeOfAttribute:attr];
            
            if ( HIEncodingType_NSNumber == propertyType )
            {
                [self setValue:[NSNumber numberWithInt:0] forKey:propertyName];
            }
            else if ( HIEncodingType_NSString == propertyType )
            {
                [self setValue:@"" forKey:propertyName];
            }
            else if ( HIEncodingType_NSArray == propertyType )
            {
                [self setValue:[NSMutableArray array] forKey:propertyName];
            }
            else if ( HIEncodingType_NSDictionary == propertyType )
            {
                [self setValue:[NSMutableDictionary dictionary] forKey:propertyName];
            }
            else if ( HIEncodingType_NSDate == propertyType )
            {
                [self setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:propertyName];
            }
            else if ( HIEncodingType_Object == propertyType )
            {
                Class clazz = [HITypeEncoding classOfAttribute:attr];
                if ( clazz )
                {
                    NSObject * newObj = [[clazz alloc] init];
                    [self setValue:newObj forKey:propertyName];
                }
                else
                {
                    [self setValue:nil forKey:propertyName];
                }
            }
            else
            {
                [self setValue:nil forKey:propertyName];
            }
        }
        
        free( properties );
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
    }
    
    return self;
}

- (id)objectToString
{
    return [self objectToStringUntilRootClass:nil];
}

- (id)objectToStringUntilRootClass:(Class)rootClass
{
    NSString *	json = nil;
    NSUInteger	propertyType = [HITypeEncoding typeOfObject:self];
    
    if ( HIEncodingType_NSNumber == propertyType )
    {
        json = [self asNSString];
    }
    else if ( HIEncodingType_NSString == propertyType )
    {
        json = [self asNSString];
    }
    else if ( HIEncodingType_NSArray == propertyType )
    {
        NSMutableArray * array = [NSMutableArray array];
        
        for ( NSObject * elem in (NSArray *)self )
        {
            NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
            if ( dict )
            {
                [array addObject:dict];
            }
            else
            {
                if ( [HITypeEncoding isAtomClass:[elem class]] )
                {
                    [array addObject:elem];
                }
            }
        }
        
        json = [array JSONString];
    }
    else if ( HIEncodingType_NSDictionary == propertyType )
    {
        NSDictionary * dict = [self objectToDictionaryUntilRootClass:rootClass];
        if ( dict )
        {
            json = [dict JSONString];
        }
    }
    else if ( HIEncodingType_NSDate == propertyType )
    {
        json = [self description];
    }
    else
    {
        NSDictionary * dict = [self objectToDictionaryUntilRootClass:rootClass];
        if ( dict )
        {
            json = [dict JSONString];
        }
    }
    
    if ( nil == json || 0 == json.length )
        return nil;
    
    return [NSMutableString stringWithString:json];
}

- (id)objectToData
{
    return [self objectToDataUntilRootClass:nil];
}

- (id)objectToDataUntilRootClass:(Class)rootClass
{
    NSString * string = [self objectToStringUntilRootClass:rootClass];
    if ( nil == string )
        return nil;
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)serializeObject
{
    NSUInteger type = [HITypeEncoding typeOfObject:self];
    
    if ( HIEncodingType_NSNumber == type )
    {
        return self;
    }
    else if ( HIEncodingType_NSString == type )
    {
        return self;
    }
    else if ( HIEncodingType_NSDate == type )
    {
        return self;
    }
    else if ( HIEncodingType_NSArray == type )
    {
        NSArray *			array = (NSArray *)self;
        NSMutableArray *	result = [NSMutableArray array];
        
        for ( NSObject * elem in array )
        {
            NSObject * val = [elem serializeObject];
            if ( val )
            {
                [result addObject:val];
            }
        }
        
        return result;
    }
    else if ( HIEncodingType_NSDictionary == type )
    {
        NSDictionary *			dict = (NSDictionary *)self;
        NSMutableDictionary *	result = [NSMutableDictionary dictionary];
        
        for ( NSString * key in dict.allKeys )
        {
            NSObject * val = [dict objectForKey:key];
            NSObject * val2 = [val serializeObject];
            
            if ( val2 )
            {
                [result setObject:val2 forKey:key];
            }
        }
        
        return result;
    }
    else if ( HIEncodingType_Object == type )
    {
        return [self objectToDictionary];
    }
    
    return nil;
}

+ (id)unserializeObject:(id)obj
{
    NSUInteger type = [HITypeEncoding typeOfObject:obj];
    
    if ( HIEncodingType_NSNumber == type )
    {
        return self;
    }
    else if ( HIEncodingType_NSString == type )
    {
        return [self objectFromString:obj];
    }
    else if ( HIEncodingType_NSDate == type )
    {
        return self;
    }
    else if ( HIEncodingType_NSArray == type )
    {
        return [self objectsFromArray:obj];
    }
    else if ( HIEncodingType_NSDictionary == type )
    {
        return [self objectFromDictionary:obj];
    }
    else if ( HIEncodingType_Object == type )
    {
        return self;
    }
    
    return nil;
}

@end
