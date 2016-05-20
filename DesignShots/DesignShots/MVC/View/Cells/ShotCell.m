//
//  ShotCell.m
//  DesignShots
//
//  Created by lizhenjie on 4/28/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "ShotCell.h"
#import "ShotModel.h"
#import "ImageModel.h"

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

//- (UIImageView *)shotImageView
//{
//    if (!_shotImageView) {
//        _shotImageView = [UIImageView newAutoLayoutView];
//        _shotImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _shotImageView.backgroundColor = [UIColor whiteColor];
//    }
//    return _shotImageView;
//}


- (FLAnimatedImageView *)shotImageView
{
    if (!_shotImageView) {
        _shotImageView = [FLAnimatedImageView newAutoLayoutView];
//        _shotImageView.contentMode = UIViewContentModeScaleAspectFit;
        _shotImageView.backgroundColor = [UIColor whiteColor];
        _shotImageView.contentMode = UIViewContentModeScaleAspectFill;
        _shotImageView.clipsToBounds = YES;
    }
    return _shotImageView;
}

- (void)setShotModel:(ShotModel *)shotModel
{
    if (shotModel == _shotModel) {
        return;
    }
    _shotModel = shotModel;
    HI_WEAK_SELF;
    
    NSURL *imageUrl = [NSURL URLWithString:shotModel.defaultUrl];

    if (shotModel.isAnimation) {

//        FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfURL:imageUrl]];
//        [self.shotImageView setAnimatedImage:animatedImage];
        weakSelf.shotImageView.image = nil;

        [self loadAnimatedImageWithURL:imageUrl completion:^(FLAnimatedImage *animatedImage) {
            weakSelf.shotImageView.animatedImage = animatedImage;
        }];
    } else {
        self.shotImageView.animatedImage = nil;

        [self.shotImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"mainicon0"]];
    }
}

- (void)loadAnimatedImageWithURL:(NSURL *const)url completion:(void (^)(FLAnimatedImage *animatedImage))completion
{
    NSString *const filename = url.lastPathComponent;
    NSString *const diskPath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:diskPath];
    FLAnimatedImage * __block animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
    
    if (animatedImage) {
        if (completion) {
            completion(animatedImage);
        }
    } else {
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            animatedImageData = data;
            animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
            if (animatedImage) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(animatedImage);
                    });
                }
                [data writeToFile:diskPath atomically:YES];
            }
        }] resume];
    }
}

@end
