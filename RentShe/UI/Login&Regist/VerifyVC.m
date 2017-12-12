//
//  VerifyVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "VerifyVC.h"
#import "InfoRegistVC.h"
#import "ModifyPswVC.h"

@interface VerifyVC ()
{
    UILabel *_regetLab;
    UILabel *_timeLab;
    UIView *_regetV;
    NSInteger _second;
}
@property (nonatomic, strong) UITextField *captchaTF;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation VerifyVC

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createV];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
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
    //验证码
    UIView *infoV = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 113, 228, 44)];
    infoV.backgroundColor = [UIColor whiteColor];
    infoV.layer.masksToBounds = YES;
    infoV.layer.cornerRadius = 5.0;
    [self.view addSubview:infoV];
    
    UITextField *captchaTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 12, 228 - 30 - 81, 20)];
    captchaTF.placeholder = @"输入验证码";
    captchaTF.font = [UIFont systemFontOfSize:13];
//    captchaTF.keyboardType = UIKeyboardTypeNumberPad;
    [captchaTF addTarget: self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.captchaTF = captchaTF;
    [infoV addSubview:captchaTF];
    
    UIView *regetV = [[UIView alloc] initWithFrame:CGRectMake(228 - 81, 0, 81, 44)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regetCode:)];
    [regetV addGestureRecognizer:tap];
    _regetV = regetV;
    regetV.backgroundColor = kRGB_Value(0x442509);
    [infoV addSubview:regetV];
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
    regetLab.text = @"重新获取";
    _regetLab = regetLab;
    [regetV addSubview:regetLab];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 44, 228, 44);
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5.0;
    nextBtn.backgroundColor = kRGB_Value(0x442509);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _second = 60;
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)countDown
{
    _second --;
    if (_second == 0)
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
        _timeLab.text = [NSString stringWithFormat:@"%lds后",_second];
        _timeLab.hidden = NO;
        _regetV.userInteractionEnabled = NO;
        _regetLab.frame = CGRectMake(0, 22, 81, 20);
        _regetLab.textColor = kRGB_Value(0x282828);
        _regetV.backgroundColor = kRGB_Value(0xc3c3c3);
    }
}

- (void)regetCode:(UIGestureRecognizer *)tap
{
    _second = 60;
    [self.timer setFireDate:[NSDate distantPast]];
    if (self.regetBlock)
    {
        self.regetBlock();
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 11)
    {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (void)nextClick:(UIButton *)btn
{
    if (!self.captchaTF.text.length) {
        return;
    }
    [NetAPIManager verifyCode:@{@"mobile":self.phoneNum,@"captcha":self.captchaTF.text} callBack:^(BOOL success, id object) {
        if (success) {
            [self jumpVC];
        }
    }];
}

- (void)jumpVC
{
    if (_isModify)
    {
        ModifyPswVC *ctl = [ModifyPswVC new];
        ctl.phoneNum = self.phoneNum;
        ctl.captchaNum = self.captchaTF.text;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else
    {
        InfoRegistVC *ctl = [InfoRegistVC new];
        ctl.phoneNum = self.phoneNum;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
