//
//  HIUIActionSheet.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIActionSheet.h"
#import "HIPrecompile.h"

#pragma mark - HIUIActionSheet

@implementation HIUIActionSheet


#pragma mark HIUIActionSheet Set up methods

- (id)init
{    
    self = [self initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    self.buttonResponse = HIUIActionSheetButtonResponseFadesOnPress;
    self.backgroundColor = [UIColor clearColor];
    self.buttons = [[NSMutableArray alloc] init];
    self.shouldCancelOnTouch = YES;
    
    self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    self.transparentView.backgroundColor = [UIColor blackColor];
    self.transparentView.alpha = 0.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRemove)];
    tap.numberOfTapsRequired = 1;
    [self.transparentView addGestureRecognizer:tap];
    
    return self;
}

-(void) tapRemove
{
    [self dismissWithClickedButtonIndex:self.buttons.count - 1 animated:YES];
}

- (id)initWithTitle:(NSString *)title delegate:(id<HIUIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ...
{
    self = [self init];
    self.delegate = delegate;
    self.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    if (otherTitles) {
        va_list args;
        va_start(args, otherTitles);
        for (NSString *arg = otherTitles; arg != nil; arg = va_arg(args, NSString* ))
        {
            [titles addObject:arg];
        }
        va_end(args);
    }
    
    if (destructiveTitle) {
        [titles insertObject:destructiveTitle atIndex:0];
        self.hasDestructiveButton = YES;
    } else {
        self.hasDestructiveButton = NO;
    }
    
    // set up cancel button
    if (cancelTitle) {
        HIUIActionSheetButton *cancelButton = [[HIUIActionSheetButton alloc] initWithAllCornersRounded];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:(18)];//[UIFont boldSystemFontOfSize:21];
        [cancelButton setTitle:cancelTitle forState:UIControlStateAll];
        [self.buttons addObject:cancelButton];
        self.hasCancelButton = YES;
    } else {
        self.shouldCancelOnTouch = NO;
        self.hasCancelButton = NO;
    }
    
    switch (titles.count) {
            
        case 0: {
            break;
        }
            
        case 1: {
            
            HIUIActionSheetButton *otherButton;
            
            if (title && title.length > 0) {
                otherButton = [[HIUIActionSheetButton alloc] initWithBottomCornersRounded];
            } else {
                otherButton = [[HIUIActionSheetButton alloc] initWithAllCornersRounded];
            }
            
            [otherButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:otherButton atIndex:0];
            
            break;
            
        } case 2: {
            
            HIUIActionSheetButton *otherButton = [[HIUIActionSheetButton alloc] initWithBottomCornersRounded];
            [otherButton setTitle:[titles objectAtIndex:1] forState:UIControlStateAll];
            
            HIUIActionSheetButton *secondButton;
            
            if (title) {
                secondButton = [[HIUIActionSheetButton alloc] init];
            } else {
                secondButton = [[HIUIActionSheetButton alloc] initWithTopCornersRounded];
            }
            
            [secondButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:secondButton atIndex:0];
            [self.buttons insertObject:otherButton atIndex:1];
            
            break;
            
        } default: {
            
            HIUIActionSheetButton *bottomButton = [[HIUIActionSheetButton alloc] initWithBottomCornersRounded];
            [bottomButton setTitle:[titles lastObject] forState:UIControlStateAll];
            
            HIUIActionSheetButton *topButton;
            
            if (title) {
                topButton = [[HIUIActionSheetButton alloc] init];
            } else {
                topButton = [[HIUIActionSheetButton alloc] initWithTopCornersRounded];
            }
            
            [topButton setTitle:[titles objectAtIndex:0] forState:UIControlStateAll];
            [self.buttons insertObject:topButton atIndex:0];
            
            NSUInteger whereToStop = titles.count - 1;
            for (int i = 1; i < whereToStop; ++i) {
                HIUIActionSheetButton *middleButton = [[HIUIActionSheetButton alloc] init];
                [middleButton setTitle:[titles objectAtIndex:i] forState:UIControlStateAll];
                [self.buttons insertObject:middleButton atIndex:i];
            }
            
            [self.buttons insertObject:bottomButton atIndex:(titles.count - 1)];
            
            break;
        }
    }
    
    [self setUpTheActions];
    
    if (destructiveTitle) {
        [[self.buttons objectAtIndex:0] setTextColor:[UIColor colorWithRed:1.000 green:0.229 blue:0.000 alpha:1.000]];
        [[self.buttons objectAtIndex:0] setOriginalTextColor:[UIColor colorWithRed:1.000 green:0.229 blue:0.000 alpha:1.000]];
    }
    
    for (int i = 0; i < self.buttons.count; ++i) {
        [[self.buttons objectAtIndex:i] setIndex:i];
    }
    
    if (title) {
        self.title = title;
    } else {
        [self setUpTheActionSheet];
    }
    
    return self;
}

