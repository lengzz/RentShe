//
//  AddRentSkillVC.h
//  RentShe
//
//  Created by Lengzz on 2017/9/16.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRentSkillVC : UIViewController

@property (nonatomic, copy) void (^skillBlock)(NSString *price,NSArray *arr);
@end
