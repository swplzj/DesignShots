//
//  NSObject+HINotification.h
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//


@interface NSNotification (HINotification)

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;

@end

@interface NSObject (HINotification)

- (void)handleNotification:(NSNotification *)notification;

- (void)observeNotification:(NSString *)name;
- (void)unobserveNotification:(NSString *)name;

- (void)observeNotification:(NSString *)notificationName object:(id)object;

- (void)unobserveAllNotifications;

+ (BOOL)postNotification:(NSString *)name;
+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

- (BOOL)postNotification:(NSString *)name;
- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

@end
