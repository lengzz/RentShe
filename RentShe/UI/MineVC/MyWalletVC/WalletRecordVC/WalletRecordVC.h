//
//  WalletRecordVC.h
//  RentShe
//
//  Created by Lengzz on 17/6/11.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletRecordM.h"
@class WalletRecordVC;

@protocol WalletRecordDelegate <NSObject>

- (void)walletRecordDidScroll:(WalletRecordVC *)vc withContentOffset:(CGPoint)origin;

@end

@interface WalletRecordVC : UIViewController
@property (nonatomic, copy) void (^showBlock)(BOOL);
@property (nonatomic, assign) WalletType type;
@property (nonatomic, assign) WalletPurpose purpose;
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, weak) id<WalletRecordDelegate> delegate;
@end
