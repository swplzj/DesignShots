//
//  ShotModel.m
//  DesignShots
//
//  Created by lizhenjie on 5/3/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "ShotModel.h"
#import "ImageModel.h"
#import "UserModel.h"
#import "TeamModel.h"

static NSString *const kFileExtensionGif = @"gif";

@implementation ShotModel

//TODO:key mapper

//+ (JSONKeyMapper *)keyMapper {
//    return [];
//}

- (NSString<Ignore> *)defaultUrl {
    return self.imageModel.hidpi ? self.imageModel.hidpi : self.imageModel.normal;
}

- (NSString<Ignore> *)fileType {
    return [[self.defaultUrl pathExtension] lowercaseString];
}

- (NSNumber<Ignore> *)authorityId {
    return self.userModel ? self.userModel.userId : self.teamModel.teamId;
}

- (BOOL)isAnimation {
    return [self.fileType isEqualToString:kFileExtensionGif];
}

- (BOOL)isEqual:(id)object {
    ShotModel *shot = (ShotModel *)object;
    return [shot.shotId isEqualToNumber:self.shotId];
}

- (NSUInteger)hash {
    return [[self.shotId stringValue] hash];
}

@end
