//
//  HILog.h
//  HIFramework
//
//  Created by lizhenjie on 3/31/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIPrecompile.h"


#undef  NSLog
#define NSLog(desc, ...)    HILog(desc, ##__VA_ARGS__)

#undef  INFO
#define INFO(desc, ...)     HIInfo(desc, ##__VA_ARGS__)

#undef  ERROR
#define ERROR(desc, ...)    HIError(HI_THIS_FILE, HI_THIS_METHOD, HI_THIS_LINE, desc, ##__VA_ARGS__)

#undef  CMDLog
#define CMDLog(desc, ...)   HICMDLog(desc, ##__VA_ARGS__)

#if __cplusplus
extern "C" {
#endif
    
    void HILog(NSObject *format, ...);
    void HIInfo(NSObject *format, ...);
    void HIError(NSString *file, const char *function, int line, NSObject *format, ...);
    void HICMDLog(NSObject *format, ...);
    NSString *extractFileNameWithoutExtension(const char *filePath, BOOL copy);
    
#if __cplusplus
};
#endif

#define HI_THIS_FILE    (extractFileNameWithoutExtension(__FILE__, NO))
#define HI_THIS_METHOD  __FUNCTION__
#define HI_THIS_LINE    __LINE__
