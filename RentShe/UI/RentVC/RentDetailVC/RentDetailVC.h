//
//  RentDetailVC.h
//  RentShe
//
//  Created by Lengzz on 17/5/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NearbyM;

@interface RentDetailVC : UIViewController
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, strong) NearbyM *infoM;
@property (nonatomic, assign) BOOL isSelf;
@end
