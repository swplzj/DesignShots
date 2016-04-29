//
//  HIUITopNotificationView.m
//  HIFramework
//
//  Created by lizhenjie on 4/10/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUITopNotificationView.h"
#import "HIPrecompile.h"

@interface HIUITopNotificationView ()
{
    HITopNotificationViewType style;
}

@property(nonatomic,retain) UIView * parentView;

@end

@implementation HIUITopNotificationView

+ (HIUITopNotificationView *)showInView:(UIView *)view style:(HITopNotificationViewType)style message:(NSString *)message
{
    HIUITopNotificationView * notificationView = [[HIUITopNotificationView alloc] initWithParentView:view type:style];
    notificationView.label.text = message;
    
    if (style == HITopNotificationViewTypeError) {
        
        notificationView.imageView.image = [UIImage imageNamed:@"HI_UITopNotificationView_exclamationMarkIcon.png"];
        notificationView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        
    } else if (style == HITopNotificationViewTypeSuccess){
        
        notificationView.imageView.image = [UIImage imageNamed:@"HI_UITopNotificationView_checkmarkIcon.png"];
        notificationView.backgroundColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:0.9];
    } else if (style == HITopNotificationViewTypeNone){
        notificationView.imageView.image = nil;
        notificationView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.6 alpha:0.3];
    }
    
    [notificationView show];
    return notificationView;
}

+ (HIUITopNotificationView *)showInView:(UIView *)view
                               tintColor:(UIColor*)tintColor
                                   image:(UIImage*)image
                                 message:(NSString*)message
                                duration:(NSTimeInterval)duration
{
    HIUITopNotificationView * notificationView = [[HIUITopNotificationView alloc] initWithParentView:view type:HITopNotificationViewTypeNone];
    notificationView.label.text = message;
    notificationView.imageView.image = image;
    notificationView.duration = duration;
    notificationView.backgroundColor = tintColor;
    
    [notificationView show];
    return notificationView;
}

-(void) dealloc
{
    if (self.parentView && [self.parentView isKindOfClass:[UIScrollView class]]) {
        [self.parentView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    self.parentView = nil;
}

-(void) removeFromSuperview
{
    if (self.parentView && [self.parentView isKindOfClass:[UIScrollView class]]) {
        [self.parentView removeObserver:self forKeyPath:@"contentOffset"];
        self.parentView = nil;
    }
    
    [super removeFromSuperview];
}

- (id)initWithParentView:(UIView *)view type:(HITopNotificationViewType)type
{
    self = [super initWithFrame:[self getFrameFromView:view]];
    if (self) {
        style = type;
        self.parentView = view;
        self.duration = 2;
        self.backgroundColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0];
        [self initSelf];
    }
    return self;
}

- (CGRect) getFrameFromView:(UIView *)view
{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView * scrollView = (UIScrollView *)view;
        return CGRectMake(0, scrollView.contentOffset.y + scrollView.contentInset.top, view.frame.size.width, HIUITopNotificationViewHeight);
    }
    
    return CGRectMake(0, 0, view.frame.size.width, HIUITopNotificationViewHeight);
}

-(void) initSelf
{
//    [self createBlurLayer];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.opaque = NO;
    [self addSubview:_imageView];
    
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize:17.0f];
    self.label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.label.numberOfLines = 3;
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.textColor = [UIColor whiteColor];
    
    
    [self addSubview:self.label];
    
    if ([self.parentView isKindOfClass:[UIScrollView class]]) {
        [self.parentView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
}

-(void) layout
{
    if (self.imageView.image) {
        float distanceSide = (HIUITopNotificationViewHeight - HIUITopNotificationViewImageViewSidelength)/2;
        self.imageView.frame = CGRectMake(distanceSide, distanceSide, HIUITopNotificationViewImageViewSidelength, HIUITopNotificationViewImageViewSidelength);
        
        float labelX = distanceSide * 2 + HIUITopNotificationViewImageViewSidelength;
        self.label.frame = CGRectMake(labelX, distanceSide, self.parentView.frame.size.width - labelX - distanceSide - HIUITopNotificationViewImageViewSidelength, HIUITopNotificationViewHeight - distanceSide * 2);
    } else {
        
        float distanceSide = (HIUITopNotificationViewHeight - 16);
        self.label.frame = CGRectMake(8, 8, self.parentView.frame.size.width - 16, distanceSide);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([object isEqual:self.parentView]) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            self.frame = [self getFrameFromView:self.parentView];
        }
    }
}

-(void) createBlurLayer
{
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:[self bounds]];
    toolbar.alpha = 0.8;
    [self insertSubview:toolbar atIndex:0];
}

-(void) show
{
    if (!self.parentView) {
        self.parentView = [UIApplication sharedApplication].keyWindow;
    }
    
    [self layout];
    self.alpha = 0;
    [self.parentView addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.duration != INT_MAX) {
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            });
        }
    }];
}

@end
