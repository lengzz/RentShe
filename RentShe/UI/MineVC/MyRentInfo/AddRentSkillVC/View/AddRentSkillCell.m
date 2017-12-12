//
//  AddRentSkillCell.m
//  RentShe
//
//  Created by Lengzz on 2017/9/16.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "AddRentSkillCell.h"

@interface AddRentSkillCell ()
{
    UILabel *_skillName;
}

@end

@implementation AddRentSkillCell

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
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = kRGB_Value(0xd6d6d6).CGColor;
    
    UILabel *skillName = [[UILabel alloc] init];
    skillName.font = [UIFont systemFontOfSize:16];
    skillName.textColor = kRGB_Value(0x282828);
    skillName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:skillName];
    _skillName = skillName;
    
    [skillName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
    }];
}

- (void)refreshCell:(id)obj
{
    _skillName.text = obj[@"skill_name"];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.contentView.backgroundColor = selected ? kRGB_Value(0xff751a) : [UIColor whiteColor];
    _skillName.textColor = selected ? [UIColor whiteColor] : kRGB_Value(0x282828);
    self.contentView.layer.borderColor = selected ? [UIColor whiteColor].CGColor : kRGB_Value(0xd6d6d6).CGColor;
}

@end
