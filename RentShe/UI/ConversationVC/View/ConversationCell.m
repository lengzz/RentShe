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

#define kConversationCell @"conversationCellIdentifier"

@interface ConversationCell ()
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLab;
@end

@implementation ConversationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kConversationCell];
    if (cell == nil) {
        cell = [[ConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kConversationCell];
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12, 46, 46)];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 23;
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 0, 0)];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = kRGB_Value(0x282828);
    _nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_right"]];
    [self.contentView addSubview:arrowImg];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(headImg.mas_right).offset(10);
    }];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@17);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setType:(CustomConversation)type
{
    _type = type;
    switch (type) {
        case CustomConversationOfService:
            self.nameLab.text = @"客服";
            self.headImg.image= [UIImage imageNamed:@"conversation_service"];
            break;
            
        default:
            break;
    }
}



@end
