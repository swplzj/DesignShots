//
//  ShotModel.h
//  DesignShots
//
//  Created by lizhenjie on 5/3/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "ArtWorkModel.h"

@class ImageModel;

@interface ShotModel : ArtWorkModel

@property (strong, nonatomic) NSNumber *shotId;
@property (strong, nonatomic) NSNumber *width;
@property (strong, nonatomic) NSNumber *height;
@property (strong, nonatomic) NSNumber *viewsCount;
@property (strong, nonatomic) NSNumber *likesCount;
@property (strong, nonatomic) NSNumber *commentsCount;
@property (strong, nonatomic) NSNumber *attachmentsCount;
@property (strong, nonatomic) NSNumber *reboundsCount;
@property (strong, nonatomic) NSNumber *bucketsCount;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *shotDescription;
@property (copy, nonatomic) NSString <Optional>*reboundSourceUrl;
@property (copy, nonatomic) NSString <Optional>*htmlUrl;
@property (copy, nonatomic) NSString <Optional>*attachmentsUrl;
@property (copy, nonatomic) NSString <Optional>*bucketsUrl;
@property (copy, nonatomic) NSString <Optional>*commentsUrl;
@property (copy, nonatomic) NSString <Optional>*likesUrl;
@property (copy, nonatomic) NSString <Optional>*projectsUrl;
@property (copy, nonatomic) NSString <Optional>*reboundsUrl;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) ImageModel *imageModel;

@property (nonatomic, readonly) NSString <Ignore>*defaultUrl;
@property (nonatomic, copy) NSString <Ignore>*fileType;
@property (nonatomic, readonly) NSNumber <Ignore>*authorityId;

- (BOOL)isAnimation;

@end
