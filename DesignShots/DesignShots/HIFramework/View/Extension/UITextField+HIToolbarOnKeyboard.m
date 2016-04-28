//
//  UITextField+HIToolbarOnKeyboard.m
//  UCreditProject
//
//  Created by lizhenjie on 15/5/27.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "UITextField+HIToolbarOnKeyboard.h"

@implementation UITextField (HIToolbarOnKeyboard)

#pragma mark - Toolbar on UIKeyboard

- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    if (IOS7_OR_LATER) {
        toolbar.barStyle = UIBarStyleDefault;
    } else {
        [toolbar setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        toolbar.barStyle = UIBarStyleBlack;
    }
    [toolbar sizeToFit];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:action];
    
    UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects: nilButton,doneButton, nil]];
    
    [self setInputAccessoryView:toolbar];
}

- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    if (IOS7_OR_LATER) {
        toolbar.barStyle = UIBarStyleDefault;
    } else {
        [toolbar setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        toolbar.barStyle = UIBarStyleBlack;
    }
    [toolbar sizeToFit];
    
    UIBarButtonItem *preButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_toolbar_left_arrow"] style:UIBarButtonItemStyleDone target:target action:previousAction];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_toolbar_right_arrow"] style:UIBarButtonItemStyleDone target:target action:nextAction];
    
    UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:doneAction];
    
    [toolbar setItems:[NSArray arrayWithObjects: preButton, nilButton, nextButton, nilButton, nilButton, nilButton, doneButton, nil]];
    
    [self setInputAccessoryView:toolbar];
}

- (void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled
{
    UIToolbar *inputView = (UIToolbar*)[self inputAccessoryView];
    
    if ([inputView isKindOfClass:[UIToolbar class]] && [[inputView items] count]>0) {
        UIBarButtonItem *preBarButtonItem = (UIBarButtonItem*)[[inputView items] objectAtIndex:0];
        
        if ([preBarButtonItem isKindOfClass:[UIBarButtonItem class]]) {
            preBarButtonItem.enabled = isPreviousEnabled;
        }
        
        UIBarButtonItem *nextBarButtonItem = (UIBarButtonItem *)[[inputView items] objectAtIndex:2];
        
        if ([nextBarButtonItem isKindOfClass:[UIBarButtonItem class]]) {
            nextBarButtonItem.enabled = isNextEnabled;
        }
    }
}

@end
