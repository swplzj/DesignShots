//
//  HIUIPullLoader.m
//  HIFramework
//
//  Created by lizhenjie on 4/10/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUIPullLoader.h"
#import "HIPrecompile.h"

#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#pragma mark -

#undef	ANIMATION_DURATION
#define ANIMATION_DURATION	(0.3f)

#pragma mark -

@interface HIUIPullLoader()

@property(nonatomic,assign) HI_PULL_STYLE pullStyle;

@end

#pragma mark -

@implementation HIUIPullLoader


-(void) dealloc
{
    self.beginRefreshBlock = nil;
}

+ (id) pullLoaderWithScrollView:(UIScrollView *)scrollView
                      pullStyle:(HI_PULL_STYLE)pullStyle
                backGroundStyle:(HI_PULL_BACK_GROUND_STYLE)backGroundStyle
{
    HIUIPullLoader * pull = [[HIUIPullLoader alloc] initWithScrollView:scrollView pullStyle:pullStyle backGroundStyle:backGroundStyle];
    return pull;
}

- (id) initWithScrollView:(UIScrollView *)scrollView pullStyle:(HI_PULL_STYLE)pullStyle backGroundStyle:(HI_PULL_BACK_GROUND_STYLE)backGroundStyle
{
    if (self = [super init]) {
        self.scrollView = scrollView;
        [self performSelector:@selector(initSelf:) withObject:[NSNumber numberWithInteger:pullStyle] afterDelay:0];
    }
    
    return self;
}

- (id) initWithWeakScrollView:(UIScrollView *)scrollView pullStyle:(HI_PULL_STYLE)pullStyle backGroundStyle:(HI_PULL_BACK_GROUND_STYLE)backGroundStyle
{
    if (self = [super init]) {
        self.scrollView = scrollView;
        [self performSelector:@selector(initSelf:) withObject:[NSNumber numberWithInteger:pullStyle] afterDelay:0];
    }
        
    return self;
}

-(void) initSelf:(NSNumber *)pullStyle
{
    self.pullStyle = (HI_PULL_STYLE)[pullStyle integerValue];
    
    __weak typeof(self) weakSelf = self;
    switch (self.pullStyle) {
        case HI_PULL_STYLE_HEADER:
        {
            // setup pull-to-refresh
            [self.scrollView addPullToRefreshWithActionHandler:^{
                [weakSelf handRefresh:HI_PULL_DIRETION_TOP];
            }];
        }
            break;
            
        case HI_PULL_STYLE_FOOTER:
        {
            // setup infinite scrolling
            [self.scrollView addInfiniteScrollingWithActionHandler:^{
                [weakSelf handRefresh:HI_PULL_DIRETION_BUTTOM];
            }];
        }
            break;
            
        case HI_PULL_STYLE_HEADER_AND_FOOTER:
        {
            
            // setup pull-to-refresh
            [self.scrollView addPullToRefreshWithActionHandler:^{
                
                [weakSelf handRefresh:HI_PULL_DIRETION_TOP];
            }];
            
            // setup infinite scrolling
            [self.scrollView addInfiniteScrollingWithActionHandler:^{
                [weakSelf handRefresh:HI_PULL_DIRETION_BUTTOM];
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)handRefresh:(HI_PULL_DIRETION)diretion
{
    if (self.beginRefreshBlock) {
        self.beginRefreshBlock(self,diretion);
    }
}

- (void) startRefresh
{
    if (self.scrollView.pullToRefreshView) {
        [self.scrollView triggerPullToRefresh];
    }
}

- (void) endRefresh
{
    [self endRefreshWithAnimated:YES];
}

- (void) endRefreshWithAnimated:(BOOL)animated
{
    if (self.scrollView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
        [self.scrollView.pullToRefreshView stopAnimating];
    }
    
    if (self.scrollView.infiniteScrollingView.state == SVPullToRefreshStateLoading) {
        [self.scrollView.infiniteScrollingView stopAnimating];
    }
    
}

-(void) setCanLoadMore:(BOOL)canLoadMore
{
    _canLoadMore = canLoadMore;
    self.scrollView.infiniteScrollingView.enabled = _canLoadMore;
}


@end
