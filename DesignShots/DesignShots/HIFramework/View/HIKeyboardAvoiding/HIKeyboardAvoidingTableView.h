//
//  HIKeyboardAvoidingTableView.h
//  UCreditProject
//
//  Created by lizhenjie on 15/5/29.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIKeyboardAvoidingTableView : UITableView<UITextViewDelegate, UITextFieldDelegate>

- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;

@end
