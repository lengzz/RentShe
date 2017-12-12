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
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, strong, readonly) NSDateFormatter *week_DateFormatter;

+ (instancetype)shareInstance;
@end
