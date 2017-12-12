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
//    _beginIndex = -1;
//    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
//    [self.myCollectionV addGestureRecognizer:_longPress];
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.myCollectionV indexPathForItemAtPoint:[_longPress locationInView:self.myCollectionV]];
                
                [self.myCollectionV beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.myCollectionV updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.myCollectionV endInteractiveMovement];
            break;
        }
        default: [self.myCollectionV cancelInteractiveMovement];
            break;
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

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"1221");
    if ([self.delegate respondsToSelector:@selector(editInfoHeader:moveImageAtIndex:toIndex:)]) {
        [self.delegate editInfoHeader:self moveImageAtIndex:sourceIndexPath.item toIndex:destinationIndexPath.item];
    }
}

@end
