//
//  UIView+HIGesture.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIView+HIGesture.h"


@interface __HI_TapGesture : UITapGestureRecognizer

@end

#pragma mark -

@implementation __HI_TapGesture

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if ( self ) {
        self.numberOfTapsRequired = 1;
        self.numberOfTouchesRequired = 1;
        self.cancelsTouchesInView = YES;
        self.delaysTouchesBegan = YES;
        self.delaysTouchesEnded = YES;
    }
    return self;
}

@end

#pragma mark -


@interface __HI_PanGesture : UIPanGestureRecognizer

@end

#pragma mark -

@implementation __HI_PanGesture

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if ( self ) {
        
    }
    return self;
}

@end

#pragma mark -

@interface __HI_PinchGesture : UIPinchGestureRecognizer
@end

@implementation __HI_PinchGesture

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    
    if ( self ) {
        
    }
    return self;
}

@end

#pragma mark -

@implementation UIView (HIGesture)

#pragma mark -

- (CGPoint) panOffset
{
    return [self.panGesture translationInView:self];
}

- (CGFloat) pinchScale
{
    UIPinchGestureRecognizer * gesture = self.pinchGesture;
    if ( nil == gesture ) {
        return 1.0f;
    }
    
    return gesture.scale;
}

#pragma mark -

- (UITapGestureRecognizer *)tapGesture
{
    __HI_TapGesture * tapGesture = nil;
    
    for ( UIGestureRecognizer * gesture in self.gestureRecognizers ) {
        if ( [gesture isKindOfClass:[__HI_TapGesture class]] ) {
            tapGesture = (__HI_TapGesture *)gesture;
        }
    }
    
    return tapGesture;
}

-(UITapGestureRecognizer *) addTapTarget:(id)target selector:(SEL)selector
{
    __HI_TapGesture * tapGesture = [[__HI_TapGesture alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tapGesture];
    
    return tapGesture;
}

#pragma mark -

- (UIPanGestureRecognizer *) panGesture
{
    __HI_PanGesture * panGesture = nil;
    
    for ( UIGestureRecognizer * gesture in self.gestureRecognizers ) {
        if ( [gesture isKindOfClass:[__HI_PanGesture class]] ) {
            panGesture = (__HI_PanGesture *)gesture;
        }
    }
    
    return panGesture;
}

-(UIPanGestureRecognizer *) addPanTarget:(id)target selector:(SEL)selector
{
    __HI_PanGesture * panGesture = [[__HI_PanGesture alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:panGesture];
    
    return panGesture;
}

#pragma mark -

-(UIPinchGestureRecognizer *) pinchGesture
{
    __HI_PinchGesture * pinchGesture = nil;
    
    for ( UIGestureRecognizer * gesture in self.gestureRecognizers ) {
        if ( [gesture isKindOfClass:[__HI_PinchGesture class]] ) {
            pinchGesture = (__HI_PinchGesture *)gesture;
        }
    }
    
    return pinchGesture;
}

-(UIPinchGestureRecognizer *) addPinchTarget:(id)target selector:(SEL)selector
{
    __HI_PinchGesture * pinchGesture = [[__HI_PinchGesture alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:pinchGesture];
    
    return pinchGesture;
}

@end
