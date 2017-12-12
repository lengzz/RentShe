//
//  OrderListM.h
//  RentShe
//
//  Created by Lengzz on 2017/9/3.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListM : NSObject
@property(nonatomic, copy) NSString *order_id;
@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, copy) NSString *rent_skill_name;
@property(nonatomic, copy) NSString *rent_price;
@property(nonatomic, copy) NSString *rent_hours;
@property(nonatomic, copy) NSString *meeting_time;
@property(nonatomic, copy) NSString *addr_lat;
@property(nonatomic, copy) NSString *addr_lng;
@property(nonatomic, copy) NSString *addr_name;
@property(nonatomic, copy) NSString *order_state_index;
@property(nonatomic, copy) NSString *order_state;
@property(nonatomic, copy) NSString *order_state_name;
@property(nonatomic, copy) NSString *explain;


//@property(nonatomic, copy) NSString *his_info;": {           //他人信息
@property(nonatomic, copy) NSString *his_user_id;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *certified;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *gender;

@end
