//
//  NSArray+HIExtension.m
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSArray+HIExtension.h"

@implementation NSArray (HIExtension)

@dynamic APPEND;
@dynamic mutableArray;

- (NSArrayAppendBlock)APPEND
{
    NSArrayAppendBlock block = ^ NSMutableArray *(id obj){
        NSMutableArray *array = [NSMutableArray arrayWithArray:self];
        [array addObject:obj];
        return array;
    };
    
    return [block copy];
}

- (NSArrayObjectAtIndexBlock)EXTRACT
{
    NSArrayObjectAtIndexBlock block = ^ id (NSInteger index){
        return [self objectAtIndex:index];
    };
    
    return [block copy];
}

- (NSArray *)head:(NSUInteger)count
{
    if ([self count] < count) {
        return self;
    } else {
        NSMutableArray *tmpFeeds = [NSMutableArray array];
        for (NSObject *elem in self) {
            [tmpFeeds addObject:elem];
            if ([tmpFeeds count] >= count) {
                break;
            }
        }
        return tmpFeeds;
    }
}

- (NSArray *)tail:(NSUInteger)count
{
    NSRange range = NSMakeRange(self.count - count, count);
    return [self subarrayWithRange:range];
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if (index < 0) {
        return nil;
    }
    
    if (index >= self.count) {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range
{
    if (0 == self.count) {
        return nil;
    }
    
    if (range.location >= self.count) {
        return nil;
    }
    
    if (range.location + range.length >= self.count) {
        return nil;
    }
    
    return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (NSMutableArray *)mutableArray
{
    return [NSMutableArray arrayWithArray:self];
}

- (id)objectForKey:(NSString *)key
{
    ERROR(@"NSArray can't call objectForKey:!");
    return nil;
}

@end

#pragma mark -

@implementation NSMutableArray(HIExtension)

@dynamic APPEND;

-(NSMutableArrayObjectAtIndexBlock)EXTRACT
{
    NSMutableArrayObjectAtIndexBlock block = ^ id (NSInteger index){
        return [self objectAtIndex:index];
    };
    
    return [block copy];
}

- (NSMutableArrayAppendBlock)APPEND
{
    NSMutableArrayAppendBlock block = ^ NSMutableArray * (id obj){
        [self addObject:obj];
        return self;
    };
    
    return [block copy];
}

- (NSMutableArray *)pushHead:(NSObject *)obj
{
    if (obj){
        [self insertObject:obj atIndex:0];
    }
    
    return self;
}

- (NSMutableArray *)pushHeadN:(NSArray *)all
{
    if ([all count]){
        for(NSUInteger i = [all count]; i > 0; --i ){
            [self insertObject:[all objectAtIndex:i - 1] atIndex:0];
        }
    }
    
    return self;
}

- (NSMutableArray *)popTail
{
    if ([self count] > 0){
        [self removeObjectAtIndex:[self count] - 1];
    }
    
    return self;
}

- (NSMutableArray *)popTailN:(NSUInteger)n
{
    if ([self count] > 0){
        if (n >= [self count]){
            [self removeAllObjects];
        } else {
            NSRange range;
            range.location = n;
            range.length = [self count] - n;
            
            [self removeObjectsInRange:range];
        }
    }
    
    return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj
{
    if (obj){
        [self addObject:obj];
    }
    
    return self;
}

- (NSMutableArray *)pushTailN:(NSArray *)all
{
    if ([all count]){
        [self addObjectsFromArray:all];
    }
    
    return self;
}

- (NSMutableArray *)popHead
{
    if ([self count]){
        [self removeLastObject];
    }
    
    return self;
}

- (NSMutableArray *)popHeadN:(NSUInteger)n
{
    if ([self count] > 0){
        if (n >= [self count]){
            [self removeAllObjects];
        } else {
            NSRange range;
            range.location = 0;
            range.length = n;
            
            [self removeObjectsInRange:range];
        }
    }
    
    return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n
{
    if ([self count] > n){
        NSRange range;
        range.location = n;
        range.length = [self count] - n;
        
        [self removeObjectsInRange:range];
    }
    
    return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n
{
    if ([self count] > n){
        NSRange range;
        range.location = 0;
        range.length = [self count] - n;
        
        [self removeObjectsInRange:range];
    }
    
    return self;
}

@end


