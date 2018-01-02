//
//  EditInfoHeaderCell.h
//  RentShe
//
//  Created by Lengzz on 2017/9/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditInfoHeaderCell : UICollectionViewCell


@property (nonatomic, strong) UIImageView *photoV;
@property (nonatomic, assign) BOOL isMove;

- (void)refreshCell:(id)obj;

@end
