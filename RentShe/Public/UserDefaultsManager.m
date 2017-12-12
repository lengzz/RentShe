//
//  UserDefaultsManager.m
//  RentShe
//
//  Created by Lengzz on 17/5/22.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "UserDefaultsManager.h"
#import "NearbyM.h"
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kAuditStatus @"auditStatus"
#define kCurCityCode @"curCityCode"

@implementation UserDefaultsManager

#pragma mark -
#pragma mark - LogOut
+ (void) logOut
{
    [self setToken:@""];
    [self setUserId:@""];
    [self setNickName:@""];
    [self setDescribe:@""];
    [self setAvatar:@""];
    [self setMobile:@""];
    [self setGender:0];
    [self setBirthday:@"0000-00-00"];
    [self setMoney:@""];
    [self setVisitorNum:@""];
    [self setIdStatus:IdStatusNormal];
    [self setRYToken:@""];
    [self setMsgFlag:0];
    [self setCertified:NO];
    [[RCIM sharedRCIM] logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusIsChange object:self];
}

+ (void) login:(id)obj
{
    if (!obj)
    {
        return;
    }
    [self setToken:obj[@"token"]];
    [self setUserId:obj[@"userinfo"][@"id"]];
    [self setNickName:obj[@"userinfo"][@"nickname"]];
    [self setDescribe:obj[@"userinfo"][@"describe"]];
    [self setAvatar:obj[@"userinfo"][@"avatar"]];
    [self setMobile:obj[@"userinfo"][@"mobile"]];
    [self setGender:[obj[@"userinfo"][@"gender"] integerValue]];
    [self setBirthday:obj[@"userinfo"][@"birthday"]];
    [self setMoney:obj[@"userinfo"][@"money"]];
    [self setVisitorNum:obj[@"userinfo"][@"visitornum"]];
    [self setIdStatus:[obj[@"userinfo"][@"status"] integerValue]];
    [self setRYToken:obj[@"userinfo"][@"rongyun_token"]];
    [self setMsgFlag:[obj[@"userinfo"][@"flag"] integerValue]];
    [self setCertified:[obj[@"userinfo"][@"certified"] boolValue]];
    
    //    [[RCIM sharedRCIM] connectWithToken:[self getRYToken] success:^(NSString *userId) {
    //        NSLog(@"RongYun is Login !!!");
    //        RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userId name:[self getNickName] portrait:[self getAvatar]];
    //        [RCIM sharedRCIM].currentUserInfo = info;
    //    } error:^(RCConnectErrorCode status) {
    //
    //    } tokenIncorrect:^{
    //
    //    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusIsChange object:self];
}

+ (void) updateUserInfo
{
    [NetAPIManager myHomeInfoWithCallBack:^(BOOL success, id object) {
        if (success)
        {
            NearbyM *infoM = [NearbyM new];
            [infoM setValuesForKeysWithDictionary:object[@"data"]];
            [self setNickName:infoM.user_info.nickname];
            [self setDescribe:infoM.user_info.describe];
            [self setAvatar:infoM.user_info.avatar];
            [self setBirthday:infoM.user_info.birthday];
            [self setMoney:infoM.user_info.money];
            [self setVisitorNum:[NSString stringWithFormat:@"%zd",infoM.user_info.visitornum]];
            [self setMsgFlag:infoM.user_info.flag];
            [self setCertified:infoM.user_info.certified];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoIsChange object:self];
        }
    }];
}

