//
//  LinkModel.h
//  DesignShots
//
//  Created by lizhenjie on 5/3/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "JSONModel.h"

@interface LinkModel : JSONModel

@property (copy, nonatomic) NSString <Optional>*web;
@property (copy, nonatomic) NSString <Optional>*twitter;

@end
