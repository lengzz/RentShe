//
//  DisFocusCell.m
//  RentShe
//
//  Created by Lzz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "DisFocusCell.h"
#define kDisFocusCell @"disFocusCellIdentifier"
@interface DisFocusCell ()
{
    UIImageView *_headImg;
    UIImageView *_coverImg;
    UILabel *_nameLab;
    UILabel *_timeLab;
    UILabel *_contentLab;
    UILabel *_distanceLab;
    UILabel *_watchLab;
    UILabel *_praiseLab;
    UILabel *_commentLab;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
@implementation DisFocusCell
+ (instancetype)cellWithTableView:(UITableView *)tableV withIndexPath:(NSIndexPath *)indexPath
{
    DisFocusCell *cell = [tableV dequeueReusableCellWithIdentifier:kDisFocusCell];
    cell.indexPath = indexPath;
    if (!cell) {
        cell = [[DisFocusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDisFocusCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

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
    [professionLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _professionLab = professionLab;
    [self.contentView addSubview:professionLab];
    
    UIImageView *priceImg = [[UIImageView alloc] init];
    priceImg.image = [UIImage imageNamed:@"rent_price"];
    [self.contentView addSubview:priceImg];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.font = [UIFont systemFontOfSize:12];
    priceLab.textColor = kRGB_Value(0x989898);
    [priceLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
    }];
}

- (void)refreshCell:(id)obj
{
    NSArray *imgArr = @[@"http://img3.duitang.com/uploads/item/201609/18/20160918000527_GZfkP.thumb.224_0.jpeg",@"http://www.qqzi.net/uploads/allimg/160324/021410I11-0-lp.jpg",@"http://img.bitscn.com/upimg/allimg/c160120/1453262W253120-12J05.jpg",@"http://v1.qzone.cc/avatar/201508/24/10/45/55da854d208b0119.jpg%21200x200.jpg"];
    NSInteger i = arc4random()%4;
        
}
@end
