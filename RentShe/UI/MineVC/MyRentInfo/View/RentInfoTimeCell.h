//
//  RentInfoTimeCell.h
//  RentShe
//
//  Created by Lengzz on 17/5/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentInfoTimeCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t chooseWeekBlock;
@property (nonatomic, copy) void (^timeBlock)(NSString *begin, NSString *end);

@property (nonatomic, assign) CGFloat beginTime;
@property (nonatomic, assign) CGFloat endTime;
@property (nonatomic, strong) NSDictionary *dayDic;
@end
