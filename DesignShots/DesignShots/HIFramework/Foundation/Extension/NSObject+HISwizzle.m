//
//  NSObject+HISwizzle.m
//  HIFramework
//
//  Created by lizhenjie on 4/1/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "NSObject+HISwizzle.h"
#import "HILog.h"

#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#import <objc/message.h>
#else
#import <objc/objc-class.h>
#endif

#define SetNSErrorFor(FUNC, ERROR_VAR, FORMAT, ...) \
if (ERROR_VAR){ \
NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT, FUNC, ##__VA_ARGS__];  \
*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
code:-1 \
userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]];  \
}

#define SetNSError(ERROR_VAR, FORMAT, ...) SetNSErrorFor(__func__, ERROR_VAR, FORMAT, ##__VA_ARGS__)

#if OBJC_API_VERSION >= 2
#define GetClass(obj)   object_getClass(obj)
#else 
#define GetClass(obj)   (obj ? obj->isa : Nil)
#endif


@implementation UIView (HISwizzle)

- (void)swizzleAddSubview:(UIView *)view
{
    if (!view) {
        return ;
    }
    
    if (self == view) {
        ERROR(@"%@ can't add self.", [self class]);
        return ;
    }
    
    if (![view isKindOfClass:[UIView class]]) {
        ERROR(@"%@ can't add %@.", [self class], [view class]);
        return;
    }
    
    [self swizzleAddSubview:view];
}

@end

@implementation NSArray (HISwizzle)

- (id)swizzleObjectAtIndex:(int)index
{
    if (index >= 0 && index < self.count) {
        return [self swizzleObjectAtIndex:index];
    }
    
    ERROR(@"Invalid index %d at %@.", index, self);

    return nil;
}

@end

@implementation NSMutableArray (HISwizzle)

- (void)swizzleRemoveObjectAtIndex:(int)index
{
    if (index >= 0 && index < self.count) {
        [self swizzleRemoveObjectAtIndex:index];
    } else {
        ERROR(@"Invalid index %d at %@.", index, self);
    }
}

- (void)swizzleInsertObject:(id)object atIndex:(NSInteger)index
{
    if (!object) {
        ERROR(@"Object cannot be nil.");
        return;
    }
    [self swizzleInsertObject:object atIndex:index];
}

- (void)swizzleAddObject:(id)object
{
    if (!object) {
        ERROR(@"Object cannot be nil.");
        return;
    }
    [self swizzleAddObject:object];
}

@end

@implementation NSDictionary (HISwizzle)



@end


@implementation NSMutableDictionary (HISwizzle)

- (id)swizzleSetObject:(id)object forKey:(id<NSCopying>)key
{
    if (object && key) {
        return [self swizzleSetObject:object forKey:key];
    } else {
        ERROR(@"Object 或 key 为空！  %@ %@", object, key);
        return nil;
    }
}

- (void)swizzleRemoveObjectForKey:(id<NSCopying>)aKey
{
    if (aKey) {
        return [self swizzleRemoveObjectForKey:aKey];
    } else {
        ERROR(@"Key 为空！ %@", aKey);
    }
}

@end



@implementation NSObject (HISwizzle)

+ (BOOL)swizzleAll
{
    NSError *error;

    [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(swizzleObjectAtIndex:) error:&error];
    [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(swizzleObjectAtIndex:) error:&error];
    [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(swizzleRemoveObjectAtIndex:) error:&error];
    [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(swizzleInsertObject:atIndex:) error:&error];
    [objc_getClass("__NSArrayM") swizzleMethod:@selector(addObject:) withMethod:@selector(swizzleAddObject:) error:&error];
    
    [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(swizzleSetObject:forKey:) error:&error];
    [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(removeObjectForKey:) withMethod:@selector(swizzleRemoveObjectForKey:) error:&error];

    [objc_getClass("UIView") swizzleMethod:@selector(addSubview:) withMethod:@selector(swizzleAddSubview:) error:&error];
    
    return YES;
}

