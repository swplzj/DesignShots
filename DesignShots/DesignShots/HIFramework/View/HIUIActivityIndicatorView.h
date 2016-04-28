//
//  HIUIActivityIndicatorView.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIUIActivityIndicatorView : UIActivityIndicatorView

@property (nonatomic, assign) BOOL animating;

+ (HIUIActivityIndicatorView *)whiteActivityIndicatorView;
+ (HIUIActivityIndicatorView *)grayActivityIndicatorView;

@end
