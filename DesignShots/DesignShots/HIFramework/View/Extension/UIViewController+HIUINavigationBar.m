//
//  UIViewController+HIUINavigationBar.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIViewController+HIUINavigationBar.h"
#import "HIPrecompile.h"

#pragma mark -

#undef	BUTTON_MIN_WIDTH
#define	BUTTON_MIN_WIDTH	(24.0f)

#undef	BUTTON_MIN_HEIGHT
#define	BUTTON_MIN_HEIGHT	(24.0f)

#pragma mark -

@interface UIViewController(UINavigationBarPrivate)
- (void)didLeftBarButtonTouched;
- (void)didRightBarButtonTouched;
@end

#pragma mark -

@implementation UIViewController (HIUINavigationBar)

+ (id)viewController
{
    return [[[self class] alloc] init];
}

- (void)showNavigationBarAnimated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)hideNavigationBarAnimated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didLeftBarButtonTouched
{
    [self navigationBarButtonClick:NavigationBarButtonTypeLeft];
}

- (void)didRightBarButtonTouched
{
    [self navigationBarButtonClick:NavigationBarButtonTypeRight];
}

- (void)showBackBarButtonWithImage:(UIImage *)image selectImage:(UIImage *)selectImage
{
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH ) {
        buttonFrame.size.width = BUTTON_MIN_WIDTH;
    }

    if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT ) {
        buttonFrame.size.height = BUTTON_MIN_HEIGHT;
    }
    
    UIButton * button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    if (selectImage) {
        [button setImage:selectImage forState:UIControlStateHighlighted];
    }
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    button.titleLabel.textColor = HI_UINAVIGATION_BAR_DEFAULT_BUTTON_TITLE_COLOR;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)button];
}

- (void)showBarButton:(NavigationBarButtonType)position title:(NSString *)name textColor:(UIColor *)textColor
{
    UIFont  * font = [UIFont systemFontOfSize:14];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    
    CGSize size = [name sizeWithFont:font byWidth:label.frame.size.width];
    label.frame = CGRectMake(0, 0, size.width, size.height);
    label.text = name;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    
    if ( NavigationBarButtonTypeLeft == position ) {
        [label addTapTarget:self selector:@selector(didLeftBarButtonTouched)];
        [self showBarButton:NavigationBarButtonTypeLeft custom:label];
    } else if ( NavigationBarButtonTypeRight == position ) {
        [label addTapTarget:self selector:@selector(didRightBarButtonTouched)];
        [self showBarButton:NavigationBarButtonTypeRight custom:label];
    }
}

- (void)showBarButton:(NavigationBarButtonType)position image:(UIImage *)image selectImage:(UIImage *)selectImage
{
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH ) {
        buttonFrame.size.width = BUTTON_MIN_WIDTH;
    }
    
    if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT ) {
        buttonFrame.size.height = BUTTON_MIN_HEIGHT;
    }
    
    UIButton * button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    button.exclusiveTouch = YES;
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    if (selectImage) {
        [button setImage:selectImage forState:UIControlStateHighlighted];
    }else{
        button.showsTouchWhenHighlighted = YES;
    }
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    button.titleLabel.textColor = HI_UINAVIGATION_BAR_DEFAULT_BUTTON_TITLE_COLOR;
    
    if ( NavigationBarButtonTypeLeft == position ) {
        [button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)button];
    } else if ( NavigationBarButtonTypeRight == position ) {
        [button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)button];
    }
}

- (void)showBarButton:(NavigationBarButtonType)position title:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage
{
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH ) {
        buttonFrame.size.width = BUTTON_MIN_WIDTH;
    }
    
    if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT ) {
        buttonFrame.size.height = BUTTON_MIN_HEIGHT;
    }
    
    UIButton * button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    if (selectImage) {
        [button setImage:selectImage forState:UIControlStateHighlighted];
    }
    [button setTitle:title forState:UIControlStateNormal];
    //button.titleLabel.text = title;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    button.titleLabel.textColor = HI_UINAVIGATION_BAR_DEFAULT_BUTTON_TITLE_COLOR;
    
    if ( NavigationBarButtonTypeLeft == position ) {
        [button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else if ( NavigationBarButtonTypeRight == position ) {
        [button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)showBarButton:(NavigationBarButtonType)position title:(NSString *)title{
    CGRect buttonFrame = CGRectMake(0, 0, 60, 45);
    
    UIButton * button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    

    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    button.titleLabel.textColor = HI_UINAVIGATION_BAR_DEFAULT_BUTTON_TITLE_COLOR;
    
    if ( NavigationBarButtonTypeLeft == position ) {
        [button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else if ( NavigationBarButtonTypeRight == position ) {
        [button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)showBarButton:(NavigationBarButtonType)position system:(UIBarButtonSystemItem)index
{
    if ( NavigationBarButtonTypeLeft == position ) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
                                                                                               target:self
                                                                                               action:@selector(didLeftBarButtonTouched)];
    } else if ( NavigationBarButtonTypeRight == position ) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
                                                                                                target:self
                                                                                                action:@selector(didRightBarButtonTouched)];
    }
}

- (void)showBarButton:(NavigationBarButtonType)position custom:(UIView *)view
{
    if ( NavigationBarButtonTypeLeft == position ) {
        if (IOS7_OR_LATER) {
            
        }
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    } else if ( NavigationBarButtonTypeRight == position ) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
}

- (void)hideBarButton:(NavigationBarButtonType)position
{
    if ( NavigationBarButtonTypeLeft == position ) {
        self.navigationItem.leftBarButtonItem = nil;
    } else if ( NavigationBarButtonTypeRight == position ) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void) navigationBarButtonClick:(NavigationBarButtonType)type
{
    
}
@end
