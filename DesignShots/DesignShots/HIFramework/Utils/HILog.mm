//
//  HILog.m
//  HIFramework
//
//  Created by lizhenjie on 3/31/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HILog.h"

/**
 *  @author lizhenjie, 15-03-31 19:03:55
 *
 *  extern "C" void fun(int a, int b); 作用：告诉编译器在编译fun这个函数名时按着C的规则去翻译相应的函数名而不是C++的，C++的规则在翻译这个函数名时会把fun这个名字变得面目全非
 *  va_list 是一个字符指针，为指向当前参数的一个指针，取参必须通过这个指针进行
 */

extern "C" NSString * NSStringFormatted(NSString *format, va_list argList)
{
    return [[NSString alloc] initWithFormat:format arguments:argList];
}

extern "C" void HILog(NSObject *format, ...)
{
#if defined(HI_LOG_ENABLE) && HI_LOG_ENABLE
    if (nil == format) {
        return;
    }
    
    va_list args;
    va_start(args, format);
    
    NSString *text = nil;
    if ([format isKindOfClass:[NSString class]]) {
        text = [NSString stringWithFormat:@"HI  🔨  [LOG]  ⥤  %@", NSStringFormatted((NSString *)format, args)];
    } else {
        text = [NSString stringWithFormat:@"HI  🔨  [LOG]  ⥤  %@", [format description]];
    }
    
    va_end(args);
    
    if ([text rangeOfString:@"\n"].length) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t\t"];
    }
    
#if defined(HI_DEBUG_ENABLE) && HI_DEBUG_ENABLE
    //TODO: weiyuanc
#endif
    
    printf("%s", [text UTF8String]);
    printf("\n");
    
#endif
}


extern "C" void HIInfo( NSObject * format, ... )
{
#if defined(HI_LOG_ENABLE) && HI_LOG_ENABLE
    
    if (nil == format )
        return;
    
    va_list args;
    va_start( args, format );
    
    NSString * text = nil;
    
    if ( [format isKindOfClass:[NSString class]] ){
        text = [NSString stringWithFormat:@"HI 📝 [INFO] ⥤ %@", NSStringFormatted((NSString *)format, args)];
    } else{
        text = [NSString stringWithFormat:@"HI 📝 [INFO] ⥤ %@", [format description]];
    }
    
    va_end( args );
    
    if ( [text rangeOfString:@"\n"].length ){
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
    }
    
#if defined(HI_DEBUG_ENABLE) && HI_DEBUG_ENABLE

    [[HIDebugInformationView HIInstance] appendLogString:text];
    
#endif
    
    printf("%s",[text UTF8String]);
    printf("\n");
    
#endif
    
}

extern "C" void HIError(NSString *file, const char *function, int line, NSObject *format, ...)
{
    va_list args;
    va_start(args, format);
    
    NSString *text = nil;
    if ([format isKindOfClass:[NSString class]]) {
        text = [NSString stringWithFormat:@"HI  💣  [ERROR]  ⥤  %@", NSStringFormatted((NSString *)format, args)];
    } else {
        text = [NSString stringWithFormat:@"HI  💣  [ERROR]  ⥤  %@", [format description]];
    }
    
    va_end(args);
    
    if ([text rangeOfString:@"\n"].length) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
    }
    
#if defined(HI_DEBUG_ENABLE) && HI_DEBUG_ENABLE

    //TODO: DEBUGINFO
    
#endif
    
    
    printf("%s", [text UTF8String]);
    printf("\n\n[\n    File : %s", [file UTF8String]);
    printf("\n    Line : %d", line);
    printf("\n    Function : %s\n]\n\n", function);
    
#if defined(HI_ERROR_LOCAL_FILE_LOG) && HI_ERROR_LOCAL_FILE_LOG
    
    //TODO: Write to file ...
#endif
    
}

extern "C" void HICMDLog(NSObject *format, ...)
{
#if defined(HI_DEBUG_ENABLE) && HI_DEBUG_ENABLE
    
    va_list args;
    va_start(args, format);
    
    NSString *text = nil;
    
    if ([format isKindOfClass:[NSString class]]){
        text = [NSString stringWithFormat:@"HI  ➕  [CMD]  ⥤  %@", NSStringFormatted((NSString *)format, args)];
    } else {
        text = [NSString stringWithFormat:@"HI  ➕  [CMD]  ⥤  %@", [format description]];
    }
    
    va_end( args );
    
    if ( [text rangeOfString:@"\n"].length ){
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
    }
    //TODO: debuginfo
    [[HIDebugInformationView HIInstance] appendLogString:text];
    printf("%s",[text UTF8String]);
    printf("\n");
    
#endif
}

NSString *extractFileNameWithoutExtension(const char *filePath, BOOL copy)
{
    if (NULL == filePath) {
        return nil;
    }
    
    char *lastSlash = NULL;
    char *lastDot = NULL;
    
    char *path = (char *)filePath;
    
    while (*path != '\0') {
        if (*path == '/') {
            lastSlash = path;
        } else if(*path == '.') {
            lastDot = path;
        }
        path++;
    }
    
    char *subStr;
    NSUInteger subLen;
    
    if (lastSlash) {
        if (lastDot) {
            // lastSlash -> lastDot
            subStr = lastSlash + 1;
            subLen = lastDot - subStr;
        } else {
            // lastSlash -> endOfString
            subStr = lastSlash + 1;
            subLen = path - subStr;
        }
    } else {
        if (lastDot) {
            // startOfString -> lastDot
            subStr = (char *)filePath;
            subLen = lastDot - subStr;
        } else {
            // startOfString -> endOfString
            subStr = (char *)filePath;
            subLen = path - subStr;
        }
    }
    
    if (copy) {
        return [[NSString alloc] initWithBytes:subStr
                                        length:subLen
                                      encoding:NSUTF8StringEncoding];
    } else {
        return [[NSString alloc] initWithBytesNoCopy:subStr
                                              length:subLen
                                            encoding:NSUTF8StringEncoding
                                        freeWhenDone:NO];
    }
    
}







// @"HI ⇶ ➕⚠️💣👾👿✨👹👀📝🔧👻🔨🐞🐜";
