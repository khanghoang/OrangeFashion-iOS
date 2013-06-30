//
//  OFSetting.h
//  OrangeFashion
//
//  Created by Khang on 30/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "BaseModel.h"

@interface OFSetting : BaseModel

@property (nonatomic, copy) NSNumber * ID;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, strong) id value;

@end
