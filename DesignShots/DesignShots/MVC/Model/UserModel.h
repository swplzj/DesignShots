//
//  UserModel.h
//  DesignShots
//
//  Created by lizhenjie on 5/3/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "AuthorityBaseModel.h"

@interface UserModel : AuthorityBaseModel

@property (strong, nonatomic) NSNumber *userId;
@property (copy, nonatomic)   NSString <Optional>*teamsUrl;
@property (strong, nonatomic) NSNumber <Optional>*teamsCount;

@end
