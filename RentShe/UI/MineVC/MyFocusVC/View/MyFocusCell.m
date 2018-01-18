//
//  MyFocusCell.m
//  RentShe
//
//  Created by Lzz on 2018/1/18.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "MyFocusCell.h"

#define kMyFocusCell @"myFocusCellIdentifier"

@interface MyFocusCell()
{
    UIImageView *_headImg;
    UILabel *_nameLab;
    UILabel *_descLab;
    UIButton *_focusBtn;
}

@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation MyFocusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)index
{
    MyFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyFocusCell];
    if (cell == nil) {
        cell = [[MyFocusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyFocusCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.index = index;
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
    headImg.layer.cornerRadius = 24.0;
    headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:headImg];
    _headImg = headImg;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = kRGB(40, 40, 40);
    [self.contentView addSubview:nameLab];
    _nameLab = nameLab;
    
    UILabel *descLab = [[UILabel alloc] init];
    descLab.font = [UIFont systemFontOfSize:12];
    descLab.textColor = kRGB(152, 152, 152);
    [self.contentView addSubview:descLab];
    _descLab = descLab;
    
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    focusBtn.layer.cornerRadius = 2.0;
    focusBtn.layer.borderWidth = 1.0;
    focusBtn.layer.borderColor = kRGB(102, 102, 102).CGColor;
    focusBtn.layer.masksToBounds = YES;
    focusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
    [focusBtn setTitleColor:kRGB(153, 153, 153) forState:UIControlStateNormal];
    [focusBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:focusBtn];
    _focusBtn = focusBtn;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kRGB(102, 102, 102);
    [self.contentView addSubview:line];
    
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@48);
        make.left.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(10);
        make.height.equalTo(@20);
        make.centerY.equalTo(headImg).offset(-15);
    }];
    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(10);
        make.height.equalTo(@20);
        make.centerY.equalTo(headImg).offset(15);
        make.right.lessThanOrEqualTo(focusBtn.mas_left).offset(-10);
    }];
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        make.left.equalTo(headImg.mas_right).offset(10);
    }];
}

- (void)refreshCell:(id)obj
{
    _nameLab.text = @"小小情歌";
    _descLab.text = @"我有一个梦想，I have a dream ~~~ !我有一个梦想";
    _headImg.image = [UIImage imageNamed:@"mine_default"];
}

- (void)focusClick
{
    [self refreshCell:@1];
    if ([self.delegate respondsToSelector:@selector(myFocusCell:clickWithIndex:)]) {
        [self.delegate myFocusCell:self clickWithIndex:self.index];
    }
}


@end
