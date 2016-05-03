//
//  ShotCell.m
//  DesignShots
//
//  Created by lizhenjie on 4/28/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "ShotCell.h"

@interface ShotCell ()

@property(assign, nonatomic) BOOL didSetupConstraints;

@end

@implementation ShotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.shotImageView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - AutoLayout Methods

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [self.shotImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.shotImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.shotImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.shotImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - Getter And Setter

- (UIImageView *)shotImageView
{
    if (!_shotImageView) {
        _shotImageView = [UIImageView newAutoLayoutView];
        _shotImageView.contentMode = UIViewContentModeScaleAspectFit;
        _shotImageView.backgroundColor = [UIColor whiteColor];
    }
    return _shotImageView;
}

@end
