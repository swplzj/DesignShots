//
//  UIView+HIBackground.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIView+HIBackground.h"


#pragma mark -

@interface __HI_BackgroundImageView : UIImageView
@end

#pragma mark -

@implementation __HI_BackgroundImageView
@end

@implementation UIView (HIBackground)


@dynamic backgroundImageView;
@dynamic backgroundImage;

- (UIImageView *) backgroundImageView
{
    UIImageView * imageView = nil;
    
    for ( UIView * subView in self.subviews )
    {
        if ( [subView isKindOfClass:[__HI_BackgroundImageView class]] )
        {
            imageView = (UIImageView *)subView;
            break;
        }
    }
    
    if ( nil == imageView )
    {
        imageView = [[__HI_BackgroundImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizesSubviews = YES;
        imageView.autoresizingMask = UIViewAutoresizingNone;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        
        [self addSubview:imageView];
        [self sendSubviewToBack:imageView];
    }
    
    return imageView;
}

- (UIImage *)backgroundImage
{
    return self.backgroundImageView.image;
}

- (void)setBackgroundImage:(UIImage *)image
{
    UIImageView * imageView = self.backgroundImageView;
    
    if ( imageView )
    {
        if ( image )
        {
            imageView.image = image;
            imageView.frame = self.bounds;
            [imageView setNeedsDisplay];
        }
        else
        {
            imageView.image = nil;
            [imageView removeFromSuperview];
        }
    }
}

@end
