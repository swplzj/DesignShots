//
//  HIAnimation.m
//  HIFramework
//
//  Created by lizhenjie on 4/11/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIAnimation.h"

@interface HIUIAnimation ()

@end

@implementation HIUIAnimation

@end

@implementation HIUIAnimationFade

+(HIUIAnimationFade *) animationToAlpha:(CGFloat)alpha duration:(CGFloat)duration
{
    HIUIAnimationFade * fadeTo = [[HIUIAnimationFade alloc] init];
    fadeTo.animationType = HI_ANIMATION_TYPE_FADE_TO;
    fadeTo.animationDuration = duration;
    fadeTo.alpha = alpha;
    return fadeTo;
}

+(HIUIAnimationFade *) animationByAlpha:(CGFloat)alpha duration:(CGFloat)duration
{
    HIUIAnimationFade * fadeBy = [[HIUIAnimationFade alloc] init];
    fadeBy.animationType = HI_ANIMATION_TYPE_FADE_BY;
    fadeBy.animationDuration = duration;
    fadeBy.alpha = alpha;
    return fadeBy;
}

@end

@implementation HIUIAnimationDisplace

+(HIUIAnimationDisplace*) animationToPoint:(CGPoint)point duration:(CGFloat)duration
{
    HIUIAnimationDisplace * animation = [[HIUIAnimationDisplace alloc] init];
    animation.point = point;
    animation.animationType = HI_ANIMATION_TYPE_DISPLACEMENT_TO;
    animation.animationDuration = duration;
    return animation;
}

+(HIUIAnimationDisplace *) animationByPoint:(CGPoint)point duration:(CGFloat)duration
{
    HIUIAnimationDisplace * animation = [[HIUIAnimationDisplace alloc] init];
    animation.animationType = HI_ANIMATION_TYPE_DISPLACEMENT_BY;
    animation.animationDuration = duration;
    animation.point = point;
    return animation;
}

@end

@implementation HIUIAnimationScale

+(HIUIAnimationScale *) animationToScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY duration:(CGFloat)duration
{
    HIUIAnimationScale * animation = [[HIUIAnimationScale alloc] init];
    animation.animationType = HI_ANIMATION_TYPE_SCALE_TO;
    animation.animationDuration = duration;
    animation.scaleX = scaleX;
    animation.scaleY = scaleY;
    return animation;
}

+(HIUIAnimationScale *) animationByScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY duration:(CGFloat)duration;
{
    HIUIAnimationScale * animation = [[HIUIAnimationScale alloc] init];
    animation.animationType = HI_ANIMATION_TYPE_SCALE_BY;
    animation.animationDuration = duration;
    animation.scaleX = scaleX;
    animation.scaleY = scaleY;
    return animation;
}

@end

@implementation HIUIAnimationRotate

+(HIUIAnimationRotate *) animationToRotate:(CGFloat)angle duration:(CGFloat)duration
{
    HIUIAnimationRotate * animation = [[HIUIAnimationRotate alloc] init];
    animation.animationType = HI_ANIMATION_TYPE_ROTATE_TO;
    animation.animationDuration = duration;
    animation.angle = angle;
    
    return animation;
}

+(HIUIAnimationRotate *) animationByRotate:(CGFloat)angle duration:(CGFloat)duration;
{
    HIUIAnimationRotate * animation = [[HIUIAnimationRotate alloc] init];
    animation.animationType = HI_ANIMATION_TYPE_ROTATE_BY;
    animation.animationDuration = duration;
    animation.angle = angle;
    
    return animation;
}

@end


@interface HIUIAnimationQueue()

@property(nonatomic,retain) NSMutableArray * actionList;

@end


@implementation HIUIAnimationQueue

-(void) dealloc
{
    self.completionblock = nil;
}

-(id)init
{
    if (self = [super init]) {
        self.actionList = [NSMutableArray array];
    }
    
    return self;
}

-(HIUIAnimation *) getFirstAnimation
{
    if([_actionList count])
        return [_actionList objectAtIndex:0];
    else
        return nil;
}

-(void) removeFirstAnimation
{
    if([_actionList count])
        [_actionList removeObjectAtIndex:0];
}

-(void) addAnimation:(HIUIAnimation *)animation
{
    if (animation)
        [_actionList addObject:animation];
}

-(void) runAnimationsInView:(UIView *)view
{
    if (!_actionList) {
        return;
    }
    
    CGPoint center = view.center;
    CGFloat alpha = view.alpha;
    CGAffineTransform transform = view.transform;
    
    HIUIAnimation * animation = [self getFirstAnimation];
    
    switch (animation.animationType)
    {
        case HI_ANIMATION_TYPE_DISPLACEMENT_TO:
        {
            HIUIAnimationDisplace * displaceMent  = (HIUIAnimationDisplace *)animation;
            center.x = displaceMent.point.x;
            center.y = displaceMent.point.y;
            break;
        }
        case HI_ANIMATION_TYPE_DISPLACEMENT_BY:
        {
            HIUIAnimationDisplace * displaceMent  = (HIUIAnimationDisplace *)animation;
            center.x+=displaceMent.point.x;
            center.y+=displaceMent.point.y;
            break;
        }
        case HI_ANIMATION_TYPE_FADE_TO:
        {
            HIUIAnimationFade * fadeAnimation  = (HIUIAnimationFade *)animation;
            alpha=fadeAnimation.alpha;
            break;
        }
        case HI_ANIMATION_TYPE_FADE_BY:
        {
            HIUIAnimationFade * fadeAnimation  = (HIUIAnimationFade *)animation;
            alpha+=fadeAnimation.alpha;
            break;
        }
        case HI_ANIMATION_TYPE_SCALE_BY:
        {
            HIUIAnimationScale * scale =(HIUIAnimationScale *)animation;
            transform.a = scale.scaleX;
            transform.d = scale.scaleY;
            break;
        }
        case HI_ANIMATION_TYPE_SCALE_TO:
        {
            HIUIAnimationScale * scale =(HIUIAnimationScale *)animation;
            transform = CGAffineTransformMakeScale(scale.scaleX,
                                                   scale.scaleY);
            break;
        }
        case HI_ANIMATION_TYPE_ROTATE_BY:
        {
            HIUIAnimationRotate * rotate =(HIUIAnimationRotate *)animation;
            CGFloat radians = rotate.angle * M_PI/180;
            CGAffineTransform rotatedTransform = CGAffineTransformRotate(transform,radians);
            transform  = rotatedTransform;
            break;
        }
        case HI_ANIMATION_TYPE_ROTATE_TO:
        {
            HIUIAnimationRotate * rotate =(HIUIAnimationRotate *)animation;
            CGFloat radians = rotate.angle * M_PI/180;
            transform = CGAffineTransformMakeRotation(radians);
            //            CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(rotate.angle);
            break;
        }
        default:
            break;
    }
    
    [UIView animateWithDuration:animation.animationDuration animations:^{
        view.center    = center;
        view.alpha     = alpha;
        view.transform = transform;
    } completion:^(BOOL finished) {
        [self removeFirstAnimation];
        
        if (self.actionList.count == 0) {
            if (self.completionblock) {
                _completionblock(self);
            }
            return;
        }
        
        [self runAnimationsInView:view];

    }];
    
}


@end