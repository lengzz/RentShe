//
//  RechargeVC.m
//  RentShe
//
//  Created by Lengzz on 2017/11/4.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RechargeVC.h"
#import "WXApi.h"
#import "WXApiManager.h"

#define kBtnWidth (kWindowWidth - 80)/3.0

@interface RechargeVC ()<UITextFieldDelegate,WXApiManagerDelegate>
{
    UIImageView *_wayImg;
    UIButton *_moneyBtn;
    UITextField *_moneyTF;
    /**
     *  2 支付宝
     */
    NSInteger _rechargeWay;
}
@end

@implementation RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self createV];
    [WXApiManager sharedManager].delegate = self;
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
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"充值"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)createV
{
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *moneryArr = @[@1000,@500,@200,@100,@50,@20];
    for (NSInteger i = 0; i < 6; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i%3 *(kBtnWidth + 20) + 20, i/3*60 + 20 + kNavBarHeight, kBtnWidth, 40);
        [btn setBackgroundImage:[CustomNavVC imageWithColor:kRGB(242, 242, 242)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[CustomNavVC imageWithColor:kRGB_Value(0xff751a)] forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@"%@元",moneryArr[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.adjustsImageWhenHighlighted = NO;
        btn.layer.cornerRadius = 5.0;
        btn.layer.masksToBounds = YES;
        btn.tag = [moneryArr[i] integerValue];
        [btn addTarget:self action:@selector(moneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (!i) {
            _moneyBtn = btn;
            btn.selected = YES;
        }
    }
    
    UITextField *moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(kWindowWidth/4.0, 150 + kNavBarHeight, kWindowWidth/2.0, 30)];
    moneyTF.borderStyle = UITextBorderStyleNone;
    moneyTF.placeholder = @"请输入充值金额(元)";
    moneyTF.textAlignment = NSTextAlignmentCenter;
    moneyTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    moneyTF.delegate = self;
    [moneyTF addTarget:self action:@selector(moneyTFClick) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:moneyTF];
    _moneyTF = moneyTF;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(moneyTF.frame) + 5, kWindowWidth - 40, 1)];
    line.backgroundColor = kRGB(242, 242, 242);
    [self.view addSubview:line];
    
    for (NSInteger i = 0; i < 1; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + i * 60 + 20, kWindowWidth, 60)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wayClick:)];
        [v addGestureRecognizer:tap];
        v.tag = i + 1;
        [self.view addSubview:v];
        
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 17.5, 25, 25)];
        iconImg.image = [UIImage imageNamed:@"pay_alipay"];//[UIImage imageNamed:(i ? @"pay_alipay" : @"pay_weixin")];
        [v addSubview:iconImg];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(64, 10, kWindowWidth/2.0, 20)];
        nameLab.textColor = kRGB(51, 51, 51);
        nameLab.font = [UIFont systemFontOfSize:16];
        nameLab.text = @"支付宝";//i ? @"支付宝" : @"微信";
        [v addSubview:nameLab];
        
        UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(64, 30, kWindowWidth/2.0, 15)];
        tipsLab.textColor = kRGB(138, 138, 138);
        tipsLab.font = [UIFont systemFontOfSize:13];
        tipsLab.text = @"充值";
        [v addSubview:tipsLab];
        
        UIImageView *wayImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth - 40, 20, 20, 20)];
        wayImg.image = [UIImage new];
        wayImg.tag = 110;
        [v addSubview:wayImg];
        if (!i) {
            wayImg.image = [UIImage imageNamed:@"rent_chooseweek"];
            _wayImg = wayImg;
            _rechargeWay = 2;
        }
    }
    
    UIButton *rechargeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.frame = CGRectMake(20, kWindowHeight - 100, kWindowWidth - 40, 45);
    [rechargeBtn setBackgroundImage:[CustomNavVC imageWithColor:kRGB_Value(0xff751a)] forState:UIControlStateNormal];
    [rechargeBtn setTitle:@"去充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rechargeBtn.adjustsImageWhenHighlighted = NO;
    rechargeBtn.layer.cornerRadius = 5.0;
    rechargeBtn.layer.masksToBounds = YES;
    [rechargeBtn addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(rechargeBtn.frame) - 50, kWindowWidth, 15)];
    tipsLab.textColor = kRGB(138, 138, 138);
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.font = [UIFont systemFontOfSize:13];
    tipsLab.text = @"点击充值，即表示已阅读并同意";
    tipsLab.hidden = YES;
    [self.view addSubview:tipsLab];
    
    UIView *v = [[UIView alloc] init];
    [self.view addSubview:v];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"充值协议" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:kRGB_Value(0xff751a) forState:UIControlStateNormal
     ];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [v addSubview:btn];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = kRGB(138, 138, 138);
    lab.text = @"，租我咯的充值金额全部可提现";
    [lab sizeToFit];
    [v addSubview:lab];
    v.hidden = YES;
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@20);
        make.bottom.equalTo(rechargeBtn.mas_top).offset(-15);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v.mas_left);
        make.centerY.equalTo(v.mas_centerY);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_right);
        make.centerY.equalTo(v.mas_centerY);
        make.right.equalTo(v);
    }];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moneyBtnClick:(UIButton *)btn
{
    if (!_moneyBtn)
    {
        _moneyBtn = btn;
        btn.selected = YES;
        return;
    }
    _moneyBtn.selected = NO;
    btn.selected = YES;
    _moneyBtn = btn;
    _moneyTF.text = @"";
}

