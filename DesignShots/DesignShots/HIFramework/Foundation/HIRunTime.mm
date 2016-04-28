//
//  HIRunTime.m
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIRunTime.h"
#import "HILog.h"
#import "NSArray+HIExtension.h"

#pragma mark -

#undef	MAX_CALLSTACK_DEPTH
#define MAX_CALLSTACK_DEPTH	(64)

#pragma mark -

@interface HICallFrame()
{
    NSUInteger			_type;
    NSString *			_process;
    NSUInteger			_entry;
    NSUInteger			_offset;
    NSString *			_clazz;
    NSString *			_method;
}

+ (NSUInteger)hex:(NSString *)text;
+ (id)parseFormat1:(NSString *)line;
+ (id)parseFormat2:(NSString *)line;

@end

#pragma mark -

@implementation HICallFrame

@synthesize type = _type;
@synthesize process = _process;
@synthesize entry = _entry;
@synthesize offset = _offset;
@synthesize clazz = _clazz;
@synthesize method = _method;

- (NSString *)description
{
    if (HICallFrame_OBJC == _type){
        return [NSString stringWithFormat:@"[O] %@(0x%08x + %llu) -> [%@ %@]", _process, (unsigned int)_entry, (unsigned long long)_offset, _clazz, _method];
    } else if (HICallFrame_NativeC == _type) {
        return [NSString stringWithFormat:@"[C] %@(0x%08x + %llu) -> %@", _process, (unsigned int)_entry, (unsigned long long)_offset, _method];
    } else {
        return [NSString stringWithFormat:@"[X] <unknown>(0x%08x + %llu)", (unsigned int)_entry, (unsigned long long)_offset];
    }
}

+ (NSUInteger)hex:(NSString *)text
{
    unsigned int number = 0;
    [[NSScanner scannerWithString:text] scanHexInt:&number];
    return (NSUInteger)number;
}

+ (id)parseFormat1:(NSString *)line
{
    //	example: peeper  0x00001eca -[PPAppDelegate application:didFinishLaunchingWithOptions:] + 106
    NSError * error = NULL;
    NSString * expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+-\\[([a-z0-9_]+)\\s+([a-z0-9_:]+)]\\s+\\+\\s+([0-9]+)$";
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult * result = [regex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];
    if (result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges){
        HICallFrame * frame = [[HICallFrame alloc] init];
        frame.type = HICallFrame_OBJC;
        frame.process = [line substringWithRange:[result rangeAtIndex:1]];
        frame.entry = [HICallFrame hex:[line substringWithRange:[result rangeAtIndex:2]]];
        frame.clazz = [line substringWithRange:[result rangeAtIndex:3]];
        frame.method = [line substringWithRange:[result rangeAtIndex:4]];
        frame.offset = [[line substringWithRange:[result rangeAtIndex:5]] intValue];
        return frame;
    }
    
    return nil;
}

+ (id)parseFormat2:(NSString *)line
{
    //	example: UIKit 0x0105f42e UIApplicationMain + 1160
    NSError * error = NULL;
    NSString * expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+([a-z0-9_]+)\\s+\\+\\s+([0-9]+)$";
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult * result = [regex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];
    if (result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges){
        HICallFrame * frame = [[HICallFrame alloc] init];
        frame.type = HICallFrame_NativeC;
        frame.process = [line substringWithRange:[result rangeAtIndex:1]];
        frame.entry = [self hex:[line substringWithRange:[result rangeAtIndex:2]]];
        frame.clazz = nil;
        frame.method = [line substringWithRange:[result rangeAtIndex:3]];
        frame.offset = [[line substringWithRange:[result rangeAtIndex:4]] intValue];
        return frame;
    }
    
    return nil;
}

+ (id)unknown
{
    HICallFrame * frame = [[HICallFrame alloc] init];
    frame.type = HICallFrame_Unknown;
    return frame;
}

+ (id)parse:(NSString *)line
{
    if (0 == [line length])
        return nil;
    
    id frame1 = [HICallFrame parseFormat1:line];
    if (frame1)
        return frame1;
    
    id frame2 = [HICallFrame parseFormat2:line];
    if (frame2)
        return frame2;
    
    return [HICallFrame unknown];
}

@end

#pragma mark -

@implementation HITypeEncoding

