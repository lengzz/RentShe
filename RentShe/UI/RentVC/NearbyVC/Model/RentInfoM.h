//
//  RentInfoM.h
//  RentShe
//
//  Created by Lengzz on 2017/7/3.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentInfoM : NSObject

@property (nonatomic, copy) NSString *rent_id;//"13",
@property (nonatomic, copy) NSString *user_id;//"192",
@property (nonatomic, copy) NSString *city_code;//"440",
@property (nonatomic, assign) NSInteger display;//"3",
@property (nonatomic, copy) NSString *lng;//"100.10000000",
@property (nonatomic, copy) NSString *lat;//"80.00000000",
@property (nonatomic, assign) CGFloat distance;//"0.0001"      //两人的距离
@property (nonatomic, copy) NSString *rental_start_time;//"17",
@property (nonatomic, copy) NSString *rental_end_time;//"20",
@property (nonatomic, copy) NSString *sun;//"0",
@property (nonatomic, copy) NSString *mon;//"1",
@property (nonatomic, copy) NSString *tue;//"0",
@property (nonatomic, copy) NSString *wed;//"1",
@property (nonatomic, copy) NSString *thu;//"0",
@property (nonatomic, copy) NSString *fri;//"1",
@property (nonatomic, copy) NSString *sat;//"1"
@property (nonatomic, assign) NSInteger comment_num;

@end