#pragma mark -
#pragma mark - auditStatus
+ (BOOL) getAuditStatus
{
    return [[kUserDefaults objectForKey:kAuditStatus] boolValue];
}
+ (void) setAuditStatus:(BOOL)isAudit
{
    [kUserDefaults setObject:@(isAudit) forKey:kAuditStatus];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - Token
+ (NSString *) getToken
{
    return [kUserDefaults objectForKey:@"token"];
}
+ (void) setToken:(NSString *) token
{
    [kUserDefaults setObject:token forKey:@"token"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - City
+ (NSString *) getCity
{
    return [kUserDefaults objectForKey:@"city"] ? [kUserDefaults objectForKey:@"city"] : @"深圳";
}
+ (void) setCity:(NSString *) city
{
    [kUserDefaults setObject:city forKey:@"city"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - CityCode
+ (NSString *) getCityCode
{
    return [kUserDefaults objectForKey:@"citycode"] ? [kUserDefaults objectForKey:@"citycode"] : @"0755";
}
+ (void) setCityCode:(NSString *)cityCode
{
    [kUserDefaults setObject:cityCode forKey:@"citycode"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - curCityCode -> 发布信息城市编码
+ (NSString *) getCurCityCode
{
    return [kUserDefaults objectForKey:kCurCityCode] ? [kUserDefaults objectForKey:kCurCityCode] : @"0755";
}

+ (void) setCurCityCode:(NSString *)cityCode
{
    [kUserDefaults setObject:cityCode forKey:kCurCityCode];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - UserId
+ (NSString *) getUserId
{
    return [kUserDefaults objectForKey:@"userid"];
}
+ (void) setUserId:(NSString *)userId
{
    [kUserDefaults setObject:userId forKey:@"userid"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - certified
+ (BOOL) getCertified
{
    return [[kUserDefaults objectForKey:@"certified"] boolValue];
}
+ (void) setCertified:(BOOL)certified
{
    [kUserDefaults setObject:@(certified) forKey:@"certified"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - nickname
+ (NSString *) getNickName
{
    return [kUserDefaults objectForKey:@"nickname"];
}
+ (void) setNickName:(NSString *)nickName
{
    [kUserDefaults setObject:nickName forKey:@"nickname"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - describe 个性签名
+ (NSString *) getDescribe
{
    return [kUserDefaults objectForKey:@"user_describe"];
}
+ (void) setDescribe:(NSString *)describe
{
    [kUserDefaults setObject:describe forKey:@"user_describe"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - avatar  头像
+ (NSString *) getAvatar
{
    return [kUserDefaults objectForKey:@"avatar"];
}
+ (void) setAvatar:(NSString *)avatar
{
    [kUserDefaults setObject:avatar forKey:@"avatar"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - mobile
+ (NSString *) getMobile
{
    return [kUserDefaults objectForKey:@"mobile"];
}
+ (void) setMobile:(NSString *)mobile
{
    [kUserDefaults setObject:mobile forKey:@"mobile"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - gender
+ (NSInteger) getGender
{
    return [[kUserDefaults objectForKey:@"user_gender"] integerValue];
}
+ (void) setGender:(NSInteger)gender
{
    [kUserDefaults setObject:@(gender) forKey:@"user_gender"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - birthday
+ (NSString *) getBirthday
{
    return [kUserDefaults objectForKey:@"user_birthday"];
}
+ (void) setBirthday:(NSString *)birthday
{
    [kUserDefaults setObject:birthday forKey:@"user_birthday"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - money
+ (NSString *) getMoney
{
    return [kUserDefaults objectForKey:@"user_money"];
}
+ (void) setMoney:(NSString *)money
{
    [kUserDefaults setObject:money forKey:@"user_money"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - visitornum  人气
+ (NSString *) getVisitorNum
{
    return [kUserDefaults objectForKey:@"visitornum"];
}
+ (void) setVisitorNum:(NSString *)visitorNum
{
    [kUserDefaults setObject:visitorNum forKey:@"visitornum"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - status 是否被冻结
+ (IdStatus) getIdStatus
{
    return [[kUserDefaults objectForKey:@"user_status"] integerValue];
}
+ (void) setIdStatus:(IdStatus)status
{
    [kUserDefaults setObject:@(status) forKey:@"user_status"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - rongyun_token
+ (NSString *) getRYToken
{
    return [kUserDefaults objectForKey:@"rongyun_token"];
}
+ (void) setRYToken:(NSString *)token
{
    [kUserDefaults setObject:token forKey:@"rongyun_token"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - flag 私信开关
+ (NSInteger) getMsgFlag
{
    return [[kUserDefaults objectForKey:@"msg_flag"] integerValue];
}
+ (void) setMsgFlag:(NSInteger)flag
{
    [kUserDefaults setObject:@(flag) forKey:@"msg_flag"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - lng 经度
+ (NSNumber *) getUserLng
{
    return [kUserDefaults objectForKey:@"user_longitude"] ? [kUserDefaults objectForKey:@"user_longitude"] : @(100.1);
}
+ (void) setUserLng:(CLLocationDegrees)lng
{
    [kUserDefaults setObject:@(lng) forKey:@"user_longitude"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - lat 纬度
+ (NSNumber *) getUserLat;
{
    return [kUserDefaults objectForKey:@"user_latitude"] ? [kUserDefaults objectForKey:@"user_latitude"] : @(80);
}
+ (void) setUserLat:(CLLocationDegrees)lat
{
    [kUserDefaults setObject:@(lat) forKey:@"user_latitude"];
    [kUserDefaults synchronize];
}

#pragma mark -
#pragma mark - filter
+ (NSDictionary *) getFilterInfo
{
    return [kUserDefaults objectForKey:kFilterInfo];
}
+ (void) setFilterInfo:(NSDictionary *)info
{
    [kUserDefaults setObject:info forKey:kFilterInfo];
    [kUserDefaults synchronize];
}
@end

