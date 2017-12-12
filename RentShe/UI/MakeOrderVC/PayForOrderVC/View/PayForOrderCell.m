//
//  PayForOrderCell.m
//  RentShe
//
//  Created by Lengzz on 2017/8/27.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "PayForOrderCell.h"

@interface PayForOrderCell ()
{
    UIImageView *_iconImg;
    UILabel *_titleLab;
    UIImageView *_selectedImg;
}
@end

@implementation PayForOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 26, 26)];
    [self.contentView addSubview:iconImg];
    _iconImg = iconImg;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, kWindowWidth - 100, 20)];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = kRGB_Value(0x282828);
    [self.contentView addSubview:titleLab];
    _titleLab = titleLab;
    
    UIImageView *selectedImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth - 31, 14, 16, 16)];
    [self.contentView addSubview:selectedImg];
    _selectedImg = selectedImg;
}

- (void)setType:(PayType)type
{
    _type = type;
    
    switch (type) {
        case PayTypeOfSys:
            _titleLab.text = [NSString stringWithFormat:@"钱包支付(可用余额%@元)",self.tips];
            _iconImg.image = [UIImage imageNamed:@"pay_wallet"];
            break;
        case PayTypeOfWeChat:
            _titleLab.text = @"微信支付";
            _iconImg.image = [UIImage imageNamed:@"pay_weixin"];
            break;
        case PayTypeOfZfb:
            _titleLab.text = @"支付宝支付";
            _iconImg.image = [UIImage imageNamed:@"pay_alipay"];
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _selectedImg.image = selected ? [UIImage imageNamed:@"rent_chooseweek"]: [UIImage new];
    
}

@end
