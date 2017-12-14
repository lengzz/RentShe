//
//  RentMeVC.m
//  RentShe
//
//  Created by Lengzz on 17/6/11.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RentMeVC.h"
#import "RentCell.h"
#import "OrderListVC.h"
#import "OrderListM.h"

#import "ConversationDetailVC.h"

@interface RentMeVC ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *_contentV;
    UIView *_choiceV;
    UIButton *_selectedBtn;
}
@property (nonatomic, strong) UICollectionView *mycollectionV;
@property (nonatomic, strong) OrderListVC *waitConfirmVC;
@property (nonatomic, strong) OrderListVC *waitMeettingVC;
@property (nonatomic, strong) OrderListVC *endVC;
@end

@implementation RentMeVC

- (OrderListVC *)waitConfirmVC
{
    if (!_waitConfirmVC) {
        _waitConfirmVC = [[OrderListVC alloc] init];
        _waitConfirmVC.type = OrderTypeOfRentMe;
        _waitConfirmVC.state = OrderStateOfWait;
        __block typeof(self)wself = self;
        _waitConfirmVC.chatBlock = ^(OrderListM *model)
        {
            [wself chatWithOrder:model];
        };
    }
    return _waitConfirmVC;
}

- (OrderListVC *)waitMeettingVC
{
    if (!_waitMeettingVC) {
        _waitMeettingVC = [[OrderListVC alloc] init];
        _waitMeettingVC.type = OrderTypeOfRentMe;
        _waitMeettingVC.state = OrderStateOfImplement;
        __block typeof(self)wself = self;
        _waitMeettingVC.chatBlock = ^(OrderListM *model)
        {
            [wself chatWithOrder:model];
        };
    }
    return _waitMeettingVC;
}

- (OrderListVC *)endVC
{
    if (!_endVC) {
        _endVC = [[OrderListVC alloc] init];
        _endVC.type = OrderTypeOfRentMe;
        _endVC.state = OrderStateOfEnd;
        __block typeof(self)wself = self;
        _endVC.chatBlock = ^(OrderListM *model)
        {
            [wself chatWithOrder:model];
        };
    }
    return _endVC;
}

- (UICollectionView *)mycollectionV
{
    if (!_mycollectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWindowWidth, kWindowHeight - kNavBarHeight - 44);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mycollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 44, kWindowWidth, kWindowHeight - kNavBarHeight - 44) collectionViewLayout:layout];
        _mycollectionV.backgroundColor = [UIColor whiteColor];
        _mycollectionV.delegate = self;
        _mycollectionV.dataSource = self;
        _mycollectionV.showsHorizontalScrollIndicator = NO;
        _mycollectionV.bounces = NO;
        _mycollectionV.pagingEnabled = YES;
        [_mycollectionV registerClass:[RentCell class] forCellWithReuseIdentifier:@"rentMeCell"];
        [self.view addSubview:_mycollectionV];
    }
    return _mycollectionV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self createV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createV
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kWindowWidth, 44)];
    view.backgroundColor = [UIColor redColor];
    _contentV = view;
    [self.view addSubview:view];
    
    NSArray *arr = @[@"待确认",@"待见面",@"已结束"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kWindowWidth/3.0, 0, kWindowWidth/3.0, 44);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:kRGB_Value(0x565656) forState:UIControlStateNormal];
        [btn setTitleColor:kRGB_Value(0xff751a) forState:UIControlStateSelected];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(choiceStatus:) forControlEvents:UIControlEventTouchUpInside];
        if (!i) {
            btn.selected = YES;
            _selectedBtn = btn;
        }
        [view addSubview:btn];
    }
    UIView *choiceV = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/6.0 - 20, 36, 40, 1)];
    choiceV.backgroundColor = kRGB_Value(0xff751a);
    _choiceV = choiceV;
    [view addSubview:choiceV];
    
    [self mycollectionV];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"谁租了我"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chatWithOrder:(OrderListM *)orderM
{
    RCConversationModel *model = [RCConversationModel new];
    model.conversationType = ConversationType_PRIVATE;
    model.targetId = orderM.his_user_id;
    model.conversationTitle = orderM.nickname;
    
    ConversationDetailVC *_conversationVC = [[ConversationDetailVC alloc] init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = model.targetId;
    _conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:_conversationVC
                                         animated:YES];
}

- (void)choiceStatus:(UIButton *)btn
{
    if ([btn isEqual:_selectedBtn]) {
        return;
    }
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    CGRect frame = _choiceV.frame;
    switch (btn.tag) {
        case 1000:
        {
            frame.origin.x = kWindowWidth/6.0 - 20;
//            _choiceV.frame = frame;
            [self.mycollectionV setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        }
        case 1001:
        {
            frame.origin.x = kWindowWidth*3/6.0 - 20;
//            _choiceV.frame = frame;
            [self.mycollectionV setContentOffset:CGPointMake(kWindowWidth, 0) animated:YES];
            break;
        }
        case 1002:
        {
            frame.origin.x = kWindowWidth*5/6.0 - 20;
//            _choiceV.frame = frame;
            [self.mycollectionV setContentOffset:CGPointMake(kWindowWidth*2, 0) animated:YES];
            break;
        }
        default:
            break;
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
    RentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rentMeCell" forIndexPath:indexPath];
    switch (indexPath.item) {
        case 0:
        {
            self.waitConfirmVC.view.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight - kNavBarHeight - 44);
            cell.infoV = self.waitConfirmVC.view;
            break;
        }
        case 1:
        {
            self.waitMeettingVC.view.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight - kNavBarHeight - 44);
            cell.infoV = self.waitMeettingVC.view;
            break;
        }
        case 2:
        {
            self.endVC.view.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight - kNavBarHeight - 44);
            cell.infoV = self.endVC.view;
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_mycollectionV])
    {
        CGFloat x = scrollView.contentOffset.x;
        CGRect frame = _choiceV.frame;
        frame.origin.x = kWindowWidth/6.0 - 20 + x/3.0;
        _choiceV.frame = frame;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.mycollectionV]) {
        UIButton *btn;
        if (!scrollView.contentOffset.x)
        {
            btn = [_contentV viewWithTag:1000];
            [self choiceStatus:btn];
        }
        else if (scrollView.contentOffset.x == kWindowWidth)
        {
            btn = [_contentV viewWithTag:1001];
            [self choiceStatus:btn];
        }
        else if (scrollView.contentOffset.x == kWindowWidth*2)
        {
            btn = [_contentV viewWithTag:1002];
            [self choiceStatus:btn];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end