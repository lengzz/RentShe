//
//  EditInfoHeader.m
//  RentShe
//
//  Created by Lengzz on 2017/9/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "EditInfoHeader.h"
#import "CustomFlowLayout.h"

#import "EditInfoHeaderCell.h"

#define kCellIdentifier @"EditInfoHeaderCell"

@interface EditInfoHeader ()<UICollectionViewDelegate,UICollectionViewDataSource,CustomFlowLayoutDelegate>
{
    NSInteger _beginIndex;
    UILongPressGestureRecognizer *_longPress;
    UIImageView *_topImg;
    EditInfoHeaderCell *_curCell;
    NSIndexPath *_curIndex;
    NSIndexPath *_toIndex;
}
@property (nonatomic, strong) UICollectionView *myCollectionV;
@end

@implementation EditInfoHeader
- (UICollectionView *)myCollectionV
{
    if (!_myCollectionV) {
        CustomFlowLayout *layout = [[CustomFlowLayout alloc] init];
        layout.delegate = self;
        _myCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, kWindowWidth, kWindowWidth) collectionViewLayout:layout];
        _myCollectionV.delegate = self;
        _myCollectionV.dataSource = self;
        _myCollectionV.bounces = NO;
        //        _myCollectionV.scrollEnabled = NO;
        _myCollectionV.backgroundColor = [UIColor whiteColor];
        [_myCollectionV registerClass:[EditInfoHeaderCell class] forCellWithReuseIdentifier:kCellIdentifier];
        [self addSubview:_myCollectionV];
    }
    return _myCollectionV;
}

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
    [self myCollectionV];
    _beginIndex = -1;
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.myCollectionV addGestureRecognizer:_longPress];
    
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    topImg.hidden = YES;
    topImg.backgroundColor = [UIColor redColor];
    [self addSubview:topImg];
    _topImg = topImg;
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.myCollectionV indexPathForItemAtPoint:[_longPress locationInView:self.myCollectionV]];
                EditInfoHeaderCell *cell = (EditInfoHeaderCell *)[self.myCollectionV cellForItemAtIndexPath:selectIndexPath];
                if (cell.photoV.hidden) {
                    return;
                }
                _curCell = cell;
                _curIndex = selectIndexPath;
                _toIndex = selectIndexPath;
                cell.isMove = YES;
                _topImg.center = cell.center;
                _topImg.image = cell.photoV.image;
                _topImg.hidden = NO;
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [longPress locationInView:_longPress.view];
            NSIndexPath *selectIndexPath = [self.myCollectionV indexPathForItemAtPoint:[_longPress locationInView:self.myCollectionV]];
            EditInfoHeaderCell *cell = (EditInfoHeaderCell *)[self.myCollectionV cellForItemAtIndexPath:selectIndexPath];
            if (_toIndex.item != selectIndexPath.item && !cell.photoV.hidden) {
                [self.myCollectionV moveItemAtIndexPath:_toIndex toIndexPath:selectIndexPath];
                _toIndex = selectIndexPath;
            }
            _topImg.center = point;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self moveItemAtIndexPath:_curIndex toIndexPath:_toIndex];
            _topImg.hidden = YES;
            _curCell.isMove = NO;
            break;
        }
        default: {
            _topImg.hidden = YES;
            _curCell.isMove = NO;
            break;
        }
    }
}

- (void)deleteImage:(NSInteger)index
{
    [self.myCollectionV deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    [self.myCollectionV insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:5 inSection:0]]];
}

- (void)addImage:(NSInteger)index
{
    [self.myCollectionV reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}

- (void)updateHeader
{
    [self.myCollectionV reloadData];
}


- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"1221");
    if ([self.delegate respondsToSelector:@selector(editInfoHeader:moveImageAtIndex:toIndex:)]) {
        [self.delegate editInfoHeader:self moveImageAtIndex:sourceIndexPath.item toIndex:toIndexPath.item];
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.item) {
        return CGSizeMake((kWindowWidth - 10)*2/3.0, (kWindowWidth - 10)*2/3.0);
    }
    return CGSizeMake((kWindowWidth - 10)/3.0, (kWindowWidth - 10)/3.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditInfoHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(editInfoHeader:imageUrlAtIndex:)]) {
        [cell refreshCell:[self.dataSource editInfoHeader:self imageUrlAtIndex:indexPath.item]];
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < self.imgNum) {
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(editInfoHeader:clickImageAtIndex:)]) {
        [self.delegate editInfoHeader:self clickImageAtIndex:indexPath.item];
    }
}

@end
