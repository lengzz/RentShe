//
//  LocationVC.m
//  RentShe
//
//  Created by Lengzz on 17/6/1.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "LocationVC.h"
#import "LocationHotCell.h"
#import "CityM.h"

@interface LocationVC ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    NSString *_locationCity;
}
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationVC

- (NSMutableArray *)hotArr
{
    if (!_hotArr) {
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        NSDictionary *dic = [CityM sortCitys];
        _dataArr = [dic[kCityContent] mutableCopy];
        [_dataArr insertObject:@[@"00"] atIndex:0];
    }
    return _dataArr;
}

- (NSMutableArray *)titleArr
{
    if (!_titleArr) {
        NSDictionary *dic = [CityM sortCitys];
        _titleArr = [dic[kCityTitle] mutableCopy];
        [_titleArr insertObject:@"定位" atIndex:0];
    }
    return _titleArr;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStyleGrouped
                   ];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB(242, 242, 242);
        _myTabV.showsVerticalScrollIndicator = NO;
        _myTabV.sectionIndexColor = kRGB(255, 117, 26);
        _myTabV.sectionIndexBackgroundColor = [UIColor clearColor];
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            UIAlertController *ctl = [UIAlertController alertControllerWithTitle:@"无法定位" message:@"请检查您的设备是否开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [ctl dismissViewControllerAnimated:YES completion:nil];
            }];
            [ctl addAction:action];
            [self presentViewController:ctl animated:YES completion:nil];
        }
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            [self.locationManager requestWhenInUseAuthorization];
        }
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestHotCity];
    [self locationManager];
    [self createNavbar];
    [self myTabV];
    [self.myTabV reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"选择城市"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)requestHotCity
{
    [NetAPIManager hotCityWithCallBack:^(BOOL success, id object) {
        if (success)
        {
            NSArray * arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                if (arr.count) {
                    for (NSDictionary *dic in arr) {
                        CityM *m = [CityM new];
                        [m setValuesForKeysWithDictionary:dic];
                        [self.hotArr addObject:m];
                    }
                    [self.dataArr insertObject:self.hotArr atIndex:1];
                    [self.titleArr insertObject:@"热门" atIndex:1];
                    [self.myTabV reloadData];
                }
            }
        }
    }];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationClick:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    [self.locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section||(indexPath.section == 1 && self.hotArr.count)) {
        return;
    }
    self.locationBtn.selected = NO;
    NSArray *arr = self.dataArr[indexPath.section];
    CityM *obj = arr[indexPath.row];
    [self.locationBtn setTitle:obj.city forState:UIControlStateNormal];
    [UserDefaultsManager setCity:obj.city];
    [UserDefaultsManager setCityCode:obj.code];
    if (self.cityBlock) {
        self.cityBlock(YES);
    }
    [self backClick];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    }
    if (self.hotArr.count && section == 1) {
        return 1;
    }
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationBtnCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"locationBtnCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(24, 0, kWindowWidth/3.0 - 24, 43);
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5.0;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = kRGB(228, 228, 228).CGColor;
            [btn setTitle:[UserDefaultsManager getCity]?[UserDefaultsManager getCity]:@"点击定位" forState:UIControlStateNormal];
            [btn setTitle:@"定位中..." forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:kRGB(40, 40, 40) forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
            _locationBtn = btn;
            [cell.contentView addSubview:btn];
        }
        return cell;
    }
    else if (self.hotArr.count && indexPath.section == 1) {
        LocationHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationHotCell"];
        if (!cell) {
            cell = [[LocationHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationHotCell"];
            
            __weak typeof(self) wself = self;
            cell.hotCityBlock = ^(CityM *obj){
                wself.locationBtn.selected = NO;
                [wself.locationBtn setTitle:obj.city forState:UIControlStateNormal];
                [UserDefaultsManager setCity:obj.city];
                [UserDefaultsManager setCityCode:obj.code];
                if (wself.cityBlock) {
                    wself.cityBlock(YES);
                }
                [wself backClick];
            };
        }
        [cell refreshCell:self.hotArr];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"locationCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = kRGB(40, 40, 40);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kRGB_Value(0xf2f2f2);
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left);
            make.height.equalTo(@.5);
            make.width.equalTo(@(kWindowWidth));
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
    }
    NSArray *arr = self.dataArr[indexPath.section];
    CityM *m = arr[indexPath.row];
    cell.textLabel.text = m.city;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotArr.count && indexPath.section == 1)
    {
        return (self.hotArr.count + 3)/3 * 58 - 15;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"locationHeader"];
    if (!header) {
        header = [UIView new];
        header.backgroundColor = [UIColor clearColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 0, 0)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = kRGB(152, 152, 152);
        lab.tag = 1;
        [header addSubview:lab];
    }
    UILabel *lab = (UILabel *)[header viewWithTag:1];
    lab.text = self.titleArr[section];
    [lab sizeToFit];
    return header;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView

{
    return self.titleArr;
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    [UserDefaultsManager setUserLat:location.coordinate.latitude];
    [UserDefaultsManager setUserLng:location.coordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (_locationCity) {
            return ;
        }
        if (error || !placemarks.count)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *ctl = [UIAlertController alertControllerWithTitle:@"无法定位" message:@"请检查您的设备是否开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [ctl dismissViewControllerAnimated:YES completion:nil];
                }];
                [ctl addAction:action];
                [self presentViewController:ctl animated:YES completion:nil];
            });
        }
        else
        {
            CLPlacemark *placeMark = placemarks[0];
            _locationCity = placeMark.locality;
            
            if (_locationCity.length && _locationCity.length > 2) {
                
                NSString *last = [_locationCity substringFromIndex:_locationCity.length-1];
                if ([last isEqualToString:@"市"])
                    _locationCity = [_locationCity substringWithRange:NSMakeRange(0, _locationCity.length-1)];
                [UserDefaultsManager setCurCityCode:[CityM getCodeByCity:_locationCity]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.locationBtn setTitle:_locationCity forState:UIControlStateNormal];
                    [UserDefaultsManager setCity:_locationCity];
                    [UserDefaultsManager setCityCode:[CityM getCodeByCity:_locationCity]];
                    if (self.cityBlock) {
                        self.cityBlock(YES);
                    }
                });
                
            }
        }
    }];
    
    [manager stopUpdatingLocation];
    self.locationBtn.selected = NO;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    //    NSLog(@"1111");
}

@end

