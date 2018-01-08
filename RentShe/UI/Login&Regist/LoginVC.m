//
//  LoginVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/20.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "LoginVC.h"
#import "RegistVC.h"
#import "ForgetPswVC.h"
#import "ShareToV.h"

#import <UMSocialCore/UMSocialCore.h>

@interface LoginVC ()<UITextFieldDelegate>
{
    UIImageView *_phoneImg;
    UIImageView *_pswImg;
    UIButton *_loginBtn;
}
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pswTF;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.prefersNavigationBarHidden = YES;
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = kRGB_Value(0xfde23d);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 22, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"setting_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(kWindowWidth - 60 - 15, 27, 60, 30);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:kRGB_Value(0x442509) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 130.25, kWindowHeight/2.0 - 114 - 80, 260.5, 114)];
    backImg.image = [UIImage imageNamed:@"login_back"];
    [self.view addSubview:backImg];
    //手机号 密码
    UIView *infoV = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 90, 228, 89)];
    infoV.backgroundColor = [UIColor whiteColor];
    infoV.layer.masksToBounds = YES;
    infoV.layer.cornerRadius = 5.0;
    [self.view addSubview:infoV];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, 228, .5)];
    line.backgroundColor = kRGB_Value(0xc3c3c3);
    [infoV addSubview:line];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    phoneImg.image = [UIImage imageNamed:@"login_phone"];
    [infoV addSubview:phoneImg];
    _phoneImg = phoneImg;
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(20 + 30, 12, 228 - 30 - 20 - 20, 20)];
    phoneTF.placeholder = @"手机号/QQ号";
    phoneTF.font = [UIFont systemFontOfSize:13];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.delegate = self;
    self.phoneTF = phoneTF;
    [infoV addSubview:phoneTF];
    
    UIImageView *pswImg = [[UIImageView alloc] initWithFrame:CGRectMake(15,44 + 12, 20, 20)];
    pswImg.image = [UIImage imageNamed:@"login_psw"];
    [infoV addSubview:pswImg];
    _pswImg = pswImg;
    UITextField *pswTF = [[UITextField alloc] initWithFrame:CGRectMake(20 + 30, 44 + 12, 228 - 30 - 20 - 20, 20)];
    pswTF.placeholder = @"8-30位数字或英文";
    pswTF.font = [UIFont systemFontOfSize:13];
    pswTF.secureTextEntry = YES;
    pswTF.delegate = self;
    self.pswTF = pswTF;
    [infoV addSubview:pswTF];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 + 25, 228, 44);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5.0;
    loginBtn.backgroundColor = kRGB_Value(0x442509);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(kWindowWidth/2.0 - 50, kWindowHeight/2.0 + 25 + 44 + 25, 100, 30);
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:kRGB_Value(0x282828) forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:registBtn];
    [registBtn addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (!ShareToV.isShare) {
        return;
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 60, kWindowHeight - 100, 120, 15)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = kRGB_Value(0x282828);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"使用其他方式";
    [self.view addSubview:lab];
    
    NSArray *arr = @[
                     @{@"name":@"微信",
                       @"img":@"login_wechat",
                       @"type":@(LoginTypeWechat)},
                     @{@"name":@"QQ",
                       @"img":@"login_QQ",
                       @"type":@(LoginTypeQQ)}];
    CGFloat interval = 62;
    CGFloat x = kWindowWidth/2.0 - (arr.count * (31 + interval) - interval)/2.0;
    for (NSInteger i = 0; i < arr.count; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, kWindowHeight - 60, 31, 45)];
        x = x + 31 + interval;
        v.tag = [arr[i][@"type"] integerValue];
        [self.view addSubview:v];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherLogin:)];
        [v addGestureRecognizer:tap];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];
        img.image = [UIImage imageNamed:arr[i][@"img"]];
        [v addSubview:img];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, 31, 14)];
        lab.font = [UIFont systemFontOfSize:10];
        lab.text = arr[i][@"name"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = kRGB_Value(0x282828);
        [v addSubview:lab];
    }
}

- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)forgetClick
{
    [self.navigationController pushViewController:[ForgetPswVC new] animated:YES];
}

- (void)loginClick:(UIButton *)btn
{
    if (!self.pswTF.text.length || !self.phoneTF.text.length) {
        return;
    }
    [self requestLogin:@{@"password":SHA1Str(MD5Str(self.pswTF.text)),@"mobile":self.phoneTF.text} withType:LoginTypePhone];
}

- (void)registClick
{
    [self.navigationController pushViewController:[RegistVC new] animated:YES];
}

- (void)otherLogin:(UIGestureRecognizer *)tap
{
    UIView *v = tap.view;
    switch (v.tag) {
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
    LoginType type;
    if (platformType == UMSocialPlatformType_QQ)
    {
        type = LoginTypeQQ;
    }
    else if (platformType == UMSocialPlatformType_WechatSession)
    {
        type = LoginTypeWechat;
    }
    else
    {
        return;
    }
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        if (!error)
        {
            NSNumber *gender = @0;
            if ([resp.unionGender isEqualToString:@"女"]) {
                gender = @1;
            }
            NSDictionary *dic = @{@"openid":resp.openid,
                                  @"nickname":resp.name,
                                  @"avatar":resp.iconurl,
                                  @"gender":gender};
            [self requestLogin:dic withType:type];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_phoneImg setImage:[UIImage imageNamed:@"login_phone"]];
    [_pswImg setImage:[UIImage imageNamed:@"login_psw"]];
}

#pragma mark -
#pragma mark - 网络请求

- (void) requestLogin:(id)obj withType:(LoginType)type
{
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSMutableDictionary *params = [obj mutableCopy];
    [params setValue:@(type) forKey:@"login_type"];
    [NetAPIManager login:params callBack:^(BOOL success, id object) {
        if (success)
        {
            NSLog(@"%@",object);
            [UserDefaultsManager login:object[@"data"]];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            NSLog(@"%@",@"AAAAA");
        }
    }];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_phoneTF])
    {
        [_phoneImg setImage:[UIImage imageNamed:@"login_phone_selected"]];
    }
    else if ([textField isEqual:_pswTF])
    {
        [_pswImg setImage:[UIImage imageNamed:@"login_psw_selected"]];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_phoneTF])
    {
        [_phoneImg setImage:[UIImage imageNamed:@"login_phone"]];
    }
    else if ([textField isEqual:_pswTF])
    {
        [_pswImg setImage:[UIImage imageNamed:@"login_psw"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
