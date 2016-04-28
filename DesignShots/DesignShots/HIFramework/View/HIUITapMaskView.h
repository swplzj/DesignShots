//
//  HIUITapMaskView.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIUITapMaskView : UIView

typedef void (^HIUITapMaskViewWillHideBlock)( HIUITapMaskView * tapMask );

@property(nonatomic,copy) HIUITapMaskViewWillHideBlock willHideBlock;

-(void) show;
-(void) hide;
-(void) hide:(BOOL)animated;

@end
