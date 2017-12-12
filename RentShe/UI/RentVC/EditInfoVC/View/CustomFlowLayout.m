//
//  CustomFlowLayout.m
//  TouchMoveDemo
//
//  Created by Lengzz on 17/6/21.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CustomFlowLayout.h"

@interface CustomFlowLayout ()
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@end

@implementation CustomFlowLayout
- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    return self;
}

#pragma mark - Methods to Override
- (CGSize)collectionViewContentSize
{
    [super collectionViewContentSize];
    return CGSizeMake(kWindowWidth, kWindowWidth);
}
- (void)prepareLayout
{
    [super prepareLayout];
    
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGFloat xOffset = self.sectionInset.left;
    CGFloat yOffset = self.sectionInset.top;
    CGFloat xNextOffset = self.sectionInset.left;
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
        xNextOffset += (self.minimumInteritemSpacing + itemSize.width);
        if (xNextOffset > [self collectionView].bounds.size.width + 1) {
            if (idx == 2)
            {
                xOffset = self.sectionInset.left + self.minimumInteritemSpacing + [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].width;
            }
            else
            {
                xOffset = self.sectionInset.left;
            }
            xNextOffset = (xOffset + self.minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + self.minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
        }
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        [_itemAttributes addObject:layoutAttributes];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}
@end
