//
//  InformFooterV.m
//  RentShe
//
//  Created by Feng on 2017/11/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "InformFooterV.h"
#import "EditInfoHeaderCell.h"

#define kInformFooter @"InformFooterIdentifier"

@interface InformFooterV ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *myCollectionV;
@end

@implementation InformFooterV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createV];
    }
    return self;
}

- (void)createV
{
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kWindowWidth - 30, 20)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = kRGB(51, 51, 51);
    lab.text = @"添加图片说明";
    [self addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, kWindowWidth - 15, 0.5)];
    line.backgroundColor = kRGB(229, 229, 229);
    [self addSubview:line];
    [self myCollectionV];
}

- (UICollectionView *)myCollectionV
{
    if (!_myCollectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake(kWindowWidth/3.0 - 20, kWindowWidth/3.0 - 30);
        _myCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, kWindowWidth, kWindowWidth/3.0) collectionViewLayout:layout];
        _myCollectionV.delegate = self;
        _myCollectionV.dataSource = self;
        _myCollectionV.bounces = NO;
        _myCollectionV.scrollEnabled = NO;
        _myCollectionV.backgroundColor = [UIColor whiteColor];
        [_myCollectionV registerClass:[EditInfoHeaderCell class] forCellWithReuseIdentifier:kInformFooter];
        [self addSubview:_myCollectionV];
    }
    return _myCollectionV;
}

- (void)updateHeader
{
    [self.myCollectionV reloadData];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditInfoHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kInformFooter forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(informFooter:imageUrlAtIndex:)]) {
        [cell refreshCell:[self.dataSource informFooter:self imageUrlAtIndex:indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(informFooter:clickImageAtIndex:)]) {
        [self.delegate informFooter:self clickImageAtIndex:indexPath.item];
    }
}


@end
