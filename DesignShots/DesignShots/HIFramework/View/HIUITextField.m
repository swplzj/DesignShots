//
//  HIUITextField.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUITextField.h"

@interface HIUITextFieldHandle : NSObject<UITextFieldDelegate>

@property(nonatomic,assign) HIUITextField * textField;
@property(nonatomic,assign) NSInteger maxLength;

@end

@implementation HIUITextFieldHandle

- (BOOL)textFieldShouldBeginEditing:(HIUITextField *)textField
{
    if (textField.shouldBeginEditingBlock) {
        return textField.shouldBeginEditingBlock((HIUITextField *)textField);
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(HIUITextField *)textField
{
    if (textField.didBeginEditingBlock) {
        textField.didBeginEditingBlock((HIUITextField *)textField);
    }
}

- (BOOL)textFieldShouldEndEditing:(HIUITextField *)textField
{
    if (textField.shouldEndEditingBlock) {
        return textField.shouldEndEditingBlock((HIUITextField *)textField);
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(HIUITextField *)textField
{
    if (textField.didEndEditingBlock) {
        textField.didEndEditingBlock((HIUITextField *)textField);
    }
}

- (BOOL)textField:(HIUITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.shouldChangeCharactersBlock) {
        return textField.shouldChangeCharactersBlock((HIUITextField *)textField, range, string);
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (self.maxLength == 0) {
        return YES;
    }
    
    //    NSString * new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //    NSInteger res = self.maxLength - [new length];
    //    if(res >= 0)
    //    {
    //        return YES;
    //    }
    //    else
    //    {
    //        NSRange rg = {0,[string length]+res};
    //        if (rg.length>0)
    //        {
    //            NSString * s = [string substringWithRange:rg];
    //            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
    //        }
    //        return NO;
    //    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(HIUITextField *)textField
{
    if (textField.shouldClearBlock) {
        return textField.shouldClearBlock((HIUITextField *)textField);
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(HIUITextField *)textField
{
    if (textField.shouldReturnBlock) {
        return textField.shouldReturnBlock((HIUITextField *)textField);
    }
    
    return YES;
}


@end

@interface HIUITextField ()<UITextFieldDelegate>

@property(nonatomic,retain) HIUITextFieldHandle * handle;

@end

@implementation HIUITextField

-(void) dealloc
{
    self.shouldBeginEditingBlock = nil;
    self.didBeginEditingBlock = nil;
    self.shouldEndEditingBlock = nil;
    self.didEndEditingBlock = nil;
    self.shouldChangeCharactersBlock = nil;
    self.shouldClearBlock = nil;
    self.shouldReturnBlock = nil;
    
    self.placeholderColor = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSelf];
    }
    return self;
}

-(id) init
{
    if (self = [super init]) {
        [self initSelf];
    }
    return self;
}

-(void) initSelf
{
    self.handle = [[HIUITextFieldHandle alloc] init];
    self.handle.maxLength = self.maxLength;
    self.delegate = self.handle;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

-(void) setMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
    self.handle.maxLength = self.maxLength;
}


@end
