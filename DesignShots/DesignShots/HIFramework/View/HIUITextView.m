//
//  HIUITextView.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUITextView.h"
#import "HIPrecompile.h"

@interface HIUITextView ()
{
    UILabel * _placeholderLabel;
}

@end

@implementation HIUITextView

-(void) dealloc
{
    self.placeholder = nil;
    self.beginEditing = nil;
    self.endEditing = nil;
    self.changed = nil;
    
    [self unobserveAllNotifications];
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
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.frame = CGRectMake(5, 0, self.frame.size.width - 10, self.frame.size.height);
    _placeholderLabel.text = self.placeholder;
    _placeholderLabel.userInteractionEnabled = NO;
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderLabel];
    
    [self observeNotification:UITextViewTextDidBeginEditingNotification object:self];
    [self observeNotification:UITextViewTextDidChangeNotification object:self];
    [self observeNotification:UITextViewTextDidEndEditingNotification object:self];
}

-(void) setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    _placeholderLabel.text = placeholder;
    
    if (self.text.length == 0) {
        [self _setPlaceholderText:self.placeholder];
    } else {
        [self _setPlaceholderText:@""];
    }
}

-(void) setText:(NSString *)text
{
    [super setText:text];
    
    if (text.length == 0) {
        [self _setPlaceholderText:self.placeholder];
    } else {
        [self _setPlaceholderText:@""];
    }
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _placeholderLabel.frame = CGRectMake(5, 0, self.frame.size.width - 10, self.frame.size.height);
}

#pragma mark -

-(void) handleNotification:(NSNotification *)notification
{
    if ([notification is:UITextViewTextDidBeginEditingNotification]) {
        
        if (notification.object != self) {
            return;
        }
        
        if (self.beginEditing) {
            self.beginEditing(self);
        }
        
    } else if([notification is:UITextViewTextDidChangeNotification]){
        
        if (notification.object != self) {
            return;
        }
        
        if (self.text.length == 0) {
            [self _setPlaceholderText:self.placeholder];
        } else {
            [self _setPlaceholderText:@""];
        }
        
        if (self.changed) {
            self.changed(self);
        }
        
    }else if ([notification is:UITextViewTextDidEndEditingNotification]){
        
        if (notification.object != self) {
            return;
        }
        
        if (self.endEditing) {
            self.endEditing(self);
        }
        
    }
}

-(void) _setPlaceholderText:(NSString *)text
{
    if (self.placeholderLabelOffsetY) {
        CGRect orignalFrame = _placeholderLabel.frame;
        orignalFrame.origin.y = self.placeholderLabelOffsetY;
        _placeholderLabel.frame = orignalFrame;
    }
    
    _placeholderLabel.text = text;
}

@end

