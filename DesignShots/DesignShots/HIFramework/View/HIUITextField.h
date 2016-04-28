//
//  HIUITextField.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HIUITextField;

typedef BOOL (^HITextFieldShouldBeginEditingBlock) (HIUITextField * textField);
typedef void (^HITextFieldDidBeginEditingBlock) (HIUITextField * textField);
typedef BOOL (^HITextFieldShouldEndEditingBlock) (HIUITextField * textField);
typedef void (^HITextFieldDidEndEditingBlock) (HIUITextField * textField);
typedef BOOL (^HITextFieldShouldChangeCharactersBlock) (HIUITextField * textField, NSRange range, NSString * replacementString);
typedef BOOL (^HITextFieldShouldClearBlock) (HIUITextField * textField);
typedef BOOL (^HITextFieldShouldReturnBlock) (HIUITextField * textField);

@interface HIUITextField : UITextField

@property(nonatomic,copy) HITextFieldShouldBeginEditingBlock shouldBeginEditingBlock;
@property(nonatomic,copy) HITextFieldDidBeginEditingBlock didBeginEditingBlock;
@property(nonatomic,copy) HITextFieldShouldEndEditingBlock shouldEndEditingBlock;
@property(nonatomic,copy) HITextFieldDidEndEditingBlock didEndEditingBlock;
@property(nonatomic,copy) HITextFieldShouldChangeCharactersBlock shouldChangeCharactersBlock;
@property(nonatomic,copy) HITextFieldShouldClearBlock shouldClearBlock;
@property(nonatomic,copy) HITextFieldShouldReturnBlock shouldReturnBlock;

@property(nonatomic,retain) UIColor * placeholderColor;
@property(nonatomic,assign) NSInteger maxLength;

@end
