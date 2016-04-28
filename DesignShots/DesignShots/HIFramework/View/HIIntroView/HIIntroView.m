//
//  HIIntroView.m
//  UCreditProject
//
//  Created by lizhenjie on 15/5/4.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HIIntroView.h"
#import "HIIntroPage.h"
#import "UIView+HIAnimation.h"

typedef enum : NSUInteger {
    HIIntroViewSwipLeft,
    HIIntroViewSwipRight,
} HIIntroViewSwip;

@interface HIIntroView ()

@property (assign, nonatomic) NSUInteger currentPageIndex;
@property (assign, nonatomic) NSUInteger visiblePageIndex;
@property (strong, nonatomic) HIIntroPage *page;
@property (assign, nonatomic) BOOL didSetupConstraints;
@property (assign, nonatomic) NSInteger lastPageIndex;
@property (strong, nonatomic) UIButton *nowUseButton;

@end

@interface HIIntroPage ()

@property (strong, nonatomic, readwrite) UIView *pageView;

@end

@implementation HIIntroView


- (void)showFullScreen
{
    [self showFullscreenWithAnimateDuration:0.3f];
}

- (void)showFullscreenWithAnimateDuration:(CGFloat)duration
{
    // iOS 9 上排版出现问题，
//    UIView *selectedView;
//    NSLog(@"windows = %d", [[[UIApplication sharedApplication] windows] count]);
//    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
//    for (UIWindow *window in frontToBackWindows) {
//        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
//        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
//        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
//        
//        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
//            selectedView = window;
//            break;
//        }
//    }
    
//    [self showInView:selectedView animateDuration:duration];
    
    [self  showInView:[[[UIApplication sharedApplication] windows] lastObject] animateDuration:duration];
}

- (void)showInView:(UIView *)view
{
    [self showInView:view animateDuration:0];
}

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration
{
    self.alpha = 0;
    
    if(self.superview != view) {
        [view addSubview:self];
    } else {
        [view bringSubviewToFront:self];
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self showPageViewWithIndex:0 withSwipeDirection:HIIntroViewSwipLeft];
    }];
}

- (void)hideWithFadeOutDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self finishIntroductionAndRemoveSelf];
    }];
}

- (void)finishIntroductionAndRemoveSelf {
    if (self.finishIntroBlock) {
        self.finishIntroBlock();
    }

    self.alpha = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeFromSuperview];
    });
}

- (void)showPageViewWithIndex:(NSInteger)pageIndex withSwipeDirection:(HIIntroViewSwip)swipDirection
{
    HIIntroPage *page = [self pageForIndex:pageIndex];
    page.titleImageView.alpha = 1.0;
    page.subtitleImageView.alpha = 1.0;

    CGPoint titleCenter;
    CGPoint subtitleCenter;

    if (HIIntroViewSwipLeft == swipDirection) {
        titleCenter = CGPointMake(3/2.0*SCREEN_WIDTH, 76);
        subtitleCenter = CGPointMake(3/2.0*SCREEN_WIDTH, 124);
        titleCenter.x -= self.width;
        subtitleCenter.x -= self.width;
    } else {
        titleCenter = CGPointMake(-SCREEN_WIDTH/2.0, 76);
        subtitleCenter = CGPointMake(-SCREEN_WIDTH/2.0, 124);
        titleCenter.x += self.width;
        subtitleCenter.x += self.width;
    }

    [UIView animateWithDuration:0.5 animations:^{
        page.titleImageView.center = titleCenter;
    } completion:nil];

    [UIView animateWithDuration:0.4 delay:0.25 options:0 animations:^{
        page.subtitleImageView.center = subtitleCenter;
    } completion:nil];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self checkIndexForScrollView:scrollView];
    CGFloat offset = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    NSUInteger page = (NSUInteger)(offset);
   
    HIIntroPage *lastPage = [self pageForIndex:self.lastPageIndex];
    CGRect titleFrame = lastPage.titleImageView.frame;
    CGRect subtitleFrame = lastPage.subtitleImageView.frame;

    HIIntroViewSwip swipDicretion;
    if (page > self.lastPageIndex) {
        swipDicretion = HIIntroViewSwipLeft;
        titleFrame.origin.x -= self.width;
        subtitleFrame.origin.x -= self.width;
    } else if (page < self.lastPageIndex) {
        swipDicretion = HIIntroViewSwipRight;
        titleFrame.origin.x += self.width;
        subtitleFrame.origin.x += self.width;
    } else {
        return;
    }

    [self showPageViewWithIndex:page withSwipeDirection:swipDicretion];

    self.lastPageIndex = page;
    lastPage.titleImageView.frame = titleFrame;
    lastPage.titleImageView.alpha = 0;
    lastPage.subtitleImageView.alpha = 0;
    lastPage.subtitleImageView.frame = subtitleFrame;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    if (offset > self.width * (self.pagesArray.count-1)) {
//        [self hideWithFadeOutDuration:0.3];
    }
}

#pragma mark - Private Methods

