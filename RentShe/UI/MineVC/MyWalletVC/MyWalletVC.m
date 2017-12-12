//
//  MyWalletVC.m
//  RentShe
//
//  Created by Lengzz on 17/6/7.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MyWalletVC.h"
#import "WalletRecordVC.h"
#import "RentCell.h"
#import "RechargeVC.h"
#import "WithdrawVC.h"

@interface MyWalletVC ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WalletRecordDelegate>
{
    UILabel *_moneyLab;
    UIView *_choiceV;
    UIButton *_selectedBtn;
    UILabel *_title;
}
@property (nonatomic, strong) UIView *headerV;
@property (nonatomic, strong) UICollectionView *mycollectionV;
@property (nonatomic, strong) WalletRecordVC *allRecordVC;
@property (nonatomic, strong) WalletRecordVC *rechargeRecordVC;
@property (nonatomic, strong) WalletRecordVC *withdrawRecordVC;
@end

@implementation MyWalletVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.headerV removeObserver:self forKeyPath:@"frame"];
}

- (WalletRecordVC *)allRecordVC
{
    if (!_allRecordVC) {
        _allRecordVC = [[WalletRecordVC alloc] init];
        _allRecordVC.type = WalletTypeOfOrder;
        _allRecordVC.purpose = WalletPurposeOfAll;
        _allRecordVC.delegate = self;
    }
    return _allRecordVC;
}

- (WalletRecordVC *)rechargeRecordVC
{
    if (!_rechargeRecordVC) {
        _rechargeRecordVC = [[WalletRecordVC alloc] init];
        _rechargeRecordVC.type = WalletTypeOfSystem;
        _rechargeRecordVC.purpose = WalletPurposeOfIn;
        _rechargeRecordVC.delegate = self;
    }
    return _rechargeRecordVC;
}

- (WalletRecordVC *)withdrawRecordVC
{
    if (!_withdrawRecordVC) {
        _withdrawRecordVC = [[WalletRecordVC alloc] init];
        _withdrawRecordVC.type = WalletTypeOfSystem;
        _withdrawRecordVC.purpose = WalletPurposeOfOut;
        _withdrawRecordVC.delegate = self;
    }
    return _withdrawRecordVC;
}

- (UIView *)headerV
{
    if (!_headerV) {
        _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 311 + 21 + 44)];
        _headerV.backgroundColor = kRGB(242, 242, 242);
        _headerV.opaque = YES;
        [self.view addSubview:_headerV];
        [self createV];
    }
    return _headerV;
}

- (UICollectionView *)mycollectionV
{
    if (!_mycollectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWindowWidth, kWindowHeight - 64 - 44);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mycollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 44, kWindowWidth, kWindowHeight - 64 - 44) collectionViewLayout:layout];
        _mycollectionV.backgroundColor = [UIColor whiteColor];
        _mycollectionV.delegate = self;
        _mycollectionV.dataSource = self;
        _mycollectionV.showsHorizontalScrollIndicator = NO;
        _mycollectionV.bounces = NO;
        _mycollectionV.pagingEnabled = YES;
        [_mycollectionV registerClass:[RentCell class] forCellWithReuseIdentifier:@"recordCell"];
        [self.view addSubview:_mycollectionV];
    }
    return _mycollectionV;
}

- (UIView *)extracted {
    return [self headerV];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.interactivePopDisabled = NO;
    [self mycollectionV];
    [self extracted];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoIsChange) name:kUserInfoIsChange object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect frame = self.headerV.frame;
    self.headerV.frame = frame;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)createV
{
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 311)];
    backImg.image = [UIImage imageNamed:@"mywallet_back"];
    [_headerV addSubview:backImg];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, 150, 13)];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor whiteColor];
    lab.text = @"账户余额（元）：";
    [_headerV addSubview:lab];
    
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, kWindowWidth, 50)];
    moneyLab.textColor = [UIColor whiteColor];
    moneyLab.font = [UIFont systemFontOfSize:50];
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.text = [UserDefaultsManager getMoney];
    _moneyLab = moneyLab;
    [_headerV addSubview:moneyLab];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i?kWindowWidth/2.0 + 18:36, 260, kWindowWidth/2.0 - 56, 32);
        [btn setTitle: i?@"提现":@"充值" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.backgroundColor = kRGB_Value(0xff751a);
        btn.layer.cornerRadius = 16;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerV addSubview:btn];
    }

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 311 + 21, kWindowWidth, 0.5)];
    line.backgroundColor = kRGB(227, 227, 229);
    [_headerV addSubview:line];
    
    NSArray *arr = @[@"订单记录",@"提现记录",@"充值记录"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kWindowWidth/3.0, 311 + 21, kWindowWidth/3.0, 44);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:kRGB_Value(0x565656) forState:UIControlStateNormal];
        [btn setTitleColor:kRGB_Value(0xff751a) forState:UIControlStateSelected];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(choiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        if (!i) {
            btn.selected = YES;
            _selectedBtn = btn;
        }
        [_headerV addSubview:btn];
    }
    UIView *choiceV = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/6.0 - 25, 311 + 21 + 38, 50, 1)];
    choiceV.backgroundColor = kRGB_Value(0xff751a);
    _choiceV = choiceV;
    [_headerV addSubview:choiceV];
    
    [self.headerV addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)infoIsChange
{
    _moneyLab.text = [UserDefaultsManager getMoney];
}

