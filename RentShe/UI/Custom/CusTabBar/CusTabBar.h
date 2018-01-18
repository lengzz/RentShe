//
//  CusTabBar.h
//  RentShe
//
//  Created by Leng_zz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CusTabBar;
@protocol CusTabBarDelegate<NSObject>

- (void)tabBar:(CusTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end
@interface CusTabBar : UITabBar

@property (nonatomic, weak) id<CusTabBarDelegate> cusDelegate;

@end
