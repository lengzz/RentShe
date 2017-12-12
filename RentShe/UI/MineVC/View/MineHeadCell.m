//
//  MineHeadCell.m
//  RentShe
//
//  Created by Lengzz on 17/5/20.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MineHeadCell.h"

@interface MineHeadCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *fansLab;
@property (nonatomic, strong) UILabel *logLab;

@end

@implementation MineHeadCell

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
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 55, 55)];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 27.5;
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth - 15 - 17, 26.5, 17, 17)];
    rightImg.image = [UIImage imageNamed:@"mine_right"];
    [self.contentView addSubview:rightImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 55, 25, kWindowWidth - 160, 20)];
    nameLab.font = [UIFont systemFontOfSize:17];
    nameLab.textColor = kRGB_Value(0x282828);
    self.nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UILabel *fansLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 55, 35, kWindowWidth - 160, 20)];
    fansLab.font = [UIFont systemFontOfSize:12];
    fansLab.textColor = kRGB_Value(0x989898);
    self.fansLab = fansLab;
    [self.contentView addSubview:fansLab];
    
    UILabel *logLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 55, 35, 100, 20)];
    logLab.font = [UIFont systemFontOfSize:17];
    logLab.textColor = kRGB_Value(0x282828);
    logLab.text = @"登录";
    self.logLab = logLab;
    [self.contentView addSubview:logLab];
}

- (void)refreshCellIsLogin:(BOOL)isLogin
{
    if (isLogin)
    {
        self.logLab.hidden = YES;
        self.nameLab.hidden = NO;
        self.fansLab.hidden = YES;
        
        self.nameLab.text = [UserDefaultsManager getNickName];
        self.fansLab.text = [NSString stringWithFormat:@"粉丝 %@",[UserDefaultsManager getVisitorNum]];
        [self.icon sd_setImageWithUrlStr:[UserDefaultsManager getAvatar]];
    }
    else
    {
        self.icon.image = [UIImage imageNamed:@"mine_default"];
        self.logLab.hidden = NO;
        self.nameLab.hidden = YES;
        self.fansLab.hidden = YES;
    }
}

@end
