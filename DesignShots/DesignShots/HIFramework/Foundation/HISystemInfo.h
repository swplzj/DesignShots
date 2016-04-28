//
//  HISystemInfo.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )


#else

#define IOS8_OR_LATER   (NO)
#define IOS7_OR_LATER   (NO)
#define IOS6_OR_LATER	(NO)

#endif

@interface HISystemInfo : NSObject

+ (NSString *)appVersion;
+ (NSString *)appIdentifier;
+ (NSString *)deviceModel;
+ (NSString *)deviceUUID;

/* Cpu usage. */
+ (CGFloat) cpuUsage;
/* Device total memory. */
+ (NSInteger) totalMemory;
/* Device free memory. */
+ (CGFloat) freeMemory;
/* Device used memory. */
+ (CGFloat) usedMemory;

+ (NSString *) totalDiskSpace;
+ (NSString *) freeDiskSpace;
+ (NSString *) usedDiskSpace;

+ (BOOL)isJailBroken		NS_AVAILABLE_IOS(4_0);

+ (NSString *)jailBreaker	NS_AVAILABLE_IOS(4_0);

+ (BOOL)isDevicePhone;
+ (BOOL)isDevicePad;

+ (BOOL)isPhone35;
+ (BOOL)isPhoneRetina35;
+ (BOOL)isPhoneRetina4;
+ (BOOL)isPad;
+ (BOOL)isPadRetina;
+ (BOOL)isScreenSize:(CGSize)size;

/* Simulate low memory warning. */
+ (void)simulateLowMemoryWarning;

/* Application run number. */
+ (int) applicationRunsNumber;


/* Detail info. */
+ (NSDictionary *) deviceDetailInfo;
+ (NSString *) deviceName;
+ (NSString *) platformType;
+ (NSString *) currentIPAddress;
+ (NSString *) cellIPAddress;

@end
