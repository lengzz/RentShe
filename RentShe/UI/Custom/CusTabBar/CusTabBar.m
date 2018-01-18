//
//  CusTabBar.m
//  RentShe
//
//  Created by Leng_zz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "CusTabBar.h"

@interface CusTabBar()
{
    BOOL _isShow;
}
@end

@implementation CusTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_light_bg"]];
        self.itemWidth = kWindowWidth/5.0;
//        self.tintColor = HEX_RGB(0xfafafa);
//        self.backgroundColor = HEX_RGB(0xfafafa);
//        self.translucent = NO;
    }
    return self;
}


- (void)layoutSubviews {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [view removeFromSuperview];
//            view.width = kWindowWidth/5;
//            view.height = 49;
        }
    }
//    if (self.frame.origin.y != kWindowHeight && !_isShow) {
//        _isShow = YES;
////        [self setUpBaseView];
//    }
}

- (void)setItemWidth:(CGFloat)itemWidth

@end
