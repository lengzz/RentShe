//
//  CommonConfig.m
//  RentShe
//
//  Created by Lengzz on 2017/9/2.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CommonConfig.h"
typedef NS_ENUM(NSUInteger, ServerType){
    /**  线上环境  */
    ServerTypeOfOnline = 1,
    /**  测试环境  */
    ServerTypeOfTest,
};

//正式环境
#define kApiHostUrl_Online @"https://api.rentshe.com/Nip"
#define kRongCAppKey_Online @"6tnym1br6jwt7"

//测试环境
#define kApiHostUrl_Test @"http://zuapi.rentshe.com"
#define kRongCAppKey_Test @"c9kqb3rdcvn9j"

@interface CommonConfig ()
@property (nonatomic, assign) ServerType type;
@property (nonatomic, strong) NSString *apiHostUrl;//服务器地址
@property (nonatomic, strong) NSString *rongCAppKey;//融云
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *week_DateFormatter;
@end

@implementation CommonConfig

+ (instancetype)shareInstance
{
    static CommonConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [CommonConfig new];
        /**
         *
         */
        /**   切换环境   */
        config.type = ServerTypeOfTest;
        
        [config createData];
    });
    return config;
}

- (void)createData
{
    switch (self.type) {
        case ServerTypeOfOnline:
        {
            self.apiHostUrl = kApiHostUrl_Online;
            self.rongCAppKey = kRongCAppKey_Online;
#ifdef DEBUG    //调试不提交BUG统计
#else
#endif
            break;
        }
        case ServerTypeOfTest:
        {
            self.apiHostUrl = kApiHostUrl_Test;
            self.rongCAppKey = kRongCAppKey_Test;
            break;
        }
        default:
            break;
    }
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
        dateFormatter.dateFormat = @"MM月dd日 HH:mm";
        _dateFormatter = dateFormatter;
    }
    return _dateFormatter;
}

- (NSDateFormatter *)week_DateFormatter
{
    if (!_week_DateFormatter) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
        dateFormatter.dateFormat = @"MM月dd日 EE HH:mm";
        dateFormatter.shortWeekdaySymbols = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        _week_DateFormatter = dateFormatter;
    }
    return _week_DateFormatter;
}

@end
