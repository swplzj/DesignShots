//
//  HIIntroView.h
//  UCreditProject
//
//  Created by lizhenjie on 15/5/4.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinishIntroductionBlock)(void);

@interface HIIntroView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *pagesArray;
@property (copy, nonatomic) FinishIntroductionBlock finishIntroBlock;
@property (assign,nonatomic) BOOL swipeToExit;

- (void)showFullScreen;
- (void)showFullscreenWithAnimateDuration:(CGFloat)duration;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;

- (void)hideWithFadeOutDuration:(CGFloat)duration;

- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex;
- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex animated:(BOOL)animated;


@end
