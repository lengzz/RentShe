//
//  OrderListCell.h
//  RentShe
//
//  Created by Lengzz on 2017/9/3.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderListM;

@interface OrderListCell : UITableViewCell

@property (nonatomic, copy) void (^functionBlock)(NSString *type, id obj);
@property (nonatomic, assign) OrderType type;

- (void)refreshCell:(OrderListM *)model;

@end
