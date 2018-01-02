//
//  MyRentInfoVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/27.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MyRentInfoVC.h"
#import "RentInfoTimeCell.h"
#import "TipsV.h"

#import "NearbyM.h"

#import "AddRentSkillVC.h"
#import "ChooseWeekVC.h"
#import "EditInfoVC.h"

@interface MyRentInfoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_showBtn;
}

@property (nonatomic, strong) NearbyM *myInfo;

@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSDictionary *weekDic;
@end

@implementation MyRentInfoVC

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStyleGrouped];
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBar];
    [self requestData];
}

- (void)createNavBar
{
    self.view.backgroundColor = kRGB_Value(0xf2f2f2);
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"我的技能"]];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.frame = CGRectMake(0, 0, 54, 24);
    [showBtn setImage:[UIImage imageNamed:@"rentinfo_show"] forState:UIControlStateNormal];
    [showBtn setImage:[UIImage imageNamed:@"rentinfo_hidden"] forState:UIControlStateSelected];
    [showBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:showBtn]];
    _showBtn = showBtn;
}

- (void)showBtnClick:(UIButton *)btn
{
    if (!btn.selected) {
        TipsV *tips = [[TipsV alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
        __block typeof(self) wself = self;
        tips.clickBlock = ^(BOOL isOK)
        {
            if (isOK) {
                [wself changeRentInfo:NO];
            }
        };
        [tips show];
    }
    else
        [self changeRentInfo:YES];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteSkill:(UIButton *)btn
{
    NSInteger i = btn.tag - 1;
    if (self.dataArr.count > i && i >= 0) {
        [self.dataArr removeObjectAtIndex:i];
        [self.myTabV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)addSkill
{
    AddRentSkillVC *ctl = [[AddRentSkillVC alloc] init];
    __weak typeof(self) wself = self;
    ctl.skillBlock = ^(NSString *price, NSArray *skills)
    {
        RentSkillM *skillM = [RentSkillM new];
        skillM.price = price;
        skillM.layer_info = skills;
        [wself.dataArr addObject:skillM];
        [self.myTabV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestData
{
    [NetAPIManager myHomeInfoWithCallBack:^(BOOL success, id object) {
        if (success) {
            _myInfo = [NearbyM new];
            [_myInfo setValuesForKeysWithDictionary:object[@"data"]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if ([_myInfo.rent_info.mon integerValue]) {
                [dic setValue:@"1" forKey:kMon];
            }
            if ([_myInfo.rent_info.tue integerValue]) {
                [dic setValue:@"1" forKey:kTue];
            }
            if ([_myInfo.rent_info.wed integerValue]) {
                [dic setValue:@"1" forKey:kWed];
            }
            if ([_myInfo.rent_info.thu integerValue]) {
                [dic setValue:@"1" forKey:kThu];
            }
            if ([_myInfo.rent_info.fri integerValue]) {
                [dic setValue:@"1" forKey:kFri];
            }
            if ([_myInfo.rent_info.sat integerValue]) {
                [dic setValue:@"1" forKey:kSat];
            }
            if ([_myInfo.rent_info.sun integerValue]) {
                [dic setValue:@"1" forKey:kSun];
            }
            if (!_myInfo.rent_info.rental_start_time)
            {
                _myInfo.rent_info.rental_start_time = @"10";
            }
            if (!_myInfo.rent_info.rental_end_time)
            {
                _myInfo.rent_info.rental_end_time = @"18";
            }
            self.weekDic = [dic copy];
            _showBtn.selected = _myInfo.rent_info.display == 4 ? YES : NO;
            self.dataArr = [_myInfo.rent_skill mutableCopy];
            [self.myTabV reloadData];
        }
    }];
}

- (void)submitInfo
{
    if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
    {
        [SVProgressHUD showErrorWithStatus:@"允许租我咯访问定位后，才能发布出租。手机设置-隐私-定位服务-租我咯-使用期间"];
        return;
    }
    [NetAPIManager submitRentInfo:[self configParams] callBack:^(BOOL success, id object) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)changeRentInfo:(BOOL)isDisplay
{
    NSString *rent_id = self.myInfo.rent_info.rent_id ? self.myInfo.rent_info.rent_id : @"";
    NSDictionary *dic = @{@"rent_id":rent_id,
                          @"display":isDisplay ? @"3" : @"4"};
    [NetAPIManager changeRentInfo:dic callBack:^(BOOL success, id object) {
        if (success) {
            _showBtn.selected = !isDisplay;
        }
    }];
}

- (void)chooseWeek
{
    ChooseWeekVC *ctl = [[ChooseWeekVC alloc] init];
    ctl.dayDic = [self.weekDic mutableCopy];
    __weak typeof(self) wself = self;
    ctl.chooseBlock = ^(NSDictionary *dic)
    {
        wself.weekDic = dic;
        [wself.myTabV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSDictionary *)configParams
{
    NSMutableArray *skillArr = [NSMutableArray array];
    for (RentSkillM *skillM in self.dataArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:skillM.price forKey:@"price"];
        NSMutableArray *idArr = [NSMutableArray array];
        for (NSDictionary *skill in skillM.layer_info) {
            [idArr addObject:skill[@"skill_id"]];
        }
        [dic setValue:idArr forKey:@"skill_id"];
        [skillArr addObject:dic];
    }
    NSDictionary *dic = @{@"city_code":[UserDefaultsManager getCurCityCode],
                          @"rental_start_time":_myInfo.rent_info.rental_start_time,
                          @"rental_end_time":_myInfo.rent_info.rental_end_time,
                          @"rental_date":self.weekDic,
                          @"rental_skill":skillArr};
    return dic;
}

#pragma mark -
#pragma mark - _______UITableViewDelegate,UITableViewDataSource_______
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && indexPath.row == 1) {
        if (!_myInfo.user_info.vocation.length)
        {
            EditInfoVC *vc = [EditInfoVC new];
            vc.infoM = self.myInfo;
            __block typeof(self) wself = self;
            vc.isChange = ^{
                [wself requestData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 3;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && indexPath.row < 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rentCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rentCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB_Value(0x282828);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"年龄";
                cell.detailTextLabel.text = _myInfo ? _myInfo.user_info.age : @"";
                break;
            case 1:
                cell.textLabel.text = @"职业";
                cell.detailTextLabel.text = _myInfo ? _myInfo.user_info.vocation : @"";
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    else if (!indexPath.section)
    {
        RentInfoTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rentTimeCell"];
        if (!cell) {
            cell = [[RentInfoTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rentTimeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) wself = self;
            cell.chooseWeekBlock = ^(){
                [wself chooseWeek];
            };
            cell.timeBlock = ^(NSString *begin, NSString *end)
            {
                wself.myInfo.rent_info.rental_start_time = begin;
                wself.myInfo.rent_info.rental_end_time = end;
            };
        }
        cell.beginTime = [_myInfo.rent_info.rental_start_time floatValue];
        cell.endTime = [_myInfo.rent_info.rental_end_time floatValue];
        cell.dayDic = self.weekDic;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rentSkillCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"rentSkillCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB_Value(0x282828);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = kRGB(255, 117, 26);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"rentinfo_delete"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(deleteSkill:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(kWindowWidth - 45, 10, 30, 30);
            [cell.contentView addSubview:btn];
        }
        for (UIView *v in cell.contentView.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                v.tag = indexPath.row + 1;
                break;
            }
        }
        NSMutableString *string = [NSMutableString string];
        RentSkillM *skillM = self.dataArr[indexPath.row];
        NSArray *arr = skillM.layer_info;
        for (id obj in arr) {
            [string appendFormat:@"、%@",obj[@"skill_name"]];
        }
        if (string.length) {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        cell.textLabel.text = string;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/小时",skillM.price];
        cell.imageView.image = [CustomNavVC imageWithColor:[UIColor whiteColor]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && indexPath.row == 2)
    {
        return 44 + 67;
    }
    if (indexPath.section)
    {
        return 50;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 10;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!section) {
        return 10;
    }
    if (self.dataArr.count > 2) {
        return 44 + 10;
    }
    return 44 + 44 + 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!section) {
        UIView *footer = [UIView new];
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
    UIView *footer = [UIView new];
    CGFloat y = 10;
    if (self.dataArr.count < 3) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(15, y, kWindowWidth - 30, 44);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"rentinfo_add_back"] forState:UIControlStateNormal];
        addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [addBtn setTitle:@"添加技能主题" forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"rentinfo_add"] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [addBtn addTarget:self action:@selector(addSkill) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setTitleColor:kRGB(40, 40, 40) forState:UIControlStateNormal];
        y += 64;
        [footer addSubview:addBtn];
    }
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subBtn.frame = CGRectMake(15, y, kWindowWidth - 30, 44);
    [subBtn setTitle:self.dataArr.count ? @"修改信息" : @"提交申请" forState:UIControlStateNormal];
    subBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [subBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    subBtn.backgroundColor = kRGB(255, 101, 0);
    subBtn.layer.masksToBounds = YES;
    subBtn.layer.cornerRadius = 5.0;
    [footer addSubview:subBtn];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!section) {
        UIView *header = [UIView new];
        header.backgroundColor = [UIColor clearColor];
        return header;
    }
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = kRGB(40, 40, 40);
    lab.text = @"我的技能";
    [lab sizeToFit];
    lab.frame = CGRectMake(15, 22 - lab.bounds.size.height/2.0, lab.bounds.size.width, lab.bounds.size.height);
    [header addSubview:lab];
    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.font = [UIFont systemFontOfSize:12];
    tipsLab.textColor = kRGB(152, 152, 152);
    tipsLab.text = @"(最多添加3组)";
    [tipsLab sizeToFit];
    tipsLab.frame = CGRectMake(CGRectGetMaxX(lab.frame), CGRectGetMaxY(lab.frame) - tipsLab.bounds.size.height, tipsLab.bounds.size.width, tipsLab.bounds.size.height);
    [header addSubview:tipsLab];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, kWindowWidth - 15, 0.5)];
    line.backgroundColor = kRGB(227, 227, 229);
    [header addSubview:line];
    return header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