- (void)setUpTheActionSheet
{
    float height;
    float width;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        width = CGRectGetWidth([UIScreen mainScreen].bounds);
    } else {
        width = CGRectGetHeight([UIScreen mainScreen].bounds);
    }
    
    
    // slight adjustment to take into account non-retina devices
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        
        // setup spacing for retina devices
        if (self.hasCancelButton) {
            height = 59.5;
        } else {
            height = 104.0;
        }
        
        if (self.buttons.count) {
            height += (self.buttons.count * 44.5);
        }
        if (self.titleView) {
            height += CGRectGetHeight(self.titleView.frame) - 44;
        }
        
        self.frame = CGRectMake(0, 0, width, height);
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGPoint pointOfReference = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - 30);
        
        NSUInteger whereToStop;
        if (self.hasCancelButton) {
            [self addSubview:[self.buttons lastObject]];
            HIUIActionSheetButton *lastButton = [self.buttons lastObject];
            HIUIActionSheetButton *firstButton = [self.buttons objectAtIndex:0];
            [lastButton setCenter:pointOfReference];
            [firstButton setCenter:CGPointMake(pointOfReference.x, pointOfReference.y - 52)];
            pointOfReference = CGPointMake(pointOfReference.x, pointOfReference.y - 52);
            whereToStop = self.buttons.count - 2;
        } else {
            [self addSubview:[self.buttons lastObject]];
            HIUIActionSheetButton *lastButton = [self.buttons lastObject];
            [lastButton setCenter:pointOfReference];
            whereToStop = self.buttons.count - 1;
        }
        
        for (NSUInteger i = 0, j = whereToStop; i <= whereToStop; ++i, --j) {
            [self addSubview:[self.buttons objectAtIndex:i]];
            HIUIActionSheetButton *sheetButton = [self.buttons objectAtIndex:i];
            [sheetButton setCenter:CGPointMake(pointOfReference.x, pointOfReference.y - (44.5 * j))];
        }
        
        if (self.titleView) {
            [self addSubview:self.titleView];
            self.titleView.center = CGPointMake(self.center.x, CGRectGetHeight(self.titleView.frame) / 2.0);
        }
        
    } else {
        
        // setup spacing for non-retina devices
        
        if (self.hasCancelButton) {
            height = 60.0;
        } else {
            height = 104.0;
        }
        
        if (self.buttons.count) {
            height += (self.buttons.count * 45);
        }
        if (self.titleView) {
            height += CGRectGetHeight(self.titleView.frame) - 45;
        }
        
        self.frame = CGRectMake(0, 0, width, height);
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGPoint pointOfReference = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - 30);
        
        NSUInteger whereToStop;
        if (self.hasCancelButton) {
            [self addSubview:[self.buttons lastObject]];
            HIUIActionSheetButton *lastButton = [self.buttons lastObject];
            [lastButton setCenter:pointOfReference];
            HIUIActionSheetButton *firstButton = [self.buttons objectAtIndex:0];
            [firstButton setCenter:CGPointMake(pointOfReference.x, pointOfReference.y - 52)];
            pointOfReference = CGPointMake(pointOfReference.x, pointOfReference.y - 52);
            whereToStop = self.buttons.count - 2;
        } else {
            [self addSubview:[self.buttons lastObject]];
            HIUIActionSheetButton *lastButton = [self.buttons lastObject];
            [lastButton setCenter:pointOfReference];
            whereToStop = self.buttons.count - 1;
        }
        
        for (NSUInteger i = 0, j = whereToStop; i <= whereToStop; ++i, --j) {
            [self addSubview:[self.buttons objectAtIndex:i]];
            HIUIActionSheetButton *sheetButton = [self.buttons objectAtIndex:i];

            [sheetButton setCenter:CGPointMake(pointOfReference.x, pointOfReference.y - (45 * j))];
        }
        
        if (self.titleView) {
            [self addSubview:self.titleView];
            self.titleView.center = CGPointMake(self.center.x, CGRectGetHeight(self.titleView.frame) / 2.0);
        }
    }
    
}

