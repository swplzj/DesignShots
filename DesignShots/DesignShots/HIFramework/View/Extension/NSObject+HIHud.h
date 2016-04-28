//
//  NSObject+HIHud.h
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIUIHud;

@interface NSObject (HIHud)

- (HIUIHud *)showMessageHud:(NSString *)message;
- (HIUIHud *)showSuccessHud:(NSString *)message;
- (HIUIHud *)showFailureHud:(NSString *)message;
- (HIUIHud *)showLoadingHud:(NSString *)message;
- (HIUIHud *)showProgressHud:(NSString *)message;

@end
