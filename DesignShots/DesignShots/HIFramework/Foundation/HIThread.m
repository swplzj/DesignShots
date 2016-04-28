//
//  HIThread.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIThread.h"


#define OPERATION_COUNT 5

@implementation HIThreadQueue

-(instancetype) init
{
    HI_SUPER_INIT({
        
        self.maxConcurrentOperationCount = OPERATION_COUNT;
        
    })
}

+(BOOL) cancelWithTagString:(NSString *)tagString
{
    HIThread * thread = [HIThreadQueue threadWithTagString:tagString];
    
    if (thread) {
        [thread cancel];
        return YES;
    }
    
    return NO;
}

+(HIThread *) threadWithTagString:(NSString *)tagString
{
    NSArray * operations = [HIThreadQueue HIInstance].operations;
    
    for (HIThread * thread in operations) {
        
        if (!HI_NSSTRING_IS_INVALID(thread.tagString)) {
            
            if ([thread.tagString isEqualToString:tagString]) {
                return thread;
            }
        }
    }
    
    return nil;
}

@end

@implementation HIThread

-(void) dealloc
{
    self.operationBlock = nil;
    self.operationCompleteBlock = nil;
}

+(HIThread *) performOperationBlockInBackground:(HIOperationBlock)block completeBlock:(HIOperationCompleteBlock)completeBlock
{
    HIThread * thread = [[HIThread alloc] initWithOperationBlock:block completeBlock:completeBlock];
    
    [[HIThreadQueue HIInstance] addOperation:thread];
    
    return thread;
}

-(HIThread *) initWithOperationBlock:(HIOperationBlock)block completeBlock:(HIOperationCompleteBlock)completeBlock
{
    HI_SUPER_INIT({
        
        self.operationBlock = block;
        self.operationCompleteBlock = completeBlock;
        self.object = nil;
        self.tagString = nil;
    })
}

-(void) main
{
    if (self.operationBlock) {
        self.operationBlock();
    }else{
        ERROR(@"HIThread not found 'operationBlock'.");
    }
    
    if (self.operationCompleteBlock) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.operationCompleteBlock(); 
        });
    }
}

@end
