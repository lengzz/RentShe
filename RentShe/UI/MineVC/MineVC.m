//
//  MineVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MineVC.h"
#import "MineHeadCell.h"

#import "SettingVC.h"
#import "MyRentInfoVC.h"
#import "MyWalletVC.h"
#import "MyRentVC.h"
#import "RentMeVC.h"
#import "RentDetailVC.h"
#import "CertificationVC.h"

#import "MyFansVC.h"
#import "MyFocusVC.h"
#import "MyVideosVC.h"

typedef NS_ENUM(NSInteger,CellType) {
    CellTypeWallet = 1,
    CellTypeRentMe,
    CellTypeMyRent,
    CellTypeData,
    CellTypeCertification,
    CellTypeInfo
};

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource,MineHeadDelegate>
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation MineVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 49) style:UITableViewStylePlain];
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.prefersNavigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusIsChange) name:kLoginStatusIsChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusIsChange) name:kUserInfoIsChange object:nil];
     
    [self createNavBar];
    [self configData];
    [self myTabV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:kRGB_Value(0xfde23d)];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)statusIsChange
{
    [self configData];
    [self.myTabV reloadData];
}

- (void)configData
{
    [self.dataArr removeAllObjects];
    if ([UserDefaultsManager getToken].length)
    {//是否登陆
        [self.dataArr addObject:@(YES)];
    }
    else
    {
        [self.dataArr addObject:@(NO)];
    }
    NSArray *firstArr = @[
                          @{@"name":@"我的钱包",
                            @"img":@"mine_wallet",
                            @"type":@(CellTypeWallet)}];
    
    NSArray *secondArr = @[
                           @{@"name":[UserDefaultsManager getAuditStatus] ? @"聘用我的" : @"谁租了我",
                             @"img":@"mine_rentme",
                             @"type":@(CellTypeRentMe)},
                           @{@"name":[UserDefaultsManager getAuditStatus] ? @"我聘请的" : @"我租了谁",
                             @"img":@"mine_myrent",
                             @"type":@(CellTypeMyRent)}];//,
//                           @{@"name":@"数据分析",
//                             @"img":@"mine_data",
//                             @"type":@(CellTypeData)}];
    
    NSArray *thirdArr = @[
                          @{@"name":@"实名认证",
                            @"img":@"mine_certification",
                            @"type":@(CellTypeCertification)},
                          @{@"name":@"我的技能",
                            @"img":@"mine_info",
                            @"type":@(CellTypeInfo)}];
    [self.dataArr addObjectsFromArray:@[firstArr,secondArr,thirdArr]];
}

- (void)createNavBar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"我的"]];
    
    [self.navigationItem setRightBarButtonItem:[CustomNavVC getRightBarButtonItemWithTarget:self action:@selector(settingClick) normalImg:[UIImage imageNamed:@"navbar_setting"] hilightImg:[UIImage imageNamed:@"navbar_setting"]]];
}

- (void)settingClick
{
    if (!isLogin(self))
    {
        return;
    }
    SettingVC *settingVC = [[SettingVC alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - _______UITableViewDelegate,UITableViewDataSource_______
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isLogin(self))
    {
        return;
    }
    if (!indexPath.section)
    {
        RentDetailVC *vc = [RentDetailVC new];
        vc.isSelf = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSDictionary *dic = self.dataArr[indexPath.section][indexPath.row];
    switch ([dic[@"type"] integerValue]) {
        case CellTypeWallet:
        {
            MyWalletVC *vc = [[MyWalletVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case CellTypeRentMe:
        {
            RentMeVC *vc = [[RentMeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case CellTypeMyRent:
        {
            MyRentVC *vc = [[MyRentVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case CellTypeData:
            
            break;
            
        case CellTypeCertification:
        {
            CertificationVC *vc = [CertificationVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case CellTypeInfo:
        {
            MyRentInfoVC *vc = [[MyRentInfoVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    }
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB_Value(0x282828);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSArray *arr = self.dataArr[indexPath.section];
        NSDictionary *dic = arr[indexPath.row];
        cell.textLabel.text = dic[@"name"];
        cell.imageView.image = [UIImage imageNamed:dic[@"img"]];
        return cell;
    }
    else
    {
        MineHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineHeadCell"];
        if (!cell) {
            cell = [[MineHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineHeadCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell refreshCellIsLogin:[self.dataArr[indexPath.section] boolValue]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        return 150;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

#pragma mark -
#pragma mark - MineHeadDelegate

- (void)mineHeadCell:(MineHeadCell *)headCell didClickWithType:(MineHeadType)type
{
    if (!isLogin(self))
    {
        return;
    }
    switch (type) {
        case MineHeadOfFocus:
        {
            MyFocusVC *vc = [MyFocusVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case MineHeadOfFans:
        {
            MyFansVC *vc = [MyFansVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case MineHeadOfVideos:
        {
            MyVideosVC *vc = [MyVideosVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
