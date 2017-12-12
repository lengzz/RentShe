//
//  CityM.h
//  RentShe
//
//  Created by Lzz on 2017/9/30.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCityTitle @"titles"
#define kCityContent @"content"

@interface CityM : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *code;

+ (NSArray *)dataArr;
+ (NSString *)getCityByCode:(NSString *)code;
+ (NSString *)getCodeByCity:(NSString *)city;

+ (NSDictionary *)sortCitys;

@end
