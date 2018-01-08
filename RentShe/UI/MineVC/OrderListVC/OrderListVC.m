//
//  OrderListVC.m
//  RentShe
//
//  Created by Lengzz on 2017/9/2.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderListCell.h"
#import "OrderListM.h"

#define kOrderListCell @"orderListCell"
#define kOrderListEndCell @"orderListEndCell"

static const NSString *kOrderStateWait = @"await";//等待确认
static const NSString *kOrderStateImplement = @"implement";//待见面
static const NSString *kOrderStateEvaluate = @"evaluate";//等待评价
static const NSString *kOrderStateEnd = @"end";//已完成



@interface OrderListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _index;
}
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSArray *stateArr;

@end

@implementation OrderListVC

- (NSArray *)stateArr
{
    if (!_stateArr) {
        _stateArr = @[kOrderStateWait,kOrderStateImplement,kOrderStateEvaluate,kOrderStateEnd];
    }
    return _stateArr;
}

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
        _myTabV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTabV.estimatedRowHeight = 100;
        _myTabV.backgroundColor = kRGB(242, 242, 242);
        [self.view addSubview:_myTabV];
        [_myTabV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSDictionary *dic = @{@"state":self.stateArr[self.state],@"page":@(_index)};
    switch (self.type) {
        case OrderTypeOfMyRent:
        {
            [NetAPIManager myRentOrderList:dic callBack:^(BOOL success, id object) {
                [self.myTabV.mj_header endRefreshing];
                [self.myTabV.mj_footer resetNoMoreData];
                if (success) {
                    id arr = object[@"data"];
                    if ([arr isKindOfClass:[NSArray class]])
                    {
                        [self.dataArr removeAllObjects];
                        for (id obj in arr) {
                            OrderListM *model = [OrderListM new];
                            [model setValuesForKeysWithDictionary:obj];
                            [self.dataArr addObject:model];
                        }
                        [self.myTabV reloadData];
                    }
                }
            }];
            break;
        }
        case OrderTypeOfRentMe:
        {
            [NetAPIManager rentMeOrderList:dic callBack:^(BOOL success, id object) {
                [self.myTabV.mj_header endRefreshing];
                [self.myTabV.mj_footer resetNoMoreData];
                if (success) {
                    id arr = object[@"data"];
                    if ([arr isKindOfClass:[NSArray class]])
                    {
                        [self.dataArr removeAllObjects];
                        for (id obj in arr) {
                            OrderListM *model = [OrderListM new];
                            [model setValuesForKeysWithDictionary:obj];
                            [self.dataArr addObject:model];
                        }
                        [self.myTabV reloadData];
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)requestMoreData
{
    _index ++;
    NSDictionary *dic = @{@"state":self.stateArr[self.state],@"page":@(_index)};
    switch (self.type) {
        case OrderTypeOfMyRent:
        {
            [NetAPIManager myRentOrderList:dic callBack:^(BOOL success, id object) {
                if (success) {
                    NSArray *arr = object[@"data"];
                    if ([arr isKindOfClass:[NSArray class]])
                    {
                        if (!arr.count) {
                            [self.myTabV.mj_footer endRefreshingWithNoMoreData];
                        }
                        for (id obj in arr) {
                            OrderListM *model = [OrderListM new];
                            [model setValuesForKeysWithDictionary:obj];
                            [self.dataArr addObject:model];
                        }
                        [self.myTabV reloadData];
                    }
                }
            }];
            break;
        }
        case OrderTypeOfRentMe:
        {
            [NetAPIManager rentMeOrderList:dic callBack:^(BOOL success, id object) {
                if (success) {
                    NSArray *arr = object[@"data"];
                    if ([arr isKindOfClass:[NSArray class]])
                    {
                        if (!arr.count) {
                            [self.myTabV.mj_footer endRefreshingWithNoMoreData];
                        }
                        for (id obj in arr) {
                            OrderListM *model = [OrderListM new];
                            [model setValuesForKeysWithDictionary:obj];
                            [self.dataArr addObject:model];
                        }
                        [self.myTabV reloadData];
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)updateStatus:(NSString *)type withOrderId:(NSString *)orderId
{
    NSDictionary *dic = @{@"type":type,
                          @"order_id":orderId};
    switch (self.type) {
        case OrderTypeOfMyRent:
        {
            [NetAPIManager myRentUpdateOrder:dic callBack:^(BOOL success, id object) {
                if (success) {
                    [self requestData];
                }
            }];
            break;
        }
        case OrderTypeOfRentMe:
        {
            [NetAPIManager rentMeUpdateOrder:dic callBack:^(BOOL success, id object) {
                if (success) {
                    [self requestData];
                }
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0&&self.state == OrderStateOfEnd)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB_Value(0x282828);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *arr = self.dataArr[indexPath.section];
        NSDictionary *dic = arr[indexPath.row];
        cell.textLabel.text = dic[@"name"];
        cell.imageView.image = [UIImage imageNamed:dic[@"img"]];
        return cell;
    }
    else
    {
        OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderListCell];
        if (!cell) {
            cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOrderListCell];
            __block typeof(self) wself = self;
            cell.functionBlock = ^(NSString *type, id obj)
            {
                if ([type isEqualToString:@"0"])
                {
                    if (wself.chatBlock) {
                        wself.chatBlock(obj);
                    }
                }
                else if ([type isEqualToString:@"1"])
                {
                    if (wself.reviewBlock) {
                        wself.reviewBlock(obj);
                    }
                }
                else
                    [wself updateStatus:type withOrderId:obj];
            };
        }
        [cell refreshCell:self.dataArr[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
