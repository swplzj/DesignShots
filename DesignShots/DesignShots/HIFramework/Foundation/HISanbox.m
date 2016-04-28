//
//  HISanbox.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HISanbox.h"
#import "HIPrecompile.h"

static int autoCleanTmpPath = NO;

@implementation HISanbox

+(void) autoCleanTmpPath:(BOOL)yesOrNo
{
    autoCleanTmpPath = yesOrNo;
    
    if (autoCleanTmpPath) {
        //
    }
}

-(id) init
{
    HI_SUPER_INIT({
        
        [self observeNotification:UIApplicationDidFinishLaunchingNotification];
        
    })
}

-(void) handleNotification:(NSNotification *)notification
{
    if ([notification is:UIApplicationDidFinishLaunchingNotification]) {
        
        
    }
}

+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{
    return NSTemporaryDirectory();
    
}

@end
