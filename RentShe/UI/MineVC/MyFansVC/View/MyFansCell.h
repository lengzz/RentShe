//
//  MyFansCell.h
//  RentShe
//
//  Created by Lzz on 2018/1/16.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyFansCell;

@protocol MyFansCellDelegate<NSObject>

- (void)myFansCell:(MyFansCell *)cell clickWithIndex:(NSIndexPath *)index;

@end

@interface MyFansCell : UITableViewCell
@property (nonatomic, weak) id<MyFansCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)index;

- (void)refreshCell:(id)obj;

@end
