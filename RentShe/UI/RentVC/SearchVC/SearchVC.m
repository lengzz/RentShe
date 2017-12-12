//
//  SearchVC.m
//  RentShe
//
//  Created by Lengzz on 2017/7/8.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "SearchVC.h"
#import "SearchM.h"
#import "SearchBarV.h"

#import "RentDetailVC.h"

@interface SearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_searchTF;
    NSInteger _index;
}
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation SearchVC

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB(242, 242, 242);
        _myTabV.showsVerticalScrollIndicator = NO;
//        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTabV.rowHeight = 60;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.myTabV.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.myTabV.mj_footer = footer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}
- (void)createNav
{
    [self.navigationItem setTitleView:[self searchV]];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *btn = [CustomNavVC getRightDefaultButtonWithTarget:self action:@selector(cancelClick) titile:@"取消"];
    [btn setTitleColor:kRGB(255, 117, 26) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
}

- (UIView *)searchV
{
    SearchBarV *contentV = [[SearchBarV alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    
    _searchTF = contentV.searchTF;
    _searchTF.delegate = self;
    return contentV;
}

- (void)requestData
{
    if (!_searchTF.text.length) {
        [self.myTabV.mj_header endRefreshing];
        return;
    }
    _index = 1;
    NSDictionary *dic = @{@"page":@(_index),
                          @"nickName":_searchTF.text};
    [NetAPIManager searchPeople:dic callBack:^(BOOL success, id object) {
        [self.myTabV.mj_header endRefreshing];
        if (success) {
            NSArray *arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]] && arr.count) {
                [self.dataArr removeAllObjects];
                for (NSDictionary *dic in arr) {
                    SearchM *m = [SearchM new];
                    [m setValuesForKeysWithDictionary:dic];
                    [self.dataArr addObject:m];
                }
                [self.myTabV reloadData];
            }
        }
    }];
}

- (void)loadMore
{
    if (!_searchTF.text.length) {
        [self.myTabV.mj_footer endRefreshing];
        return;
    }
    [self.myTabV.mj_footer beginRefreshing];
    _index ++;
    NSDictionary *dic = @{@"page":@(_index),
                          @"nickName":_searchTF.text};
    [NetAPIManager searchPeople:dic callBack:^(BOOL success, id object) {
        [self.myTabV.mj_footer endRefreshing];
        if (success) {
            NSArray *arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]] && arr.count) {
                for (NSDictionary *dic in arr) {
                    SearchM *m = [SearchM new];
                    [m setValuesForKeysWithDictionary:dic];
                    [self.dataArr addObject:m];
                }
                [self.myTabV reloadData];
            }
        }
    }];
}

- (void)cancelClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.imageView removeFromSuperview];
    }
    SearchM *m = self.dataArr[indexPath.row];
    cell.textLabel.text = m.nickname;
    cell.detailTextLabel.text = m.describe;
    [cell.imageView sd_setImageWithUrlStr:m.avatar placeholderImage:[UIImage imageNamed:@"mine_default"]];
    cell.imageView.frame = CGRectMake(15, 10, 30, 30);
    return cell;
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
    RentDetailVC *ctl = [[RentDetailVC alloc] init];
    SearchM *m = self.dataArr[indexPath.row];
    ctl.user_id = m.user_id;
    ctl.isSelf = [[UserDefaultsManager getUserId] isEqualToString:m.user_id];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    [self requestData];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
