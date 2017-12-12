//
//  LocationVC.h
//  RentShe
//
//  Created by Lengzz on 17/6/1.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationVC : UIViewController
@property (nonatomic, copy) void (^cityBlock)(BOOL isChange);
@end
