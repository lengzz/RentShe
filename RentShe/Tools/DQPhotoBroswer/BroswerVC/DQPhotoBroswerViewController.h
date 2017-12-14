//
//  DQPhotoBroswerViewController.h
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQPhotoBroswerViewController : UIView
+(void)showWithIndex:(NSUInteger)index photoModelBlock:(NSArray *(^)())photoModelBlock currentPageWhenDismiss:(void(^)(NSInteger page))setCurrentPage;
@end
