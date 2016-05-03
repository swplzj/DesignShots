//
//  API.h
//  DesignShots
//
//  Created by lizhenjie on 4/29/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#ifndef API_h
#define API_h

// Block definitions

@class DRApiResponse, NXOAuth2Account;

typedef void(^DRHandler)(void);
typedef void(^DRResponseHandler)(DRApiResponse *response);
typedef void(^DROAuthHandler)(NXOAuth2Account *account, NSError *error);
typedef void(^DRErrorHandler)(NSError *error);
typedef void(^DRDownloadProgressHandler)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

// Dribbble API OAuth Key

static NSString * const kOAuth2ClientId = @"22586d7758eaea9f6e1868603e8ddbb2b26f542988fec3dde2213925ad6cf157";
static NSString * const kOAuth2ClientSecret = @"2ce31f001902c2cafc9a1b79f1aeb089e79631f2ccf43b202640cd715b1fa9ef";
static NSString * const kOAuth2ClientAccessToken = @"99251ab9a1d07a23fd1eeee51c33b7a0a118c4c19b2844b786eb6ced8a02c9b3";

static NSString * const kOAuth2RedirectURL = @"http://swplzj.github.io";
static NSString * const kOAuth2AuthorizationURL = @"https://dribbble.com/oauth/authorize";
static NSString * const kOAuth2TokenURL = @"https://dribbble.com/oauth/token";

static NSString * const kBaseApiUrl = @"https://api.dribbble.com/v1/";



// Dribbble API methods

//static NSString * const kApiMethodUser = @"user";
//static NSString * const kApiMethodUserInfo = @"users/%@";
//static NSString * const kApiMethodUserLikes = @"users/%@/likes";
//static NSString * const kApiMethodMyLikes = @"user/likes";
//static NSString * const kApiMethodUserProjects = @"users/%@/projects";
//static NSString * const kDRApiMethodOwnUserProjects = @"user/projects";
//static NSString * const kDRApiMethodUserTeams = @"users/%@/teams";
//static NSString * const kDRApiMethodMyTeams = @"user/teams";
//static NSString * const kDRApiMethodUserShots = @"users/%@/shots";
//static NSString * const kDRApiMethodOwnUserShots = @"user/shots";
//static NSString * const kDRApiMethodShotProjects = @"shots/%@/projects";
//static NSString * const kDRApiMethodProject = @"projects/%@";
//static NSString * const kDRApiMethodProjectShots = @"projects/%@/shots";
//static NSString * const kDRApiMethodShotAttachments = @"shots/%@/attachments";
//static NSString * const kDRApiMethodAttachment = @"shots/%@/attachments/%@";
//static NSString * const kDRApiMethodEditComment = @"shots/%@/comments/%@";
//static NSString * const kDRApiMethodShotComments = @"shots/%@/comments";
//static NSString * const kDRApiMethodComment = @"shots/%@/comments/%@";
//static NSString * const kDRApiMethodCommentLikes = @"shots/%@/comments/%@/likes";
//static NSString * const kDRApiMethodCheckLikeComment = @"shots/%@/comments/%@/like";
//static NSString * const kDRApiMethodShots = @"shots";
//static NSString * const kDRApiMethodShot = @"shots/%@";
//static NSString * const kDRApiMethodLikeShot = @"shots/%@/like";
//static NSString * const kDRApiMethodShotLikes = @"shots/%@/likes";
//static NSString * const kDRApiMethodShotRebounds = @"shots/%@/rebounds";
//static NSString * const kDRApiMethodFollowUser = @"users/%@/follow";
//static NSString * const kDRApiMethodCheckShotWasLiked = @"shots/%@/like";
//static NSString * const kDRApiMethodGetFollowers = @"users/%@/followers";
//static NSString * const kDRApiMethodGetMyFollowers = @"user/followers";
//static NSString * const kDRApiMethodCheckIfUserFollowing = @"user/following/%@";
//static NSString * const kDRApiMethodCheckIfOneUserFollowingAnother = @"users/%@/following/%@";
//static NSString * const kDRApiMethodGetFollowees = @"users/%@/following";
//static NSString * const kDRApiMethodGetMyFollowees = @"user/following";
//static NSString * const kDRApiMethodGetFolloweesShot = @"user/following/shots";
//static NSString * const kDRApiMethodGetLikes = @"users/%@/likes";
//static NSString * const kDRApiMethodTeamMembers = @"teams/%@/members";
//static NSString * const kDRApiMethodTeamShots = @"teams/%@/shots";
//static NSString * const kDRApiMethodMyBuckets = @"user/buckets";
//static NSString * const kDRApiMethodUserBuckets = @"users/%@/buckets";
//static NSString * const kDRApiMethodBucketsForShot = @"shots/%@/buckets";
//static NSString * const kDRApiMethodLoadBucket = @"buckets/%@";
//static NSString * const kDRApiMethodLoadBucketShots = @"buckets/%@/shots";
//static NSString * const kDRApiMethodAddBucket = @"buckets";
//
//// Dribbble API params keys
//
//static NSString * const kDRParamPage = @"page";
//static NSString * const kDRParamPerPage = @"per_page";
//static NSString * const kDRParamList = @"list";
//static NSString * const kDRParamTimeFrame = @"timeframe";
//static NSString * const kDRParamDate = @"date";
//static NSString * const kDRParamSort = @"sort";
//
//// Dribbble API param keys
//
//static NSString * const kDRParamTitle = @"title";
//static NSString * const kDRParamImage = @"image";
//static NSString * const kDRParamDescription = @"description";
//static NSString * const kDRParamTags = @"tags";
//static NSString * const kDRParamTeamId = @"team_id";
//static NSString * const kDRParamReboundSourceId = @"rebound_source_id";
//static NSString * const kDRParamBody = @"body";
//static NSString * const kDRParamFile = @"file";
//
//// Dribbble API permission keys
//
//static NSString * const kDRPublicScope = @"public";
//static NSString * const kDRWriteScope = @"write";
//static NSString * const kDRCommentScope = @"comment";
//static NSString * const kDRUploadScope = @"upload";
//
//// Http errors
//
//static NSInteger const kHttpAuthErrorCode = 401;
//static NSInteger const kHttpNotFoundErrorCode = 404;
//static NSInteger const kHttpRequestFailedErrorCode = 403;
//static NSInteger const kHttpRateLimitErrorCode = 429;
//static NSInteger const kHttpInternalServerErrorCode = 500;
//static NSInteger const kHttpContentNotModifiedCode = 304;
//
//static NSString * const kDROAuthErrorDomain = @"DROAuthErrorDomain";
//static NSString * const kDROAuthErrorFailureKey = @"DRAuthErrorFailureKey";
//static NSString * const kDRUploadErrorFailureKey = @"DRUploadErrorFailureKey";
//
//static NSInteger kDROAuthErrorCodeUnacceptableRedirectUrl = 10001;
//static NSString * const kDROAuthErrorUnacceptableRedirectUrlDescription = @"Authentification failed, please try again";
//
//// Keychain
//
//static NSString * const kIDMOAccountType = @"DribbleAuth";
//
//// Misc
//
//static NSString * const kUnacceptableWebViewUrl = @"session/new";

#endif /* API_h */
