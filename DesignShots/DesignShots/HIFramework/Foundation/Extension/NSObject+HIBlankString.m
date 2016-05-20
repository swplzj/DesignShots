//
//  NSObject+HIBlankString.m
//  DesignShots
//
//  Created by lizhenjie on 5/19/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "NSObject+HIBlankString.h"

@implementation NSObject (HIBlankString)

- (BOOL)isBlankString:(NSString *)string
{
    if (self == nil || self == NULL) {
        return YES;
    } else if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    } else if([string isEqualToString:@"<null>"]){
        return YES;
    } else if ([string isEqualToString:@"(null)"]) {
        return YES;
    } else if ([string isEqualToString:@"null"]) {
        return YES;
    } else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