- (void)checkIndexForScrollView:(UIScrollView *)scrollView {
    NSUInteger newPageIndex = (scrollView.contentOffset.x + scrollView.bounds.size.width/2)/self.scrollView.frame.size.width;
    self.currentPageIndex = newPageIndex;
    
    if (self.currentPageIndex == (self.pagesArray.count)) {
        self.currentPageIndex = self.pagesArray.count - 1;
        
        [self finishIntroductionAndRemoveSelf];
    }
}

- (void)buildScrollView
{
    CGFloat contentXIndex = 0;
    
    for (NSUInteger i = 0; i < self.pagesArray.count; i++) {
        HIIntroPage *page = self.pagesArray[i];
        page.pageView = [self viewForPage:page atXIndex:contentXIndex];
        contentXIndex += self.scrollView.frame.size.width;
        page.pageView.backgroundColor = [self bgColorForPage:i];
        if (i == self.pagesArray.count - 1) {
            [page.pageView addSubview:self.nowUseButton];
        }
        [self.scrollView addSubview:page.pageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.pagesArray.count, self.scrollView.frame.size.height);
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    self.lastPageIndex = 0;
}

- (CGFloat)alphaForPageIndex:(NSUInteger)idx
{
    if(![self pageForIndex:idx]) {
        return 1.f;
    }
    
    return [self pageForIndex:idx].alpha;
}

- (UIView *)viewForPageIndex:(NSUInteger)idx
{
    return [self pageForIndex:idx].pageView;
}

- (HIIntroPage *)pageForIndex:(NSUInteger)idx
{
    if(idx >= self.pagesArray.count) {
        return nil;
    }
    
    return (HIIntroPage *)self.pagesArray[idx];
}

- (UIView *)viewForPage:(HIIntroPage *)page atXIndex:(CGFloat)xIndex
{
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(xIndex, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    UIImageView *titleIconView = page.titleIconView;
    UIImageView *titleImageView = page.titleImageView;
    UIImageView *subtitleImageView = page.subtitleImageView;
    CGSize iconSize = titleIconView.image.size;
    CGSize titleSize = titleImageView.image.size;
    CGSize subtitleSize = subtitleImageView.image.size;
    
    CGFloat oneSpace = self.height/10;
    
    if (titleImageView) {
        titleImageView.frame = CGRectMake((self.width - titleSize.width)/2 + self.width, oneSpace, titleSize.width, titleSize.height);
       [pageView addSubview:titleImageView];
    }
    
    if (subtitleImageView) {
        subtitleImageView.frame = CGRectMake((self.width - subtitleSize.width)/2 + self.width, 2 * oneSpace, subtitleSize.width, subtitleSize.height);
        [pageView addSubview:subtitleImageView];
    }
    
    if(titleIconView) {
        titleIconView.frame = CGRectMake((self.width - iconSize.width)/2, 3 * oneSpace, iconSize.width, iconSize.height);
        [pageView addSubview:titleIconView];
    }

    return pageView;
}

- (UIColor *)bgColorForPage:(NSUInteger)idx
{
    return [self pageForIndex:idx].bgColor;
}

- (void)showPanelAtPageControl
{
    [self setCurrentPageIndex:self.pageControl.currentPage animated:YES];
}

- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    [self setCurrentPageIndex:currentPageIndex animated:NO];
}

- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex animated:(BOOL)animated {
    if(![self pageForIndex:currentPageIndex]) {
        return;
    }
    
    CGFloat offset = currentPageIndex * self.scrollView.frame.size.width;
    CGRect pageRect = { .origin.x = offset, .origin.y = 0.0, .size.width = self.scrollView.frame.size.width, .size.height = self.scrollView.frame.size.height };
    [self.scrollView scrollRectToVisible:pageRect animated:animated];
}

#pragma mark - Event Response

- (void)nowUseButtonClicked:(UIButton *)sender
{
    [self hideWithFadeOutDuration:0.3];
}

#pragma mark - Getter And Setter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
        _scrollView.contentSize = CGSizeMake(self.width * self.pagesArray.count, self.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake((self.width-160)/2, self.height * 0.9, 160, 30);
        _pageControl.currentPage = 0;
        _pageControl.defersCurrentPageDisplay = YES;
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [_pageControl addTarget:self action:@selector(showPanelAtPageControl) forControlEvents:UIControlEventValueChanged];

    }
    return _pageControl;
}

- (void)setPagesArray:(NSArray *)pagesArray
{
    _pagesArray = [pagesArray copy];
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self buildScrollView];
    self.pageControl.numberOfPages = _pagesArray.count;
}

- (UIButton *)nowUseButton
{
    if (!_nowUseButton) {
        UIImage *buttonImage = [UIImage imageNamed:@"user_guide_4_now_use"];
        _nowUseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nowUseButton setImage:buttonImage forState:UIControlStateNormal];
        _nowUseButton.frame = CGRectMake((self.width - buttonImage.size.width)/2, self.height * 0.8+5, buttonImage.size.width, buttonImage.size.height);
        [_nowUseButton addTapTarget:self selector:@selector(nowUseButtonClicked:)];
    }
    return _nowUseButton;
}

@end
