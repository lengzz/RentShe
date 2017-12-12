//
//  MineInfoM.h
//  RentShe
//
//  Created by Lengzz on 2017/7/16.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineInfoM : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *describe;//个性签名
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *gender;   //性别
@property (nonatomic, copy) NSString *birthday; //"1998-01-01",
@property (nonatomic, copy) NSString *money;   //金额
@property (nonatomic, assign) NSInteger *visitornum;   //人气
@property (nonatomic, assign) NSInteger *status; //是否被冻结 0被冻结，1正常使用
@property (nonatomic, copy) NSString *rongyun_token;
@end
