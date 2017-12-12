//
//  AccountSafeVC.m
//  RentShe
//
//  Created by Lengzz on 2017/10/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "AccountSafeVC.h"
#import "BindingVC.h"
#import "ForgetPswVC.h"

@interface AccountSafeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTabV;
@end

@implementation AccountSafeVC

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
    self.prefersNavigationBarHidden = NO;
    [self createNavbar];
    [self myTabV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"帐号与安全"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - _____UITableViewDelegate,UITableViewDataSource______

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"修改密码";
            break;
            
        case 1:
            cell.textLabel.text = @"绑定帐号";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ForgetPswVC *vc = [ForgetPswVC new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            BindingVC *vc = [BindingVC new];
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
