//
//  ShotCell.h
//  DesignShots
//
//  Created by lizhenjie on 4/28/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Dribbble Shot List Cell */

@class ShotModel;

@interface ShotCell : UITableViewCell

@property (strong, nonatomic) UIImageView *shotImageView;
@property (strong, nonatomic) ShotModel *shotModel;

@end