+ (NSUInteger)typeOf:(const char *)attr
{
    if ( attr[0] != 'T' )
        return HIEncodingType_Unknown;
    
    const char * type = &attr[1];
    if (type[0] == '@'){
        if (type[1] != '"')
            return HIEncodingType_Unknown;
        
        char typeClazz[128] = { 0 };
        
        const char * clazz = &type[2];
        const char * clazzEnd = strchr( clazz, '"' );
        
        if ( clazzEnd && clazz != clazzEnd ){
            unsigned int size = (unsigned int)(clazzEnd - clazz);
            strncpy( &typeClazz[0], clazz, size );
        }
        
        if ( 0 == strcmp((const char *)typeClazz, "NSNumber") ){
            return HIEncodingType_NSNumber;
        } else if ( 0 == strcmp((const char *)typeClazz, "NSString") || 0 == strcmp((const char *)typeClazz, "NSMutableString")){
            return HIEncodingType_NSString;
        } else if ( 0 == strcmp((const char *)typeClazz, "NSDate") ) {
            return HIEncodingType_NSDate;
        } else if ( 0 == strcmp((const char *)typeClazz, "NSArray") || 0 == strcmp((const char *)typeClazz, "NSMutableArray")) {
            return HIEncodingType_NSArray;
        } else if ( 0 == strcmp((const char *)typeClazz, "NSDictionary") || 0 == strcmp((const char *)typeClazz, "NSMutableDictionary")) {
            return HIEncodingType_NSDictionary;} else {
            return HIEncodingType_Object;
        }
    } else if ( type[0] == '[' ) {
        return HIEncodingType_Unknown;
    } else if ( type[0] == '{' ) {
        return HIEncodingType_Unknown;
    } else {
        if ( type[0] == 'c' || type[0] == 'C' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == 'i' || type[0] == 's' || type[0] == 'l' || type[0] == 'q' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == 'I' || type[0] == 'S' || type[0] == 'L' || type[0] == 'Q' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == 'f' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == 'd' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == 'B' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == 'v' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == '*' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == ':' ) {
            return HIEncodingType_Unknown;
        } else if ( 0 == strcmp(type, "bnum") ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == '^' ) {
            return HIEncodingType_Unknown;
        } else if ( type[0] == '?' ) {
            return HIEncodingType_Unknown;
        } else {
            return HIEncodingType_Unknown;
        }
    }
    
    return HIEncodingType_Unknown;
}

+ (NSUInteger)typeOfAttribute:(const char *)attr
{
    return [self typeOf:attr];
}

+ (NSUInteger)typeOfObject:(id)obj
{
    if ( nil == obj )
        return HIEncodingType_Unknown;
    
    if ( [obj isKindOfClass:[NSNumber class]] ){
        return HIEncodingType_NSNumber;
    } else if ( [obj isKindOfClass:[NSString class]] ) {
        return HIEncodingType_NSString;
    } else if ( [obj isKindOfClass:[NSArray class]] ) {
        return HIEncodingType_NSArray;
    } else if ( [obj isKindOfClass:[NSDictionary class]] ) {
        return HIEncodingType_NSDictionary;
    } else if ( [obj isKindOfClass:[NSDate class]] ) {
        return HIEncodingType_NSDate;
    } else if ( [obj isKindOfClass:[NSObject class]] ) {
        return HIEncodingType_Object;
    }
    
    return HIEncodingType_Unknown;
}

+ (NSString *)classNameOf:(const char *)attr
{
    if ( attr[0] != 'T' )
        return nil;
    
    const char * type = &attr[1];
    if ( type[0] == '@' ){
        if ( type[1] != '"' )
            return nil;
        
        char typeClazz[128] = { 0 };
        
        const char * clazz = &type[2];
        const char * clazzEnd = strchr( clazz, '"' );
        
        if ( clazzEnd && clazz != clazzEnd ){
            unsigned int size = (unsigned int)(clazzEnd - clazz);
            strncpy( &typeClazz[0], clazz, size );
        }
        
        return [NSString stringWithUTF8String:typeClazz];
    }
    
    return nil;
}

+ (NSString *)classNameOfAttribute:(const char *)attr
{
    return [self classNameOf:attr];
}

+ (Class)classOfAttribute:(const char *)attr
{
    NSString * className = [self classNameOf:attr];
    if ( nil == className )
        return nil;
    
    return NSClassFromString( className );
}

