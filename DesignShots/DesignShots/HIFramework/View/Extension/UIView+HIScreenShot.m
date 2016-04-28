//
//  UIView+HIScreenShot.m
//  HIFramework
//
//  Created by lizhenjie on 4/8/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "UIView+HIScreenShot.h"


@implementation UIView (HIScreenShot)

- (UIImage *) screenshot
{
    return [self capture];
}

- (UIImage *) screenshotOneLayer
{
    NSMutableArray * temp = [NSMutableArray new];
    
    for ( UIView * subview in self.subviews ) {
        if ( NO == subview.hidden ) {
            subview.hidden = YES;
            
            [temp addObject:subview];
        }
    }
    
    UIImage * image = [self capture];
    
    for ( UIView * subview in temp ) {
        subview.hidden = NO;
    }
    
    return image;
}

- (UIImage *)capture
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect captureBounds = CGRectZero;
    captureBounds.size = self.bounds.size;
    
    if ( captureBounds.size.width > screenSize.width ) {
        captureBounds.size.width = screenSize.width;
    }
    
    if ( captureBounds.size.height > screenSize.height ) {
        captureBounds.size.height = screenSize.height;
    }
    
    return [self capture:captureBounds];
}

- (UIImage *)capture:(CGRect)frame
{
    UIImage * result = nil;
    
    UIGraphicsBeginImageContextWithOptions( frame.size, NO, 1.0 );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( context ) {
        CGContextTranslateCTM( context, -frame.origin.x, -frame.origin.y );
        [self.layer renderInContext:context];
        
        result = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end