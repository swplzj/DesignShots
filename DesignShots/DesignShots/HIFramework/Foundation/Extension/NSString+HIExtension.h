//
//  NSString+HIExtension.h
//  HIFramework
//
//  Created by lizhenjie on 4/2/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

typedef NSString *			(^NSStringAppendBlock)( id format, ... );
typedef NSString *			(^NSStringReplaceBlock)( NSString * string, NSString * string2 );
typedef BOOL                (^NSStringEqualBlock)( NSString * string );
typedef BOOL                (^NSStringValidBlock)();

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
typedef NSMutableString *	(^NSMutableStringReplaceBlock)( NSString * string, NSString * string2 );

#pragma mark -

@interface NSString (HIExtension)

@property (nonatomic, readonly) NSStringAppendBlock		APPEND;
@property (nonatomic, readonly) NSStringAppendBlock		LINE;
@property (nonatomic, readonly) NSStringReplaceBlock	REPLACE;
@property (nonatomic, readonly) NSStringEqualBlock	    EQUAL;
@property (nonatomic, readonly) NSStringValidBlock	    VALID;

@property (nonatomic, readonly) NSData *				data;
@property (nonatomic, readonly) NSDate *				date;

@property (nonatomic, readonly) NSString *				MD5;
@property (nonatomic, readonly) NSData *				MD5Data;

@property (nonatomic, readonly) NSString *				SHA1;

-(BOOL) isSignal:(NSString *)signal;

+(NSString *) uuid;

+ (NSString *)stringWithBytes:(unsigned long long)bytes;

- (NSArray *)allURLs;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingArray:(NSArray *)params;
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

- (NSString *)trim;
- (NSString *)unwrap;

- (BOOL)match:(NSString *)expression;
- (BOOL)matchAnyOf:(NSArray *)array;

- (BOOL)empty;
- (BOOL)notEmpty;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (BOOL)isTelephone;
- (BOOL)isUserName;
- (BOOL)isPassword;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isIncludeSpecialCharacter;

- (void)doNothing;

-(NSString *) stringByAppendingString:(NSString *)string;

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
- (CGFloat)widthWithFont:(UIFont *)font byHeight:(CGFloat)height;
- (CGFloat)heightWithFont:(UIFont *)font byWidth:(CGFloat)width;

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@end

#pragma mark -

@interface NSMutableString(HIExtension)

@property (nonatomic, readonly) NSMutableStringAppendBlock	APPEND;
@property (nonatomic, readonly) NSMutableStringAppendBlock	LINE;
@property (nonatomic, readonly) NSMutableStringReplaceBlock	REPLACE;

@end
