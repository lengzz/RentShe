//
//  BindMobileVC.m
//  RentShe
//
//  Created by Lengzz on 2017/10/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "BindMobileVC.h"

@interface BindMobileVC ()<UITextFieldDelegate>
{
    UIImageView *_phoneImg;
    UILabel *_regetLab;
    UILabel *_timeLab;
    UIView *_regetV;
    NSInteger _second;
}
@property (nonatomic, strong) UITextField *captchaTF;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextField *phoneTF;
@end

@implementation BindMobileVC

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

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
    
    UIView *codeV = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 113 + 64, 228, 44)];
    codeV.backgroundColor = [UIColor whiteColor];
    codeV.layer.masksToBounds = YES;
    codeV.layer.cornerRadius = 5.0;
    [self.view addSubview:codeV];
    
    UITextField *captchaTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 12, 228 - 30 - 81, 20)];
    captchaTF.placeholder = @"输入验证码";
    captchaTF.font = [UIFont systemFontOfSize:13];
    [captchaTF addTarget: self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.captchaTF = captchaTF;
    [codeV addSubview:captchaTF];
    
    UIView *regetV = [[UIView alloc] initWithFrame:CGRectMake(228 - 81, 0, 81, 44)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regetCode:)];
    [regetV addGestureRecognizer:tap];
    _regetV = regetV;
    regetV.backgroundColor = kRGB_Value(0x442509);
    [codeV addSubview:regetV];
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 81, 13)];
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.textColor = kRGB_Value(0x282828);
    timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab = timeLab;
    [regetV addSubview:timeLab];
    
    UILabel *regetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 81, 13)];
    regetLab.font = [UIFont systemFontOfSize:13];
    regetLab.textColor = kRGB_Value(0x282828);
    regetLab.textAlignment = NSTextAlignmentCenter;
    regetLab.text = @"获取验证码";
    _regetLab = regetLab;
    [regetV addSubview:regetLab];
    
    UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bindBtn.frame = CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 113 + 64 + 44 + 30, 228, 44);
    bindBtn.layer.masksToBounds = YES;
    bindBtn.layer.cornerRadius = 5.0;
    bindBtn.backgroundColor = kRGB_Value(0x442509);
    [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bindBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:bindBtn];
    [bindBtn addTarget:self action:@selector(bindClick:) forControlEvents:UIControlEventTouchUpInside];
    [self countDown];
    
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)countDown
{
    _second --;
    if (_second <= 0)
    {
        [self.timer setFireDate:[NSDate distantFuture]];
        _timeLab.hidden = YES;
        _regetV.userInteractionEnabled = YES;
        _regetLab.frame = _regetV.bounds;
        _regetLab.textColor = [UIColor whiteColor];
        _regetV.backgroundColor = kRGB_Value(0x442509);
    }
    else
    {
        _timeLab.text = [NSString stringWithFormat:@"%zds后",_second];
        _timeLab.hidden = NO;
        _regetV.userInteractionEnabled = NO;
        _regetLab.frame = CGRectMake(0, 22, 81, 20);
        _regetLab.textColor = kRGB_Value(0x282828);
        _regetV.backgroundColor = kRGB_Value(0xc3c3c3);
    }
}

- (void)regetCode:(UIGestureRecognizer *)tap
{
    if (self.phoneTF.text.length < 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码"];
        return;
    }
    _second = 60;
    _regetV.userInteractionEnabled = NO;
    [NetAPIManager takeCode:@{@"mobile":self.phoneTF.text,@"identification":MD5Str([NSString stringWithFormat:@"mobile%@",self.phoneTF.text])} callBack:^(BOOL success, id object) {
        if (success) {
            [self.timer setFireDate:[NSDate distantPast]];
        }
    }];
}

-(void)bindClick:(UIButton *)btn
{
    if (self.phoneTF.text.length < 11 || self.captchaTF.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号和验证码"];
        return;
    }
    btn.enabled = NO;
    NSDictionary *dic = @{@"mobile":self.phoneTF.text,@"captcha":self.captchaTF.text};
    [NetAPIManager bindMobilePhone:dic callBack:^(BOOL success, id object) {
        btn.enabled = YES;
        if (success) {
            [SVProgressHUD showSuccessWithStatus:object[@"message"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.bindSuccess) {
                    self.bindSuccess();
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }
    }];
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
    [self.view endEditing:YES];
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
    if ([textField isEqual:_phoneTF]) {
        [_phoneImg setImage:[UIImage imageNamed:@"login_phone_selected"]];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_phoneTF]) {
        [_phoneImg setImage:[UIImage imageNamed:@"login_phone"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
