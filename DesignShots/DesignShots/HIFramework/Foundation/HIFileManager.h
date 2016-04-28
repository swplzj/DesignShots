//
//  HIFileManager.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIFileManager : NSFileManager

+ (BOOL) removeItemAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL) copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

+ (BOOL) moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

+ (BOOL) fileExistsAtPath:(NSString *)path;

+ (BOOL) touch:(NSString *)path;

+ (BOOL) setSkipBackupAttribute:(NSString *)path;

// kb
+ (float) fileSizeWithPath:(NSString *)path;

@end
