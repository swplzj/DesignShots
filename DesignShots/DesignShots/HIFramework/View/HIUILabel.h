//
//  HILabel.h
//  HIFramework
//
//  Created by lizhenjie on 4/3/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIUILabel : UILabel

@property(nonatomic,assign)  BOOL strikeThroughLine;
@property(nonatomic,assign)  BOOL copyingEnabled;
@property(nonatomic,assign)  UIMenuControllerArrowDirection copyMenuArrowDirection;

-(id) initWithCopyingEnabled:(BOOL)copyingEnabled;
-(id) initWithFrame:(CGRect)frame copyingEnabled:(BOOL)copyingEnabled;

@end
