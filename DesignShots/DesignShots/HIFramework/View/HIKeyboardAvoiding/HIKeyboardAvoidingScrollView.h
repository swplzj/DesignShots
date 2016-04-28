//
//  HIKeyboardAvoidingScrollView.h
//  UCreditProject
//
//  Created by lizhenjie on 15/5/29.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+HIKeyboardAvoidingAdditions.h"

@interface HIKeyboardAvoidingScrollView : UIScrollView<UITextFieldDelegate, UITextViewDelegate>

- (void)contentSizeToFit;
- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;

@end
