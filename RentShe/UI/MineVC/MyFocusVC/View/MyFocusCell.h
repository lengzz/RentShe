//
//  MyFocusCell.h
//  RentShe
//
//  Created by Lzz on 2018/1/18.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyFocusCell;

@protocol MyFocusCellDelegate<NSObject>

- (void)myFocusCell:(MyFocusCell *)cell clickWithIndex:(NSIndexPath *)index;

@end

@interface MyFocusCell : UITableViewCell
@property (nonatomic, weak) id<MyFocusCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)index;

- (void)refreshCell:(id)obj;

@end
