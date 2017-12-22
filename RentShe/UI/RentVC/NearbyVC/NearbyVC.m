//
//  NearbyVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "NearbyVC.h"
#import "NearbyCell.h"
#import "NearbyM.h"

#import "RentDetailVC.h"

@interface NearbyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _index;
    UIButton *_maleBtn,*_femaleBtn;
}
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation NearbyVC

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
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 64 - 49) style:UITableViewStylePlain];
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myTabV.tableHeaderView = [self headerView];
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (UIView *) headerView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 36)];
    header.backgroundColor = [UIColor whiteColor];
    for (NSInteger i = 0; i < 2; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i ? (kWindowWidth/2.0 + 20) : (kWindowWidth/2.0 - 20 - 36), 0, 36, 36);
        [btn setTitle: i ? @"女":@"男" forState:UIControlStateNormal];
        [btn setTitleColor:kRGB(40, 40, 40) forState:UIControlStateNormal];
        [btn setTitleColor:kRGB(253, 226, 61) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(choiceGender:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:btn];
        if (i)
        {
            _femaleBtn = btn;
            btn.selected = YES;
        }
        else
        {
            _maleBtn = btn;
        }
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 35.5, kWindowWidth, 0.5)];
    line.backgroundColor = kRGB(227, 227, 229);
    [header addSubview:line];
    
    return header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self myTabV];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.myTabV.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    self.myTabV.mj_footer = footer;
    
    [self.myTabV.mj_header beginRefreshing];
}

- (void)choiceGender:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    if ([btn isEqual:_maleBtn])
    {
        _femaleBtn.selected = NO;
    }
    else
    {
        _maleBtn.selected = NO;
    }
    [self.myTabV.mj_header beginRefreshing];
}

- (void) requestNewData
{
    _index = 1;
    NSDictionary *params = @{
                             @"city_code":[UserDefaultsManager getCurCityCode],
                             @"lng":[UserDefaultsManager getUserLng],
                             @"lat":[UserDefaultsManager getUserLat],
                             @"page":@(_index),
                             @"gender":@(_femaleBtn.selected)
                             };
    [NetAPIManager nearbyPeople:params callBack:^(BOOL success, id object) {
        [self.myTabV.mj_header endRefreshing];
        if (success) {
            NSArray *arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                [self.myTabV.mj_footer resetNoMoreData];
                [self.dataArr removeAllObjects];
                for (id obj in arr) {
                    NearbyM *model = [NearbyM new];
                    [model setValuesForKeysWithDictionary:obj];
                    [self.dataArr addObject:model];
                }
                [self.myTabV reloadData];
            }
        }
    }];
}

- (void) requestMoreData
{
    _index ++;
    NSDictionary *params = @{
                             @"city_code":[UserDefaultsManager getCurCityCode],
                             @"lng":[UserDefaultsManager getUserLng],
                             @"lat":[UserDefaultsManager getUserLat],
                             @"page":@(_index),
                             @"gender":@(_femaleBtn.selected)
                             };
    [NetAPIManager nearbyPeople:params callBack:^(BOOL success, id object) {
        [self.myTabV.mj_footer endRefreshing];
        if (success)
        {
            NSArray *arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                if (!arr.count) {
                    [self.myTabV.mj_footer endRefreshingWithNoMoreData];
                }
                for (id obj in arr) {
                    NearbyM *model = [NearbyM new];
                    [model setValuesForKeysWithDictionary:obj];
                    [self.dataArr addObject:model];
                }
                [self.myTabV reloadData];
            }
        }
        else
        {
            [self.myTabV.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark -
#pragma mark - _______UITableViewDelegate,UITableViewDataSource_______
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.navC) {
        return;
    }
    RentDetailVC *vc = [RentDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    NearbyM *model = self.dataArr[indexPath.row];
    vc.infoM = model;
    vc.user_id = model.user_info.user_id;
    vc.isSelf = [[UserDefaultsManager getUserId] isEqualToString:model.user_info.user_id];
    [self.navC pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyCell *cell = [tableView 	dequeueReusableCellWithIdentifier:@"nearbyCell"];
    if (!cell) {
        cell = [[NearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nearbyCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell refreshCell:self.dataArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
