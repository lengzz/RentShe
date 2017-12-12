//
//  LocationHotCell.h
//  RentShe
//
//  Created by Lengzz on 17/6/2.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityM;

@interface LocationHotCell : UITableViewCell

@property (nonatomic, copy) void (^hotCityBlock)(CityM *obj);

- (void)refreshCell:(NSArray *)arr;

@end

