//
//  CustomFlowLayout.h
//  TouchMoveDemo
//
//  Created by Lengzz on 17/6/21.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CustomFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>
@end

@interface CustomFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<CustomFlowLayoutDelegate> delegate;
@end