- (void)createNavBar
{
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.text = @"我的钱包";
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    _title = label;
    [self.navigationItem setTitleView:label];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
            [self.navigationController pushViewController:[RechargeVC new] animated:YES];
            break;
            
        case 101:
            [self.navigationController pushViewController:[WithdrawVC new] animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)choiceRecord:(UIButton *)btn
{
    if ([btn isEqual:_selectedBtn]) {
        return;
    }
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    switch (btn.tag) {
        case 1000:
        {
            _choiceV.frame = CGRectMake(kWindowWidth/6.0 - 25, 311 + 21 + 38, 50, 1);
            [self.mycollectionV setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        }
        case 1001:
        {
            _choiceV.frame = CGRectMake(kWindowWidth*3/6.0 - 25, 311 + 21 + 38, 50, 1);
            [self.mycollectionV setContentOffset:CGPointMake(kWindowWidth, 0) animated:YES];
            break;
        }
        case 1002:
        {
            _choiceV.frame = CGRectMake(kWindowWidth*5/6.0 - 25, 311 + 21 + 38, 50, 1);
            [self.mycollectionV setContentOffset:CGPointMake(kWindowWidth*2, 0) animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqual:self.headerV] && [keyPath isEqualToString:@"frame"])
    {
        if (self.headerV.y >= -64) {
            [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor clearColor]];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            _title.textColor = [UIColor whiteColor];
            return;
        }
        
        CGFloat alpha = - (self.headerV.y + 64)/40.0;
        if (alpha > 0 && alpha < 1) {
            [self.navigationController.navigationBar setCustomBarBackgroundColor:kRGBA(255, 255, 255, alpha)];
            _title.textColor = kRGBA_Value(0x442509, alpha);
        }
        else if (alpha >= 1)
        {
            [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
            _title.textColor = kRGB_Value(0x442509);
            [self.navigationController.navigationBar setShadowImage:nil];
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        }
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recordCell" forIndexPath:indexPath];
    switch (indexPath.item) {
        case 0:
        {
            cell.infoV = self.allRecordVC.view;
            break;
        }
        case 1:
        {
            cell.infoV = self.withdrawRecordVC.view;
            break;
        }
        case 2:
        {
            cell.infoV = self.rechargeRecordVC.view;
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark - WalletRecordDelegate

- (void)walletRecordDidScroll:(WalletRecordVC *)vc withContentOffset:(CGPoint)origin
{
    CGRect frame = self.headerV.frame;
    if (origin.y < -(311 + 21 - 64)) {
        frame.origin.y = 0;
        self.headerV.frame = frame;
        return;
    }
    if (origin.y > 0) {
        frame.origin.y = -(311 + 21 - 64);
        self.headerV.frame = frame;
        return;
    }
    frame.origin.y = -(311 + 21 - 64 + origin.y);
    self.headerV.frame = frame;
    self.allRecordVC.myTabV.contentOffset = origin;
    self.rechargeRecordVC.myTabV.contentOffset = origin;
    self.withdrawRecordVC.myTabV.contentOffset = origin;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_mycollectionV])
    {
        CGFloat x = scrollView.contentOffset.x;
        CGRect frame = _choiceV.frame;
        frame.origin.x = kWindowWidth/6.0 - 25 + x/3.0;
        _choiceV.frame = frame;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.mycollectionV]) {
        UIButton *btn;
        if (!scrollView.contentOffset.x)
        {
            btn = [self.headerV viewWithTag:1000];
            [self choiceRecord:btn];
        }
        else if (scrollView.contentOffset.x == kWindowWidth)
        {
            btn = [self.headerV viewWithTag:1001];
            [self choiceRecord:btn];
        }
        else if (scrollView.contentOffset.x == kWindowWidth*2)
        {
            btn = [self.headerV viewWithTag:1002];
            [self choiceRecord:btn];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
