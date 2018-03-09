//
//  DisFocusCell.m
//  RentShe
//
//  Created by Lzz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "DisFocusCell.h"
#import "DisFocusM.h"
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
    UIButton *_praiseBtn;
    UIButton *_reviewsBtn;
    UIButton *_commentBtn;
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
    self.contentView.backgroundColor = [UIColor whiteColor];
   
    UIImageView *headImg = [[UIImageView alloc] init];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 17.0;
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:13];
    nameLab.textColor = kRGB_Value(0x282828);
    _nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = [UIFont systemFontOfSize:10];
    timeLab.textColor = kRGB_Value(0x989898);
    _timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = [UIFont systemFontOfSize:13];
    contentLab.textColor = kRGB_Value(0x282828);
    contentLab.numberOfLines = 0;
    _contentLab = contentLab;
    [self.contentView addSubview:contentLab];
    
    UIImageView *coverImg = [[UIImageView alloc] init];
    _coverImg = coverImg;
    [self.contentView addSubview:coverImg];
    
    UILabel *distanceLab = [[UILabel alloc] init];
    distanceLab.font = [UIFont systemFontOfSize:10];
    distanceLab.textColor = kRGB_Value(0x989898);
    _distanceLab = distanceLab;
    [self.contentView addSubview:distanceLab];

    UILabel *watchLab = [[UILabel alloc] init];
    watchLab.font = [UIFont systemFontOfSize:10];
    watchLab.textColor = kRGB_Value(0x989898);
    _watchLab = watchLab;
    [self.contentView addSubview:watchLab];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    
    UIButton *praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [praiseBtn setTitle:@"0" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:kRGB_Value(0x989898) forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [self.contentView addSubview:praiseBtn];
    _praiseBtn = praiseBtn;
    
    UIButton *reviewsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reviewsBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [reviewsBtn setTitle:@"0" forState:UIControlStateNormal];
    [reviewsBtn setTitleColor:kRGB_Value(0x989898) forState:UIControlStateNormal];
    [reviewsBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [reviewsBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [self.contentView addSubview:reviewsBtn];
    _reviewsBtn = reviewsBtn;
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [self.contentView addSubview:commentBtn];
    _commentBtn = commentBtn;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:bottomLine];
    
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.height.width.equalTo(@34);
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(13);
        make.right.greaterThanOrEqualTo(self.contentView).offset(-10);
        make.height.equalTo(@13);
    }];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(10);
        make.top.equalTo(nameLab.mas_bottom).offset(7);
        make.right.greaterThanOrEqualTo(self.contentView).offset(-10);
        make.height.equalTo(@10);
    }];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(headImg.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    [coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(contentLab.mas_bottom).offset(10);
        make.width.equalTo(@190);
        make.height.equalTo(@115);
    }];
    [distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(coverImg.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    [watchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(distanceLab.mas_right).offset(20);
        make.top.equalTo(coverImg.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(distanceLab.mas_bottom).offset(10);
        make.height.equalTo(@.5);
    }];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.height.equalTo(@25);
        make.width.equalTo(@(kWindowWidth/4));
    }];
    [reviewsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(praiseBtn.mas_right).offset(10);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.height.equalTo(@25);
        make.width.equalTo(@(kWindowWidth/4));
    }];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.height.equalTo(@25);
        make.width.equalTo(@(kWindowWidth/4));
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(praiseBtn.mas_bottom).offset(10);
        make.height.equalTo(@5);
    }];

}

- (void)refreshCell:(id)obj
{
    if ([obj isKindOfClass:[DisFocusM class]]) {
        DisFocusM *m = (DisFocusM *)obj;
        [_headImg sd_setImageWithUrlStr:m.avatar];
        [_coverImg sd_setImageWithUrlStr:m.video_cover];
        _nameLab.text = m.nickname;
        _timeLab.text = @"2018-03-09 15:45";
        _distanceLab.text = @"150 km";
        _watchLab.text = [NSString stringWithFormat:@"%@ 观看",m.visitors_num];
        _contentLab.text = @"sdjfoasjgo adofjo ajdogfjso ofsgaf";
    }
        
}
@end
