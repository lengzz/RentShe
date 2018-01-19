//
//  DiscoverVC.m
//  RentShe
//
//  Created by Lzz on 2018/1/18.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "DiscoverVC.h"
#import "RentCell.h"

#import "DisFocusVC.h"
#import "DisRecommendVC.h"

@interface DiscoverVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *_currentBtn;
    UIView *_titleV;
}
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) DisFocusVC *focusVC;
@property (nonatomic, strong) DisRecommendVC *recommendVC;
@end

@implementation DiscoverVC

- (DisFocusVC *)focusVC
{
    if (!_focusVC) {
        _focusVC = [[DisFocusVC alloc] init];
        _focusVC.navC = self.navigationController;
    }
    return _focusVC;
}

- (DisRecommendVC *)recommendVC
{
    if (!_recommendVC) {
        _recommendVC = [[DisRecommendVC alloc] init];
        _recommendVC.navC = self.navigationController;
    }
    return _recommendVC;
}

- (UICollectionView *)collectionV
{
    if (!_collectionV) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kWindowWidth, kWindowHeight - kNavBarHeight - kTabBarHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.backgroundColor = [UIColor whiteColor];
        _collectionV.bounces = NO;
        _collectionV.showsHorizontalScrollIndicator = NO;
        _collectionV.pagingEnabled = YES;
        [_collectionV registerClass:[RentCell class]forCellWithReuseIdentifier:@"discoverCell"];
        _collectionV.scrollsToTop = NO;
        [self.view addSubview:_collectionV];
    }
    return _collectionV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self collectionV];
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
    [leftBtn setTitle:@"关注" forState:UIControlStateNormal];
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
            self.focusVC.myTabV.scrollsToTop = YES;
            self.recommendVC.myCollectionV.scrollsToTop = NO;
            UIButton *btn = [_titleV viewWithTag:2];
            btn.selected = NO;
            btn.userInteractionEnabled = YES;
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
            self.navigationItem.leftBarButtonItem.customView.hidden = YES;
            break;
        }
        case 2:
        {
            self.focusVC.myTabV.scrollsToTop = NO;
            self.recommendVC.myCollectionV.scrollsToTop = YES;
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

- (void)statusIsChange
{
    
}

#pragma mark - _______UICollectionViewDelegate,UICollectionViewDataSource________
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"discoverCell" forIndexPath:indexPath];
    UIView *infoV;
    if (indexPath.item)
    {
        infoV = self.recommendVC.view;
    }
    else
    {
        infoV = self.focusVC.view;
    }
    infoV.backgroundColor = [UIColor whiteColor];
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
        [self titleSelected:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
