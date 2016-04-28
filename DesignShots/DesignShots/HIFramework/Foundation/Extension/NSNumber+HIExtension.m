//
//  NSNumber+HIExtension.m
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSNumber+HIExtension.h"

@implementation NSNumber (HIExtension)

-(NSUInteger) length
{
    ERROR(@"NSNumber can't call length!");
    
    NSString * tempString = [NSString stringWithFormat:@"%@", self];
    return tempString.length;
}

@end
