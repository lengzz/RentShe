//
//  WalletRecordVC.m
//  RentShe
//
//  Created by Lengzz on 17/6/11.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "WalletRecordVC.h"
#import "WalletRecordCell.h"

@interface WalletRecordVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger _index;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIImageView *noDataImg;
@end

@implementation WalletRecordVC
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
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 64 - 44) style:UITableViewStylePlain];
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTabV.rowHeight = 44;
//        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 311 + 21 - 64)];
//        _myTabV.tableHeaderView = header;
        _myTabV.contentInset = UIEdgeInsetsMake(311 + 21 - 64, 0, 0, 0);
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (UIImageView *)noDataImg
{
    if (!_noDataImg) {
        _noDataImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 93, 100, 186, 54)];
        _noDataImg.image = [UIImage imageNamed:@"mywallet_norecord"];
        _noDataImg.hidden = YES;
        [self.myTabV addSubview:_noDataImg];
    }
    return _noDataImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self myTabV];
    [self requestData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.myTabV.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    self.myTabV.mj_footer = footer;
}

- (void)requestData
{
    _index = 1;
    NSString *type,*purpose;
    switch (self.type) {
        case WalletTypeOfOrder:
            type = @"1";
            break;
            
        case WalletTypeOfSystem:
            type = @"0";
            break;
        default:
            break;
    }
    switch (self.purpose) {
        case WalletPurposeOfAll:
            purpose = @"";
            break;
        case WalletPurposeOfIn:
            purpose = @"1";
            break;
            
        case WalletPurposeOfOut:
            purpose = @"0";
            break;
        default:
            break;
    }
    NSDictionary *dic = @{@"type": type,
                          @"purpose":purpose,
                          @"page":@(_index)};
    [NetAPIManager walletList:dic callBack:^(BOOL success, id object) {
        [self.myTabV.mj_header endRefreshing];
        [self.myTabV.mj_footer resetNoMoreData];
        if (success) {
            id arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                [self.dataArr removeAllObjects];
                for (id obj in arr) {
                    WalletRecordM *model = [WalletRecordM new];
                    [model setValuesForKeysWithDictionary:obj];
                    [self.dataArr addObject:model];
                }
                [self.myTabV reloadData];
            }
        }
    }];
}

- (void)requestMoreData
{
    _index ++;
    NSString *type,*purpose;
    switch (self.type) {
        case WalletTypeOfOrder:
            type = @"1";
            break;
            
        case WalletTypeOfSystem:
            type = @"0";
            break;
        default:
            break;
    }
    switch (self.purpose) {
        case WalletPurposeOfIn:
            purpose = @"1";
            break;
            
        case WalletPurposeOfOut:
            purpose = @"0";
            break;
        case WalletPurposeOfAll:
            purpose = @"";
        default:
            break;
    }
    NSDictionary *dic = @{@"type": type,
                          @"purpose":purpose,
                          @"page":@(_index)};
    [NetAPIManager walletList:dic callBack:^(BOOL success, id object) {
        [self.myTabV.mj_footer endRefreshing];
        if (success) {
            NSArray *arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                if (!arr.count) {
                    [self.myTabV.mj_footer endRefreshingWithNoMoreData];
                }
                for (id obj in arr) {
                    WalletRecordM *model = [WalletRecordM new];
                    [model setValuesForKeysWithDictionary:obj];
                    [self.dataArr addObject:model];
                }
                [self.myTabV reloadData];
            }
        }
    }];
}

#pragma mark -
#pragma mark - _______UITableViewDelegate,UITableViewDataSource_______
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.dataArr.count)
    {
        self.noDataImg.hidden = NO;
        return 0;
    }
    if (_noDataImg)
    {
        _noDataImg.hidden = YES;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletRecordCell"];
    if (!cell) {
        cell = [[WalletRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"walletRecordCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell refreshCell:self.dataArr[indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.myTabV]) {
        if (scrollView.contentOffset.y < -64) {
            if (self.showBlock) {
                self.showBlock(NO);
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(walletRecordDidScroll:withContentOffset:)]) {
        [self.delegate walletRecordDidScroll:self withContentOffset:scrollView.contentOffset];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
