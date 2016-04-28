//
//  HIUICheckbox.m
//  HIFramework
//
//  Created by lizhenjie on 4/16/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUICheckbox.h"

#define kBoxSize    .875
#define kCheckHorizontalExtention .125
#define kCheckVerticalExtension .125
#define kCheckIndent .125
#define kCheckRaise .1875
#define kCheckSize .8125
#define kCheckBoxSpacing 0.3125
#define kCheckboxMaxFontSize 100.0


@interface CheckView : UIView

@property (nonatomic, weak) HIUICheckbox *checkbox;
@property (nonatomic, assign) BOOL selected;

@end

@implementation CheckView

- (void)drawRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect boxRect = CGRectMake(self.checkbox.strokeWidth, (self.frame.size.height * kCheckVerticalExtension), (self.frame.size.height * kBoxSize) - self.checkbox.strokeWidth, (self.frame.size.height * kBoxSize) - self.checkbox.strokeWidth);
    UIColor *fillColor = nil;
    UIColor *strokeColor = nil;
    UIColor *checkColor = nil;
    
    if (self.checkbox.checkState == HIUICheckboxStateUnchecked) {
        fillColor = self.checkbox.uncheckedColor;
    } else {
        fillColor = self.checkbox.tintColor;
    }
    
    if (self.selected) {
        CGFloat r, g, b, a;
        [fillColor getRed:&r green:&g blue:&b alpha:&a];
    }
    
    if (!self.checkbox.enabled) {
        CGFloat r, g, b, a;
        [fillColor getRed:&r green:&g blue:&b alpha:&a];
        fillColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
        [self.checkbox.strokeColor getRed:&r green:&g blue:&b alpha:&a];
        strokeColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
        [self.checkbox.checkColor getRed:&r green:&g blue:&b alpha:&a];
        checkColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
    } else {
        strokeColor = self.checkbox.strokeColor;
        checkColor = self.checkbox.checkColor;
    }
    
    //Draw box
    if (self.checkbox.flat) {
        UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:self.checkbox.radius];
        [fillColor setFill];
        [boxPath fill];
        [strokeColor setStroke];
        boxPath.lineWidth = self.checkbox.strokeWidth;
        [boxPath stroke];
    } else {
        //Create colors based off of tint color
        CGFloat r, g, b, a;
        [fillColor getRed:&r green:&g blue:&b alpha:&a];
        UIColor *topColor = [UIColor colorWithRed:(r + 0.20) green:(g + 0.20) blue:(b + 0.20) alpha:a];
        UIColor *bottomColor = [UIColor colorWithRed:(r + 0.15) green:(g + 0.15) blue:(b + 0.15) alpha:a];
        NSArray *fillGradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)topColor.CGColor, (id)fillColor.CGColor, (id)bottomColor.CGColor, nil];
        CGFloat fillGradientLocations[] = {0, 0.47, 0.53, 1};
        CGGradientRef fillGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)fillGradientColors, fillGradientLocations);
        
        //Draw
        UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:self.checkbox.radius];
        CGContextSaveGState(context);
        [boxPath addClip];
        CGContextDrawLinearGradient(context, fillGradient, CGPointMake(0, (self.frame.size.height * kCheckVerticalExtension)), CGPointMake(0, self.frame.size.height), 0);
        CGContextRestoreGState(context);
        [strokeColor setStroke];
        boxPath.lineWidth = self.checkbox.strokeWidth;
        [boxPath stroke];
        
        //Cleanup
        CGGradientRelease(fillGradient);
    }
    
    //Draw Shape
    if (self.checkbox.checkState == HIUICheckboxStateUnchecked) {
        //Do Nothing
    } else if (self.checkbox.checkState == HIUICheckboxStateChecked) {
        [checkColor setFill];
        [[self.checkbox getDefaultShape] fill];
    } else if (self.checkbox.checkState == HIUICheckboxStateMixed) {
        UIBezierPath *mixedPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.checkbox.strokeWidth + ((boxRect.size.width - (.5 * self.frame.size.height)) * 0.5), (self.frame.size.height * .5) - ((0.09375 * self.frame.size.height) * .5), .5 * self.frame.size.height, 0.1875 * self.frame.size.height) cornerRadius:(0.09375 * self.frame.size.height)];
        [checkColor setFill];
        [mixedPath fill];
    }
    
    //Cleanup
    CGColorSpaceRelease(colorSpace);
}

