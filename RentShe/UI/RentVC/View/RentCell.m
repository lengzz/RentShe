//
//  RentCell.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RentCell.h"

@implementation RentCell

- (void)setInfoV:(UIView *)infoV
{
    if (_infoV) {
        [_infoV removeFromSuperview];
    }
    infoV.frame = self.contentView.bounds;
    _infoV = infoV;
    [self.contentView addSubview:_infoV];
}

@end
