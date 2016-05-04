//
//  HomeViewController.m
//  DesignShots
//
//  Created by lizhenjie on 4/25/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "HomeViewController.h"

/** Controller */


/** View */
#import "ShotCell.h"

/** Model */
#import "ShotModel.h"

/** API */
#import "ShotApi.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *shotTableView;
@property (nonatomic, strong) NSMutableArray *shotDataSource;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Design Shots";
    self.view.backgroundColor = [UIColor whiteColor];
    self.shotDataSource = [[NSMutableArray alloc] init];
//    [self showBarButton:NavigationBarButtonTypeLeft
//                  title:@""
//                  image:[UIImage imageNamed:@"nav_back_icon"]
//            selectImage:nil];
    HI_WEAK_SELF;
    [self.shotTableView addPullToRefreshWithActionHandler:^{
        // request shots data
//        DRApiClient
//        HI_WEAK_SELF
        [weakSelf requstShotsData];
    }];
    self.shotTableView.pullToRefreshView.arrowColor = APP_COLOR_BLUE;
    self.shotTableView.pullToRefreshView.textColor = APP_COLOR_BLUE;
    
}

#pragma mark - Private Methods

- (void)requstShotsData
{
    /*
     animated
     attachments
     debuts
     playoffs
     rebounds
     teams
     
     week
     month
     year
     ever
      
     YYYY-MM-DD
     
     comments
     recent
     views
     */
    NSDictionary *dic = @{
                          @"list": @"animated",
                          @"timeframe": @"week",
                          @"date": @"",
                          @"sort": @""
                          };
    HI_WEAK_SELF;
    ShotApi *api = [[ShotApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(HIBaseRequest *request) {
        [weakSelf.shotTableView.pullToRefreshView stopAnimating];
        ShotApi *shotApi = (ShotApi *)request;
        if (shotApi.responseObject) {
            weakSelf.shotDataSource = [NSMutableArray arrayWithArray:[shotApi responseShotList]];
        }
        [weakSelf.shotTableView reloadData];
    } failure:^(HIBaseRequest *request) {
        [weakSelf.shotTableView.pullToRefreshView stopAnimating];        
    }];
}

#pragma mark - AutoLayout Methods

- (void)loadView
{
    self.view = [UIView new];
    
    [self.view addSubview:self.shotTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.shotTableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.shotTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.shotTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.shotTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
    }
    self.didSetupConstraints = YES;
    
    [super updateViewConstraints];
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shotDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShotCell";
    ShotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ShotCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//    cell.textLabel.text = @"Dribble";
    cell.shotImageView.image = [UIImage imageNamed:@"mainicon0"];
//    [cell.shotImageView setImageWithURL:[] placeholderImage:<#(nullable UIImage *)#>];
    cell.shotModel = self.shotDataSource[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SHOT_IMAGE_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Getter And Setter

- (UITableView *)shotTableView
{
    if (!_shotTableView) {
        _shotTableView = [UITableView newAutoLayoutView];
        _shotTableView.delegate = self;
        _shotTableView.dataSource = self;
    }
    return _shotTableView;
}

@end
