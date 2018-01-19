//
//  DisFocusVC.m
//  RentShe
//
//  Created by Lzz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "DisFocusVC.h"
#import "DisFocusCell.h"

@interface DisFocusVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _index;
}
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DisFocusVC

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
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - kNavBarHeight - kTabBarHeight) style:UITableViewStylePlain];
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
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

- (void) requestNewData
{
    _index = 1;
//    NSDictionary *params = @{
//                             @"city_code":[UserDefaultsManager getCurCityCode],
//                             @"page":@(_index),
//                             @"gender":@(_femaleBtn.selected)
//                             };
//    [NetAPIManager nearbyPeople:params callBack:^(BOOL success, id object) {
//        [self.myTabV.mj_header endRefreshing];
//        if (success) {
//            NSArray *arr = object[@"data"];
//            if ([arr isKindOfClass:[NSArray class]])
//            {
//                [self.myTabV.mj_footer resetNoMoreData];
//                [self.dataArr removeAllObjects];
//                for (id obj in arr) {
//                    NearbyM *model = [NearbyM new];
//                    [model setValuesForKeysWithDictionary:obj];
//                    [self.dataArr addObject:model];
//                }
//                [self.myTabV reloadData];
//            }
//        }
//    }];
}

- (void) requestMoreData
{
    _index ++;
//    NSDictionary *params = @{
//                             @"city_code":[UserDefaultsManager getCurCityCode],
//                             @"page":@(_index),
//                             @"gender":@(_femaleBtn.selected)
//                             };
//    [NetAPIManager nearbyPeople:params callBack:^(BOOL success, id object) {
//        [self.myTabV.mj_footer endRefreshing];
//        if (success)
//        {
//            NSArray *arr = object[@"data"];
//            if ([arr isKindOfClass:[NSArray class]])
//            {
//                if (!arr.count) {
//                    [self.myTabV.mj_footer endRefreshingWithNoMoreData];
//                }
//                for (id obj in arr) {
//                    NearbyM *model = [NearbyM new];
//                    [model setValuesForKeysWithDictionary:obj];
//                    [self.dataArr addObject:model];
//                }
//                [self.myTabV reloadData];
//            }
//        }
//        else
//        {
//            [self.myTabV.mj_footer endRefreshingWithNoMoreData];
//        }
//    }];
}

#pragma mark -
#pragma mark - _______UITableViewDelegate,UITableViewDataSource_______
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.navC) {
        return;
    }
//    RentDetailVC *vc = [RentDetailVC new];
//    vc.hidesBottomBarWhenPushed = YES;
//    NearbyM *model = self.dataArr[indexPath.row];
//    vc.infoM = model;
//    vc.user_id = model.user_info.user_id;
//    vc.isSelf = [[UserDefaultsManager getUserId] isEqualToString:model.user_info.user_id];
//    [self.navC pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"disFocusCell"];
    if (!cell) {
        cell = [[DisFocusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"disFocusCell"];
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
