//
//  ChooseWeekVC.m
//  RentShe
//
//  Created by Lengzz on 2017/9/17.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ChooseWeekVC.h"
#import "ChooseWeekCell.h"


#define kCellIdentifier @"chooseweekcell"

@interface ChooseWeekVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTabV;
@end

@implementation ChooseWeekVC

- (NSMutableDictionary *)dayDic
{
    if (!_dayDic) {
        _dayDic = [NSMutableDictionary dictionary];
    }
    return _dayDic;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.allowsMultipleSelection = YES;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myTabV.rowHeight = 44;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavbar];
    [self myTabV];
    [self configData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"时间"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)configData
{
    if ([self.dayDic[kMon] integerValue]) {
        [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if ([self.dayDic[kTue] integerValue]) {
        [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if ([self.dayDic[kWed] integerValue]) {
        [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if ([self.dayDic[kThu] integerValue]) {
        [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if ([self.dayDic[kFri] integerValue]) {
        [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if ([self.dayDic[kSat] integerValue]) {
        [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if ([self.dayDic[kSun] integerValue]) {
        [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)backClick
{
    if (self.chooseBlock) {
        self.chooseBlock([self.dayDic copy]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseWeekCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[ChooseWeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"星期一";
            break;
        case 1:
            cell.textLabel.text = @"星期二";
            break;
        case 2:
            cell.textLabel.text = @"星期三";
            break;
        case 3:
            cell.textLabel.text = @"星期四";
            break;
        case 4:
            cell.textLabel.text = @"星期五";
            break;
        case 5:
            cell.textLabel.text = @"星期六";
            break;
        case 6:
            cell.textLabel.text = @"星期日";
            break;
            
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.dayDic setValue:@"1" forKey:kMon];
            break;
        case 1:
            [self.dayDic setValue:@"1" forKey:kTue];
            break;
        case 2:
            [self.dayDic setValue:@"1" forKey:kWed];
            break;
        case 3:
            [self.dayDic setValue:@"1" forKey:kThu];
            break;
        case 4:
            [self.dayDic setValue:@"1" forKey:kFri];
            break;
        case 5:
            [self.dayDic setValue:@"1" forKey:kSat];
            break;
        case 6:
            [self.dayDic setValue:@"1" forKey:kSun];
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.dayDic setValue:@"0" forKey:kMon];
            break;
        case 1:
            [self.dayDic setValue:@"0" forKey:kTue];
            break;
        case 2:
            [self.dayDic setValue:@"0" forKey:kWed];
            break;
        case 3:
            [self.dayDic setValue:@"0" forKey:kThu];
            break;
        case 4:
            [self.dayDic setValue:@"0" forKey:kFri];
            break;
        case 5:
            [self.dayDic setValue:@"0" forKey:kSat];
            break;
        case 6:
            [self.dayDic setValue:@"0" forKey:kSun];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
