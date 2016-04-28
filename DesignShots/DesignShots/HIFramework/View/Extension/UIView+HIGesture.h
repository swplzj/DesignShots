//
//  UIView+HIGesture.h
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HIGesture)

@property (nonatomic, readonly) UITapGestureRecognizer      * tapGesture;
@property (nonatomic, readonly) UIPanGestureRecognizer      * panGesture;
@property (nonatomic, readonly) UIPinchGestureRecognizer    * pinchGesture;

@property (nonatomic, readonly) CGPoint	panOffset;
@property (nonatomic, readonly) CGFloat	pinchScale;

-(UITapGestureRecognizer *) addTapTarget:(id)target selector:(SEL)selector;
-(UIPanGestureRecognizer *) addPanTarget:(id)target selector:(SEL)selector;
-(UIPinchGestureRecognizer *) addPinchTarget:(id)target selector:(SEL)selector;

@end
