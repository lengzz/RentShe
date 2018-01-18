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
#import "DiscoverVC.h"
#import "ConversationVC.h"
#import "MineVC.h"
#import "CusTabBar.h"

@interface RootTabbarVC ()

@end

@implementation RootTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubVC];
    CusTabBar *customTabBar = [[CusTabBar alloc] init];
//    _customTabBar.customDelegate = self;
    [self setValue:customTabBar forKey:@"tabBar"];
}

- (void)addSubVC
{
    NSMutableArray *subVCArr = [NSMutableArray array];
    //租我
    RentVC *rentVC = [[RentVC alloc] init];
    CustomNavVC *rentNavVC = [[CustomNavVC alloc] initWithRootViewController:rentVC];
    [subVCArr addObject:rentNavVC];
    //发现
    DiscoverVC *discoverVC = [[DiscoverVC alloc] init];
    CustomNavVC *discoverNavVC = [[CustomNavVC alloc] initWithRootViewController:discoverVC];
    [subVCArr addObject:discoverNavVC];
    //占位控制器
//    [subVCArr addObject:[UIViewController new]];
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
    
    NSArray *titleArr = @[@"租我",@"发现",@"",@"消息",@"我的"];
    NSArray *imgArr = @[@"tabbar_rent",@"tabbar_discover",@"tabbar_video",@"tabbar_conversation",@"tabbar_mine"];
    NSArray *imgSelArr = @[@"tabbar_rent_selected",@"tabbar_discover_selected",@"tabbar_video",@"tabbar_conversation_selected",@"tabbar_mine_selected"];
    for (NSInteger i = 0; i < subVCArr.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        id item1;
        if (i != 2)
        {
            item1 = [item initWithTitle:titleArr[i] image:[[UIImage imageNamed:imgArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:imgSelArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:kRGB_Value(0x989898)} forState:UIControlStateNormal];
            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:kRGB(254, 217, 13)} forState:UIControlStateSelected];
            item.tag = i;
        }
        else
        {
            item1 = [item initWithTitle:nil image:[[UIImage imageNamed:imgArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:imgSelArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
            item.tag = i;
        }
    }
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_light_bg"]];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}


@end
