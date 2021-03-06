//
//  HIFileManager.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIFileManager.h"
#import "HIPrecompile.h"
#include <sys/xattr.h> 

@implementation HIFileManager

+ (BOOL) removeItemAtPath:(NSString *)path error:(NSError **)error
{
    return [[HIFileManager defaultManager] removeItemAtPath:path error:error];
}

+ (BOOL) moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error
{
    return [[HIFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
}

+(BOOL) copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error
{
    return [[HIFileManager defaultManager] copyItemAtPath:path toPath:toPath error:error];
}

+(BOOL) fileExistsAtPath:(NSString *)path
{
    return [[HIFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)touch:(NSString *)path
{
    if ( NO == [HIFileManager fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

+ (BOOL) setSkipBackupAttribute:(NSString *)path
{
    NSString * strVersion = [[UIDevice currentDevice] systemVersion];
    float fVersion = 0.0;
    
    if (strVersion.length > 0) {
        fVersion = [strVersion floatValue];
    }
    
    BOOL result = NO;
    
    NSURL * url = [NSURL fileURLWithPath:path];
    
    if (fVersion >= 5.1f) {
        result = [self addSkipBackupAttributeToItemAtURL_iOS5_1:url];
    }
    
    if ((fVersion > 5.0f) && (fVersion < 5.1f)) {
        result = [self addSkipBackupAttributeToItemAtURL:url];
    }
    
    return result;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL_iOS5_1:(NSURL *)URL
{
    BOOL success = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                 forKey:NSURLIsExcludedFromBackupKey error:&error];
        
        if (!success) {
            ERROR(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
    }
    
    return success;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    int result = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]) {
        const char *filePath = [[URL path] fileSystemRepresentation];
        
        const char  *attrName = "com.apple.MobileBackup";
        u_int8_t    attrValue = 1;
        
        result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    }
    
    return result;
}

+ (float) fileSizeWithPath:(NSString *)path
{
    NSDictionary * fileAttributes = [[HIFileManager HIInstance] attributesOfItemAtPath:path error:nil];
    
    unsigned long long length = [fileAttributes fileSize];
    
    return length/1024.0;
}

@end
