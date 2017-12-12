//
//  ChooseWeekCell.m
//  RentShe
//
//  Created by Lengzz on 2017/9/17.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ChooseWeekCell.h"

@interface ChooseWeekCell ()
{
    UIImageView *_seletedImg;
}

@end

@implementation ChooseWeekCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createCell
{
    UIImageView *seletedImg = [[UIImageView alloc] initWithImage:[CustomNavVC imageWithColor:kRGB(195, 195, 195)]];
    [self.contentView addSubview:seletedImg];
    seletedImg.layer.cornerRadius = 10;
    seletedImg.layer.masksToBounds = YES;
    _seletedImg = seletedImg;
    
    [seletedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _seletedImg.image = selected ? [UIImage imageNamed:@"rent_chooseweek"] : [CustomNavVC imageWithColor:kRGB(195, 195, 195)];
}

@end