@end


@interface HIUICheckbox ()

@property (nonatomic, assign) CGFloat boxFrame;

@end

@implementation HIUICheckbox
{
    CheckView *checkView;
    UIColor *labelColor;
}

@synthesize flat = _flat;
@synthesize strokeColor = _strokeColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize checkColor = _checkColor;
@synthesize tintColor = _tintColor;
@synthesize radius = _radius;
@synthesize titleLabel = _titleLabel;
@synthesize checkState = _checkState;
@synthesize boxFrame;
@synthesize checkAlignment = _checkAlignment;
@synthesize uncheckedColor = _uncheckedColor;
@synthesize enabled = _enabled;
@synthesize checkedValue;
@synthesize uncheckedValue;
@synthesize mixedValue;

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, kCheckboxDefaultHeight, kCheckboxDefaultHeight)];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_checkHeight == 0) {
            _checkHeight = self.frame.size.height;
        }
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _checkHeight = kCheckboxDefaultHeight;
        [self setup];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
{
    self = [self initWithFrame:CGRectMake(0, 0, 100.0, kCheckboxDefaultHeight) title:title checkHeight:kCheckboxDefaultHeight];
    if (self) {
        CGSize labelSize;
        if ([title respondsToSelector:@selector(sizeWithAttributes:)]) {
            labelSize = [title sizeWithAttributes:@{ NSFontAttributeName: _titleLabel.font }];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            labelSize = [title sizeWithFont:_titleLabel.font];
#pragma clang diagnostic pop
        }
        
        self.frame = CGRectMake(
                                self.frame.origin.x,
                                self.frame.origin.y,
                                labelSize.width + ([self heightForCheckbox] * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * [self heightForCheckbox]),
                                self.frame.size.height);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [self initWithFrame:frame title:title checkHeight:kCheckboxDefaultHeight];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title checkHeight:(CGFloat)checkHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        //Set the title label text
        _checkHeight = checkHeight;
        [self setup];
        _titleLabel.text = title;
        [self layoutSubviews];
    }
    return self;
}

- (void)setup
{
    //Set the basic properties
    CGFloat heightForCheckbox = [self heightForCheckbox];
    _flat = YES;
    _strokeColor = [UIColor colorWithRed:0.02 green:0.47 blue:1 alpha:1];
    _strokeWidth = kCheckboxStrokedWidth * heightForCheckbox;
    _checkColor = [UIColor colorWithRed:0.02 green:0.47 blue:1 alpha:1];
    _tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    _uncheckedColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    _radius = kCheckboxRadius * heightForCheckbox;
    _checkAlignment = HIUICheckboxAlignmentLeft;
    _checkState = HIUICheckboxStateUnchecked;
    _enabled = YES;
    //Create the check view
    CGRect checkViewFrame = CGRectIntegral(CGRectMake(
                                                      self.frame.size.width - ((kBoxSize + kCheckHorizontalExtention) * heightForCheckbox),
                                                      (self.frame.size.height - ((kBoxSize + kCheckHorizontalExtention) * heightForCheckbox)) / 2.0,
                                                      ((kBoxSize + kCheckHorizontalExtention) * heightForCheckbox),
                                                      heightForCheckbox));
    checkView = [[CheckView alloc] initWithFrame:checkViewFrame];
    checkView.checkbox = self;
    checkView.selected = NO;
    checkView.backgroundColor = [UIColor clearColor];
    checkView.clipsToBounds = NO;
    checkView.userInteractionEnabled = NO;
    
    //Create the title label
    CGRect labelFrame = CGRectIntegral(CGRectMake(
                                                  0,
                                                  0,
                                                  self.frame.size.width - checkView.frame.size.width - ([self heightForCheckbox] * kCheckBoxSpacing),
                                                  self.frame.size.height));
    _titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
    _titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.userInteractionEnabled = NO;
    //Set font size
    [self autoFitFontToHeight];
    //Add the subviews
    [self addSubview:checkView];
    [self addSubview:_titleLabel];
    
}

