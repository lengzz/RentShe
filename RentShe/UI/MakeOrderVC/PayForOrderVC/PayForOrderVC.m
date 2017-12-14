//
//  PayForOrderVC.m
//  RentShe
//
//  Created by Lengzz on 2017/8/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "PayForOrderVC.h"
#import "PayForOrderM.h"
#import "PayForOrderCell.h"
#import "WXApi.h"
#import "WXApiManager.h"

@interface PayForOrderVC ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>
{
    PayType _payWay;
}
@property (nonatomic, strong) UITableView *myTabV;
@end

@implementation PayForOrderVC

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStyleGrouped];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
//        _myTabV.allowsMultipleSelection = YES;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _payWay = PayTypeOfSys;
    [self createNavbar];
    [self myTabV];
    [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [WXApiManager sharedManager].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"确认订单"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)paySuccess
{
    NSInteger index = self.navigationController.childViewControllers.count
    ;
    index -= 4;
    if (index < 0) {
        index = 0;
    }
    [self.navigationController popToViewController:self.navigationController.childViewControllers[index] animated:YES];
}

- (void)confirmPay
{
    switch (_payWay) {
        case PayTypeOfSys:
            [self payByWallet];
            break;
            
        case PayTypeOfWeChat:
            [self payByWeChat];
            break;
            
        case PayTypeOfZfb:
            [self payByZfb];
            break;
            
        default:
            break;
    }
}

- (void)payByWallet
{
    [NetAPIManager balancePay:@{@"order_num":self.orderM.order_num} callBack:^(BOOL success, id object) {
        if (success)
        {
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self paySuccess];
                [UserDefaultsManager updateUserInfo];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
        }
    }];
}

- (void)payByZfb
{
    [NetAPIManager zfbPay:@{@"order_num":self.orderM.order_num} callBack:^(BOOL success, id object) {
        if (success) {
            payByAlipay(object[@"data"], ^(BOOL isSuccess) {
                if (isSuccess)
                {
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
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section)
    {
        return 2;//3;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayForOrderInfoCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PayForOrderInfoCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB_Value(0x282828);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
        cell.detailTextLabel.textColor = kRGB_Value(0x989898);
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"预约时间";
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.orderM.meeting_time doubleValue]];
                cell.detailTextLabel.text = [kCommonConfig.dateFormatter stringFromDate:date];
                break;
            }
            case 1:
                cell.textLabel.text = @"预约地点";
                cell.detailTextLabel.text = self.orderM.addr_name;
                break;
            case 2:
                cell.textLabel.text = @"时长";
                cell.detailTextLabel.text = self.orderM.rent_hours;
                break;
//            case 3:
//                cell.textLabel.text = @"留言";
//                break;
            case 3:
                cell.textLabel.text = @"合计：";
                cell.detailTextLabel.textColor = kRGB(253, 99, 0);
                cell.detailTextLabel.text = [NSString stringWithFormat: @"¥ %@",self.orderM.rent_price];
                break;
            default:
                break;
        }
        return cell;
    }
    else
    {
        PayForOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayForOrderCell"];
        if (!cell) {
            cell = [[PayForOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayForOrderCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        switch (indexPath.row) {
            case 0:
                cell.tips = self.orderM.my_money;
                cell.type = PayTypeOfSys;
                break;
//            case 1:
//                cell.type = PayTypeOfWeChat;
//                break;
            case 1:
                cell.type = PayTypeOfZfb;
                break;
            default:
                break;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 44 + 25;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footer = [UIView new];
        footer.backgroundColor = [UIColor clearColor];
        UIView *exitV = [[UIView alloc] initWithFrame:CGRectMake(15, 25, kWindowWidth - 30, 44)];
        exitV.backgroundColor = kRGB_Value(0xff751a);
        exitV.layer.masksToBounds = YES;
        exitV.layer.cornerRadius = 5.0;
        [footer addSubview:exitV];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:exitV.bounds];
        lab.font = [UIFont systemFontOfSize:18];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"确认支付";
        [exitV addSubview:lab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmPay)];
        [exitV addGestureRecognizer:tap];
        return footer;
    }
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kWindowWidth - 30, 20)];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = kRGB(152, 152, 152);
    [header addSubview:lab];
    lab.text = section ? @"如果对方未赴约，租金原路返回":@"订单信息";

    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section)
    {
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_payWay - 1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    if (indexPath.row + 1 == _payWay)
    {
        return;
    }
    else
    {
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_payWay - 1 inSection:1] animated:YES];
        //隐藏微信支付
        _payWay = indexPath.row ? PayTypeOfZfb : PayTypeOfSys;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
