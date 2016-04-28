//
//  HIUIKeyBoard.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIKeyBoard.h"
#import "HIPrecompile.h"


#define	DEFAULT_KEYBOARD_HEIGHT	(216.0f)

@interface HIUIKeyBoard ()
{
    CGRect		_accessorFrame;
    UIView *	_accessor;
}

@end

@implementation HIUIKeyBoard


-(void) dealloc
{
    [self unobserveAllNotifications];
}

+ (void) load
{
    [HIUIKeyBoard HIInstance];
}

- (id) init
{
    if (self = [super init]) {
        _isShowing = NO;
        _animationDuration = 0.25;
        _height = DEFAULT_KEYBOARD_HEIGHT;
        
        [self observeNotification:UIKeyboardDidShowNotification];
        [self observeNotification:UIKeyboardDidHideNotification];
        [self observeNotification:UIKeyboardWillChangeFrameNotification];
    }
    
    return self;
}

- (void) handleNotification:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    
    if ( userInfo ) {
        _animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    if ([notification is:UIKeyboardDidShowNotification]) {
        
        if (NO == _isShowing) {
            _isShowing = YES;
            // Is showing.
        }
        
        NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        if (value) {
            CGRect keyboardEndFrame = [value CGRectValue];
            CGFloat	keyboardHeight = keyboardEndFrame.size.height;
            
            if ( keyboardHeight != _height ) {
                _height = keyboardHeight;
                // Height changed.
            }
        }
        
        
    } else if ([notification is:UIKeyboardWillChangeFrameNotification]){
        
        NSValue * value1 = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        NSValue * value2 = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        if (value1 && value2) {
            CGRect rect1 = [value1 CGRectValue];
            CGRect rect2 = [value2 CGRectValue];
            
            if (rect1.origin.y >= [UIScreen mainScreen].bounds.size.height){
                if (NO == _isShowing){
                    _isShowing = YES;
                    // Is showing.
                }
                
                if ( rect2.size.height != _height ){
                    _height = rect2.size.height;
                    // Height changed.
                }
            } else if (rect2.origin.y >= [UIScreen mainScreen].bounds.size.height){
                if (rect2.size.height != _height){
                    _height = rect2.size.height;
                    // Height changed.
                }
                
                if (_isShowing){
                    _isShowing = NO;
                    // Is hidden.
                }
            }
        }
    } else if ([notification is:UIKeyboardDidHideNotification]){
        
        NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        if (value) {
            CGRect	keyboardEndFrame = [value CGRectValue];
            
            CGFloat	keyboardHeight = keyboardEndFrame.size.height;
            
            if (keyboardHeight != _height){
                _height = keyboardHeight;
            }
        }
        
        if (_isShowing){
            _isShowing = NO;
            // Height changed.
        }
    }
    
    [self updateAccessorFrame];
}

- (void)setAccessor:(UIView *)view
{
    _accessor = view;
    _accessorFrame = view.frame;
}

-(void) updateAccessorFrame
{
    if ( nil == _accessor ) {
        return;
    }
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        if (_isShowing){
            CGFloat containerHeight = _accessor.superview.bounds.size.height;
            CGRect newFrame = _accessorFrame;
            newFrame.origin.y = containerHeight - (_accessorFrame.size.height + _height);
            _accessor.frame = newFrame;
        } else{
            _accessor.frame = _accessorFrame;
        }
    } completion:^(BOOL finished) {
        
    }];
}

@end
