//
//  AuthorityBaseModel.h
//  DesignShots
//
//  Created by lizhenjie on 5/3/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "JSONModel.h"

/**
 *  authority base model
 */

@class LinkModel;

@interface AuthorityBaseModel : JSONModel

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *avatarUrl;
@property (copy, nonatomic) NSString *htmlUrl;
@property (copy, nonatomic) NSString <Optional>*bio;
@property (copy, nonatomic) NSString <Optional>*location;
@property (strong, nonatomic) LinkModel *linkModel;
@property (strong, nonatomic) NSNumber *bucketsCount;
@property (strong, nonatomic) NSNumber *commentReceivedCount;
@property (strong, nonatomic) NSNumber *followersCount;
@property (strong, nonatomic) NSNumber *followingCount;
@property (strong, nonatomic) NSNumber *likesCount;
@property (strong, nonatomic) NSNumber *likesReceivedCount;
@property (strong, nonatomic) NSNumber <Optional>*membersCount;
@property (strong, nonatomic) NSNumber *projectsCount;
@property (strong, nonatomic) NSNumber *reboundsReceivedCount;
@property (strong, nonatomic) NSNumber *shotsCount;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString <Optional>*bucketsUrl;
@property (copy, nonatomic) NSString <Optional>*followersUrl;
@property (copy, nonatomic) NSString <Optional>*followingUrl;
@property (copy, nonatomic) NSString <Optional>*likesUrl;
@property (copy, nonatomic) NSString <Optional>*membersUrl;
@property (copy, nonatomic) NSString <Optional>*shotsUrl;
@property (copy, nonatomic) NSString <Optional>*teamShotsUrl;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *updatedAt;
@property (assign, nonatomic) BOOL canUploadShot;
@property (assign, nonatomic) BOOL pro;

@end
