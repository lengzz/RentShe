//
//  CustomSlider.h
//  RentShe
//
//  Created by Lengzz on 17/5/27.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSlider : UIView
@property (nonatomic, copy) void (^resultBlock)(CGFloat min, CGFloat max);
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat rightValue;
@end