- (void)setUpTheActions
{
    for (HIUIActionSheetButton *button in self.buttons) {
        if ([button isKindOfClass:[HIUIActionSheetButton class]]) {
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(highlightPressedButton:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(unhighlightPressedButton:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
        }
    }
}

- (void)highlightPressedButton:(HIUIActionSheetButton *)button
{
    [UIView animateWithDuration:0.15f
                     animations:^() {
                         
                         if (self.buttonResponse == HIUIActionSheetButtonResponseFadesOnPress) {
                             button.alpha = .80f;
                         } else if (self.buttonResponse == HIUIActionSheetButtonResponseShrinksOnPress) {
                             button.transform = CGAffineTransformMakeScale(.98, .95);
                         } else if (self.buttonResponse == HIUIActionSheetButtonResponseHighlightsOnPress) {
                             button.backgroundColor = button.highlightBackgroundColor;
                             [button setTitleColor:button.highlightTextColor forState:UIControlStateAll];
                             
                         } else {
                             
                             UIColor *tempColor = button.titleLabel.textColor;
                             [button setTitleColor:button.backgroundColor forState:UIControlStateAll];
                             button.backgroundColor = tempColor;
                         }
                         
                     }];
}

- (void)unhighlightPressedButton:(HIUIActionSheetButton *)button
{
    [UIView animateWithDuration:0.3f
                     animations:^() {
                         
                         if (self.buttonResponse == HIUIActionSheetButtonResponseFadesOnPress) {
                             button.alpha = .95f;
                         } else if( self.buttonResponse == HIUIActionSheetButtonResponseShrinksOnPress) {
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } else  if (self.buttonResponse == HIUIActionSheetButtonResponseHighlightsOnPress) {
                             button.backgroundColor = button.originalBackgroundColor;
                             [button setTitleColor:button.originalTextColor forState:UIControlStateAll];
                         } else {
                             UIColor *tempColor = button.backgroundColor;
                             button.backgroundColor = button.titleLabel.textColor;
                             [button setTitleColor:tempColor forState:UIControlStateAll];
                         }
                     }];
    
}

#pragma mark HIUIActionSheet Helpful methods

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    
    NSUInteger index = self.buttons.count;
    
    if (self.buttons.count == 0) {
        index = 0;
    }
    
    HIUIActionSheetButton *button = [[HIUIActionSheetButton alloc] initWithBottomCornersRounded];
    [button setTitle:title forState:UIControlStateAll];
    button.index = index;
    
    if (self.hasCancelButton) {
        
        [self.buttons insertObject:button atIndex:index];
        [[self.buttons lastObject] setIndex:self.buttons.count - 1];
        
        HIUIActionSheetButton *tempButton;
        HIUIActionSheetButton *theButtonToCopy;
        
        if (self.buttons.count == 3) {
            if (self.titleView) {
                tempButton = [[HIUIActionSheetButton alloc] init];
            } else {
                tempButton = [[HIUIActionSheetButton alloc] initWithTopCornersRounded];
            }
            
            theButtonToCopy = [self.buttons objectAtIndex:0];
            tempButton.index = theButtonToCopy.index;
            [tempButton setTitle:theButtonToCopy.titleLabel.text forState:UIControlStateAll];
            
            [self.buttons replaceObjectAtIndex:0 withObject:tempButton];
            [self setButtonTextColor:theButtonToCopy.titleLabel.textColor forButtonAtIndex:0];
            [self setButtonBackgroundColor:theButtonToCopy.backgroundColor forButtonAtIndex:0];
            
        } else {
            
            tempButton = [[HIUIActionSheetButton alloc] init];
            theButtonToCopy = [self.buttons objectAtIndex:(index - 1)];
            [tempButton setTitle:theButtonToCopy.titleLabel.text forState:UIControlStateAll];
            tempButton.titleLabel.text = theButtonToCopy.titleLabel.text;
            
            [self.buttons replaceObjectAtIndex:(index - 1) withObject:tempButton];
            [self setButtonTextColor:theButtonToCopy.titleLabel.textColor forButtonAtIndex:(index - 1)];
            [self setButtonBackgroundColor:theButtonToCopy.backgroundColor forButtonAtIndex:(index - 1)];
        }
    } else {
        [self.buttons addObject:button];
    }
    
    [self setUpTheActions];
    [self setUpTheActionSheet];
    
    return index;
}


- (void)buttonClicked:(HIUIActionSheetButton *)button
{
    
    [self.delegate actionSheet:self clickedButtonAtIndex:button.index];
    self.shouldCancelOnTouch = YES;
    [self removeFromView];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    
    if (buttonIndex < 0) {
        
        buttonIndex = 0;
    }
    
    if (!animated) {
        [self.transparentView removeFromSuperview];
        [self removeFromSuperview];
        self.visible = NO;
        [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
    } else {
        [self removeFromView];
        [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
    }
}

- (void)showInView:(UIView *)theView
{
    [theView addSubview:self];
    [theView insertSubview:self.transparentView belowSubview:self];
    
    CGRect theScreenRect = [UIScreen mainScreen].bounds;
    
    float height;
    float x;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        height = CGRectGetHeight(theScreenRect);
        x = CGRectGetWidth(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetWidth(theScreenRect), CGRectGetHeight(theScreenRect));
    } else {
        height = CGRectGetWidth(theScreenRect);
        x = CGRectGetHeight(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetHeight(theScreenRect), CGRectGetWidth(theScreenRect));
    }
    
    self.center = CGPointMake(x, height + CGRectGetHeight(self.frame) / 2.0);
    self.transparentView.center = CGPointMake(x, height / 2.0);
    self.visible = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            self.center = CGPointMake(x, (height - 20) - CGRectGetHeight(self.frame) / 2.0);
        } else {
            self.center = CGPointMake(x, height - CGRectGetHeight(self.frame) / 2.0);
        }

    } completion:^(BOOL finished) {
        
    }];
  
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^() {
                         self.transparentView.alpha = 0.4f;
                         /*
                          if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                          self.center = CGPointMake(x, (height - 20) - CGRectGetHeight(self.frame) / 2.0);
                          } else {
                          self.center = CGPointMake(x, height - CGRectGetHeight(self.frame) / 2.0);
                          }
                          */
                         
                     } completion:^(BOOL finished) {
                         self.visible = YES;
                     }];
}
- (void)removeFromView
{
    
    if (self.shouldCancelOnTouch) {
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^() {
                             
                             self.alpha = 0;
                             self.transparentView.alpha = 0.0f;
                             self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);
                         } completion:^(BOOL finished) {
                             [self.transparentView removeFromSuperview];
                             [self removeFromSuperview];
                             self.visible = NO;
                         }];
    }
}

