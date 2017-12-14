//
//  RecommendCell.m
//  RentShe
//
//  Created by Lengzz on 17/5/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RecommendCell.h"
#import "NearbyM.h"

@interface RecommendCell ()
{
    UIImageView *_headImg;
    UIImageView *_sexImg;
    UILabel *_nameLab;
    UILabel *_skillLab;
    UILabel *_professionLab;
    UILabel *_priceLab;
}

@end

@implementation RecommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.width)];
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 6 + self.contentView.bounds.size.width, 0, 0)];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = kRGB_Value(0x282828);
    _nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UIImageView *sexImg = [[UIImageView alloc] init];
    _sexImg = sexImg;
    [self.contentView addSubview:sexImg];
    
    UILabel *professionLab = [[UILabel alloc] init];
    professionLab.font = [UIFont systemFontOfSize:12];
    professionLab.textColor = [UIColor whiteColor];
    professionLab.textAlignment = NSTextAlignmentCenter;
    professionLab.layer.masksToBounds = YES;
    professionLab.layer.cornerRadius = 7.5;
    _professionLab = professionLab;
    [self.contentView addSubview:professionLab];
    
    UILabel *skillLab = [[UILabel alloc] init];
    skillLab.font = [UIFont systemFontOfSize:12];
    skillLab.textColor = kRGB_Value(0x989898);
    _skillLab = skillLab;
    [self.contentView addSubview:skillLab];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.font = [UIFont systemFontOfSize:12];
    priceLab.textColor = kRGB_Value(0x989898);
    priceLab.textAlignment = NSTextAlignmentRight;
    [priceLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _priceLab = priceLab;
    [self.contentView addSubview:priceLab];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(headImg.mas_bottom).offset(6);
    }];
    [sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLab.mas_centerY);
        make.left.equalTo(nameLab.mas_right).offset(5);
        make.right.lessThanOrEqualTo(professionLab.mas_left).offset(-5);
        make.width.equalTo(@11);
        make.height.equalTo(@11);
    }];
    
    [professionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLab.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@15);
    }];
    
    [skillLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLab.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom).offset(6);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.greaterThanOrEqualTo(skillLab.mas_right).offset(6);
    }];
}

- (void)refreshCell:(id)obj
{
    if (!obj) {
        NSArray *imgArr = @[@"http://img3.duitang.com/uploads/item/201609/18/20160918000527_GZfkP.thumb.224_0.jpeg",@"http://www.qqzi.net/uploads/allimg/160324/021410I11-0-lp.jpg",@"http://img.bitscn.com/upimg/allimg/c160120/1453262W253120-12J05.jpg",@"http://v1.qzone.cc/avatar/201508/24/10/45/55da854d208b0119.jpg%21200x200.jpg"];
        NSInteger i = arc4random()%4;
        _nameLab.text = @"琳娜";
        _priceLab.text = @"$99/小时";
        _skillLab.text = @"陪聊、音乐";
        _professionLab.text = i % 2 ? @"销销售售":@"销售";
        _sexImg.image = [UIImage imageNamed:i % 2 ? @"rent_male" : @"rent_female"];
        _professionLab.backgroundColor = i % 2 ?kRGB(28, 185, 255):kRGB(252, 0, 128);
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
        _professionLab.backgroundColor = [model.user_info.gender integerValue] ?kRGB(252, 0, 128) : kRGB(28, 185, 255);
        NSMutableString *vocation = [model.user_info.vocation mutableCopy];
        if (!vocation.length)
        {
            _professionLab.hidden = YES;
        }
        else
        {
            _professionLab.hidden = NO;
            _professionLab.text = vocation.length > 3 ? [vocation substringToIndex:2] : vocation;
        }
        
        _sexImg.image = [UIImage imageNamed:[model.user_info.gender integerValue] ? @"rent_female" : @"rent_male"];
        NSArray *photoArr = [model.user_info.photo componentsSeparatedByString:@","];
        if (photoArr.count)
        {
            [_headImg sd_setImageWithUrlStr:photoArr[0]];
        }
        else
            [_headImg sd_setImageWithUrlStr:model.user_info.avatar];
    }
    [self labSizeToFit];
}

- (void)labSizeToFit
{
//    [_nameLab sizeToFit];
    
    CGSize size = [_professionLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    size.width += 15;
    [_professionLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width));
    }];
}

@end
