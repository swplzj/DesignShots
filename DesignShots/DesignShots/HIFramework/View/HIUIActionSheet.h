//
//  HIUIActionSheet.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define UIControlStateAll UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted
#define SYSTEM_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)

// Define 'button press' effects
typedef NS_ENUM(NSInteger, HIUIActionSheetButtonResponse) {
    
    HIUIActionSheetButtonResponseFadesOnPress,
    HIUIActionSheetButtonResponseReversesColorsOnPress,
    HIUIActionSheetButtonResponseShrinksOnPress,
    HIUIActionSheetButtonResponseHighlightsOnPress
};

typedef NS_ENUM(NSInteger, HIUIActionSheetButtonCornerType) {
    
    HIUIActionSheetButtonCornerTypeNoCornersRounded,
    HIUIActionSheetButtonCornerTypeTopCornersRounded,
    HIUIActionSheetButtonCornerTypeBottomCornersRounded,
    HIUIActionSheetButtonCornerTypeAllCornersRounded
    
};


// forward declarations
@class HIUIActionSheet, HIUIActionSheetTitleView;

#pragma mark - HIUIActionSheetDelegate Protocol

// Protocol needed to receive notifications from the HIUIActionSheet (Will receive UIActionSheet notifications as well)
@protocol HIUIActionSheetDelegate <NSObject>

-(void)actionSheet:(HIUIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

#pragma mark - HIUIActionSheet

@interface HIUIActionSheet : UIView
{
    
}

@property (nonatomic,retain) UIView * transparentView;
@property (nonatomic,retain) NSMutableArray * buttons;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) HIUIActionSheetTitleView * titleView;
@property (assign) id <HIUIActionSheetDelegate> delegate;
@property HIUIActionSheetButtonResponse buttonResponse;
@property BOOL visible, hasCancelButton, hasDestructiveButton, shouldCancelOnTouch;

- (void)showInView:(UIView *)theView;

- (NSInteger)addButtonWithTitle:(NSString *)title;

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (id)initWithTitle:(NSString *)title delegate:(id<HIUIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


- (NSInteger)numberOfButtons;
- (NSString *)buttonTitleAtIndex:(NSInteger)index;
- (void)rotateToCurrentOrientation;


// fonts
- (void)setFont:(UIFont *)font;
- (void)setTitleFont:(UIFont *)font;
- (void)setFont:(UIFont *)font forButtonAtIndex:(NSInteger)index;


// standard colors
- (void)setTitleTextColor:(UIColor *)color;
- (void)setButtonTextColor:(UIColor *)color;
- (void)setTitleBackgroundColor:(UIColor *)color;
- (void)setButtonBackgroundColor:(UIColor *)color;
- (UIColor *)buttonTextColorAtIndex:(NSInteger)index;
- (UIColor *)buttonBackgroundColorAtIndex:(NSInteger)index;
- (void)setButtonTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;
- (void)setButtonBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;


// highlight colors
- (void)setButtonHighlightBackgroundColor:(UIColor *)color;
- (void)setButtonHighlightTextColor:(UIColor *)color;
- (void)setButtonHighlightTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;
- (void)setButtonHighlightBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;

@end

#pragma mark - HIUIActionSheetButton

@interface HIUIActionSheetButton : UIButton

@property NSInteger index;
@property HIUIActionSheetButtonCornerType cornerType;
@property (nonatomic,retain) UIColor *originalTextColor, *highlightTextColor;
@property (nonatomic,retain) UIColor *originalBackgroundColor, *highlightBackgroundColor;

- (id)initWithTopCornersRounded;
- (id)initWithAllCornersRounded;
- (id)initWithBottomCornersRounded;
- (void)resizeForPortraitOrientation;
- (void)resizeForLandscapeOrientation;
- (void)setTextColor:(UIColor *)color;

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners;

@end


#pragma mark - HIUIActionSheetTitleView

@interface HIUIActionSheetTitleView : UIView

@property (nonatomic,retain) UILabel *titleLabel;


- (void)resizeForPortraitOrientation;
- (void)resizeForLandscapeOrientation;
- (id)initWithTitle:(NSString *)title;

@end
