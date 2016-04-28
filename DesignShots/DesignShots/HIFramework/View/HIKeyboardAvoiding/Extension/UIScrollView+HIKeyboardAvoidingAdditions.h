//
//  UIScrollView+HIKeyboardAvoidingAdditions.h
//  UCreditProject
//
//  Created by lizhenjie on 15/5/29.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HIKeyboardAvoidingAdditions)

- (BOOL)HIKeyboardAvoiding_focusNextTextField;
- (void)HIKeyboardAvoiding_scrollToActiveTextField;

- (void)HIKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification;
- (void)HIKeyboardAvoiding_keyboardWillHide:(NSNotification*)notification;
- (void)HIKeyboardAvoiding_updateContentInset;
- (void)HIKeyboardAvoiding_updateFromContentSizeChange;
- (void)HIKeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view;
- (UIView *)HIKeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view;
- (CGSize)HIKeyboardAvoiding_calculatedContentSizeFromSubviewFrames;

@end
