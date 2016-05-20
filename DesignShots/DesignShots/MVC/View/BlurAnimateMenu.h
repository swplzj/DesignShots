//
//  BlurAnimateMenu.h
//  DesignShots
//
//  Created by lizhenjie on 5/20/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuButtonActionBlock)(NSUInteger clickIndex);

@interface BlurAnimateMenu : UIView

@property (strong, nonatomic) NSMutableArray *titlesArray;
@property (assign, nonatomic) CGFloat  menuButtonHeight;
@property (copy, nonatomic) MenuButtonActionBlock menuButtonActionBlock;

- (void)trigger;

@end
