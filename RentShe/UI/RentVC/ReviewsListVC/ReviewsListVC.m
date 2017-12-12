//
//  ReviewsListVC.m
//  RentShe
//
//  Created by Lengzz on 2017/10/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ReviewsListVC.h"
#import "ReviewsListM.h"
#import "VisitorCell.h"

@interface ReviewsListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_totalLab;
    NSInteger _index;
}
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ReviewsListVC

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
        _myTabV.rowHeight = 60;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTabV.tableHeaderView = [self addHeaderView];
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self myTabV];
    _totalLab.text = [NSString stringWithFormat:@"总评论数量：%zd",self.reviewsNum];
    
    [self requestData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.myTabV.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    self.myTabV.mj_footer = footer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.shadowImage = nil;
}

- (UIView *)addHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 42)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 13, kWindowWidth - 60, 16)];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = kRGB(152, 152, 152);
    _totalLab = lab;
    [header addSubview:lab];
    return header;
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"评论"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    _index = 1;
    NSDictionary *dic = @{@"lender_id": self.userId,@"page":@(_index)};
    [NetAPIManager orderReviewsList:dic callBack:^(BOOL success, id object) {
        [self.myTabV.mj_header endRefreshing];
        [self.myTabV.mj_footer resetNoMoreData];
        if (success) {
            id arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                [self.dataArr removeAllObjects];
                NSMutableArray *resArr = [NSMutableArray array];
                for (id obj in arr) {
                    ReviewsListM *model = [ReviewsListM new];
                    [model setValuesForKeysWithDictionary:obj];
                    [resArr addObject:model];
                }
                self.dataArr = [ReviewsListM packetFilter:self.dataArr andNewArr:resArr];
                [self.myTabV reloadData];
            }
        }
    }];
}

- (void)requestMoreData
{
    _index ++;
    NSDictionary *dic = @{@"lender_id": self.userId,@"page":@(_index)};
    [NetAPIManager orderReviewsList:dic callBack:^(BOOL success, id object) {
        [self.myTabV.mj_header endRefreshing];
        [self.myTabV.mj_footer resetNoMoreData];
        if (success) {
            NSArray *arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                if (!arr.count) {
                    [self.myTabV.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                NSMutableArray *resArr = [NSMutableArray array];
                for (id obj in arr) {
                    ReviewsListM *model = [ReviewsListM new];
                    [model setValuesForKeysWithDictionary:obj];
                    [resArr addObject:model];
                }
                self.dataArr = [ReviewsListM packetFilter:self.dataArr andNewArr:resArr];
                [self.myTabV reloadData];
            }
        }
    }];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataArr[section];
    NSMutableArray *arr = dic[kReviewsContent];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"visitorCell"];
    if (!cell) {
        cell = [[VisitorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"visitorCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArr[indexPath.section];
    NSMutableArray *arr = dic[kReviewsContent];
    [cell refreshCell:arr[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [tableView dequeueReusableCellWithIdentifier:@"visitorHeader"];
    if (!header) {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kWindowWidth - 30, 24)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = kRGB(40, 40, 40);
        lab.tag = 110;
        [header addSubview:lab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kWindowWidth, .5)];
        line.backgroundColor = kRGB(242, 242, 242);
        [header addSubview:line];
    }
    UILabel *lab = [header viewWithTag:110];
    
    NSDictionary *dic = self.dataArr[section];
    lab.text = dic[kReviewsTitle];
    return header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