- (void)rotateToCurrentOrientation
{
    
    float width;
    float height;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        
        width = CGRectGetWidth([UIScreen mainScreen].bounds);
        height = CGRectGetHeight([UIScreen mainScreen].bounds);
        
        
        for (HIUIActionSheetButton * button in self.buttons) {
            [button resizeForPortraitOrientation];
        }
        
        [self.titleView resizeForPortraitOrientation];
        [self setUpTheActionSheet];
        
        
        
        
    } else {
        
        width = CGRectGetHeight([UIScreen mainScreen].bounds);
        height = CGRectGetWidth([UIScreen mainScreen].bounds);
        
        
        for (HIUIActionSheetButton * button in self.buttons) {
            [button resizeForLandscapeOrientation];
        }
        [self.titleView resizeForLandscapeOrientation];
        [self setUpTheActionSheet];
        
        
    }
    
    self.transparentView.frame = CGRectMake(0, 0, width, height);
    self.transparentView.center = CGPointMake(width / 2.0, height / 2.0);
    self.center = self.center = CGPointMake(width / 2.0, height - CGRectGetHeight(self.frame) / 2.0);
    
}

#pragma mark HIUIActionSheet Color methods

- (void)setButtonTextColor:(UIColor *)color
{
    
    for (HIUIActionSheetButton *button in self.buttons) {
        [button setTitleColor:color forState:UIControlStateAll];
        button.originalTextColor = color;
    }
    
    [self setTitleTextColor:color];
}

