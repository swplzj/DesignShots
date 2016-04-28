//
//  UIViewController+HITitle.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIViewController+HITitle.h"

@implementation UIViewController (HITitle)


@dynamic titleString;
@dynamic titleImage;
@dynamic titleView;

- (NSString *)titleString
{
    return self.navigationItem.title ? self.navigationItem.title : self.title;
}

- (void)setTitleString:(NSString *)text
{
    self.navigationItem.title = text;
}

- (UIImage *)titleImage
{
    UIImageView * imageView = (UIImageView *)self.navigationItem.titleView;
    if ( imageView && [imageView isKindOfClass:[UIImageView class]] ) {
        return imageView.image;
    }
    
    return nil;
}

- (void)setTitleImage:(UIImage *)image
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;
}

- (UIView *)titleView
{
    return self.navigationItem.titleView;
}

- (void)setTitleView:(UIView *)view
{
    self.navigationItem.titleView = view;
}

@end