+ (BOOL)isAtomClass:(Class)clazz
{
    if ( clazz == [NSArray class] || [[clazz description] isEqualToString:@"__NSCFArray"] )
        return YES;
    if ( clazz == [NSData class] )
        return YES;
    if ( clazz == [NSDate class] )
        return YES;
    if ( clazz == [NSDictionary class] )
        return YES;
    if ( clazz == [NSNull class] )
        return YES;
    if ( clazz == [NSNumber class] || [[clazz description] isEqualToString:@"__NSCFNumber"] )
        return YES;
    if ( clazz == [NSObject class] )
        return YES;
    if ( clazz == [NSString class] )
        return YES;
    if ( clazz == [NSURL class] )
        return YES;
    if ( clazz == [NSValue class] )
        return YES;
    
    return NO;
}

@end

#pragma mark -


@implementation HIRuntime


+ (id)allocByClass:(Class)clazz
{
    if ( nil == clazz )
        return nil;
    
    return [clazz alloc];
}

+ (id)allocByClassName:(NSString *)clazzName
{
    if ( nil == clazzName || 0 == [clazzName length] )
        return nil;
    
    Class clazz = NSClassFromString( clazzName );
    if ( nil == clazz )
        return nil;
    
    return [clazz alloc];
}

+ (NSArray *)allClasses
{
    static NSMutableArray * __allClasses = nil;
    
    if ( nil == __allClasses )
    {
        __allClasses = [[NSMutableArray alloc] init];
    }
    
    if ( 0 == __allClasses.count )
    {
        unsigned int	classesCount = 0;
        Class *			classes = objc_copyClassList( &classesCount );
        
        for ( unsigned int i = 0; i < classesCount; ++i )
        {
            Class classType = classes[i];
            
            //			if ( NO == class_conformsToProtocol( classType, @protocol(NSObject)) )
            //				continue;
            if ( NO == class_respondsToSelector( classType, @selector(doesNotRecognizeSelector:) ) )
                continue;
            if ( NO == class_respondsToSelector( classType, @selector(methodSignatureForSelector:) ) )
                continue;
            //			if ( NO == [classType isSubclassOfClass:[NSObject class]] )
            //				continue;
            
            [__allClasses addObject:classType];
        }
        
        free( classes );
    }
    
    return __allClasses;
}

+ (NSArray *)allSubClassesOf:(Class)superClass
{
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for ( Class classType in [self allClasses] )
    {
        if ( classType == superClass )
            continue;
        
        if ( NO == [classType isSubclassOfClass:superClass] )
            continue;
        
        [results addObject:classType];
    }
    
    return results;
}

+ (NSArray *)callstack:(NSUInteger)depth
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
    
    depth = backtrace( stacks, (int)((depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : depth) );
    if ( depth )
    {
        char ** symbols = backtrace_symbols( stacks, (int)depth );
        if ( symbols )
        {
            for ( int i = 0; i < depth; ++i )
            {
                NSString * symbol = [NSString stringWithUTF8String:(const char *)symbols[i]];
                if ( 0 == [symbol length] )
                    continue;
                
                NSRange range1 = [symbol rangeOfString:@"["];
                NSRange range2 = [symbol rangeOfString:@"]"];
                
                if ( range1.length > 0 && range2.length > 0 )
                {
                    NSRange range3;
                    range3.location = range1.location;
                    range3.length = range2.location + range2.length - range1.location;
                    [array addObject:[symbol substringWithRange:range3]];
                }
                else
                {
                    [array addObject:symbol];
                }					
            }
            
            free( symbols );
        }
    }
    
    return array;
}

+ (NSArray *)callframes:(NSUInteger)depth
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
    
    depth = backtrace( stacks, int((depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : depth) );
    if ( depth )
    {
        char ** symbols = backtrace_symbols( stacks, (int)depth );
        if ( symbols )
        {
            for ( int i = 0; i < depth; ++i )
            {
                NSString * line = [NSString stringWithUTF8String:(const char *)symbols[i]];
                if ( 0 == [line length] )
                    continue;
                
                HICallFrame * frame = [HICallFrame parse:line];
                if ( nil == frame )
                    continue;
                
                [array addObject:frame];
            }
            
            free( symbols );
        }
    }
    
    return array ;
}

+ (void)printCallstack:(NSUInteger)depth
{
    NSArray * callstack = [self callstack:depth];
    if ( callstack && callstack.count )
    {
        NSLog(@"CALL STACK : %@",callstack);
    }
}

@end
