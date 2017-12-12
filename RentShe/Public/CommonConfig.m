//
//  CommonConfig.m
//  RentShe
//
//  Created by Lengzz on 2017/9/2.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CommonConfig.h"

@interface CommonConfig ()
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
    });
    return config;
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
