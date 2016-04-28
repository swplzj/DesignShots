//
//  NSObject+HITimer.h
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

@interface NSTimer (HITimer)

@property (nonatomic, copy) NSString *timerName;

- (BOOL)is:(NSString *)timerName;

@end

@interface NSObject (HITimer)

@property (nonatomic, strong) NSMutableDictionary *timers;

+ (NSString *)runningTimerInfo;

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat;

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name;

- (void)cancelTimerWithName:(NSString *)name;

- (void)cancelAllTimers;

- (void)handleTimer:(NSTimer *)timer;

@end