/**
 *  @author lizhenjie, 15-04-01 17:04:59
 *
 *  <#Description#>
 *
 *  @param oldSel <#oldSel description#>
 *  @param newSel <#newSel description#>
 *  @param error  <#error description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)swizzleMethod:(SEL)oldSel withMethod:(SEL)newSel error:(NSError **)error
{
    
#if OBJC_API_VERSION >= 2
    Method originalMethod = class_getInstanceMethod(self, oldSel);
    if (!originalMethod) {
        
#if TARGET_OS_IPHONE
        SetNSError(error, @"original method %@ not found for class %@", NSStringFromSelector(oldSel), [self class]);
#else
        SetNSError(error_, @"original method %@ not found for class %@", NSStringFromSelector(oldSel), [self className]);
#endif
        return NO;
    }
                   
    Method altMethod = class_getInstanceMethod(self, newSel);
    if (!altMethod) {
#if TARGET_OS_IPHONE

        SetNSError(error, @"alternate method %@ not found for class %@", NSStringFromSelector(newSel), [self class]);
#else
        SetNSError(error_, @"alternate method %@ not found for class %@", NSStringFromSelector(newSel), [self className]);
#endif
        return NO;
    }
    
    class_addMethod(self, oldSel, class_getMethodImplementation(self, oldSel), method_getTypeEncoding(originalMethod));
    class_addMethod(self, newSel, class_getMethodImplementation(self, newSel), method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, oldSel), class_getInstanceMethod(self, newSel));
    return YES;
    
#else
    
    //	Scan for non-inherited methods.
    Method directOriginalMethod = NULL, directAlternateMethod = NULL;
    
    void *iterator = NULL;
    struct objc_method_list *mlist = class_nextMethodList(self, &iterator);
    while (mlist) {
        int method_index = 0;
        for (; method_index < mlist->method_count; method_index++) {
            if (mlist->method_list[method_index].method_name == oldSel) {
                assert(!directOriginalMethod);
                directOriginalMethod = &mlist->method_list[method_index];
            }
            if (mlist->method_list[method_index].method_name == newSel) {
                assert(!directAlternateMethod);
                directAlternateMethod = &mlist->method_list[method_index];
            }
        }
        mlist = class_nextMethodList(self, &iterator);
    }
    
    //	If either method is inherited, copy it up to the target class to make it non-inherited.
    if (!directOriginalMethod || !directAlternateMethod) {
        Method inheritedOriginalMethod = NULL, inheritedAlternateMethod = NULL;
        if (!directOriginalMethod) {
            inheritedOriginalMethod = class_getInstanceMethod(self, oldSel);
            if (!inheritedOriginalMethod) {
                SetNSError(error_, @"original method %@ not found for class %@", NSStringFromSelector(oldSel), [self className]);
                return NO;
            }
        }
        if (!directAlternateMethod) {
            inheritedAlternateMethod = class_getInstanceMethod(self, newSel);
            if (!inheritedAlternateMethod) {
                SetNSError(error_, @"alternate method %@ not found for class %@", NSStringFromSelector(newSel), [self className]);
                return NO;
            }
        }
        
        int hoisted_method_count = !directOriginalMethod && !directAlternateMethod ? 2 : 1;
        struct objc_method_list *hoisted_method_list = malloc(sizeof(struct objc_method_list) + (sizeof(struct objc_method)*(hoisted_method_count-1)));
        hoisted_method_list->obsolete = NULL;	// soothe valgrind - apparently ObjC runtime accesses this value and it shows as uninitialized in valgrind
        hoisted_method_list->method_count = hoisted_method_count;
        Method hoisted_method = hoisted_method_list->method_list;
        
        if (!directOriginalMethod) {
            bcopy(inheritedOriginalMethod, hoisted_method, sizeof(struct objc_method));
            directOriginalMethod = hoisted_method++;
        }
        if (!directAlternateMethod) {
            bcopy(inheritedAlternateMethod, hoisted_method, sizeof(struct objc_method));
            directAlternateMethod = hoisted_method;
        }
        class_addMethods(self, hoisted_method_list);
    }
    
    //	Swizzle.
    IMP temp = directOriginalMethod->method_imp;
    directOriginalMethod->method_imp = directAlternateMethod->method_imp;
    directAlternateMethod->method_imp = temp;
    
    return YES;
    
#endif
    
    return YES;
}


@end
