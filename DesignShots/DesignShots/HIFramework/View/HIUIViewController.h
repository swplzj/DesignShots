//
//  HIUIViewController.h
//  HIFramework
//
//  Created by lizhenjie on 4/7/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIUIViewController : UIViewController

@property (strong, nonatomic) UIView *contentView;    //用于无UINavgationController作为容器的viewController中
@property (strong, nonatomic) id userInfo;

@end