- (void)protocolClick
{

}

- (void)moneyTFClick
{
    if (!_moneyTF.text.length) {
        _moneyBtn.selected = YES;
        return;
    }
    _moneyBtn.selected = NO;
    NSInteger price = [_moneyTF.text integerValue];
    if (price < 1) {
        _moneyBtn.selected = YES;
        _moneyTF.text = @"";
        return;
    }
}

- (void)paySuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rechargeClick
{
    if (_rechargeWay == 1) {
        [self payByWeChat];
        return;
    }
    NSDictionary *dic = @{@"type":@"1",@"price":_moneyTF.text.length ? _moneyTF.text : [NSString stringWithFormat:@"%zd",_moneyBtn.tag ]};
    [NetAPIManager recharge:dic callBack:^(BOOL success, id object) {
        if (success) {
            payByAlipay(object[@"data"], ^(BOOL isSuccess) {
                if (isSuccess)
                {
                    [UserDefaultsManager updateUserInfo];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self paySuccess];
                    });
                }
                else
                {
                    //                    [self payFailed];
                }
            });
        }
    }];
}

- (void)wayClick:(UIGestureRecognizer *)tap
{
    UIView *v = tap.view;
    UIImageView *wayImg = (UIImageView*)[v viewWithTag:110];
    if ([_wayImg isEqual:wayImg])
    {
        return;
    }
    _rechargeWay = v.tag;
    _wayImg.image = [UIImage new];
    wayImg.image = [UIImage imageNamed:@"rent_chooseweek"];
    _wayImg = wayImg;
}

- (void)payByWeChat
{
    if([WXApi isWXAppInstalled])
    {
        [SVProgressHUD showWithStatus:@"尚未安装微信"];
        return;
    }
    return;
    //    PayReq *request = [[PayReq alloc] init];
    //    request.partnerId = @"10000100";
    //    request.prepayId= @"1101000000140415649af9fc314aa427";
    //    request.package = @"Sign=WXPay";
    //    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    //    request.timeStamp= @"1397527777";
    //    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    //    [WXApi sendReq:request];
}

#pragma mark -
#pragma mark - WXApiManagerDelegate
- (void)managerDidPayResponse:(BOOL)response
{
    if (response) {//支付成功
        //        [self paySuccess];
        
    } else {//支付失败
        //        [self payFailed];
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!_moneyTF.text.length) {
        return;
    }
    NSInteger price = [_moneyTF.text integerValue];
    if (price < 1)
    {
        _moneyBtn.selected = YES;
        _moneyTF.text = @"";
        return;
    }
    _moneyTF.text = [NSString stringWithFormat:@"%ld",(long)price];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_moneyTF endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
