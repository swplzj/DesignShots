//
//  NSArray+HIExtension.h
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HIPrecompile.h"

typedef NSMutableArray *    (^NSArrayAppendBlock)(id obj);
typedef id                  (^NSArrayObjectAtIndexBlock)(NSInteger index);

typedef NSMutableArray *    (^NSMutableArrayAppendBlock)(id obj);
typedef id                  (^NSMutableArrayObjectAtIndexBlock)(NSInteger index);

#pragma mark -

@interface NSArray (HIExtension)

@property (nonatomic, readonly) NSArrayAppendBlock          APPEND;
@property (nonatomic, readonly) NSArrayObjectAtIndexBlock   EXTRACT;

@property (nonatomic, readonly) NSMutableArray *            mutableArray;

/**
 *  @author lizhenjie, 15-04-01
 *
 *  返回起始下标为0指定个数的数组
 *
 *  @param count 指定个数
 *
 *  @return 返回指定个数数组
 */
- (NSArray *)head:(NSUInteger)count;

/**
 *  @author lizhenjie, 15-04-01
 *
 *  返回起始下标为count-1，指定个数的数组
 *
 *  @param count 指定个数
 *
 *  @return 返回指定个数数组
 */
- (NSArray *)tail:(NSUInteger)count;

/**
 *  @author lizhenjie, 15-04-01
 *
 *  通过下标安全地取对象，避免数组越界
 *
 *  @param index 对象下标
 *
 *  @return 返回下标所对应的对象
 */
- (id)safeObjectAtIndex:(NSInteger)index;

/**
 *  @author lizhenjie, 15-04-01
 *
 *  通过指定范围来安全地生成数组
 *
 *  @param range 指定数组范围
 *
 *  @return 截取后的数组
 */
- (NSArray *)safeSubarrayWithRange:(NSRange)range;

@end


#pragma mark -

@interface NSMutableArray(HIExtension)

@property (nonatomic, readonly) NSMutableArrayAppendBlock	APPEND;
@property (nonatomic, readonly) NSArrayObjectAtIndexBlock   EXTRACT;

- (NSMutableArray *)pushHead:(NSObject *)obj;
- (NSMutableArray *)pushHeadN:(NSArray *)all;
- (NSMutableArray *)popTail;
- (NSMutableArray *)popTailN:(NSUInteger)n;

- (NSMutableArray *)pushTail:(NSObject *)obj;
- (NSMutableArray *)pushTailN:(NSArray *)all;
- (NSMutableArray *)popHead;
- (NSMutableArray *)popHeadN:(NSUInteger)n;

- (NSMutableArray *)keepHead:(NSUInteger)n;
- (NSMutableArray *)keepTail:(NSUInteger)n;

@end
