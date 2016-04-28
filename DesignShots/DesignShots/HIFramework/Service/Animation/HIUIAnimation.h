//
//  HIAnimation.h
//  HIFramework
//
//  Created by lizhenjie on 4/11/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+HIAnimation.h"
#import "CALayer+HIShake.h"

typedef enum : NSUInteger {
    //** default */
    HI_ANIMATION_TYPE_NONE   =0,
    /** 位置移动量 */
    HI_ANIMATION_TYPE_DISPLACEMENT_BY,
    /** 位置移动 */
    HI_ANIMATION_TYPE_DISPLACEMENT_TO,
    HI_ANIMATION_TYPE_FADE_BY,
    HI_ANIMATION_TYPE_FADE_TO,
    HI_ANIMATION_TYPE_SCALE_BY,
    HI_ANIMATION_TYPE_SCALE_TO,
    HI_ANIMATION_TYPE_ROTATE_BY,
    HI_ANIMATION_TYPE_ROTATE_TO,
    /** 回调Block */
    HI_ANIMATION_TYPE_CALL_BACK
} HI_ANIMATION_TYPE;


#pragma mark -


@interface HIUIAnimation : NSObject

@property(nonatomic,assign) HI_ANIMATION_TYPE animationType;
@property(nonatomic,assign) CGFloat animationDuration;

@end


#pragma mark -


/** 透明度变化的动画 */
@interface HIUIAnimationFade : HIUIAnimation

@property (nonatomic,assign) CGFloat alpha;

+(HIUIAnimationFade *)animationToAlpha:(CGFloat)alpha duration:(CGFloat)duration;

/** alpha是变化量，可以是正负值 */
+(HIUIAnimationFade *)animationByAlpha:(CGFloat)alpha duration:(CGFloat)duration;

@end


#pragma mark -


/** 位置移动 */
@interface HIUIAnimationDisplace : HIUIAnimation

@property (nonatomic,assign) CGPoint point;

+(HIUIAnimationDisplace *)animationToPoint:(CGPoint)point duration:(CGFloat)duration;
+(HIUIAnimationDisplace *)animationByPoint:(CGPoint)point duration:(CGFloat)duration;

@end


#pragma mark -


/** 缩放动画 */
@interface HIUIAnimationScale : HIUIAnimation

@property (nonatomic,assign) CGFloat scaleX;
@property (nonatomic,assign) CGFloat scaleY;

+(HIUIAnimationScale *)animationToScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY duration:(CGFloat)duration;
+(HIUIAnimationScale *)animationByScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY duration:(CGFloat)duration;

@end


#pragma mark -


/** 旋转动画 */
@interface HIUIAnimationRotate : HIUIAnimation

/** 角度值,不是M_PI,不是弧度 */
@property (nonatomic,assign) CGFloat angle;


+(HIUIAnimationRotate *)animationToRotate:(CGFloat)angle duration:(CGFloat)duration;
+(HIUIAnimationRotate *)animationByRotate:(CGFloat)angle duration:(CGFloat)duration;

@end


#pragma mark -


typedef void(^HI_UIANIMATION_BLOCK)(id ani);

/** 动画队列，添加动作到队列中，然后view执行队列动画 */
@interface HIUIAnimationQueue :NSObject

@property (nonatomic,copy) HI_UIANIMATION_BLOCK completionblock;

-(void) addAnimation:(HIUIAnimation *)animation;
-(void) runAnimationsInView:(UIView *)view;

@end
