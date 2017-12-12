//
//  AddRentSkillHeaderV.h
//  RentShe
//
//  Created by Lengzz on 2017/9/16.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRentSkillHeaderV : UICollectionReusableView

@property (nonatomic, copy) void (^priceBlock) (NSString *price);
@end
