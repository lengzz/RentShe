//
//  TipsV.h
//  RentShe
//
//  Created by Lengzz on 17/5/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsV : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *lBtnName;
@property (nonatomic, copy) NSString *rBtnName;
@property (nonatomic, strong) UIImageView *tipsImg;
@property (nonatomic, copy) void (^clickBlock)(BOOL isOK);

- (void)show;
- (void)hidden;
@end
