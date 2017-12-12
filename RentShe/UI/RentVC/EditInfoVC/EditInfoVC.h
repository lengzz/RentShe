//
//  EditInfoVC.h
//  RentShe
//
//  Created by Lengzz on 2017/9/20.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NearbyM;

@interface EditInfoVC : UIViewController

@property (nonatomic, copy) dispatch_block_t isChange;

@property (nonatomic, strong) NearbyM *infoM;
@end
