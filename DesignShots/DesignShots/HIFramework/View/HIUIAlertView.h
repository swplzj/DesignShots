//
//  HIUIAlertView.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HIUIAlertViewCompletionBlock)(BOOL cancelled, NSInteger buttonIndex);

@interface HIUIAlertView : UIViewController

@property (nonatomic, copy) HIUIAlertViewCompletionBlock clickBlock;
@property (nonatomic, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UIWindow *mainWindow;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *otherButton;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, assign) CGFloat buttonsY;
@property (nonatomic, strong) CALayer *verticalLine;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

+ (instancetype)showAlertWithTitle:(NSString *)title;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                        completion:(HIUIAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        completion:(HIUIAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(HIUIAlertViewCompletionBlock)completion;

/**
 * @param otherTitles Must be a NSArray containing type NSString, or set to nil for no otherTitles.
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                        completion:(HIUIAlertViewCompletionBlock)completion;


+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                       contentView:(UIView *)view
                        completion:(HIUIAlertViewCompletionBlock)completion;
/**
 * @param otherTitles Must be a NSArray containing type NSString, or set to nil for no otherTitles.
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                       contentView:(UIView *)view
                        completion:(HIUIAlertViewCompletionBlock)completion;

/**
 * Adds a button to the receiver with the given title.
 * @param title The title of the new button
 * @return The index of the new button. Button indices start at 0 and increase in the order they are added.
 */
- (NSInteger)addButtonWithTitle:(NSString *)title;

/**
 * Dismisses the receiver, optionally with animation.
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

/**
 * By default the alert allows you to tap anywhere around the alert to dismiss it.
 * This method enables or disables this feature.
 */
- (void)setTapToDismissEnabled:(BOOL)enabled;

@end
