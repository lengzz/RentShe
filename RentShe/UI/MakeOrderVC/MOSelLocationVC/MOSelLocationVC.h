//
//  MOSelLocationVC.h
//  RentShe
//
//  Created by Lengzz on 2017/8/5.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CusAnnotation;
@interface MOSelLocationVC : UIViewController
@property (nonatomic, copy) void (^callBack)(CusAnnotation *);
@end
