//
//  UserDefaultsManager.h
//  RentShe
//
//  Created by Lengzz on 17/5/22.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+ (void) logOut;
+ (void) login:(id)obj;

+ (void) updateUserInfo;

#pragma mark -
#pragma mark - auditStatus
+ (BOOL) getAuditStatus;
+ (void) setAuditStatus:(BOOL)isAudit;

#pragma mark -
#pragma mark - token
+ (NSString *) getToken;
+ (void) setToken:(NSString *) token;
#pragma mark -
#pragma mark - city
+ (NSString *) getCity;
+ (void) setCity:(NSString *) city;
#pragma mark -
#pragma mark - cityCode -> 帅选城市
+ (NSString *) getCityCode;
+ (void) setCityCode:(NSString *)cityCode;

#pragma mark -
#pragma mark - curCityCode -> 发布信息城市编码
+ (NSString *) getCurCityCode;
+ (void) setCurCityCode:(NSString *)cityCode;

#pragma mark -
#pragma mark - userid
+ (NSString *) getUserId;
+ (void) setUserId:(NSString *)userId;

#pragma mark -
#pragma mark - certified
+ (BOOL) getCertified;
+ (void) setCertified:(BOOL)certified;

#pragma mark -
#pragma mark - nickname
+ (NSString *) getNickName;
+ (void) setNickName:(NSString *)nickName;

#pragma mark -
#pragma mark - describe 个性签名
+ (NSString *) getDescribe;
+ (void) setDescribe:(NSString *)describe;

#pragma mark -
#pragma mark - avatar  头像
+ (NSString *) getAvatar;
+ (void) setAvatar:(NSString *)avatar;

#pragma mark -
#pragma mark - mobile
+ (NSString *) getMobile;
+ (void) setMobile:(NSString *)mobile;

#pragma mark -
#pragma mark - gender
+ (NSInteger) getGender;
+ (void) setGender:(NSInteger)gender;

#pragma mark -
#pragma mark - birthday
+ (NSString *) getBirthday;
+ (void) setBirthday:(NSString *)birthday;

#pragma mark -
#pragma mark - money
+ (NSString *) getMoney;
+ (void) setMoney:(NSString *)money;

#pragma mark -
#pragma mark - visitornum  人气
+ (NSString *) getVisitorNum;
+ (void) setVisitorNum:(NSString *)visitorNum;

#pragma mark -
#pragma mark - status 是否被冻结
+ (IdStatus) getIdStatus;
+ (void) setIdStatus:(IdStatus)status;

#pragma mark -
#pragma mark - rongyun_token
+ (NSString *) getRYToken;
+ (void) setRYToken:(NSString *)token;

#pragma mark -
#pragma mark - flag 私信开关
+ (NSInteger) getMsgFlag;
+ (void) setMsgFlag:(NSInteger)flag;

#pragma mark -
#pragma mark - lng 经度
+ (NSNumber *) getUserLng;
+ (void) setUserLng:(CLLocationDegrees)lng;

#pragma mark -
#pragma mark - lat 纬度
+ (NSNumber *) getUserLat;
+ (void) setUserLat:(CLLocationDegrees)lat;

#pragma mark -
#pragma mark - filter
+ (NSDictionary *) getFilterInfo;
+ (void) setFilterInfo:(NSDictionary *)info;
@end

