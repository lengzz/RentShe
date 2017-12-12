//
//  VerifyVC.h
//  RentShe
//
//  Created by Lengzz on 17/5/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyVC : UIViewController
@property (nonatomic, assign) BOOL isModify;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) void (^regetBlock)();
@end
