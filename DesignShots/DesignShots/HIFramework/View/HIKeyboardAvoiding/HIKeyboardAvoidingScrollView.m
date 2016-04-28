//
//  HIKeyboardAvoidingScrollView.m
//  UCrediHIroject
//
//  Created by lizhenjie on 15/5/29.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HIKeyboardAvoidingScrollView.h"

@implementation HIKeyboardAvoidingScrollView

#pragma mark - Setup/Teardown

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HIKeyboardAvoiding_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HIKeyboardAvoiding_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame
{
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self setup];
    return self;
}

-(void)awakeFromNib
{
    [self setup];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self HIKeyboardAvoiding_updateContentInset];
}

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    [self HIKeyboardAvoiding_updateFromContentSizeChange];
}

- (void)contentSizeToFit
{
    self.contentSize = [self HIKeyboardAvoiding_calculatedContentSizeFromSubviewFrames];
}

- (BOOL)focusNextTextField
{
    return [self HIKeyboardAvoiding_focusNextTextField];
    
}
- (void)scrollToActiveTextField
{
    return [self HIKeyboardAvoiding_scrollToActiveTextField];
}

#pragma mark - Responders, events

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if ( !newSuperview ) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HIKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) object:self];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self HIKeyboardAvoiding_findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( ![self focusNextTextField] ) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HIKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) object:self];
    [self performSelector:@selector(HIKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) withObject:self afterDelay:0.1];
}

@end
