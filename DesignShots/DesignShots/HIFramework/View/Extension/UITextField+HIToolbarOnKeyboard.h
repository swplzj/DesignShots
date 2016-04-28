//
//  UITextField+HIToolbarOnKeyboard.h
//  UCreditProject
//
//  Created by lizhenjie on 15/5/27.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HIToolbarOnKeyboard)

- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;

- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

- (void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;

@end