- (void)setButtonBackgroundColor:(UIColor *)color
{
    
    for (HIUIActionSheetButton *button in self.buttons) {
        button.backgroundColor = color;
        button.originalBackgroundColor = color;
    }
    
    [self setTitleBackgroundColor:color];
}

- (void)setTitleTextColor:(UIColor *)color
{
    self.titleView.titleLabel.textColor = color;
}

- (void)setTitleBackgroundColor:(UIColor *)color
{
    self.titleView.backgroundColor = color;
}

- (void)setTextColor:(UIColor *)color ForButton:(HIUIActionSheetButton *)button
{
    [button setTitleColor:color forState:UIControlStateAll];
}

- (void)setButtonBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index
{
    [[self.buttons objectAtIndex:index] setBackgroundColor:color];
}

- (void)setButtonTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index
{
    [self setTextColor:color ForButton:[self.buttons objectAtIndex:index]];
}

- (UIColor *)buttonBackgroundColorAtIndex:(NSInteger)index
{
    return [[self.buttons objectAtIndex:index] backgroundColor];
}

- (UIColor *)buttonTextColorAtIndex:(NSInteger)index
{
    return [[[self.buttons objectAtIndex:index] titleLabel] textColor];
}

- (void)setButtonHighlightBackgroundColor:(UIColor *)color
{
    for (HIUIActionSheetButton *button in self.buttons) {
        button.highlightBackgroundColor = color;
    }
}

- (void)setButtonHighlightBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index
{
    [[self.buttons objectAtIndex:index] setHighlightBackgroundColor:color];
}

- (void)setButtonHighlightTextColor:(UIColor *)color
{
    for (HIUIActionSheetButton *button in self.buttons) {
        button.highlightTextColor = color;
    }
}

- (void)setButtonHighlightTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index
{
    [[self.buttons objectAtIndex:index] setHighlightTextColor:color];
}

#pragma mark HIUIActionSheet Other Properties methods

- (void)setTitle:(NSString *)title
{
    self.titleView = [[HIUIActionSheetTitleView alloc] initWithTitle:title];
    [self setUpTheActionSheet];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index
{
    return [[[self.buttons objectAtIndex:index] titleLabel] text];
}

- (NSInteger)numberOfButtons
{
    return self.buttons.count;
}

- (void)setFont:(UIFont *)font
{
    for (HIUIActionSheetButton *button in self.buttons) {
        [self setFont:font forButton:button];
    }
    
    [self setTitleFont:font];
}

- (void)setFont:(UIFont *)font forButtonAtIndex:(NSInteger)index
{
    [[[self.buttons objectAtIndex:index] titleLabel] setFont:font];
}

- (void)setFont:(UIFont *)font forButton:(HIUIActionSheetButton *)button
{
    button.titleLabel.font = font;
}

- (void)setTitleFont:(UIFont *)font
{
    if (self.titleView) {
        self.titleView.titleLabel.font = font;
    }
}

@end



#pragma mark - HIUIActionSheetButton

@implementation HIUIActionSheetButton

- (id)init
{
    float width;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        width = CGRectGetWidth([UIScreen mainScreen].bounds);
    } else {
        width = CGRectGetHeight([UIScreen mainScreen].bounds);
    }
    self = [self initWithFrame:CGRectMake(0, 0, width, 44)];
    
    self.backgroundColor = [UIColor whiteColor];
    self.originalBackgroundColor = self.backgroundColor;
    self.titleLabel.font = [UIFont systemFontOfSize:(18)];
    [self setTitleColor:[UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.000] forState:UIControlStateAll];
    self.originalTextColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.000];
    
    self.alpha = 0.95f;
    
    self.cornerType = HIUIActionSheetButtonCornerTypeNoCornersRounded;
    
    return self;
}

