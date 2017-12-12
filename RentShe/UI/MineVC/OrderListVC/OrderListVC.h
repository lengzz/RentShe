//
//  OrderListVC.h
//  RentShe
//
//  Created by Lengzz on 2017/9/2.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderListM;

typedef NS_ENUM(NSInteger, OrderState)
{
    OrderStateOfWait, /** 等待确认 **/
    OrderStateOfImplement, /** 待见面 **/
    OrderStateOfEvaluate, /** 等待评价 **/
    OrderStateOfEnd /** 已完成 **/
};

@interface OrderListVC : UIViewController

@property (nonatomic, copy) void (^chatBlock)(OrderListM *model);
@property (nonatomic, copy) void (^reviewBlock)(OrderListM *model);
@property (nonatomic, assign) OrderType type;
@property (nonatomic, assign) OrderState state;

@end
