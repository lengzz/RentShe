//
//  WalletRecordM.h
//  RentShe
//
//  Created by Lengzz on 2017/10/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WalletType)
{
    WalletTypeOfSystem = 0,
    WalletTypeOfOrder
};

typedef NS_ENUM(NSInteger, WalletPurpose)
{
    WalletPurposeOfAll = -1,
    WalletPurposeOfOut = 0,
    WalletPurposeOfIn
};

@interface WalletRecordM : NSObject
@property(nonatomic, copy) NSString *recordId;
@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, assign) WalletType type;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, assign) WalletPurpose purpose;
@property(nonatomic, assign) NSInteger channel;
@property(nonatomic, assign) NSInteger state;
@property(nonatomic, copy) NSString *order_num;
@property(nonatomic, assign) double create_time;
@property(nonatomic, assign) double end_time;
@end
