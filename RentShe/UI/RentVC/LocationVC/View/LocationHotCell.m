//
//  LocationHotCell.m
//  RentShe
//
//  Created by Lengzz on 17/6/2.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "LocationHotCell.h"
#import "CityM.h"

@interface HotCityCell : UICollectionViewCell
{
    UILabel *_cityLab;
}
- (void)refreshCell:(CityM *)obj;

@end

@implementation HotCityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5.0;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = kRGB(228, 228, 228).CGColor;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth/3.0 - 24, 43)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = kRGB(40, 40, 40);
        lab.textAlignment = NSTextAlignmentCenter;
        _cityLab = lab;
        [self.contentView addSubview:lab];
    }
    return self;
}

- (void)refreshCell:(CityM *)m
{
    _cityLab.text = m.city;
}

@end

@interface LocationHotCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_dataArr;
}
@property(nonatomic, strong) UICollectionView *myCollectionV;
@end

@implementation LocationHotCell

- (UICollectionView *)myCollectionV
{
    if (!_myCollectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWindowWidth/3.0 - 24, 43);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 24, 0, 10);
        _myCollectionV = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _myCollectionV.delegate = self;
        _myCollectionV.dataSource = self;
        [_myCollectionV registerClass:[HotCityCell class] forCellWithReuseIdentifier:@"hotCityCell"];
        _myCollectionV.scrollEnabled = NO;
        _myCollectionV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_myCollectionV];
        [_myCollectionV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.width.equalTo(@(kWindowWidth - 15));
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return _myCollectionV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)refreshCell:(NSArray *)arr
{
    _dataArr = arr;
    [self myCollectionV];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotCityBlock) {
        self.hotCityBlock(_dataArr[indexPath.item]);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataArr.count) {
        return _dataArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotCityCell" forIndexPath:indexPath];
    [cell refreshCell:_dataArr[indexPath.item]];
    return cell;
}

- (void)dealloc
{
//    NSLog(@"11110000");
}

@end


