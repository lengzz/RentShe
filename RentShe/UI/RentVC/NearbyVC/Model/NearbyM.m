//
//  NearbyM.m
//  RentShe
//
//  Created by Lengzz on 17/6/18.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "NearbyM.h"
#import "RentInfoM.h"
#import "RentSkillM.h"
#import "UserInfoM.h"

@implementation NearbyM

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"user_info"])
    {
        self.user_info = [UserInfoM new];
        [self.user_info setValuesForKeysWithDictionary:value];
    }
    else if ([key isEqualToString:@"rent_info"])
    {
        self.rent_info = [RentInfoM new];
        [self.rent_info setValuesForKeysWithDictionary:value];
    }
    else if ([key isEqualToString:@"rent_skill"])
    {
        id arr = value;
        if ([arr isKindOfClass:[NSArray class]])
        {
            NSMutableArray *skills = [NSMutableArray array];
            for (id obj in arr) {
                RentSkillM *model = [RentSkillM new];
                [model setValuesForKeysWithDictionary:obj];
                [skills addObject:model];
            }
            self.rent_skill = [skills copy];
        }
    }
    else
    {
        [super setValue:value forKey:key];

    }
}


@end
