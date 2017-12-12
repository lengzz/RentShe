//
//  FilterSectionCell.h
//  RentShe
//
//  Created by Lengzz on 2017/7/8.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FilterType)
{
    FilterTypeOfAge = 0,
    FilterTypeOfPrice,
    FilterTypeOfTime
};

@interface FilterSectionCell : UITableViewCell

@property (nonatomic, copy) void (^isChanged)(CGFloat min, CGFloat max, FilterType type);
@property (nonatomic, assign) FilterType type;
@property (nonatomic, assign) CGFloat start;
@property (nonatomic, assign) CGFloat end;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, copy) NSString *titleStr;

- (void)setInfo;

@end
