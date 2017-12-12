//
//  CustomNavVC.h
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavVC : UINavigationController
//title
+ (UILabel *)setNavgationItemTitle:(NSString *)title;

//leftBarButtonItem
+ (UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)target
                                             action:(SEL)sel
                                             titile:(NSString *)title;

+ (UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)target
                                             action:(SEL)sel;
+ (UIButton *)getLeftDefaultButtonWithTarget:(id)target
                                      action:(SEL)sel;

+ (UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)target
                                             action:(SEL)sel
                                          normalImg:(UIImage *)imageN
                                         hilightImg:(UIImage *)imageH;

+ (UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)target
                                             action:(SEL)sel
                                          normalImg:(UIImage *)imageN
                                         hilightImg:(UIImage *)imageH
                                              title:(NSString *)str;

//rightBarButtonItem
+ (UIBarButtonItem *)getRightBarButtonItemWithTarget:(id)target
                                              action:(SEL)sel
                                              titile:(NSString *)title;
+ (UIButton *)getRightDefaultButtonWithTarget:(id)target
                                       action:(SEL)sel
                                       titile:(NSString *)title;

+ (UIBarButtonItem *)getRightBarButtonItemWithTarget:(id)target
                                              action:(SEL)sel
                                           normalImg:(UIImage *)imageN
                                          hilightImg:(UIImage *)imageH;
//backgroundColor
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
