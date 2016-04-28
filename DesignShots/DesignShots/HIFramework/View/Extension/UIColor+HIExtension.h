//
//  UIColor+HIExtension.h
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HIExtension)

// 16进制颜色转UIColor
+ (UIColor *)colorWithHexString: (NSString *)color;

+ (UIColor *)fromHexValue:(NSUInteger)hex;
+ (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)fromShortHexValue:(NSUInteger)hex;
+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithString:(NSString *)string; // {#FFF|#FFFFFF|#FFFFFFFF}{,0.6}

@end
