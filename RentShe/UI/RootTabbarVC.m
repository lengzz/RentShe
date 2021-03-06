//
//  RootTabbarVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RootTabbarVC.h"

#import "CustomNavVC.h"
#import "RentVC.h"
#import "ConversationVC.h"
#import "MineVC.h"

@interface RootTabbarVC ()

@end

@implementation RootTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubVC];
}

- (void)addSubVC
{
    NSMutableArray *subVCArr = [NSMutableArray array];
    //租我
    RentVC *rentVC = [[RentVC alloc] init];
    CustomNavVC *rentNavVC = [[CustomNavVC alloc] initWithRootViewController:rentVC];
    [subVCArr addObject:rentNavVC];
    //消息
    ConversationVC *conversationVC = [[ConversationVC alloc] init];
    CustomNavVC *conversationNavVC = [[CustomNavVC alloc] initWithRootViewController:conversationVC];
    [subVCArr addObject:conversationNavVC];
    //我的
    MineVC *mineVC = [[MineVC alloc] init];
    CustomNavVC *mineNavVC = [[CustomNavVC alloc] initWithRootViewController:mineVC];
    [subVCArr addObject:mineNavVC];
    
    self.viewControllers = subVCArr;
    
    self.selectedIndex = 0;
    
    NSArray *titleArr = @[@"租我",@"消息",@"我的"];
    NSArray *imgArr = @[@"tabbar_rent",@"tabbar_conversation",@"tabbar_mine"];
    NSArray *imgSelArr = @[@"tabbar_rent_selected",@"tabbar_conversation_selected",@"tabbar_mine_selected"];
    for (NSInteger i = 0; i < subVCArr.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        id item1;
        item1 = [item initWithTitle:titleArr[i] image:[[UIImage imageNamed:imgArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:imgSelArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:kRGB_Value(0x282828)} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:kRGB(254, 217, 13)} forState:UIControlStateSelected];
        item.tag = i;
    }
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_light_bg"]];
}



@end
