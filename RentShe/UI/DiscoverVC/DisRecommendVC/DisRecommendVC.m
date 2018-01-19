//
//  DisRecommendVC.m
//  RentShe
//
//  Created by Lzz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "DisRecommendVC.h"
#import "DisRecommendCell.h"

@interface DisRecommendVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _index;
}
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DisRecommendVC

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UICollectionView *)myCollectionV
{
    if (!_myCollectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWindowWidth/2.0 - 8, (kWindowWidth/2.0 - 8) *4/3.0 );
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _myCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - kNavBarHeight - kTabBarHeight) collectionViewLayout:layout];
        _myCollectionV.delegate = self;
        _myCollectionV.dataSource = self;
        [_myCollectionV registerClass:[DisRecommendCell class] forCellWithReuseIdentifier:@"DisRecommendCell"];
        _myCollectionV.backgroundColor = kRGB_Value(0xf2f2f2);
        [self.view addSubview:_myCollectionV];
    }
    return _myCollectionV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self myCollectionV];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.myCollectionV.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.myCollectionV.mj_footer = footer;
    
    [self.myCollectionV.mj_header beginRefreshing];
    
}

- (void)requestData
{
    _index = 1;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    if (self.searchDic)
//    {
//        [dic setValuesForKeysWithDictionary:self.searchDic];
//    }
//    else
//    {
//        [dic setObject:@"ture" forKey:@"simple_search"];
//    }
//    NSDictionary *dic1 = @{@"city_code":[UserDefaultsManager getCityCode],
//                           @"page":@(_index)};
//    [dic setValuesForKeysWithDictionary:dic1];
//    [NetAPIManager recommendPeople:dic callBack:^(BOOL success, id object) {
//        [self.myCollectionV.mj_header endRefreshing];
//        [self.myCollectionV.mj_footer resetNoMoreData];
//        if (success) {
//            id arr = object[@"data"];
//            if ([arr isKindOfClass:[NSArray class]])
//            {
//                [self.dataArr removeAllObjects];
//                for (id obj in arr) {
//                    NearbyM *model = [NearbyM new];
//                    [model setValuesForKeysWithDictionary:obj];
//                    [self.dataArr addObject:model];
//                }
//                [self.myCollectionV reloadData];
//            }
//        }
//    }];
}

- (void)loadMore
{
    _index ++;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    if (self.searchDic)
//    {
//        [dic setValuesForKeysWithDictionary:self.searchDic];
//    }
//    else
//    {
//        [dic setObject:@"ture" forKey:@"simple_search"];
//    }
//    NSDictionary *dic1 = @{@"city_code":[UserDefaultsManager getCityCode],
//                           @"page":@(_index)};
//    [dic setValuesForKeysWithDictionary:dic1];
//    [NetAPIManager recommendPeople:dic callBack:^(BOOL success, id object) {
//        [self.myCollectionV.mj_footer endRefreshing];
//        if (success)
//        {
//            NSArray *arr = object[@"data"];
//            if ([arr isKindOfClass:[NSArray class]])
//            {
//                if (!arr.count) {
//                    [self.myCollectionV.mj_footer endRefreshingWithNoMoreData];
//                }
//                for (id obj in arr) {
//                    NearbyM *model = [NearbyM new];
//                    [model setValuesForKeysWithDictionary:obj];
//                    [self.dataArr addObject:model];
//                }
//                [self.myCollectionV reloadData];
//            }
//        }
//        else
//        {
//            [self.myCollectionV.mj_footer endRefreshingWithNoMoreData];
//        }
//    }];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.navC) {
        return;
    }
//    RentDetailVC *vc = [RentDetailVC new];
//    NearbyM *model = self.dataArr[indexPath.row];
//    vc.infoM = model;
//    vc.user_id = model.user_info.user_id;
//    vc.isSelf = [[UserDefaultsManager getUserId] isEqualToString:model.user_info.user_id];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navC pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DisRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DisRecommendCell" forIndexPath:indexPath];
    [cell refreshCell:self.dataArr[indexPath.item]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
