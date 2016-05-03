//
//  ImageModel.h
//  DesignShots
//
//  Created by lizhenjie on 5/3/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "JSONModel.h"

@interface ImageModel : JSONModel

@property (copy, nonatomic) NSString <Optional>*hidpi;
@property (copy, nonatomic) NSString <Optional>*normal;
@property (copy, nonatomic) NSString <Optional>*teaser;

@end
