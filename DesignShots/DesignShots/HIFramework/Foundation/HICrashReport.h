//
//  HICrashReport.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HINotification.h"

#define HI_CRASH_REPORT_NOTIFICATION    @"HI_CRASH_REPORT_NOTIFICATION"

#if __cplusplus
extern "C" {
#endif
    
    void HICrashReportMethod( NSException * exception );
    
#if __cplusplus
};
#endif


@interface HICrashReport : NSObject

+ (void)printfCrashLog;
+ (void)cleanCrashLog;

+ (NSMutableArray *)crashLog;

@end
