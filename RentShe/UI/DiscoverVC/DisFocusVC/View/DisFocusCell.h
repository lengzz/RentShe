//
//  DisFocusCell.h
//  RentShe
//
//  Created by Lzz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DisFocusCell;

typedef NS_ENUM(NSInteger, DisFocusCellType) {
    DisFocusCellTypeOfWatch = 1,
    DisFocusCellTypeOfPraise,
    DisFocusCellTypeOfLookComment
};

@protocol DisFocusCellDelegate<NSObject>
- (void)disFocusCell:(DisFocusCell *)cell clickIndex:(NSIndexPath *)index withType:(DisFocusCellType)type;
@end

@interface DisFocusCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableV withIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<DisFocusCellDelegate> delegate;
- (void)refreshCell:(id)obj;
@end
