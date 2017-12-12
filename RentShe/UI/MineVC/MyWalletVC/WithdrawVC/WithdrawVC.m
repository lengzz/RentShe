//
//  WithdrawVC.m
//  RentShe
//
//  Created by Lengzz on 2017/11/4.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "WithdrawVC.h"

@interface WithdrawVC ()<UITextFieldDelegate>
{
    UITextField *_nameTF;
    UITextField *_idTF;
    UITextField *_moneyTF;
    UIButton *_withdrawBtn;
}
@end

@implementation WithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self createV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"提现到支付宝"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)createV
{
    self.view.backgroundColor = kRGB(242, 242, 242);
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kWindowWidth, 20)];
    tipsLab.backgroundColor = kRGB(254, 171, 153);
    tipsLab.font = [UIFont systemFontOfSize:12];
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.text = @"请输入与姓名相对应的支付宝账号";
    tipsLab.textColor = [UIColor redColor];
    [self.view addSubview:tipsLab];
    
    for (NSInteger i = 0; i < 3; i++)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipsLab.frame) + 10 + 54 * i, kWindowWidth, 44)];
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
                textField.placeholder = @"请输入支付宝上对应的姓名";
                _nameTF = textField;
                break;
              
            case 1:
                lab.text = @"账号";
                textField.placeholder = @"请输入支付宝账号";
                _idTF = textField;
                break;
                
            case 2:
                lab.text = @"金额";
                textField.placeholder = [NSString stringWithFormat:@"提现金额（可提现%@元）",[UserDefaultsManager getMoney]];
                _moneyTF = textField;
                _moneyTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                break;
            default:
                break;
        }
    }
    
    UIButton *withdrawBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    withdrawBtn.frame = CGRectMake(20, kWindowHeight/2.0 - 20, kWindowWidth - 40, 45);
    [withdrawBtn setBackgroundImage:[CustomNavVC imageWithColor:kRGB_Value(0xff751a)] forState:UIControlStateNormal];
    [withdrawBtn setTitle:@"提交" forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    withdrawBtn.adjustsImageWhenHighlighted = NO;
    withdrawBtn.layer.cornerRadius = 5.0;
    withdrawBtn.layer.masksToBounds = YES;
    [withdrawBtn addTarget:self action:@selector(withdrawClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withdrawBtn];
    withdrawBtn.enabled = NO;
    _withdrawBtn = withdrawBtn;
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldClick
{
    if (_moneyTF.text.length && _idTF.text.length && _moneyTF.text.length)
    {
        _withdrawBtn.enabled = YES;
    }
}

- (void)withdrawClick:(UIButton *)btn
{
    btn.enabled = NO;
    [SVProgressHUD show];
    NSDictionary *dic = @{@"type":@"1",
                          @"realname":_nameTF.text,
                          @"payee_account":_idTF.text,
                          @"price":_moneyTF.text};
    [NetAPIManager withdraw:dic callBack:^(BOOL success, id object) {
        [SVProgressHUD dismiss];
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"提现成功"];
            [UserDefaultsManager updateUserInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"提现失败"];
        }
    }];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_moneyTF])
    {
        if (!_moneyTF.text.length) {
            return;
        }
        NSInteger price = [_moneyTF.text integerValue];
        if (price < 1)
        {
            _moneyTF.text = @"";
            return;
        }
        _moneyTF.text = [NSString stringWithFormat:@"%ld",(long)price];
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
