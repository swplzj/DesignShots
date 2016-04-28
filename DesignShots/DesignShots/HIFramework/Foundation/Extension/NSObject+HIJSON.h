//
//  NSObject+HIJSON.h
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HIJSON)

+ (id)objectsFromArray:(id)arr;
+ (id)objectFromDictionary:(id)dict;
+ (id)objectFromString:(id)str;
+ (id)objectFromData:(id)data;
+ (id)objectFromAny:(id)any;

- (id)objectToDictionary;
- (id)objectToString;
- (id)objectToData;
- (id)objectZerolize;

- (id)objectToDictionaryUntilRootClass:(Class)rootClass;
- (id)objectToStringUntilRootClass:(Class)rootClass;
- (id)objectToDataUntilRootClass:(Class)rootClass;
- (id)objectZerolizeUntilRootClass:(Class)rootClass;

- (id)serializeObject;
+ (id)unserializeObject:(id)obj;

@end
