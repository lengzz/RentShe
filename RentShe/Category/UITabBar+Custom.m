//
//  UITabBar+Custom.m
//  RentShe
//
//  Created by Lzz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "UITabBar+Custom.h"

@implementation UITabBar (Custom)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(cus_LayoutSubviews));
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    });
}

- (UIButton *)videoBtn
{
    UIButton *btn = objc_getAssociatedObject(self, _cmd);
    if (!btn)
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabbar_video"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [self addSubview:btn];
        self.videoBtn = btn;
    }
    return btn;
}

- (void)setVideoBtn:(UIButton *)videoBtn
{
    SEL key = @selector(videoBtn);
    objc_setAssociatedObject(self, key, videoBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cus_LayoutSubviews
{
    [self cus_LayoutSubviews];
    CGFloat butX = 0;
    CGFloat butY = 0;
    CGFloat butW = kWindowWidth / (self.items.count + 1);
    CGFloat butH = 49.0;
    
    int i = 0;
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            if (i == 2)
            {
                i = 3;
            }
            butX = i * butW;
            tabBarButton.frame = CGRectMake(butX, butY, butW, butH);
            i++;
        }
    }
    self.videoBtn.center = CGPointMake(kWindowWidth * 0.5, 49.0 * 0.5);
}
@end
