//
//  FilterGenderCell.h
//  RentShe
//
//  Created by Lengzz on 2017/7/8.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterGenderCell : UITableViewCell

@property (nonatomic, copy) void (^genderBlock)(NSString *obj);

- (void)refreshCell:(NSString *)str;

@end
