//
//  RentVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RentVC.h"
#import "RentCell.h"

#import "NearbyVC.h"
#import "RecommendVC.h"
#import "LocationVC.h"
#import "FilterVC.h"
#import "CityM.h"

@interface RentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,CLLocationManagerDelegate>
{
    UIButton *_currentBtn;
    UIView *_titleV;
}
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) UIButton *navCityBtn;
@property (nonatomic, strong) NearbyVC *nearbyVC;
@property (nonatomic, strong) RecommendVC *recommendVC;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation RentVC

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

- (RecommendVC *)recommendVC
{
    if (!_recommendVC) {
        _recommendVC = [[RecommendVC alloc] init];
        _recommendVC.navC = self.navigationController;
    }
    return _recommendVC;
}

- (NearbyVC *)nearbyVC
{
    if (!_nearbyVC) {
        _nearbyVC = [[NearbyVC alloc] init];
        _nearbyVC.navC = self.navigationController;
    }
    return _nearbyVC;
}

- (UICollectionView *)collectionV
{
    if (!_collectionV) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kWindowWidth, kWindowHeight - 64 - 49);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kWindowWidth, kWindowHeight - 64 - 49)collectionViewLayout:flowLayout];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.backgroundColor = [UIColor whiteColor];
        _collectionV.bounces = NO;
        _collectionV.showsHorizontalScrollIndicator = NO;
        _collectionV.pagingEnabled = YES;
        [_collectionV registerClass:[RentCell class]forCellWithReuseIdentifier:@"rentCell"];
        [self.view addSubview:_collectionV];
        if (@available(iOS 11.0, *)){
            [_collectionV setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }
    return _collectionV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavBar];
    [self collectionV];
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:kRGB_Value(0xfde23d)];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)createNavBar
{
    UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 135, 30)];
    [titleV setBackgroundColor:kRGB_Value(0x442509)];
    titleV.layer.masksToBounds = YES;
    titleV.layer.cornerRadius = 15;
    _titleV = titleV;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(.5, .5, 67, 29);
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.cornerRadius = 14.5;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    leftBtn.tag = 1;
    [leftBtn setTitle:@"附近" forState:UIControlStateNormal];
    [leftBtn setTitleColor:kRGB_Value(0xfde23d) forState:UIControlStateNormal];
    [leftBtn setTitleColor:kRGB_Value(0x442509) forState:UIControlStateSelected];
    [leftBtn setBackgroundImage:[CustomNavVC imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[CustomNavVC imageWithColor:kRGB_Value(0xfde23d)] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.selected = YES;
    _currentBtn = leftBtn;
    [titleV addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(67.5, .5, 67, 29);
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = 14.5;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rightBtn.tag = 2;
    [rightBtn setTitle:@"推荐" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kRGB_Value(0xfde23d) forState:UIControlStateNormal];
    [rightBtn setTitleColor:kRGB_Value(0x442509) forState:UIControlStateSelected];
    [rightBtn setBackgroundImage:[CustomNavVC imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[CustomNavVC imageWithColor:kRGB_Value(0xfde23d)] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleV addSubview:rightBtn];
    [self.navigationItem setTitleView:titleV];
    
    [self.navigationController.navigationBar setCustomBarBackgroundColor:kRGB_Value(0xfde23d)];
    
    [self.navigationItem setRightBarButtonItem:[CustomNavVC getRightBarButtonItemWithTarget:self action:@selector(filterClick) normalImg:[UIImage imageNamed:@"rent_filter"] hilightImg:[UIImage imageNamed:@"rent_filter"]]];
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGSize size = [@"深圳深圳" boundingRectWithSize:CGSizeMake(0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"navbar_location"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, size.width + 10, 45);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:kRGB_Value(0x442509) forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont systemFontOfSize:15];
    [button setTitle:[UserDefaultsManager getCity] ?[UserDefaultsManager getCity]:@"深圳" forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    _navCityBtn = button;
    
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
}

- (void)titleSelected:(NSInteger)tag
{
    UIButton *btn = [_titleV viewWithTag:tag];
    btn.selected = YES;
    _currentBtn = btn;
    btn.userInteractionEnabled = NO;
    switch (tag) {
        case 1:
        {
            UIButton *btn = [_titleV viewWithTag:2];
            btn.selected = NO;
            btn.userInteractionEnabled = YES;
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
            self.navigationItem.leftBarButtonItem.customView.hidden = YES;
            break;
        }
        case 2:
        {
            UIButton *btn = [_titleV viewWithTag:1];
            btn.selected = NO;
            btn.userInteractionEnabled = YES;
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            self.navigationItem.leftBarButtonItem.customView.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void)titleClick:(UIButton *)btn
{
    if ([_currentBtn isEqual:btn])
    {
        return;
    }
    [self titleSelected:btn.tag];
    if (btn.tag == 2)
    {
        [self.collectionV setContentOffset:CGPointMake(kWindowWidth, 0) animated:YES];
    }
    else
    {
        [self.collectionV setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)filterClick
{
    __weak typeof(self) wself = self;
    FilterVC *vc = [FilterVC new];
    vc.filterBlock = ^(NSDictionary *dic) {
        wself.recommendVC.searchDic = dic;
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)locationClick
{
    LocationVC *vc = [LocationVC new];
    vc.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) wself = self;
    vc.cityBlock = ^(BOOL isChange) {
        if (isChange) {
            [wself.navCityBtn setTitle:[UserDefaultsManager getCity] ?[UserDefaultsManager getCity]:@"深圳" forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - _______UICollectionViewDelegate,UICollectionViewDataSource________
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rentCell" forIndexPath:indexPath];
    UIView *infoV;
    if (indexPath.item)
    {
        infoV = self.recommendVC.view;
    }
    else
    {
        infoV = self.nearbyVC.view;
    }
    infoV.backgroundColor = [UIColor redColor];
    cell.infoV = infoV;
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x)
    {
        [self titleSelected:2];
    }
    else
    {
        [self titleSelected:1];    }
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
            NSString *locationCity = placeMark.locality;
            
            if (locationCity.length && locationCity.length > 2) {
                
                NSString *last = [locationCity substringFromIndex:locationCity.length-1];
                if ([last isEqualToString:@"市"])
                    locationCity = [locationCity substringWithRange:NSMakeRange(0, locationCity.length - 1)];
                [UserDefaultsManager setCurCityCode:[CityM getCodeByCity:locationCity]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![UserDefaultsManager.getCity isEqualToString:locationCity]) {
                        UIAlertController *ctl = [UIAlertController alertControllerWithTitle:locationCity message:@"是否切换到当前城市" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [UserDefaultsManager setCityCode:[CityM getCodeByCity:locationCity]];
                            [UserDefaultsManager setCity:locationCity];
                            [self.navCityBtn setTitle:[UserDefaultsManager getCity] forState:UIControlStateNormal];
                            [ctl dismissViewControllerAnimated:YES completion:nil];
                        }];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [ctl dismissViewControllerAnimated:YES completion:nil];
                        }];
                        [ctl addAction:action];
                        [ctl addAction:action1];
                        [self presentViewController:ctl animated:YES completion:nil];
                    }
                });
                
            }
        }
    }];
    
    [manager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
