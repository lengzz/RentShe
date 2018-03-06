//
//  CommonConfig.h
//  RentShe
//
//  Created by Lengzz on 2017/9/2.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCommonConfig [CommonConfig shareInstance]

@interface CommonConfig : NSObject
@property (nonatomic, strong, readonly) NSString *apiHostUrl;//服务器地址
@property (nonatomic, strong, readonly) NSString *rongCAppKey;//融云
@property (nonatomic, strong, readonly) NSString *jPushAppKey;//极光
@property (nonatomic, assign, readonly) BOOL isProduction;

/**
 *  APP缓存数据 -> 避免重复请求
 */
@property (nonatomic, strong) NSArray *hotCityArr;//热门城市
@property (nonatomic, strong) NSMutableDictionary *userInfo;//融云缓存用户基础信息

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, strong, readonly) NSDateFormatter *week_DateFormatter;

+ (instancetype)shareInstance;
@end
