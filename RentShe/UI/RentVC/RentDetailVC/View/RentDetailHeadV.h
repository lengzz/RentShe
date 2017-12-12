//
//  RentDetailHeadV.h
//  RentShe
//
//  Created by Lengzz on 17/6/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentDetailHeadV : UIView
@property (nonatomic, copy) void (^clickBlock)(NSInteger tag);
- (instancetype)initWithFrame:(CGRect)frame andIsSelf:(BOOL)isSelf;
- (void)refreshHead:(id)obj;
@end
