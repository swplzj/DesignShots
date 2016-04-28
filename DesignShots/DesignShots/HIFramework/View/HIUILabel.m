//
//  HILabel.m
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUILabel.h"


@interface HIUILabel ()

@property (nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation HIUILabel

-(id) initWithCopyingEnabled:(BOOL)copyingEnabled
{
    self = [super initWithFrame:CGRectZero];
    if ( self ) {
        self.copyingEnabled = copyingEnabled;
        [self initCopyGecognizer];
        [self defaultConfig];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame copyingEnabled:(BOOL)copyingEnabled
{
    self = [super initWithFrame:frame];
    if ( self ){
        self.copyingEnabled = copyingEnabled;
        [self initCopyGecognizer];
        [self defaultConfig];
    }
    return self;
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if ( self ) {
        self.copyingEnabled = NO;
        [self initCopyGecognizer];
        [self defaultConfig];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.copyingEnabled = NO;
        [self initCopyGecognizer];
        [self defaultConfig];
    }
    return self;
}

-(void) defaultConfig
{
    self.font = [UIFont systemFontOfSize:12.0f];
    self.textAlignment = NSTextAlignmentLeft;
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    self.userInteractionEnabled = YES;
}

-(void) initCopyGecognizer
{
    if (self.copyingEnabled) {
        if (self.longPressGestureRecognizer) {
            self.longPressGestureRecognizer.enabled = YES;
            return;
        }else{
            self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
            [self addGestureRecognizer:_longPressGestureRecognizer];
            
            _copyMenuArrowDirection = UIMenuControllerArrowDefault;
        }
    }else{
        if (self.longPressGestureRecognizer) {
            self.longPressGestureRecognizer.enabled = NO;
        }
    }
}

-(void) setCopyingEnabled:(BOOL)copyingEnabled
{
    _copyingEnabled = copyingEnabled;
    [self initCopyGecognizer];
}

-(void) longPressGestureRecognized:(UILongPressGestureRecognizer *)rg
{
    if (rg == self.longPressGestureRecognizer) {
        if (rg.state == UIGestureRecognizerStateBegan) {
            if(![self becomeFirstResponder]){
                NSLog(@" ! UIMenuController will not work with %@ since it cannot become first responder", self);
            }
            
            UIMenuController * copyMenu = [UIMenuController sharedMenuController];
            [copyMenu setTargetRect:self.bounds inView:self];
            copyMenu.arrowDirection = self.copyMenuArrowDirection;
            [copyMenu setMenuVisible:YES animated:YES];
        }
    }
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return self.copyingEnabled;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL retValue = NO;
    
    if (action == @selector(copy:)) {
        if (self.copyingEnabled) {
            retValue = YES;
        }
    } else {
        retValue = [super canPerformAction:action withSender:sender];
    }
    
    return retValue;
}

- (void)copy:(id)sender
{
    if (self.copyingEnabled) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.text];
    }
}


-(void) setStrikeThroughLine:(BOOL)strikeThroughLine
{
    _strikeThroughLine = strikeThroughLine;
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    if (self.strikeThroughLine) {
        //FIXME: iOS7废弃
        //CGSize contentSize = [self.text sizeWithFont:self.font constrainedToSize:self.frame.size];
        CGSize contentSize = [self.text sizeWithFont:self.font byHeight:self.frame.size.height];
        CGContextRef c = UIGraphicsGetCurrentContext();
        //CGFloat color[4] = {0.667, 0.667, 0.667, 1.0};
        CGContextSetStrokeColor(c, CGColorGetComponents(self.textColor.CGColor));
        CGContextSetLineWidth(c, 1);
        CGContextBeginPath(c);
        CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
        CGContextMoveToPoint(c, self.bounds.origin.x, halfWayUp );
        CGContextAddLineToPoint(c, self.bounds.origin.x + contentSize.width, halfWayUp);
        CGContextStrokePath(c);
    }
    
    [super drawRect:rect];
}

@end
