//
//  HIPrecompile.h
//  DesignShots
//
//  Created by lizhenjie on 4/27/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#ifndef HIPrecompile_h
#define HIPrecompile_h


#define HI_LOG_ENABLE               (1) //是否打开LOG
#define HI_CRASH_REPORT_ENABLE      (0) //是否打开崩溃记录
#define HI_DEBUG_ENABLE             (0) //是否打开DEBUG调试工具，二指上滑开启或下滑关闭
#define HI_AUDIO_ENABLE             (1) // 是否打开音频模块 开启后需要引入AVFoundation.framework
#define HI_ERROR_FILE_LOG_ENABLE    (0) //是否将ERROR保存至本地



#import "HIMarcos.h"

#import "HICommon.h"
#import "HIFoundation.h"
#import "HIService.h"
#import "HIUtils.h"
#import "HIUIView.h"
#import "HIVendor.h"


#import <execinfo.h>
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <TargetConditionals.h>

#endif /* HIPrecompile_h */
