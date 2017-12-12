//
//  PayForOrderCell.h
//  RentShe
//
//  Created by Lengzz on 2017/8/27.
//  Copyright © 2017年 Lengzz. All rights reserved.
//
typedef NS_ENUM(NSInteger, PayType)
{
    PayTypeOfSys = 1,
    PayTypeOfWeChat,
    PayTypeOfZfb
};
#import <UIKit/UIKit.h>

@interface PayForOrderCell : UITableViewCell
@property (nonatomic, assign) PayType type;
@property (nonatomic, copy) NSString *tips;

@end
