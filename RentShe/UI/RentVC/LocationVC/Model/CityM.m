//
//  CityM.m
//  RentShe
//
//  Created by Lzz on 2017/9/30.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CityM.h"

@interface CityM ()

@end

@implementation CityM

+ (NSArray *)dataArr
{
    static dispatch_once_t onceToken;
    static NSArray *dataArr;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityCode" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *sourceArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            CityM *m = [[CityM alloc] init];
            [m setValuesForKeysWithDictionary:dic];
            [sourceArr addObject:m];
        }
        dataArr = [sourceArr copy];
    });
    
    return dataArr;
}

+ (NSString *)getCityByCode:(NSString *)code
{
    for (CityM *m in self.dataArr) {
        if ([m.code isEqualToString:code]) {
            return m.city;
        }
    }
    return @"深圳";
}

+ (NSString *)getCodeByCity:(NSString *)city
{
    for (CityM *m in self.dataArr) {
        if ([m.city isEqualToString:city]) {
            return m.code;
        }
    }
    return @"0755";
}

// 按首字母分组排序数组
+ (NSDictionary *)sortCitys
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    for (CityM *model in self.dataArr) {
        NSInteger sectionNumber = [collation sectionForObject:model collationStringSelector:@selector(city)];
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:model];
    }
    
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(city)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    
    NSMutableArray *titlesArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
            [titlesArr addObject:[collation sectionTitles][index]];
        }
    }
    return @{kCityTitle:titlesArr,kCityContent:finalArr};
}
@end
