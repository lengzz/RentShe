//
//  SettingVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/20.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "SettingVC.h"
#import "AccountSafeVC.h"
#import "ProtocolVC.h"
#import "BlackListVC.h"

typedef NS_ENUM(NSInteger,SettingType) {
    SettingTypeSave = 1,
    SettingTypeBlackList,
    SettingTypePrivacy,
    SettingTypeHelp,
    SettingTypeGrade,
    SettingTypeStatement,
    SettingTypeAbout
};
#define kSettingName @"name"
#define kSettingType @"type"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation SettingVC

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self configData];
    [self myTabV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)configData
{
    NSArray *firstArr = @[
                          @{kSettingName:@"帐号与安全",
                            kSettingType:@(SettingTypeSave)},
                          @{kSettingName:@"黑名单",
                            kSettingType:@(SettingTypeBlackList)}];
    
    NSArray *secondArr = @[
                           @{kSettingName:@"隐私",
                             kSettingType:@(SettingTypePrivacy)}];
    
    NSArray *thirdArr = @[
//                          @{kSettingName:@"帮助与反馈",
//                            kSettingType:@(SettingTypeHelp)},
                          @{kSettingName:@"应用评分",
                            kSettingType:@(SettingTypeGrade)},
                          @{kSettingName:@"免责声明",
                            kSettingType:@(SettingTypeStatement)}];
    NSArray *fourthArr = @[
                           @{kSettingName:@"关于我们",
                             kSettingType:@(SettingTypeAbout)}];
    [self.dataArr addObjectsFromArray:@[firstArr,thirdArr]];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"设置"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)exitClick
{
    [NetAPIManager logoutWithCallBack:^(BOOL success, id object) {

        [UserDefaultsManager logOut];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - _____UITableViewDelegate,UITableViewDataSource______
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = kRGB_Value(0x282828);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *arr = self.dataArr[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    cell.textLabel.text = dic[kSettingName];
    return cell;
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
    if (section == 1) {
        return 44 + 25;
    }
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footer = [UIView new];
        footer.backgroundColor = [UIColor clearColor];
        UIView *exitV = [[UIView alloc] initWithFrame:CGRectMake(15, 25, kWindowWidth - 30, 44)];
        exitV.backgroundColor = kRGB_Value(0xff751a);
        exitV.layer.masksToBounds = YES;
        exitV.layer.cornerRadius = 5.0;
        [footer addSubview:exitV];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:exitV.bounds];
        lab.font = [UIFont systemFontOfSize:18];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"退出登录";
        [exitV addSubview:lab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitClick)];
        [exitV addGestureRecognizer:tap];
        return footer;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArr[indexPath.section][indexPath.row];
    switch ([dic[kSettingType] integerValue]) {
        case SettingTypeSave:
        {
            AccountSafeVC *vc = [AccountSafeVC new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case SettingTypeBlackList:
        {
            BlackListVC *vc = [BlackListVC new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case SettingTypeGrade:
        {
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", kAPPID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            break;
        }
        case SettingTypeStatement:
        {
            ProtocolVC *vc = [ProtocolVC new];
            vc.titleStr = @"租我咯-用户协议";
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
