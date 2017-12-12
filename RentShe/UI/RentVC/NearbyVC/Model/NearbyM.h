//
//  NearbyM.h
//  RentShe
//
//  Created by Lengzz on 17/6/18.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RentInfoM,RentSkillM,UserInfoM;

@interface NearbyM : NSObject

@property (nonatomic, strong) NSArray <RentSkillM*> *rent_skill;
@property (nonatomic, strong) RentInfoM *rent_info;
@property (nonatomic, strong) UserInfoM *user_info;

@end
