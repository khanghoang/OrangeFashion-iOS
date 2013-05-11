//
//  MVBadge.h
//  MyVillage
//
//  Created by Xu Xiaojiang on 9/11/12.
//  Copyright (c) 2012 2359media. All rights reserved.
//

#import "MVModel.h"

#define BADGE_APPLICATION   @"Application Usage"
#define BADGE_VISIT_COUNT   @"visit_count"
#define BADGE_SPENT_TIME    @"spend_time"
#define BADGE_SPENT_AMOUNT  @"spend_amount"

@interface MVBadge : MVModel

@property (nonatomic, copy) NSNumber *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *badge_type;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSNumber *reward_penny;
@property (nonatomic, copy) NSNumber *spending_time_from_hour;
@property (nonatomic, copy) NSNumber *spending_time_from_min;
@property (nonatomic, copy) NSNumber *spending_time_to_hour;
@property (nonatomic, copy) NSNumber *spending_time_to_min;
@property (nonatomic, copy) NSDate *updated_at;
//
@property (nonatomic, copy) NSNumber *number_of_occurrence;
@property (nonatomic, copy) NSNumber *tenant_group_id;
@property (nonatomic, copy) NSNumber *spend_amount;

@end