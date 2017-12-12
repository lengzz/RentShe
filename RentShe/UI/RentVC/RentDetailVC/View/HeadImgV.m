//
//  HeadImgV.m
//  CustomNavBar
//
//  Created by Lzz on 2017/11/7.
//  Copyright © 2017年 Lzz. All rights reserved.
//

#import "HeadImgV.h"
#define kHeadImgCell @"HeadImgCellIdentifier"
#define kHeadImgBackColor [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]

@interface HeadImgCell : UICollectionViewCell

- (void)refreshCell:(NSString *)str;

@end

@interface HeadImgV ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_myCollectionV;
    UIView *_numV;
    UILabel *_numLab;
}

@end

@implementation HeadImgV

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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.bounds.size;
    layout.minimumLineSpacing = 0;

    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *myCollectionV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    myCollectionV.showsHorizontalScrollIndicator = NO;
    myCollectionV.delegate = self;
    myCollectionV.dataSource = self;
    myCollectionV.backgroundColor = kHeadImgBackColor;
    myCollectionV.pagingEnabled = YES;
    myCollectionV.bounces = NO;
    [myCollectionV registerClass:[HeadImgCell class] forCellWithReuseIdentifier:kHeadImgCell];
    [self addSubview:myCollectionV];
    _myCollectionV = myCollectionV;
    
    UIView *numV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 60, CGRectGetHeight(self.bounds) - 60, 40, 40)];
    numV.backgroundColor = [UIColor grayColor];
    numV.layer.cornerRadius = 20.0;
    numV.layer.masksToBounds = YES;
    [self addSubview:numV];
    _numV = numV;
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:numV.bounds];
    numLab.textColor = [UIColor whiteColor];
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.font = [UIFont systemFontOfSize:15];
    [numV addSubview:numLab];
    _numLab = numLab;
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    if (dataArr.count)
    {
        _numLab.text = [NSString stringWithFormat:@"1/%zd",dataArr.count];
        _numV.hidden = NO;
    }
    else
    {
        _numV.hidden = YES;
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HeadImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHeadImgCell forIndexPath:indexPath];
    [cell refreshCell:self.dataArr[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint pInView = [self convertPoint:_myCollectionV.center toView:_myCollectionV];
    NSIndexPath *index = [_myCollectionV indexPathForItemAtPoint:pInView];
    _numLab.text = [NSString stringWithFormat:@"%zd/%zd",index.item + 1,self.dataArr.count];
}

@end

@interface HeadImgCell()
{
    UIImageView *_imgV;
}

@end

@implementation HeadImgCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    UIImageView *imgV = [[UIImageView alloc] init];
    [self.contentView addSubview:imgV];
    _imgV = imgV;
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)refreshCell:(NSString *)str
{
    [_imgV sd_setImageWithUrlStr:str];
}

@end
