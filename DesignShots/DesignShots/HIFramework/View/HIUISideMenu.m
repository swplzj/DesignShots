//
//  HIUISideMenu.m
//  HIFramework
//
//  Created by lizhenjie on 4/9/15.
//  Copyright (c) 2015 swplzj. All rights reserved.
//

#import "HIUISideMenu.h"
#import "HIPrecompile.h"

@implementation HIUISideMenuItem

-(void) dealloc
{
    self.action = nil;
}

- (id)initWithTitle:(NSString *)title action:(HIUISideItemActionBlock) action
{
    return [self initWithTitle:title image:nil highlightedImage:nil action:action];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage action:(HIUISideItemActionBlock) action
{
    self = [super init];
    if (!self)
        return nil;
    
    self.title = title;
    self.action = action;
    self.image = image;
    self.highlightedImage = highlightedImage;
    
    return self;
}


@end


#pragma mark -

@interface HIUISideMenu () <UITableViewDataSource,UITableViewDelegate>
{
    float _initialX;
}

@property(nonatomic,strong) UIImageView     *screenshotView;
@property(nonatomic,assign) CGSize          screenshotOriginalSize;

@end


@implementation HIUISideMenu

- (id)initWithItems:(NSArray *)items
{
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWin.frame.size.width;
    CGFloat height = keyWin.frame.size.height;
    
    self = [self initWithFrame:CGRectMake(0, 0, width, height)];
    if (!self)
        return nil;
    
    self.items = items;
    
    self.verticalOffset = 100;
    self.horizontalOffset = 50;
    self.itemHeight = 50;
    self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    self.textColor = [UIColor whiteColor];
    self.highlightedTextColor = [UIColor lightGrayColor];
    
    [self setupUI];
    
    return self;
}


-(void) setupUI
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_background.png"]];
    self.userInteractionEnabled = YES;
    
    _screenshotView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.screenshotView.image = [UIImage screenshotsKeyWindowWithStatusBar:YES];
    self.screenshotView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.screenshotView.userInteractionEnabled = YES;
    
    self.screenshotOriginalSize = self.screenshotView.frame.size;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.horizontalOffset, 0, self.frame.size.width-self.horizontalOffset, self.frame.size.height)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.verticalOffset)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alpha = 0;
    
    [self addSubview:_tableView];
    [self addSubview:_screenshotView];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.screenshotView addGestureRecognizer:tapGestureRecognizer];
    
    // swipe gesture
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureReCognized:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.screenshotView.userInteractionEnabled = YES;
    [self.screenshotView addGestureRecognizer:swipeGestureRecognizer];
    
    // tableHeaderView
    if (self.headerView) {
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)swipeGestureReCognized:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self hide];
    }
}

- (void)show
{
    if (_isShowing)
        return;
    
    _isShowing = YES;
    
    BOOL init = NO;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView * view in keyWindow.subviews) {
        if (view == self) {
            init = YES;
            break;
        }
    }
    
    if (init == NO) {
        [keyWindow addSubview:self];
    }
    
    _screenshotView.userInteractionEnabled = YES;
    self.screenshotView.image = [UIImage screenshotsKeyWindowWithStatusBar:YES];
    
    [self screenshotViewToMinimize];
    
    self.alpha = 1;
}

- (void)hide
{
    if (!_isShowing)
        return;
    
    _isShowing = NO;
    
    _screenshotView.userInteractionEnabled = NO;
    
    [self screenshotViewRestore];
}

- (void)setRootViewController:(UIViewController *)viewController
{
    ;
}

- (void) screenshotViewToMinimize
{
    [UIView animateWithDuration:0.35 animations:^{
        self.screenshotView.transform = CGAffineTransformScale(self.screenshotView.transform, 0.8, 0.8);
        CGFloat orginX = [[UIScreen mainScreen] bounds].size.width;
        self.screenshotView.center = CGPointMake(orginX, self.center.y);
        self.screenshotView.alpha = 1;
    }];
    
    if (_tableView.alpha == 0) {
        
        self.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.9, 0.9);
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.transform = CGAffineTransformIdentity;
        }];
        
        [UIView animateWithDuration:0.6 animations:^{
            self.tableView.alpha = 1;
        }];
    }
}

-(void) screenshotViewRestore
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.alpha = 0;
        self.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.7, 0.7);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.screenshotView.transform = CGAffineTransformScale(self.screenshotView.transform, 1.25, 1.25);
        self.screenshotView.center = self.center;
    } completion:^(BOOL finished) {
        self.alpha = 0;
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = self.font;
        cell.textLabel.textColor = self.textColor;
        cell.textLabel.highlightedTextColor = self.highlightedTextColor;
        cell.selectedBackgroundView = [UIView new];
    }
        
    HIUISideMenuItem * item = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.imageView.image = item.image;
    cell.imageView.highlightedImage = item.highlightedImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HIUISideMenuItem * item = [_items objectAtIndex:indexPath.row];
    item.action(self,item);
}


- (void)tapGestureRecognized:(UITapGestureRecognizer *)sender
{
    [self hide];
}

@end
