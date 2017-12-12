//
//  AddRentSkillVC.m
//  RentShe
//
//  Created by Lengzz on 2017/9/16.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "AddRentSkillVC.h"
#import "AddRentSkillCell.h"
#import "AddRentSkillHeaderV.h"

#define kCellIdentifier @"addrentskillcell"
#define kHeaderIdentifier @"addrentskillheader"

@interface AddRentSkillVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) UICollectionView *myColletionV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *skillArr;
@end

@implementation AddRentSkillVC

- (NSMutableArray *)skillArr
{
    if (!_skillArr) {
        _skillArr = [NSMutableArray array];
    }
    return _skillArr;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UICollectionView *)myColletionV
{
    if (!_myColletionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 20, 15, 20);
        layout.itemSize = CGSizeMake((kWindowWidth - 42 - 30)/3.0, 40);
        layout.headerReferenceSize = CGSizeMake(kWindowWidth, 120);
        _myColletionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _myColletionV.delegate = self;
        _myColletionV.dataSource = self;
        _myColletionV.allowsMultipleSelection = YES;
        [_myColletionV registerClass:[AddRentSkillCell class] forCellWithReuseIdentifier:kCellIdentifier];
        [_myColletionV registerClass:[AddRentSkillHeaderV class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
        _myColletionV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_myColletionV];
        [_myColletionV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(0);
        }];
    }
    return _myColletionV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavbar];
    [self myColletionV];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"添加技能"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
    UIButton *btn = [CustomNavVC getRightDefaultButtonWithTarget:self action:@selector(completed) titile:@"完成"];
    [btn setTitleColor:kRGB(255, 117, 26) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completed
{
    if (!self.price || !self.skillArr.count) {
        return;
    }
    else
    {
        if (self.skillBlock) {
            self.skillBlock(self.price,self.skillArr);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    [NetAPIManager getSkills:nil callBack:^(BOOL success, id object) {
        if (success) {
            NSArray *arr = object[@"data"];
            if ([arr isKindOfClass:[NSArray class]] && arr.count) {
                for (id obj in arr) {
                    [self.dataArr addObject:obj];
                }
                [self.myColletionV reloadData];
            }
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id skill = self.dataArr[indexPath.item];
    if (!skill) {
        return;
    }
    if (self.skillArr.count == 3) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        return;
    }
    [self.skillArr addObject:skill];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id skill = self.dataArr[indexPath.item];
    if (!skill) {
        return;
    }
    if ([self.skillArr containsObject:skill]) {
        [self.skillArr removeObject:skill];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddRentSkillCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell refreshCell:self.dataArr[indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AddRentSkillHeaderV *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        __weak typeof(self) wself = self;
        header.priceBlock = ^(NSString *price){
            wself.price = price;
        };
        return header;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
