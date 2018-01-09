//
//  Definition.h
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#ifndef Definition_h
#define Definition_h

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

typedef NS_ENUM(NSInteger, OrderType)
{
    OrderTypeOfRentMe = 1,
    OrderTypeOfMyRent
};

typedef NS_ENUM(NSInteger,IdStatus)
{
    IdStatusStop = 0,
    IdStatusNormal
};

typedef NS_ENUM(NSInteger,LoginType) {
    LoginTypePhone = 1,
    LoginTypeQQ,
    LoginTypeWechat
};

#define kAPPID @"1309082026"

#pragma mark - 错误状态码
#define kTokenDisabled 403

#pragma mark - 第三方平台
#define kUmeng_APPKey @"59bc9a968630f51d5f000017"
#define kWeCaht_APPID @"wx693fda99b5c287cd"
#define kWeCaht_Secret @"2aa7e7f2ae26d74077a25cadc2af153d"

#define kQQ_APPID @"1106607644"
#define kQQ_Secret @"yIwbIpVaFN7UO91U"
#define kAMapKey @"589239581301a83945f4b9c1bd6a736a"
#define kAliScheme @"alisdkRentShe"

#define kServiceRCID @"209"


#undef	kRGB
#define kRGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef	kRGBA
#define kRGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

//RGB Color macro
#define kRGB_Value(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - RGB color macro with alpha
#define kRGBA_Value(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#pragma mark - APP info
#define kAPPInfo [[NSBundle mainBundle] infoDictionary]
#define kAppVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#define kWindowWidth                ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight               ([[UIScreen mainScreen] bounds].size.height)

#define kNavBarHeight               (44 + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]))
#define kStatusBarHeight            (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]))
#define kTabBarHeight               (CGRectGetHeight([UITabBarController new].tabBar.frame) + kSafeAreaBottomHeight)
#define kSafeAreaBottomHeight       (kWindowHeight == 812.0 ? 34 : 0)

#pragma mark - APP Notification
#define kLoginStatusIsChange @"LoginStatusIsChange"
#define kUnreadMessageIsChange @"UnreadMessageIsChange"
#define kUserInfoIsChange @"UserInfoIsChange"

#pragma mark - Week Day
#define kMon @"mon"
#define kTue @"tue"
#define kWed @"wed"
#define kThu @"thu"
#define kFri @"fri"
#define kSat @"sat"
#define kSun @"sun"

#define kFilterInfo @"filterInfo"
#define kFilterAgeMin @"min_age"
#define kFilterAgeMax @"max_age"
#define kFilterMoneyMin @"min_price"
#define kFilterMoneyMax @"max_price"
#define kFilterTimeMin @"rental_start_time"
#define kFilterTimeMax @"rental_end_time"
#define kFilterGender @"gender"
#endif /* Definition_h */
