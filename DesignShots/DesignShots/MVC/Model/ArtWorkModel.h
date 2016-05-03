//
//  ArtWorkModel.h
//  DesignShots
//
//  Created by lizhenjie on 5/3/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "JSONModel.h"

/**
 *  art work model
 */

@class UserModel, TeamModel;

@interface ArtWorkModel : JSONModel

@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *updatedAt;
@property (strong, nonatomic) UserModel <Optional>*userModel;
@property (strong, nonatomic) TeamModel <Optional>*teamModel;

@end
