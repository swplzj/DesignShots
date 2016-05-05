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
    ShotModel *shot = [[ShotModel alloc] init];
    NSMutableArray *shotList = [NSMutableArray new];
    id responseObject = self.responseObject;
    if ([responseObject isKindOfClass:[NSArray class]]) {
        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
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
            
            NSDictionary *imageDic = obj[@"images"];
            
            ImageModel *image   = [[ImageModel alloc] init];
            image.hidpi         = imageDic[@"hidpi"];
            image.normal        = imageDic[@"normal"];
            image.teaser        = imageDic[@"teaser"];
            
            shot.createdAt      = obj[@"created_at"];
            shot.updatedAt      = obj[@"updated_at"];
            
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
            user.followersUrl = userDic[@"followers_url"];
            user.shotsUrl       = userDic[@"shots_url"];
            user.projectsCount  = userDic[@"projects_count"];
            user.projectsUrl    = userDic[@"projects_url"];
            user.bucketsUrl     = userDic[@"buckets_url"];
            user.followingUrl   = userDic[@"following_url"];
            user.likesUrl       = userDic[@"likes_url"];

//            user.membersCount = userDic[@""];
            
//            user.teamShotsUrl   = userDic[@""];
//            user.membersUrl     = userDic[@""];
            
            @property (strong, nonatomic) DRLink *links;
            
            
        
            @property (strong, nonatomic) NSNumber *followersCount;
            @property (strong, nonatomic) NSNumber *followingsCount;
            @property (strong, nonatomic) NSNumber *likesCount;
            @property (strong, nonatomic) NSNumber *projectsCount;
            @property (strong, nonatomic) NSNumber *bucketsCount;
            @property (strong, nonatomic) NSNumber *commentsReceivedCount;
            @property (strong, nonatomic) NSNumber *likesReceivedCount;
            @property (strong, nonatomic) NSNumber *reboundsReceivedCount;
            @property (strong, nonatomic) NSNumber *shotsCount;
            @property (strong, nonatomic) NSString *type;
            @property (strong, nonatomic) NSString *createdAt;
            @property (strong, nonatomic) NSString *updatedAt;
            @property (assign, nonatomic) BOOL canUploadShot;
            @property (assign, nonatomic) BOOL pro;
            
            
                "buckets_count" = 0;
                "can_upload_shot" = 1;
                "comments_received_count" = 97;
                "created_at" = "2016-01-18T08:40:28Z";
                "followers_count" = 213;
                "followings_count" = 82;
                "likes_count" = 49;
                "likes_received_count" = 3189;
            
                links =             {
                    twitter = "https://twitter.com/reggidlol";
                };
                pro = 0;
                "projects_url" = "https://api.dribbble.com/v1/users/1056629/projects";
                "rebounds_received_count" = 1;
                "shots_count" = 16;
                
                type = Player;
                "updated_at" = "2016-05-04T07:13:50Z";
            };

            
            [shotList addObject:obj];
        }];
    }
}

@end
