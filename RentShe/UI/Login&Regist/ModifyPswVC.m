//
//  ModifyPswVC.m
//  RentShe
//
//  Created by Lengzz on 2017/7/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ModifyPswVC.h"

@interface ModifyPswVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *pswTF;

@end

@implementation ModifyPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createV];
}

- (void)createV
{
    self.view.backgroundColor = kRGB_Value(0xfde23d);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, kStatusBarHeight + 2, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"setting_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 101.25, kWindowHeight/2.0 - 214, 202.5, 58.5)];
    backImg.image = [UIImage imageNamed:@"regist_back"];
    [self.view addSubview:backImg];
    //新密码
    UIView *infoV = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 113, 228, 44)];
    infoV.backgroundColor = [UIColor whiteColor];
    infoV.layer.masksToBounds = YES;
    infoV.layer.cornerRadius = 5.0;
    [self.view addSubview:infoV];
    
    UITextField *pswTF = [[UITextField alloc] initWithFrame:CGRectMake(20 , 12, 228 - 20 - 20, 20)];
    pswTF.placeholder = @"请输入新密码，至少8位";
    pswTF.font = [UIFont systemFontOfSize:13];
    pswTF.secureTextEntry = YES;
    pswTF.delegate = self;
    [pswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.pswTF = pswTF;
    [infoV addSubview:pswTF];
    
    UIButton *takeCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takeCodeBtn.frame = CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 44, 228, 44);
    takeCodeBtn.layer.masksToBounds = YES;
    takeCodeBtn.layer.cornerRadius = 5.0;
    takeCodeBtn.backgroundColor = kRGB_Value(0x442509);
    [takeCodeBtn setTitle:@"确定" forState:UIControlStateNormal];
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
    if (self.pswTF.text.length < 8) {
        [SVProgressHUD showErrorWithStatus:@"请至少输入8位新密码"];
        return;
    }
    btn.enabled = NO;
    [NetAPIManager modifyPsw:@{@"mobile":self.phoneNum,@"captcha":self.captchaNum,@"password":SHA1Str(MD5Str(self.pswTF.text))} callBack:^(BOOL success, id object) {
        btn.enabled = YES;
        if (success) {
            [SVProgressHUD showSuccessWithStatus:object[@"message"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self nextStep];
            });
        }
    }];
}


- (void)nextStep
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    [self.pswTF endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
