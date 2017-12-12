//
//  BindingVC.m
//  RentShe
//
//  Created by Lengzz on 2017/10/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "BindingVC.h"
#import "BindMobileVC.h"
#import <UMSocialCore/UMSocialCore.h>

@interface BindingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _mobile;
    BOOL _qq;
    BOOL _wx;
}
@property (nonatomic, strong) UITableView *myTabV;
@end

@implementation BindingVC

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
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"绑定帐号"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    [NetAPIManager getBindingInfoWithCallBack:^(BOOL success, id object) {
        if (success) {
            _mobile = [object[@"mobile"] boolValue];
            _qq = [object[@"openid_qq"] boolValue];
            _wx = [object[@"openid_wx"] boolValue];
            [self.myTabV reloadData];
        }
    }];
}

- (void)bindOrUndraw:(id)params bind:(BOOL)isBind
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic setValue:@(isBind) forKey:@"bind"];
    [NetAPIManager bindOrUndrawAccount:dic callBack:^(BOOL success, id object) {
        if (success) {
            [self requestData];
            [SVProgressHUD showSuccessWithStatus:object[@"message"]];
        }
    }];
}

- (void)bindWithType:(LoginType)type
{
    switch (type) {
        case LoginTypeQQ:
            if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ])
            {
                [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"没有安装QQ"];
            }
            break;
            
        case LoginTypeWechat:
            if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession])
            {
                [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"没有安装微信"];
            }
            break;
            
        default:
            break;
    }
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    NSNumber *bindType;
    if (platformType == UMSocialPlatformType_QQ)
    {
        bindType = @0;
    }
    else if (platformType == UMSocialPlatformType_WechatSession)
    {
        bindType = @1;
    }
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        if (!error)
        {
            NSDictionary *dic = @{@"openid":resp.openid,
                                  @"bind_type":bindType};
            [self bindOrUndraw:dic bind:YES];
        }
    }];
}

- (void)undrawAccountConfirm:(id)params
{
    
    UIAlertController *ctl = [UIAlertController alertControllerWithTitle:@"确定解绑" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self bindOrUndraw:params bind:NO];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ctl addAction:confirm];
    [ctl addAction:cancel];
    [self presentViewController:ctl animated:YES completion:nil];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mobileCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mobileCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB_Value(0x282828);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"手机号";
        if (_mobile)
        {
            cell.detailTextLabel.textColor = kRGB(152, 152, 152);
            cell.detailTextLabel.text = @"已绑定";
        }
        else
        {
            cell.detailTextLabel.textColor = kRGB(255, 0, 0);
            cell.detailTextLabel.text = @"绑定手机号";
        }
        return cell;
    }
    else if (indexPath.section ==1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB_Value(0x282828);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 24)];
        }
        UIImageView *accessoryImg = (UIImageView *)cell.accessoryView;
        switch (indexPath.row) {
            case 0:
            {
                if (_wx)
                {
                    accessoryImg.image = [UIImage imageNamed:@"setting_unwrap"];
                }
                else
                {
                    accessoryImg.image = [UIImage imageNamed:@"setting_bind"];
                }
                cell.textLabel.text = @"微信";
                break;
            }
            case 1:
            {
                if (_qq)
                {
                    accessoryImg.image = [UIImage imageNamed:@"setting_unwrap"];
                }
                else
                {
                    accessoryImg.image = [UIImage imageNamed:@"setting_bind"];
                }
                cell.textLabel.text = @"QQ";
                break;
            }
            default:
                break;
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 10;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!section) {
        UIView *footer = [UIView new];
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
    v.backgroundColor = [UIColor clearColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 2, 16)];
    line.backgroundColor = kRGB_Value(0xff751a);
    [v addSubview:line];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, kWindowWidth - 60, 16)];
    titleLab.textColor = kRGB_Value(0x989898);
    titleLab.font = [UIFont systemFontOfSize:16];
    [v addSubview:titleLab];
    titleLab.text = @"其他平台帐号绑定";
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        if (_mobile)
        {
            return;
        }
        BindMobileVC *vc = [BindMobileVC new];
        __block typeof(self) wself = self;
        vc.bindSuccess = ^{
            [wself requestData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                if (_wx)
                {
                    [self undrawAccountConfirm:@{@"bind_type":@1}];
                }
                else
                {
                    [self bindWithType:LoginTypeWechat];
                }
                break;
            }
            case 1:
            {
                if (_qq)
                {
                    [self undrawAccountConfirm:@{@"bind_type":@1}];
                }
                else
                {
                    [self bindWithType:LoginTypeQQ];
                }
                break;
            }
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
