//
//  FilterVC.h
//  RentShe
//
//  Created by Lengzz on 2017/7/4.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterVC : UIViewController

@property (nonatomic, copy) void (^filterBlock)(NSDictionary *dic);

@end
