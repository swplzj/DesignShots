//
//  HIUICheckbox.h
//  HIFramework
//
//  Created by lizhenjie on 4/16/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCheckboxDefaultHeight  24.0
#define kCheckboxRadius         0.1875
#define kCheckboxStrokedWidth   0.05

#define kCheckboxHeightAutomatic CGFLOAT_MAX

typedef enum {
    HIUICheckboxStateUnchecked = NO, //Default
    HIUICheckboxStateChecked = YES,
    HIUICheckboxStateMixed
} HIUICheckboxState;

typedef enum {
    HIUICheckboxAlignmentLeft, //Default
    HIUICheckboxAlignmentRight
} HIUICheckboxAlignment;

typedef void (^StateChangedBlock)(HIUICheckboxState state);


@interface HIUICheckbox : UIControl

@property (nonatomic, strong)   UILabel               *titleLabel;
@property (nonatomic, assign)   HIUICheckboxState     checkState;
@property (nonatomic, assign)   HIUICheckboxAlignment checkAlignment UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign)   CGFloat               checkHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, readonly) CGRect                checkboxFrame;
@property (nonatomic, strong)   id                    checkedValue;
@property (nonatomic, strong)   id                    uncheckedValue;
@property (nonatomic, strong)   id                    mixedValue;

@property (nonatomic, copy)     StateChangedBlock     changeStateBlock;

- (id)value;

- (id)init;
- (id)initWithFrame:(CGRect)frame;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithTitle:(NSString *)title;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title checkHeight:(CGFloat)checkHeight;
- (void)setCheckState:(HIUICheckboxState)state;
- (void)toggleCheckState;
- (void)autoFitFontToHeight;
- (void)autoFitWidthToText;

- (UIBezierPath *)getDefaultShape;

@property (nonatomic, assign) BOOL      flat            UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat   strokeWidth     UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor   *strokeColor    UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor   *checkColor     UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor   *tintColor      UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor   *uncheckedColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat   radius          UI_APPEARANCE_SELECTOR;

@end
