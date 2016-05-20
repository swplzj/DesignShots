//
//  ShotApi.m
//  DesignShots
//
//  Created by lizhenjie on 4/29/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "ShotApi.h"
#import "ShotModel.h"
#import "ImageModel.h"
#import "UserModel.h"
#import "TeamModel.h"
#import "LinkModel.h"

@implementation ShotApi

- (NSString *)requestURL {
    return @"/shots";
}

- (HIRequestMethod)requestMethod {
    return HIRequestMethodGet;
}

- (id)requestParameter {
    return @{
             };
}

- (NSArray *)responseShotList {
//    return (NSArray *)[self mappedDataWithModelClass:[ShotModel class]];
    NSMutableArray *shotList = [[NSMutableArray alloc] init];
    id responseObject = self.responseObject;
    if ([responseObject isKindOfClass:[NSArray class]]) {
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ShotModel *shot = [[ShotModel alloc] init];

            shot.shotId         = obj[@"id"];
            shot.width          = obj[@"width"];
            shot.height         = obj[@"height"];
            shot.viewsCount     = obj[@"views_count"];
            shot.likesCount     = obj[@"likes_count"];
            shot.commentsCount  = obj[@"comments_count"];
            shot.attachmentsCount = obj[@"attachments_count"];
            shot.reboundsCount  = obj[@"rebounds_count"];
            shot.bucketsCount   = obj[@"buckets_count"];
            shot.title          = obj[@"title"];
            shot.shotDescription= obj[@"description"];
            shot.reboundSourceUrl = obj[@"rebound_source_url"];
            shot.htmlUrl        = obj[@"html_url"];
            shot.attachmentsUrl = obj[@"attachments_url"];
            shot.bucketsUrl     = obj[@"buckets_url"];
            shot.commentsUrl    = obj[@"comments_url"];
            shot.likesUrl       = obj[@"likes_url"];
            shot.projectsUrl    = obj[@"projects_url"];
            shot.reboundsUrl    = obj[@"rebounds_url"];
            shot.tags           = obj[@"tags"];
            
            /** image model*/
            NSDictionary *imageDic = obj[@"images"];
            ImageModel *image   = [[ImageModel alloc] init];
            image.hidpi         = imageDic[@"hidpi"];
            image.normal        = imageDic[@"normal"];
            image.teaser        = imageDic[@"teaser"];
            shot.imageModel = image;
            
            shot.createdAt      = obj[@"created_at"];
            shot.updatedAt      = obj[@"updated_at"];
            
            /** user model */
            NSDictionary *userDic = obj[@"user"];
            UserModel *user = [[UserModel alloc] init];
            user.userId     = userDic[@"id"];
            user.teamsUrl   = userDic[@"teams_url"];
            user.teamsCount = userDic[@"teams_count"];
            user.name       = userDic[@"name"];
            user.username   = userDic[@"username"];
            user.avatarUrl  = userDic[@"avatar_url"];
            user.htmlUrl    = userDic[@"html_url"];
            user.location   = userDic[@"location"];
            user.bio        = userDic[@"bio"];
            user.followersUrl   = userDic[@"followers_url"];
            user.shotsUrl       = userDic[@"shots_url"];
            user.projectsCount  = userDic[@"projects_count"];
            user.projectsUrl    = userDic[@"projects_url"];
            user.bucketsUrl     = userDic[@"buckets_url"];
            user.followingUrl   = userDic[@"following_url"];
            user.likesUrl       = userDic[@"likes_url"];
            user.followersCount = userDic[@"followers_count"];
            user.followingsCount= userDic[@"followings_count"];
            user.likesCount     = userDic[@"likes_count"];
            user.bucketsCount   = userDic[@"buckets_count"];
            user.commentsReceivedCount  = userDic[@"comments_received_count"];
            user.likesReceivedCount     = userDic[@"likes_received_count"];
            user.reboundsReceivedCount  = userDic[@"rebounds_received_count"];
            user.shotsCount             = userDic[@"shots_count"];
            user.type                   = userDic[@"type"];
            user.createdAt              = userDic[@"created_at"];
            user.updatedAt              = userDic[@"updated_at"];
            user.canUploadShot          = userDic[@"can_upload_shot"];
            user.pro                    = userDic[@"pro"];
            
            LinkModel *link             = [[LinkModel alloc] init];
            link.twitter                = userDic[@"links"][@"twitter"];
            link.web                    = userDic[@"links"][@"web"];
            user.linkModel = link;
            shot.userModel = user;
            
            NSDictionary *teamDic = obj[@"team"];
            TeamModel *team = [[TeamModel alloc] init];
            if ([teamDic isKindOfClass:[NSDictionary class]]) {
                team.teamId = teamDic[@""];
            }
            shot.teamModel = team;
            
//            user.membersCount = userDic[@""];
            
//            user.teamShotsUrl   = userDic[@""];
//            user.membersUrl     = userDic[@""];
   
            [shotList addObject:shot];
        }];
    }
    return shotList;
}

@end
