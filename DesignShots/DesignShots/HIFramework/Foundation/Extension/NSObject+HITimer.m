//
//  NSObject+HITimer.m
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSObject+HITimer.h"

#define KEY_TIMER_NAME  @"NSTimer.name"
#define KEY_TIMES       @"NSObject.timers"

static NSMutableDictionary *__allTimers;

@implementation NSTimer (HITimer)

- (BOOL)is:(NSString *)timerName
{
    if ([self.timerName isEqualToString:timerName]) {
        return YES;
    }
    
    return NO;
}

- (NSString *)timerName
{
    NSObject *obj = objc_getAssociatedObject(self, KEY_TIMER_NAME);
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    }
    return nil;
}

- (void)setTimerName:(NSString *)timerName
{
    objc_setAssociatedObject(self, KEY_TIMER_NAME, timerName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


@implementation NSObject (HITimer)

+ (NSString *)runningTimerInfo
{
    if (!__allTimers) {
        return @"No running timer or no use NSObject+HITimer.";
    }
    
    NSMutableString *info = [NSMutableString string];
    
    for (NSString *key in __allTimers.allKeys) {
        NSString *oneInfo = __allTimers[key];
        [info appendFormat:@"%@\n", oneInfo];
    }
    
    return info;
}

#pragma mark - Create Timer

+ (void)setTimerInfo:(NSString *)timerInfo key:(NSString *)key
{
    if (!__allTimers) {
        __allTimers = [NSMutableDictionary dictionary];
    }
    
    [__allTimers setObject:timerInfo forKey:key];
}


- (NSMutableDictionary *) timers
{
    NSObject * obj = objc_getAssociatedObject( self, KEY_TIMES );
    
    if (!obj) {
        NSMutableDictionary * timers = [NSMutableDictionary dictionary];
        [self setTimers:timers];
        return timers;
    }else if ( obj && [obj isKindOfClass:[NSMutableDictionary class]] )
        return (NSMutableDictionary *)obj;
    
    return nil;
}

- (void)setTimers:(NSMutableDictionary *)timers
{
    objc_setAssociatedObject( self, KEY_TIMES, timers, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat
{
    NSString *key = [NSString stringWithFormat:@"Noname-%p", self];
    
    if ([self.timers objectForKey:key]) {
        return [self.timers objectForKey:key];
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                      target:self
                                                    selector:@selector(handleTimer:)
                                                    userInfo:nil
                                                     repeats:repeat];
    timer.timerName = key;
    [self.timers setObject:timer forKey:key];
    
    INFO(@"[HITimer] init in %@, name is %@.", [self class], key);
    
    // Add info to static dic.
    NSString *timerInfo = [NSString stringWithFormat:@" * TimeInterval : %f Target :%@ Repeat : %d", interval, [self class], repeat];
    NSString *keyInfo = [NSString stringWithFormat:@"Static-%p-%@", self, key];
    
    [[self class] setTimerInfo:timerInfo key:keyInfo];

    return timer;
}

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name
{
    if ([self.timers objectForKey:name]) {
        return [self.timers objectForKey:name];
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                      target:self
                                                    selector:@selector(handleTimer:)
                                                    userInfo:nil
                                                     repeats:repeat];
    timer.timerName = name;
    [self.timers setObject:timer forKey:name];
    
    INFO(@"[HITimer] init in %@, name is %@.",[self class],name);
    
    // Add info to static dic.
    
    NSString * timerInfo = [NSString stringWithFormat:@"  * TimeInterval : %f Target : %@ Repeat : %d",interval,[self class],repeat];
    NSString * infoKey = [NSString stringWithFormat:@"Static-%p-%@",self,name];
    
    [[self class] setTimerInfo:timerInfo key:infoKey];
    
    return timer;
}

#pragma mark - Cancel Timer

- (void)cancelTimerWithName:(NSString *)name
{
    NSTimer *timer = [self.timers objectForKey:name];
    
    if (timer) {
        [timer invalidate];
        
        [self.timers removeObjectForKey:name];
        
        // Remove info from static dic.
        INFO(@"[HITimer] remove in %@, name is %@.", [self class], name);
        
        NSString *infoKey = [NSString stringWithFormat:@"Static-%p-%@", self, name];
        [[self class] removeTimerInfo:infoKey];
    }
}

- (void)cancelAllTimers
{
    for (NSString *key in self.timers.allKeys) {
        NSTimer *timer = [self.timers objectForKey:key];
        [timer invalidate];
        [self.timers removeObjectForKey:key];
        
        // Remove info from static dic
        INFO(@"[HITimer] remove in %@, name is %@", [self class], key);

        NSString *infoKey = [NSString stringWithFormat:@"Static-%p-%@", self, key];
        [[self class] removeTimerInfo:infoKey];
    }
}

+ (void)removeTimerInfo:(NSString *)infoKey
{
    [__allTimers removeObjectForKey:infoKey];
}

#pragma mark - Handel Timer

- (void)handleTimer:(NSTimer *)timer
{
    ;
}

@end