- (id)initWithTopCornersRounded
{
    self = [self init];
    //    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    //    self.cornerType = HIUIActionSheetButtonCornerTypeTopCornersRounded;
    return self;
}

- (id)initWithBottomCornersRounded
{
    self = [self init];
    //    [self setMaskTo:self byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    //    self.cornerType = HIUIActionSheetButtonCornerTypeBottomCornersRounded;
    return self;
}

- (id)initWithAllCornersRounded
{
    self = [self init];
    //    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight];
    //    self.cornerType = HIUIActionSheetButtonCornerTypeAllCornersRounded;
    return self;
}


- (void)setTextColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateAll];
}

- (void)resizeForPortraitOrientation
{
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame));
    
    switch (self.cornerType) {
        case HIUIActionSheetButtonCornerTypeNoCornersRounded:
            break;
            
        case HIUIActionSheetButtonCornerTypeTopCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
            break;
        }
        case HIUIActionSheetButtonCornerTypeBottomCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            break;
        }
            
        case HIUIActionSheetButtonCornerTypeAllCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight];
            break;
        }
            
        default:
            break;
    }
}

- (void)resizeForLandscapeOrientation
{
    self.frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame));
    
    switch (self.cornerType) {
        case HIUIActionSheetButtonCornerTypeNoCornersRounded:
            break;
            
        case HIUIActionSheetButtonCornerTypeTopCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
            break;
        }
        case HIUIActionSheetButtonCornerTypeBottomCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            break;
        }
            
        case HIUIActionSheetButtonCornerTypeAllCornersRounded: {
            [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    //    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
    //                                                  byRoundingCorners:corners
    //                                                        cornerRadii:CGSizeMake(4.0, 4.0)];
    //    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    //    [shape setPath:rounded.CGPath];
    //    view.layer.mask = shape;
}

@end


#pragma mark - HIUIActionSheetTitleView

@implementation HIUIActionSheetTitleView

- (id)initWithTitle:(NSString *)title
{
    self = [self init];
    
    float width;
    float labelBuffer;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        width = CGRectGetWidth([UIScreen mainScreen].bounds);
        labelBuffer = 44;
    } else {
        width = CGRectGetHeight([UIScreen mainScreen].bounds);
        labelBuffer = 24;
    }
    
    self.alpha = .95f;
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width - labelBuffer, 44)];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = [UIColor colorWithWhite:0.564 alpha:1.000];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = title;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.titleLabel sizeToFit];
    
    if ((CGRectGetHeight(self.titleLabel.frame) + 30) < 44) {
        self.frame = CGRectMake(0, 0, width, 44);
    } else {
        self.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.titleLabel.frame) + 30);
    }
    
    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self addSubview:self.titleLabel];
    self.titleLabel.center = self.center;
    
    return self;
}

- (void)resizeForPortraitOrientation
{
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame));
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 24, 44);
    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
}

- (void)resizeForLandscapeOrientation
{
    self.frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame));
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds) - 44, 44);
    [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
}

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    //    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
    //                                                  byRoundingCorners:corners
    //                                                        cornerRadii:CGSizeMake(4.0, 4.0)];
    //    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    //    [shape setPath:rounded.CGPath];
    //    view.layer.mask = shape;
}

@end