- (CGFloat)heightForCheckbox
{
    //See if the checkbox's height is automatic, and return the proper size
    return _checkHeight == kCheckboxHeightAutomatic ? self.frame.size.height : _checkHeight;
}

/*
 The shape is defined by the height of the frame. The decimal numbers are the percentage of the height that distance is. That way, the shape can be drawn for any height.
 */

- (UIBezierPath *)getDefaultShape
{
    CGFloat height = [self heightForCheckbox];
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake((0.17625 * height), (0.368125 * height))];
    [bezierPath addCurveToPoint: CGPointMake((0.17625 * height), (0.46375 * height)) controlPoint1: CGPointMake((0.13125 * height), (0.418125 * height)) controlPoint2: CGPointMake((0.17625 * height), (0.46375 * height))];
    [bezierPath addLineToPoint: CGPointMake((0.4 * height), (0.719375 * height))];
    [bezierPath addCurveToPoint: CGPointMake((0.45375* height), (0.756875 * height)) controlPoint1: CGPointMake((0.4 * height), (0.719375 * height)) controlPoint2: CGPointMake((0.4275 * height), (0.756875 * height))];
    [bezierPath addCurveToPoint: CGPointMake((0.505625 * height), (0.719375 * height)) controlPoint1: CGPointMake((0.480625 * height), (0.75625 * height)) controlPoint2: CGPointMake((0.505625 * height), (0.719375 * height))];
    [bezierPath addLineToPoint: CGPointMake((0.978125* height), (0.145625* height))];
    [bezierPath addCurveToPoint: CGPointMake((0.978125* height), (0.050625* height)) controlPoint1: CGPointMake((0.978125* height), (0.145625* height)) controlPoint2: CGPointMake((1.026875* height), (0.09375* height))];
    [bezierPath addCurveToPoint: CGPointMake((0.885625* height), (0.050625* height)) controlPoint1: CGPointMake((0.929375* height), (0.006875* height)) controlPoint2: CGPointMake((0.885625* height), (0.050625* height))];
    [bezierPath addLineToPoint: CGPointMake((0.45375* height), (0.590625* height))];
    [bezierPath addLineToPoint: CGPointMake((0.26875* height), (0.368125 * height))];
    [bezierPath addCurveToPoint: CGPointMake((0.17625 * height), (0.368125 * height)) controlPoint1: CGPointMake((0.26875* height), (0.368125 * height)) controlPoint2: CGPointMake((0.221875* height), (0.318125* height))];
    [bezierPath closePath];
    bezierPath.miterLimit = 0;
    return bezierPath;
}

- (void)autoFitFontToHeight
{
    CGFloat height = [self heightForCheckbox] * kBoxSize;
    CGFloat fontSize = kCheckboxMaxFontSize;
    CGFloat tempHeight = MAXFLOAT;
    
    do {
        //Update font
        fontSize -= 1;
        UIFont *font = [UIFont fontWithName:_titleLabel.font.fontName size:fontSize];
        //Get size
        CGSize labelSize;
        NSString *text = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        if ([text respondsToSelector:@selector(sizeWithAttributes:)]) {
            labelSize = [text sizeWithAttributes:@{ NSFontAttributeName: font }];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            labelSize = [text sizeWithFont:font];
#pragma clang diagnostic pop
        }
        tempHeight = labelSize.height;
    } while (tempHeight >= height);
    
    _titleLabel.font = [UIFont fontWithName:_titleLabel.font.fontName size:fontSize];
}

