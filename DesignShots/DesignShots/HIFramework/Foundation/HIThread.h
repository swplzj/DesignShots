//
//  HIThread.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIPrecompile.h"

@class HIThread;

@interface HIThreadQueue : NSOperationQueue

+(BOOL) cancelWithTagString:(NSString *)tagString;

+(HIThread *) threadWithTagString:(NSString *)tagString;

@end

#pragma mark -

typedef void (^HIOperationBlock) ();
typedef void (^HIOperationCompleteBlock) ();

#pragma mark -

@interface HIThread : NSOperation

@property(nonatomic,copy) HIOperationBlock operationBlock;
@property(nonatomic,copy) HIOperationCompleteBlock operationCompleteBlock;
@property(nonatomic,retain) id object;
@property(nonatomic,retain) NSString * tagString;

+(HIThread *) performOperationBlockInBackground:(HIOperationBlock)block completeBlock:(HIOperationCompleteBlock)completeBlock;

-(HIThread *) initWithOperationBlock:(HIOperationBlock)block completeBlock:(HIOperationCompleteBlock)completeBlock;

@end
