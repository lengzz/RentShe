//
//  BlackListCell.h
//  RentShe
//
//  Created by Lzz on 2017/12/1.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackListCell : UITableViewCell
@property (nonatomic, copy) void (^cancelShield)(NSIndexPath *index);
@property (nonatomic, strong) NSIndexPath *index;

- (void)refreshCell:(id)obj;
@end
