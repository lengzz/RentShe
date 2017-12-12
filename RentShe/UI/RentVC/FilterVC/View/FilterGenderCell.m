//
//  FilterGenderCell.m
//  RentShe
//
//  Created by Lengzz on 2017/7/8.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "FilterGenderCell.h"

@interface GenderCell : UICollectionViewCell
{
    UILabel *_genderLab;
}
- (void)refreshCell:(id)obj;

@end

@implementation GenderCell

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
        _genderLab = lab;
        [self.contentView addSubview:lab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        _genderLab.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = kRGB(253, 114, 29);
    }
    else
    {
        _genderLab.textColor = kRGB(40, 40, 40);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)refreshCell:(id)obj
{
    _genderLab.text = obj;
}

@end

@interface FilterGenderCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_dataArr;
}
@property(nonatomic, strong) UICollectionView *myCollectionV;
@end

@implementation FilterGenderCell

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
        [_myCollectionV registerClass:[GenderCell class] forCellWithReuseIdentifier:@"genderCell"];
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

- (void)refreshCell:(NSString *)str
{
    _dataArr = @[@"全部",@"男",@"女"];
    [self myCollectionV];
    if ([str isEqualToString:@""])
    {
        [self.myCollectionV selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    else if ([str isEqualToString:@"0"])
    {
        [self.myCollectionV selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    else
    {
        [self.myCollectionV selectItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    if (self.genderBlock) {
        self.genderBlock(_dataArr[indexPath.item]);
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
    GenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"genderCell" forIndexPath:indexPath];
    [cell refreshCell:_dataArr[indexPath.item]];
    return cell;
}

- (void)dealloc
{
    //    NSLog(@"11110000");
}

@end


