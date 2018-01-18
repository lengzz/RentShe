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
@property (nonatomic, strong) UILabel *signLab;
@property (nonatomic, strong) UILabel *logLab;

@property (nonatomic, strong) UILabel *focusLab;
@property (nonatomic, strong) UILabel *fansLab;
@property (nonatomic, strong) UILabel *videosLab;
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
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 60, 60)];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 30.0;
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth - 15 - 17, 41.5, 17, 17)];
    rightImg.image = [UIImage imageNamed:@"mine_right"];
    [self.contentView addSubview:rightImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 60, 30, kWindowWidth - 160, 20)];
    nameLab.font = [UIFont systemFontOfSize:17];
    nameLab.textColor = kRGB_Value(0x282828);
    self.nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UILabel *signLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 60, 55, kWindowWidth - 160, 20)];
    signLab.font = [UIFont systemFontOfSize:12];
    signLab.textColor = kRGB_Value(0x989898);
    self.signLab = signLab;
    [self.contentView addSubview:signLab];
    
    UILabel *logLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 60, 40, 100, 20)];
    logLab.font = [UIFont systemFontOfSize:17];
    logLab.textColor = kRGB_Value(0x282828);
    logLab.text = @"登录";
    self.logLab = logLab;
    [self.contentView addSubview:logLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5, kWindowWidth, 0.5)];
    line.backgroundColor = kRGB_Value(0xf2f2f2);
    [self.contentView addSubview:line];
    
    for (NSInteger i = 0; i < 3; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * kWindowWidth/3.0, 100, kWindowWidth/3.0, 50)];
        view.tag = i + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionClick:)];
        [view addGestureRecognizer:tap];
        [self.contentView addSubview:view];
        {
            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, kWindowWidth/3.0, 20)];
            numLab.font = [UIFont systemFontOfSize:15];
            numLab.textColor = kRGB_Value(0x282828);
            numLab.textAlignment = NSTextAlignmentCenter;
            numLab.text = @"0";
            [view addSubview:numLab];
            
            UILabel *flagLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, kWindowWidth/3.0, 20)];
            flagLab.font = [UIFont systemFontOfSize:12];
            flagLab.textColor = kRGB_Value(0x989898);
            flagLab.textAlignment = NSTextAlignmentCenter;
            [view addSubview:flagLab];
            
            switch (i) {
                case 0:
                {
                    self.focusLab = numLab;
                    flagLab.text = @"关注";
                    break;
                }
                case 1:
                {
                    self.fansLab = numLab;
                    flagLab.text = @"粉丝";
                    break;
                }
                case 2:
                {
                    self.videosLab = numLab;
                    flagLab.text = @"视频";
                    break;
                }
                default:
                    break;
            }
        }
        
        if (i)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * kWindowWidth/3.0, 12.5 + 100, 0.5, 25)];
            line.backgroundColor = kRGB_Value(0xf2f2f2);
            [self.contentView addSubview:line];
        }
    }
}

- (void)functionClick:(UIGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(mineHeadCell:didClickWithType:)])
    {
        MineHeadType type;
        switch (tap.view.tag) {
            case 100:
                type = MineHeadOfFocus;
                break;
                
            case 101:
                type = MineHeadOfFans;
                break;
                
            case 102:
                type = MineHeadOfVideos;
                break;
            default:
                type = 0;
                break;
        }
        if (type)
        {
            [self.delegate mineHeadCell:self didClickWithType:type];
        }
    }
}

- (void)refreshCellIsLogin:(BOOL)isLogin
{
    if (isLogin)
    {
        self.logLab.hidden = YES;
        self.nameLab.hidden = NO;
        self.signLab.hidden = NO;
        
        self.nameLab.text = [UserDefaultsManager getNickName];
        self.signLab.text = @"I have a pen, I have a apple, ah ~";
//        self.fansLab.text = [NSString stringWithFormat:@"粉丝 %@",[UserDefaultsManager getVisitorNum]];
        [self.icon sd_setImageWithUrlStr:[UserDefaultsManager getAvatar]];
    }
    else
    {
        self.icon.image = [UIImage imageNamed:@"mine_default"];
        self.logLab.hidden = NO;
        self.nameLab.hidden = YES;
        self.signLab.hidden = YES;
        self.focusLab.text = @"0";
        self.fansLab.text = @"0";
        self.videosLab.text = @"0";
    }
}

@end
