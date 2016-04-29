
//
//  HIMarcos.h
//  DesignShots
//
//  Created by lizhenjie on 4/27/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#ifndef HIMarcos_h
#define HIMarcos_h


/** AppDelegate */
#define HI_APPDELEGATE ([UIApplication sharedApplication].delegate)
/* It will call self = [super init] and return self */
#define HI_SUPER_INIT(x)  \
@try { \
if(self = [super init]) \
{ \
x \
} \
else \
{ \
} \
return self; } \
@catch (NSException * exception) { \
ERROR(@"Init failed : %@",[self class]); } \
@finally { }


/** KeyWindow */
#define HI_KEYWINDOW ((UIView*)[UIApplication sharedApplication].keyWindow)

//** Screen width */
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
/** Screen height */
#define SCREEN_HEIGHT (([[UIScreen mainScreen] bounds].size.height))

/** Random number */
#define HI_RANDOM(from,to) ((int)(from + (arc4random() % (to - from + 1))))

/** String with format */
#define HI_NSSTRING_FORMAT(s,...) [NSString stringWithFormat:s,##__VA_ARGS__]

/** String is invalid */
#define HI_NSSTRING_IS_INVALID(s) ( !s || s.length <= 0 || [s isEqualToString:@"(null)"] || [s isKindOfClass:[NSNull class]])

/** String from number */
#define HI_NSSTRING_FROM_NUMBER(number) [NSString stringWithFormat:@"%@",number]

/** String from int */
#define HI_NSSTRING_FROM_INT(int) [NSString stringWithFormat:@"%d",int]


/** UIColor */
#define HI_RGB(R,G,B)       [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0f]
#define HI_RGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define HI_HEX_RGB(V)		[UIColor fromHexValue:V]
#define HI_HEX_RGBA(V, A)	[UIColor fromHexValue:V alpha:A]
#define HI_SHORT_RGB(V)	    [UIColor fromShortHexValue:V]

/** StretchableImageWithLeftCapWidth */
#define HI_IMAGE_STRETCHABLE(image,capWidth,capHeight) [image stretchableImageWithLeftCapWidth:capWidth topCapHeight:capHeight]

/** Remove from superview */
#define HI_REMOVE_FROM_SUPERVIEW(v,setToNull) if(v){[v removeFromSuperview];    \
if(setToNull == YES){             \
v = NULL;                   \
}}

/** __block self */
#define HI_BLOCK_SELF __block typeof(self) nRetainSelf = self
#define HI_WEAK_SELF  __weak typeof(self)weakSelf = self;

/** Fast animations */
#define HI_FAST_ANIMATIONS(duration,animationsBlock) [UIView animateWithDuration:duration animations:animationsBlock]

typedef void (^HIAnimationsFinishedBlock)(BOOL isFinished);

/** Fast animations */
#define HI_FAST_ANIMATIONS_F(duration,animationsBlock,HIAnimationsFinishedBlock)                             \
[UIView animateWithDuration:duration                    \
animations:animationsBlock             \
completion:HIAnimationsFinishedBlock]

/** Fast animations */
#define HI_FAST_ANIMATIONS_O_F(duration,UIViewAnimationOptions,animationsBlock,HIAnimationsFinishedBlock)    \
[UIView animateWithDuration:duration                    \
delay:0                           \
options:UIViewAnimationOptions      \
animations:animationsBlock             \
completion:HIAnimationsFinishedBlock]


#define HI_LABEL_FIT_SIZE(label) [label.text sizeWithFont:label.font   \
constrainedToSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)  \
lineBreakMode:label.lineBreakMode];

#endif /* HIMarcos_h */
