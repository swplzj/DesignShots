//
//  HIRunTime.h
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"


#pragma mark -

#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	[HIRuntime printCallstack:__n]

#undef	BREAK_POINT
#define BREAK_POINT()			[HIRuntime breakPoint];

#undef	BREAK_POINT_IF
#define BREAK_POINT_IF( __x )	if ( __x ) { [HIRuntime breakPoint]; }

#pragma mark -

typedef enum _HICallFrameType {
    
    HICallFrame_Unknown    = 0,
    HICallFrame_OBJC       = 1,
    HICallFrame_NativeC    = 2,
    
} HICallFrameType;

@interface HICallFrame : NSObject

@property (nonatomic, assign) NSUInteger	type;
@property (nonatomic, retain) NSString *	process;
@property (nonatomic, assign) NSUInteger	entry;
@property (nonatomic, assign) NSUInteger	offset;
@property (nonatomic, retain) NSString *	clazz;
@property (nonatomic, retain) NSString *	method;

+ (id)parse:(NSString *)line;
+ (id)unknown;

@end

#pragma mark -

typedef enum _HIEncodingType {
    
    HIEncodingType_Unknown      = 0,
    HIEncodingType_Object       = 1,
    HIEncodingType_NSNumber     = 2,
    HIEncodingType_NSString     = 3,
    HIEncodingType_NSArray      = 4,
    HIEncodingType_NSDictionary = 5,
    HIEncodingType_NSDate       = 6,
    
} HIEncodingType;

@interface HITypeEncoding : NSObject

+ (NSUInteger)typeOf:(const char *)attr;
+ (NSUInteger)typeOfAttribute:(const char *)attr;
+ (NSUInteger)typeOfObject:(id)obj;

+ (NSString *)classNameOf:(const char *)attr;
+ (NSString *)classNameOfAttribute:(const char *)attr;

+ (Class)classOfAttribute:(const char *)attr;

+ (BOOL)isAtomClass:(Class)clazz;

@end

#pragma mark -

@interface HIRuntime : NSObject

+ (id)allocByClass:(Class)clazz;
+ (id)allocByClassName:(NSString *)clazzName;

+ (NSArray *)allClasses;
+ (NSArray *)allSubClassesOf:(Class)clazz;

+ (NSArray *)callstack:(NSUInteger)depth;
+ (NSArray *)callframes:(NSUInteger)depth;

+ (void)printCallstack:(NSUInteger)depth;


@end
