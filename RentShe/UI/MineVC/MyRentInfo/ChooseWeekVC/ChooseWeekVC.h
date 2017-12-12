//
//  ChooseWeekVC.h
//  RentShe
//
//  Created by Lengzz on 2017/9/17.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseWeekVC : UIViewController

@property (nonatomic, copy) void (^chooseBlock)(NSDictionary *dic);
@property (nonatomic, strong) NSMutableDictionary *dayDic;
@end
