//
//  MineHeadCell.h
//  RentShe
//
//  Created by Lengzz on 17/5/20.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineHeadCell;
typedef NS_ENUM(NSInteger, MineHeadType)
{
    MineHeadOfFocus = 1,
    MineHeadOfFans,
    MineHeadOfVideos
};

@protocol MineHeadDelegate<NSObject>
- (void)mineHeadCell:(MineHeadCell *)headCell didClickWithType:(MineHeadType)type;
@end

@interface MineHeadCell : UITableViewCell

@property (nonatomic, weak) id<MineHeadDelegate> delegate;

- (void)refreshCellIsLogin:(BOOL)isLogin;
@end
