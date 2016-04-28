//
//  HIUIPullLoader.h
//  HIFramework
//
//  Created by lizhenjie on 4/10/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum _HI_PULL_DIRETION {
    
    HI_PULL_DIRETION_TOP    = 0,
    HI_PULL_DIRETION_BUTTOM = 1,
    
} HI_PULL_DIRETION;

typedef enum _HI_PULL_BACK_GROUND_STYLE {
    
    HI_PULL_BACK_GROUND_STYLE_CUSTOM   = 0, //当为自定义时可以手动设置背景以及箭头图片
    HI_PULL_BACK_GROUND_STYLE_COLORFUL = 1
    
} HI_PULL_BACK_GROUND_STYLE;

typedef enum _HI_PULL_STYLE {
    
    HI_PULL_STYLE_HEADER             = 0,
    HI_PULL_STYLE_FOOTER             = 1,
    HI_PULL_STYLE_HEADER_AND_FOOTER  = 2,
    HI_PULL_STYLE_NULL               = 3,
    
} HI_PULL_STYLE;

@class HIUIPullLoader;

typedef void (^HIUIPulldidRefreshBlock)( HIUIPullLoader * pull , HI_PULL_DIRETION diretion );

@interface HIUIPullLoader : NSObject

@property (nonatomic,copy) HIUIPulldidRefreshBlock beginRefreshBlock;

@property (nonatomic,assign) UIScrollView * scrollView;

@property (nonatomic,assign) BOOL canLoadMore;

@property (readonly) HI_PULL_STYLE             pullStyle;
@property (readonly) HI_PULL_BACK_GROUND_STYLE backGroundStyle;

+ (id) pullLoaderWithScrollView:(UIScrollView *)scrollView
                      pullStyle:(HI_PULL_STYLE)pullStyle
                backGroundStyle:(HI_PULL_BACK_GROUND_STYLE)backGroundStyle;

- (id) initWithScrollView:(UIScrollView *)scrollView
                pullStyle:(HI_PULL_STYLE)pullStyle
          backGroundStyle:(HI_PULL_BACK_GROUND_STYLE)backGroundStyle;

- (id) initWithWeakScrollView:(UIScrollView *)scrollView
                    pullStyle:(HI_PULL_STYLE)pullStyle
              backGroundStyle:(HI_PULL_BACK_GROUND_STYLE)backGroundStyle;

- (void) startRefresh;
- (void) endRefresh;
- (void) endRefreshWithAnimated:(BOOL)animated;

@end
