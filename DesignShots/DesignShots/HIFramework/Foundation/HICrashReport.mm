//
//  HICrashReport.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HICrashReport.h"
#import "HIPrecompile.h"

#define HI_CRASH_REPORT_CACHE_FILE [NSString stringWithFormat:@"%@/crash.list",[HISanbox libCachePath]]

extern "C" void HICrashReportMethod (NSException *exception)
{
#if defined(HI_CRASH_REPORT_ENABLE) && HI_CRASH_REPORT_ENABLE
    
    if (![HIFileManager fileExistsAtPath:HI_CRASH_REPORT_CACHE_FILE]) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        [array writeToFile:HI_CRASH_REPORT_CACHE_FILE atomically:YES];
    }
    
    NSString * exc = [NSString stringWithFormat:@"%@",exception];
    NSString * css = [NSString stringWithFormat:@"%@",[exception callStackSymbols]];
    NSString * date = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSDictionary * crashData = @{@"exception":exc,@"callStackSymbols":css,@"date":date};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HI_CRASH_REPORT_NOTIFICATION object:crashData];
    
    NSMutableArray * array = [[NSMutableArray alloc] initWithContentsOfFile:HI_CRASH_REPORT_CACHE_FILE];
    [array addObject:crashData];
    
    [array writeToFile:HI_CRASH_REPORT_CACHE_FILE atomically:YES];
    
#endif
}


@implementation HICrashReport

+(void) load
{
#if defined(HI_CRASH_REPORT_ENABLE) && HI_CRASH_REPORT_ENABLE
    NSSetUncaughtExceptionHandler(&HICrashReportMethod);
#endif
}

+(void) printfCrashLog
{
    INFO(@"----------Crash Log----------");
    
    for (NSDictionary * dic in [HICrashReport crashLog]) {
        
        INFO(@">>> crash date : %@",[dic objectForKey:@"date"]);
        INFO(@">>> callStackSymbols : \n%@ ",[dic objectForKey:@"callStackSymbols"]);
        INFO(@">>> exception : \n%@",[dic objectForKey:@"exception"]);
        INFO(@"///////////////////////////////////////\n");
    }
}

+(NSMutableArray *) crashLog
{
    return [NSMutableArray arrayWithContentsOfFile:HI_CRASH_REPORT_CACHE_FILE];
}

+(void) cleanCrashLog
{
    [[NSMutableArray array] writeToFile:HI_CRASH_REPORT_CACHE_FILE atomically:YES];
}

@end
