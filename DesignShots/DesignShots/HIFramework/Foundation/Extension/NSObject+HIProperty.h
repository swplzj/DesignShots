//
//  NSObject+HIProperty.h
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HI_ST_PROPERTY( __name ) \
- (NSString *)__name; \
+ (NSString *)__name;

#define HI_IMP_PROPERTY( __name ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%s", #__name]; \
}

#pragma mark -

#define HI_ST_PROPERTY_INT( __name ) \
- (NSInteger)__name; \
+ (NSInteger)__name;

#define HI_IMP_PROPERTY_INT( __name, __int ) \
- (NSInteger)__name \
{ \
return (NSInteger)[[self class] __name]; \
} \
+ (NSInteger)__name \
{ \
return __int; \
}

#pragma mark -

#define HI_ST_PROPERTY_STRING( __name ) \
- (NSNumber *)__name; \
+ (NSNumber *)__name;

#define HI_IMP_PROPERTY_STRING( __name, __value ) \
- (NSNumber *)__name \
{ \
return [[self class] __name]; \
} \
+ (NSNumber *)__name \
{ \
return __value; \
}


@interface NSObject (HIProperty)

@end