- (void)autoFitWidthToText
{
    CGSize labelSize;
    if ([_titleLabel.text respondsToSelector:@selector(sizeWithAttributes:)]) {
        labelSize = [_titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: _titleLabel.font }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        labelSize = [_titleLabel.text sizeWithFont:_titleLabel.font];
#pragma clang diagnostic pop
    }
    
    self.frame = CGRectMake(
                            self.frame.origin.x,
                            self.frame.origin.y,
                            labelSize.width + ([self heightForCheckbox] * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * [self heightForCheckbox]),
                            self.frame.size.height);
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_checkAlignment == HIUICheckboxAlignmentRight) {
        checkView.frame = CGRectIntegral(CGRectMake(
                                                    (_titleLabel.text.length == 0 ? 0 : self.frame.size.width - ((kBoxSize + kCheckHorizontalExtention) * [self heightForCheckbox])),
                                                    (self.frame.size.height - ((kBoxSize + kCheckHorizontalExtention) * [self heightForCheckbox])) / 2.0,
                                                    ((kBoxSize + kCheckHorizontalExtention) * [self heightForCheckbox]),
                                                    [self heightForCheckbox]));
        _titleLabel.frame = CGRectIntegral(CGRectMake(
                                                      0,
                                                      0,
                                                      self.frame.size.width - ([self heightForCheckbox] * (kBoxSize + kCheckHorizontalExtention + kCheckBoxSpacing)),
                                                      self.frame.size.height));
    } else {
        checkView.frame = CGRectIntegral(CGRectMake(
                                                    0,
                                                    (self.frame.size.height - ((kBoxSize + kCheckHorizontalExtention) * [self heightForCheckbox])) / 2.0,
                                                    ((kBoxSize + kCheckHorizontalExtention) * [self heightForCheckbox]),
                                                    [self heightForCheckbox]));
        _titleLabel.frame = CGRectIntegral(CGRectMake(
                                                      checkView.frame.size.width + ([self heightForCheckbox] * kCheckBoxSpacing),
                                                      0,
                                                      self.frame.size.width - ([self heightForCheckbox] * (kBoxSize + kCheckHorizontalExtention + kCheckBoxSpacing)),
                                                      self.frame.size.height));
    }
}

- (void)setCheckState:(HIUICheckboxState)checkState{
    _checkState = checkState;
    [checkView setNeedsDisplay];
}

- (void)toggleCheckState
{
    self.checkState = !self.checkState;
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        _titleLabel.textColor = labelColor;
    } else {
        labelColor = _titleLabel.textColor;
        CGFloat r, g, b, a;
        [labelColor getRed:&r green:&g blue:&b alpha:&a];
        r = floorf(r * 100.0 + 0.5) / 100.0;
        g = floorf(g * 100.0 + 0.5) / 100.0;
        b = floorf(b * 100.0 + 0.5) / 100.0;
        _titleLabel.textColor = [UIColor colorWithRed:(r + .4) green:(g + .4) blue:(b + .4) alpha:1];
    }
    _enabled = enabled;
    [checkView setNeedsDisplay];
}

- (void)setCheckAlignment:(HIUICheckboxAlignment)checkAlignment
{
    _checkAlignment = checkAlignment;
    [self layoutSubviews];
}

- (id)value
{
    if (self.checkState == HIUICheckboxStateUnchecked) {
        return uncheckedValue;
    } else if (self.checkState == HIUICheckboxStateChecked) {
        return checkedValue;
    } else {
        return mixedValue;
    }
}

- (void)setCheckHeight:(CGFloat)checkHeight
{
    _checkHeight = checkHeight;
    [self layoutSubviews];
}

- (CGRect)checkboxFrame
{
    return checkView.frame;
}

#pragma mark - UIControl overrides

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    checkView.selected = YES;
    [checkView setNeedsDisplay];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    checkView.selected = NO;
    [self toggleCheckState];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [super endTrackingWithTouch:touch withEvent:event];
    // 添加block
    if (_changeStateBlock) {
        _changeStateBlock(self.checkState);
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    checkView.selected = NO;
    [checkView setNeedsDisplay];
    [super cancelTrackingWithEvent:event];
}

@end
