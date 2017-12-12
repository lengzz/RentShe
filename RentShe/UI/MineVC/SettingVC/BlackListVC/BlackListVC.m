//
//  BlackListVC.m
//  RentShe
//
//  Created by Lzz on 2017/12/1.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "BlackListVC.h"
#import "BlackListM.h"
#import "BlackListCell.h"

@interface BlackListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _index;
}
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation BlackListVC

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
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.showsVerticalScrollIndicator = NO;
        _myTabV.backgroundColor = kRGB(242, 242, 242);
        _myTabV.estimatedSectionFooterHeight = 0;
        _myTabV.estimatedSectionHeaderHeight = 0;
        _myTabV.rowHeight = 60;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self myTabV];
    
    [self requestData];
    
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    self.myTabV.mj_header = header;
    
//    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
//    self.myTabV.mj_footer = footer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"黑名单"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
//    _index = 1;
//    NSDictionary *dic = @{@"page":@(_index)};
    [NetAPIManager shieldList:nil callBack:^(BOOL success, id object) {
//        [self.myTabV.mj_header endRefreshing];
//        [self.myTabV.mj_footer resetNoMoreData];
        if (success) {
            id arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                [self.dataArr removeAllObjects];
                NSMutableArray *resArr = [NSMutableArray array];
                for (id obj in arr) {
                    BlackListM *model = [BlackListM new];
                    [model setValuesForKeysWithDictionary:obj];
                    [resArr addObject:model];
                }
                self.dataArr = resArr;
                [self.myTabV reloadData];
            }
        }
    }];
}

- (void)requestMoreData
{
    _index ++;
    NSDictionary *dic = @{@"page":@(_index)};
    [NetAPIManager shieldList:dic callBack:^(BOOL success, id object) {
        [self.myTabV.mj_footer endRefreshing];
        if (success) {
            NSArray *arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                if (!arr.count) {
                    [self.myTabV.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                for (id obj in arr) {
                    BlackListM *model = [BlackListM new];
                    [model setValuesForKeysWithDictionary:obj];
                    [self.dataArr addObject:model];
                }
                [self.myTabV reloadData];
            }
        }
    }];
}

- (void)cancelShieldClick:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    NSInteger index = indexPath.row;
    BlackListM *model = self.dataArr[index];
    NSDictionary *dic = @{@"his_id":model.his_id};
    [NetAPIManager cancelShieldUser:dic callBack:^(BOOL success, id object) {
        [SVProgressHUD dismiss];
        if (success) {
            [SVProgressHUD showSuccessWithStatus:object[@"message"]];
            [self.dataArr removeObjectAtIndex:index];
            [self.myTabV reloadData];
        }
    }];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blackListCell"];
    if (!cell) {
        cell = [[BlackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blackListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) wself = self;
        cell.cancelShield = ^(NSIndexPath *index) {
            [wself cancelShieldClick:index];
        };
    }
    BlackListM *model = self.dataArr[indexPath.row];
    [cell refreshCell:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
