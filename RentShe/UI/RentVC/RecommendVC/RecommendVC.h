//
//  RecommendVC.h
//  RentShe
//
//  Created by Lengzz on 17/5/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendVC : UIViewController
@property (nonatomic, strong) UICollectionView *myCollectionV;
@property (nonatomic, weak) UINavigationController *navC;

- (void)filterChange;
@end
