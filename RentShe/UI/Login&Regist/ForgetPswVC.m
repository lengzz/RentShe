//
//  ForgetPswVC.m
//  RentShe
//
//  Created by Lengzz on 2017/7/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ForgetPswVC.h"
#import "VerifyVC.h"

@interface ForgetPswVC ()<UITextFieldDelegate>
{
    UIImageView *_phoneImg;
}
@property (nonatomic, strong) UITextField *phoneTF;
@end

@implementation ForgetPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.prefersNavigationBarHidden = YES;
    [self createV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createV
{
    self.view.backgroundColor = kRGB_Value(0xfde23d);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 22, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"setting_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 101.25, kWindowHeight/2.0 - 214, 202.5, 58.5)];
    backImg.image = [UIImage imageNamed:@"regist_back"];
    [self.view addSubview:backImg];
    //手机号
    UIView *infoV = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 113, 228, 44)];
    infoV.backgroundColor = [UIColor whiteColor];
    infoV.layer.masksToBounds = YES;
    infoV.layer.cornerRadius = 5.0;
    [self.view addSubview:infoV];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    phoneImg.image = [UIImage imageNamed:@"login_phone"];
    [infoV addSubview:phoneImg];
    _phoneImg = phoneImg;
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(20 + 30, 12, 228 - 30 - 20 - 20, 20)];
    phoneTF.placeholder = @"请输入您的手机号码";
    phoneTF.font = [UIFont systemFontOfSize:13];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.delegate = self;
    [phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTF = phoneTF;
    [infoV addSubview:phoneTF];
    
    UIButton *takeCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takeCodeBtn.frame = CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 44, 228, 44);
    takeCodeBtn.layer.masksToBounds = YES;
    takeCodeBtn.layer.cornerRadius = 5.0;
    takeCodeBtn.backgroundColor = kRGB_Value(0x442509);
    [takeCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [takeCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    takeCodeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:takeCodeBtn];
    [takeCodeBtn addTarget:self action:@selector(takeCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)takeCodeClick:(UIButton *)btn
{
    if (self.phoneTF.text.length < 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码"];
        return;
    }
    btn.enabled = NO;
    [NetAPIManager takeCode:@{@"mobile":self.phoneTF.text,@"identification":MD5Str([NSString stringWithFormat:@"mobile%@",self.phoneTF.text])} callBack:^(BOOL success, id object) {
        btn.enabled = YES;
        if (success) {
            [self nextStep];
        }
    }];
}


- (void)nextStep
{
    VerifyVC *ctl = [VerifyVC new];
    ctl.phoneNum = self.phoneTF.text;
    ctl.isModify = YES;
    __weak __typeof(self) wself = self;
    ctl.regetBlock = ^{
        [wself regetCode];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 11)
    {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTF endEditing:YES];
    [_phoneImg setImage:[UIImage imageNamed:@"login_phone"]];
}

- (void) regetCode
{
    [NetAPIManager takeCode:@{@"mobile":self.phoneTF.text,@"identification":MD5Str([NSString stringWithFormat:@"mobile%@",self.phoneTF.text])} callBack:^(BOOL success, id object) {
        if (success) {
            
        }
    }];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_phoneImg setImage:[UIImage imageNamed:@"login_phone_selected"]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_phoneImg setImage:[UIImage imageNamed:@"login_phone"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
