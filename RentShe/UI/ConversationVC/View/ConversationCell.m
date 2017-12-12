//
//  ConversationCell.m
//  RentShe
//
//  Created by Lengzz on 17/5/31.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ConversationCell.h"
#import <RongIMLib/RCConversation.h>
#import <RongIMKit/RCIM.h>

@interface ConversationCell ()
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *statusLab;
@end

@implementation ConversationCell

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
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 55, 55)];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 27.5;
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 0, 0)];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = kRGB_Value(0x282828);
    _nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, kWindowWidth - 160, 13)];
    contentLab.font = [UIFont systemFontOfSize:12];
    contentLab.textColor = kRGB_Value(0x989898);
    _contentLab = contentLab;
    [self.contentView addSubview:contentLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth - 70 , 25, 55, 13)];
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textColor = kRGB_Value(0x989898);
    timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    
    UILabel *statusLab = [[UILabel alloc] init];
    statusLab.font = [UIFont systemFontOfSize:13];
    statusLab.textColor = kRGB(202, 11, 36);
    _statusLab = statusLab;
    [self.contentView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nameLab.mas_bottom);
        make.left.equalTo(nameLab.mas_right).offset(10);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kRGB_Value(0xf2f2f2);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}

- (void)refreshCell:(id)obj
{
    if ([obj isKindOfClass:[RCConversation class]]) {
        RCConversation *con = obj;
        RCUserInfo *userinfo = [[RCIM sharedRCIM] getUserInfoCache:con.targetId];
        if (!userinfo) {
            [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:con.targetId completion:^(RCUserInfo *userInfo) {
                _nameLab.text = userInfo.name;
                [_nameLab sizeToFit];
                [_headImg sd_setImageWithUrlStr:userInfo.portraitUri];
            }];
        }
        _contentLab.text = ((RCTextMessage *)con.lastestMessage).content;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:con.sentTime];
        _timeLab.text = [kCommonConfig.dateFormatter stringFromDate:date];
    }
}



@end
