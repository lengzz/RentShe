//
//  MOSelLocationVC.m
//  RentShe
//
//  Created by Lengzz on 2017/8/5.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MOSelLocationVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "MOSelLocationHearderV.h"
#import "MOSelLocationCell.h"
#import "CusAnnotation.h"

@interface MOSelLocationVC ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate,AMapSearchDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MOSelLocationHearderV *hearderV;
@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation MOSelLocationVC

- (AMapSearchAPI *)mapSearch
{
    if (!_mapSearch) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}

- (AMapLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDelegate:self];
        
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        
//        [_locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    return _locationManager;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kWindowWidth, 44)];
        _searchBar.placeholder = @"搜索地点";
        _searchBar.delegate = self;
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (MOSelLocationHearderV *)hearderV
{
    if (!_hearderV)
    {
        _hearderV = [[MOSelLocationHearderV alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 200)];
    }
    return _hearderV;
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
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 44, kWindowWidth, kWindowHeight - 44 - kNavBarHeight) style:UITableViewStylePlain];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB(242, 242, 242);
        _myTabV.showsVerticalScrollIndicator = NO;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTabV.rowHeight = 60;
        _myTabV.tableHeaderView = self.hearderV;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.locationManager startUpdatingLocation];
    
    [self createNavbar];
    [self searchBar];
    [self myTabV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setCustomBarBackgroundColor:kRGB_Value(0xfde23d)];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"选择邀约地点"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    NSIndexPath *indexPath = [self.myTabV indexPathForSelectedRow];
    if (self.dataArr.count)
    {
        CusAnnotation *annotation = self.dataArr[indexPath.row];
        if (self.callBack) {
            self.callBack(annotation);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapKeywordsSearch:(NSString *)keywords
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
//    request.location = [AMapGeoPoint locationWithLatitude:self.hearderV.centerPoint.latitude longitude:self.hearderV.centerPoint.longitude];
    request.keywords  = keywords;
    /* 按照距离排序. */
    request.sortrule  = 0;
    request.requireExtension = YES;
    
    [self.mapSearch AMapPOIKeywordsSearch:request];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOSelLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selLocationCell"];
    if (!cell) {
        cell = [[MOSelLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selLocationCell"];
    }
    [cell refreshCell:self.dataArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CusAnnotation *annotation = self.dataArr[indexPath.row];
    [self.hearderV setCenterPoint:annotation.coordinate];
}

#pragma mark - 
#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.hearderV.centerPoint = location.coordinate;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    request.keywords  = @"休闲场所";
    /* 按照距离排序. */
    request.sortrule  = 0;
    request.requireExtension = YES;
    
    [self.mapSearch AMapPOIAroundSearch:request];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark -
#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%s, error = %@", __func__, error);
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    [self.dataArr removeAllObjects];
    for (AMapPOI *obj in response.pois)
    {
        [self.dataArr addObject:[[CusAnnotation alloc] initWithPOI:obj]];
    }
    [self.myTabV reloadData];
    [self.myTabV selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.hearderV.resArr = self.dataArr;
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    [self mapKeywordsSearch:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
