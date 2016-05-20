//
//  BlurAnimateMenu.m
//  DesignShots
//
//  Created by lizhenjie on 5/20/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "BlurAnimateMenu.h"

@interface BlurAnimateMenu ()

@property (strong, nonatomic) UIView *keyWindow;
@property (strong, nonatomic) FXBlurView *blurView;
@property (strong, nonatomic) UIView *containerView;
@property (assign, nonatomic) BOOL triggered;

@end

@implementation BlurAnimateMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.keyWindow addSubview:self.blurView];
        [self insertSubview:self.keyWindow belowSubview:self.blurView];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
}

#pragma mark - Event Response

/* show blur animate menu */
- (void)trigger
{
    
}

#pragma mark - Getter And Setter

- (UIView *)keyWindow
{
    if (!_keyWindow) {
        _keyWindow = HI_KEYWINDOW;
    }
    return _keyWindow;
}

- (FXBlurView *)blurView
{
    if (!_blurView) {
        _blurView = [[FXBlurView alloc] initWithFrame:self.keyWindow.bounds];
        _blurView.dynamic = YES;
        _blurView.blurRadius = 10;
        _blurView.alpha = 0.0f;
    }
    return _blurView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView alloc];
    }
    return _containerView;
}

- (void)setTitlesArray:(NSMutableArray *)titlesArray
{
    _titlesArray = titlesArray;
}

@end
