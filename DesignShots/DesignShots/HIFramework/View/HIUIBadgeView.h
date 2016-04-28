//
//  HIBadgeView.h
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIUIBadgeView : UIView

@property(nonatomic,retain) UIView * badgeView;
@property(nonatomic,retain) NSString * valueString;

@property(nonatomic,assign) BOOL hideWhenEmpty;
@property(nonatomic,assign) BOOL kawaiiBubble;

- (id)initWithFrame:(CGRect)frame valueString:(NSString *)valueString;

@end
