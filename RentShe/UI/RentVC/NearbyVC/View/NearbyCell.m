//
//  NearbyCell.m
//  RentShe
//
//  Created by Lengzz on 17/5/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "NearbyCell.h"

#import "NearbyM.h"
#import "UserInfoM.h"
#import "RentSkillM.h"
#import "RentInfoM.h"

@interface NearbyCell ()
{
    UIImageView *_headImg;
    UIImageView *_sexImg;
    UILabel *_nameLab;
    UILabel *_ageLab;
    UILabel *_skillLab;
    UILabel *_distanceLab;
    UILabel *_professionLab;
    UILabel *_priceLab;
}
@end

@implementation NearbyCell

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
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 76, 76)];
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(106, 10, 50, 15)];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = kRGB_Value(0x282828);
    _nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UIView *ageV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 15)];
    ageV.layer.masksToBounds = YES;
    ageV.layer.cornerRadius = 7.5;
    ageV.layer.borderWidth = .5;
    ageV.layer.borderColor = kRGB_Value(0x989898).CGColor;
    [self.contentView addSubview:ageV];
    UIImageView *sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 2, 11, 11)];
    _sexImg = sexImg;
    [ageV addSubview:sexImg];
    UILabel *ageLab = [[UILabel alloc] initWithFrame:CGRectMake(19, 1.5, 45 - 15 - 12, 12)];
    ageLab.font = [UIFont systemFontOfSize:12];
    ageLab.textColor = kRGB_Value(0x989898);
    ageLab.textAlignment = NSTextAlignmentCenter;
    _ageLab = ageLab;
    [ageV addSubview:ageLab];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(headImg.mas_right).offset(15);
    }];
    [ageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLab.mas_centerY);
        make.left.equalTo(nameLab.mas_right).offset(10);
        make.height.equalTo(@15);
        make.width.equalTo(@45);
    }];
    
    UILabel *skillLab = [[UILabel alloc] initWithFrame:CGRectMake(106, 39, kWindowWidth - 106 - 15, 12)];
    skillLab.font = [UIFont systemFontOfSize:12];
    skillLab.textColor = kRGB_Value(0x989898);
    _skillLab = skillLab;
    [self.contentView addSubview:skillLab];
    
    UIImageView *distanceImg = [[UIImageView alloc] initWithFrame:CGRectMake(106, 90 - 7 - 16, 16, 16)];
    distanceImg.image = [UIImage imageNamed:@"rent_distance"];
    [self.contentView addSubview:distanceImg];
    
    UILabel *distanceLab = [[UILabel alloc] init];
    distanceLab.font = [UIFont systemFontOfSize:12];
    distanceLab.textColor = kRGB_Value(0x989898);
    _distanceLab = distanceLab;
    [self.contentView addSubview:distanceLab];
    
    UIImageView *professionImg = [[UIImageView alloc] init];
    professionImg.image = [UIImage imageNamed:@"rent_profession"];
    [self.contentView addSubview:professionImg];
    
    UILabel *professionLab = [[UILabel alloc] init];
    professionLab.font = [UIFont systemFontOfSize:12];
    professionLab.textColor = kRGB_Value(0x989898);
    _professionLab = professionLab;
    [self.contentView addSubview:professionLab];
    
    UIImageView *priceImg = [[UIImageView alloc] init];
    priceImg.image = [UIImage imageNamed:@"rent_price"];
    [self.contentView addSubview:priceImg];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.font = [UIFont systemFontOfSize:12];
    priceLab.textColor = kRGB_Value(0x989898);
    _priceLab = priceLab;
    [self.contentView addSubview:priceLab];
    
    [distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(distanceImg.mas_centerY);
        make.left.equalTo(distanceImg.mas_right).offset(5);
    }];
    
    [professionImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(distanceImg.mas_centerY);
        make.left.equalTo(distanceLab.mas_right).offset(10);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
    }];
    
    [professionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(distanceImg.mas_centerY);
        make.left.equalTo(professionImg.mas_right).offset(5);
    }];
    
    [priceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(distanceImg.mas_centerY);
        make.left.equalTo(professionLab.mas_right).offset(10);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
    }];
    
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(distanceImg.mas_centerY);
        make.left.equalTo(priceImg.mas_right).offset(5);
    }];
}

- (void)refreshCell:(id)obj
{
    if (!obj)
    {
        NSArray *imgArr = @[@"http://img3.duitang.com/uploads/item/201609/18/20160918000527_GZfkP.thumb.224_0.jpeg",@"http://www.qqzi.net/uploads/allimg/160324/021410I11-0-lp.jpg",@"http://img.bitscn.com/upimg/allimg/c160120/1453262W253120-12J05.jpg",@"http://v1.qzone.cc/avatar/201508/24/10/45/55da854d208b0119.jpg%21200x200.jpg"];
        NSInteger i = arc4random()%4;
        _nameLab.text = @"琳娜";
        _ageLab.text = @"98";
        _skillLab.text = @"陪聊、音乐、运动健身";
        _distanceLab.text = @"99km";
        _professionLab.text = @"销售";
        _priceLab.text = @"999/小时";
        _sexImg.image = [UIImage imageNamed:i % 2 ? @"rent_male" : @"rent_female"];
        [_headImg sd_setImageWithUrlStr:imgArr[i]];
    }
    else if ([obj isKindOfClass:[NearbyM class]])
    {
        NearbyM *model = obj;
        NSMutableString *skills = [NSMutableString string];
        if ([model.rent_skill isKindOfClass:[NSArray class]] && model.rent_skill.count)
        {
            for (id obj in model.rent_skill[0].layer_info) {
                [skills appendFormat:@"、%@",obj[@"skill_name"]];
            }
            _skillLab.text = skills.length > 2 ? [skills substringFromIndex:1] : @"";
            _priceLab.text = [NSString stringWithFormat:@"%@/小时",model.rent_skill[0].price];
        }
        else
        {
            _skillLab.text = @"";
            _priceLab.text = @"";
        }
        _nameLab.text = model.user_info.nickname;
        _ageLab.text = model.user_info.age;
        NSString *distanceStr;
        CGFloat distance = model.rent_info.distance;
        if (distance < 0.01)
        {
            distance = distance * 1000;
            distanceStr = [NSString stringWithFormat:@"%.0f米",distance];
        }
        else
            distanceStr = [NSString stringWithFormat:@"%.2f千米",distance];
        _distanceLab.text = distanceStr;
        _professionLab.text = model.user_info.vocation;
        _sexImg.image = [UIImage imageNamed:[model.user_info.gender integerValue] ? @"rent_female" : @"rent_male"];
        [_headImg sd_setImageWithUrlStr:model.user_info.avatar];
    }
    [self labSizeToFit];
}

- (void)labSizeToFit
{
    [_nameLab sizeToFit];
    [_distanceLab sizeToFit];
    [_professionLab sizeToFit];
    [_priceLab sizeToFit];
}

@end
