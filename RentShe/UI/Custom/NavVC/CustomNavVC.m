//
//  CustomNavVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CustomNavVC.h"

@interface CustomNavVC ()<UIGestureRecognizerDelegate>

@end

@implementation CustomNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.delegate = self;
    
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}
+(UILabel *)setNavgationItemTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    label.numberOfLines = 0;
    label.textColor = kRGB_Value(0x442509);
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)target action:(SEL)sel titile:(NSString *)title;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 57, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)targett
                                            action:(SEL)sel
{
    return [[UIBarButtonItem alloc] initWithCustomView:[CustomNavVC getLeftDefaultButtonWithTarget:targett action:sel]];
}

+ (UIButton *)getLeftDefaultButtonWithTarget:(id)target
                                      action:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 48, 48);
    [button setImage:[UIImage imageNamed:@"btn_public_back_n"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_public_back_h"] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, -13, -1, 13)];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//left buttonItem3
+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)target
                                            action:(SEL)sel
                                         normalImg:(UIImage *)imageN
                                        hilightImg:(UIImage *)imageH
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:imageN forState:UIControlStateNormal];
    [button setImage:imageH forState:UIControlStateHighlighted];
    //[button sizeToFit];
    button.frame = CGRectMake(0, 0, 45, 45);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//left buttonItem4
+(UIBarButtonItem *)getLeftBarButtonItemWithTarget:(id)target
                                            action:(SEL)sel
                                         normalImg:(UIImage *)imageN
                                        hilightImg:(UIImage *)imageH
                                             title:(NSString *)str
{
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGSize size0 = [@"深圳深圳" boundingRectWithSize:CGSizeMake(0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    CGSize size = [str boundingRectWithSize:CGSizeMake(0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    if (size.width > size0.width)
    {//控制显示字数
        size.width = size0.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:imageN forState:UIControlStateNormal];
    [button setImage:imageH forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, size.width + 10, 45);
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:kRGB_Value(0x442509) forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont systemFontOfSize:15];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [button setTitle:str forState:0];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+(UIBarButtonItem *)getRightBarButtonItemWithTarget:(id)target
                                             action:(SEL)sel
                                             titile:(NSString *)title
{
    return [[UIBarButtonItem alloc] initWithCustomView:[CustomNavVC getRightDefaultButtonWithTarget:target action:sel titile:title]];
}

+ (UIButton *)getRightDefaultButtonWithTarget:(id)target
                                       action:(SEL)sel
                                       titile:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 57, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:kRGB_Value(0x442509) forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//right buttonItem2
+(UIBarButtonItem *)getRightBarButtonItemWithTarget:(id)target
                                             action:(SEL)sel
                                          normalImg:(UIImage *)imageN
                                         hilightImg:(UIImage *)imageH
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 48, 48);
    [button setImage:imageN forState:UIControlStateNormal];
    [button setImage:imageH forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, 16, -1, -16)];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - ______UIGestureRecognizerDelegate_______
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1){//关闭主界面的右滑返回
        return NO;
    }else
        return YES;
}
@end
