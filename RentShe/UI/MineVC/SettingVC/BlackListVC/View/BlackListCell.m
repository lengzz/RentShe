//
//  BlackListCell.m
//  RentShe
//
//  Created by Lzz on 2017/12/1.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "BlackListCell.h"
#import "BlackListM.h"

@interface BlackListCell()
{
    UIImageView *_headImg;
    UILabel *_nameLab;
}

@end

@implementation BlackListCell

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
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 48, 48)];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 24;
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15 + 48 + 15, 20, kWindowWidth - 180, 20)];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = kRGB(40, 40, 40);
    _nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kWindowWidth - 95, 15, 80, 30);
    [cancelBtn setTitle:@"取消拉黑" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelShieldAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 59.5, kWindowWidth - 30, .5)];
    line.backgroundColor = kRGB(242, 242, 242);
    [self.contentView addSubview:line];
}

- (void)cancelShieldAciton
{
    if (self.cancelShield) {
        self.cancelShield(self.index);
    }
}

- (void)refreshCell:(id)obj
{
    if ([obj isKindOfClass:[BlackListM class]])
    {
        BlackListM *m = (BlackListM *)obj;
        _nameLab.text = m.nickname;
        [_headImg sd_setImageWithUrlStr:m.avatar];
        return;
    }
    _nameLab.text = @"嘟嘟";
    [_headImg sd_setImageWithUrlStr:@"http://img.bitscn.com/upimg/allimg/c160120/1453262W253120-12J05.jpg"];
}

@end
