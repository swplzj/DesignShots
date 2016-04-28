//
//  HIIntroPage.h
//  UCreditProject
//
//  Created by lizhenjie on 15/5/4.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIIntroPage : NSObject

@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) UIImageView *titleIconView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *subtitleImageView;
@property (nonatomic, assign) CGFloat alpha;

@property(nonatomic, strong, readonly) UIView *pageView;

+ (instancetype)page;
+ (instancetype)pageWithCustomView:(UIView *)customV;

@end
