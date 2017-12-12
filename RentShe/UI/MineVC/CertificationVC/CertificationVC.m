//
//  CertificationVC.m
//  RentShe
//
//  Created by Lengzz on 2017/11/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CertificationVC.h"

@interface CertificationVC ()<UITextFieldDelegate>
{
    UITextField *_nameTF;
    UITextField *_idTF;
    UIButton *_submitBtn;
}
@end

@implementation CertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self createV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    self.view.backgroundColor = kRGB_Value(0xf2f2f2);
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"实名认证"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)createV
{
    if ([UserDefaultsManager getCertified])
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10, kNavBarHeight + 10, kWindowWidth - 20, 80)];
        v.backgroundColor = [UIColor whiteColor];
        v.layer.cornerRadius = 5.0;
        v.layer.masksToBounds = YES;
        [self.view addSubview:v];
        
        UIImageView *certificationImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_certification_ok"]];
        certificationImg.frame = CGRectMake(20, 23, 20, 14);
        [v addSubview:certificationImg];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 100, 20)];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = kRGB(51, 51, 51);
        lab.text = @"身份证认证";
        [v addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, kWindowWidth - 60, 35)];
        lab1.font = [UIFont systemFontOfSize:13];
        lab1.textColor = kRGB(138, 138, 138);
        lab1.numberOfLines = 2;
        lab1.text = @"绑定身份证号码可获得实名认证，提高聊天机率，提现交易安全便捷";
        [v addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(v.width - 120, 20, 100, 20)];
        lab2.font = [UIFont systemFontOfSize:15];
        lab2.textAlignment = NSTextAlignmentRight;
        lab2.textColor = [UIColor greenColor];
        lab2.text = @"已认证";
        [v addSubview:lab2];
    }
    else
    {
        for (NSInteger i = 0; i < 2; i++)
        {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 10 + 54 * i, kWindowWidth, 44)];
            v.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:v];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 60, 20)];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = kRGB(51, 51, 51);
            [v addSubview:lab];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, kWindowWidth - 80 - 15, 30)];
            textField.delegate = self;
            textField.borderStyle = UITextBorderStyleNone;
            textField.font = [UIFont systemFontOfSize:15];
            textField.textColor = kRGB(51, 51, 51);
            [textField addTarget:self action:@selector(textFieldClick) forControlEvents:UIControlEventEditingChanged];
            [v addSubview:textField];
            
            switch (i) {
                case 0:
                    lab.text = @"姓名";
                    textField.placeholder = @"请输入身份证上的姓名";
                    _nameTF = textField;
                    break;
                    
                case 1:
                    lab.text = @"身份证";
                    textField.placeholder = @"请输入身份证号码";
                    _idTF = textField;
                    break;
                    
                default:
                    break;
            }
        }
        
        UIButton *submitBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(20, kWindowHeight/2.0 - 20, kWindowWidth - 40, 45);
        [submitBtn setBackgroundImage:[CustomNavVC imageWithColor:kRGB_Value(0xff751a)] forState:UIControlStateNormal];
        [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        submitBtn.adjustsImageWhenHighlighted = NO;
        submitBtn.layer.cornerRadius = 5.0;
        submitBtn.layer.masksToBounds = YES;
        [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submitBtn];
        submitBtn.enabled = NO;
        _submitBtn = submitBtn;
        
        UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(submitBtn.frame) + 10, kWindowWidth - 40, 20)];
        tipsLab.font = [UIFont systemFontOfSize:12];
        tipsLab.textAlignment = NSTextAlignmentCenter;
        tipsLab.textColor = [UIColor redColor];
        tipsLab.text = @"*目前只支持中国大陆";
        [self.view addSubview:tipsLab];
    }
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldClick
{
    if (_nameTF.text.length && _idTF.text.length)
    {
        _submitBtn.enabled = YES;
    }
}

- (void)submitClick:(UIButton *)btn
{
    btn.enabled = NO;
    [SVProgressHUD show];
    NSDictionary *dic = @{@"type":@"1",
                          @"realname":_nameTF.text,
                          @"idcard":_idTF.text};
    [NetAPIManager cardAuth:dic callBack:^(BOOL success, id object) {
        [SVProgressHUD dismiss];
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            [UserDefaultsManager setCertified:YES];
            [UserDefaultsManager updateUserInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"认证失败"];
        }
    }];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_nameTF.text.length && _idTF.text.length)
    {
        _submitBtn.enabled = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
