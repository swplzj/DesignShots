//
//  HIIntroPage.m
//  UCreditProject
//
//  Created by lizhenjie on 15/5/4.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HIIntroPage.h"

@interface HIIntroPage ()

@property(nonatomic, strong, readwrite) UIView *pageView;

@end


@implementation HIIntroPage

#pragma mark - Page lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _bgColor = [UIColor clearColor];
        _alpha = 1.f;
    }
    return self;
}

+ (instancetype)page {
    return [[self alloc] init];
}

+ (instancetype)pageWithCustomView:(UIView *)customV {
    HIIntroPage *newPage = [[self alloc] init];
    return newPage;
}

- (UIImageView *)titleIconView
{
    if (!_titleIconView) {
        _titleIconView = [[UIImageView alloc] init];
//        _titleIconView = [UIImageView newAutoLayoutView];
    }
    return _titleIconView;
}

- (UIImageView *)titleImageView
{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
//        _titleImageView = [UIImageView newAutoLayoutView];
    }
    return _titleImageView;
}

- (UIImageView *)subtitleImageView
{
    if (!_subtitleImageView) {
        _subtitleImageView = [[UIImageView alloc] init];
//        _subtitleImageView = [UIImageView newAutoLayoutView];
    }
    return _subtitleImageView;
}

@end
