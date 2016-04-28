//
//  NSObject+HINotification.m
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//
#import "HIPrecompile.h"

#import "NSObject+HINotification.h"

@implementation NSNotification (HINotification)

- (BOOL)is:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
    return [self.name hasPrefix:prefix];
}

@end

@implementation NSObject (HINotification)

- (void)handleNotification:(NSNotification *)notification
{
    
}

- (void)observeNotification:(NSString *)name
{
    INFO(@"[HINotification] observe : %@ receiver : %@", name, [self class]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:name
                                               object:nil];
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)observeNotification:(NSString *)notificationName object:(id)object
{
    INFO(@"[HINotification] observe : %@ receiver : %@", notificationName, [self class]);

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:notificationName
                                               object:object];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)postNotification:(NSString *)name
{
    INFO(@"[HINotification] post : %@ sponsor : %@", name, [self class]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];

    return YES;
}

+(BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    INFO(@"[HINotification] post : %@ sponsor : %@", name, [self class]);

    [[NSNotificationCenter defaultCenter] postNotification:name withObject:object];
    
    return YES;
}

- (BOOL)postNotification:(NSString *)name
{
    return [[self class] postNotification:name];
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    return [[self class] postNotification:name withObject:object];
}

@end
