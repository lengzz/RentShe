//
//  VisitorCell.m
//  RentShe
//
//  Created by Lengzz on 17/6/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "VisitorCell.h"
#import "VisitorM.h"
#import "ReviewsListM.h"

@interface VisitorCell ()
{
    UIImageView *_headImg;
    UILabel *_nameLab;
    UILabel *_timeLab;
}

@end

@implementation VisitorCell

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
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 6, 48, 48)];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 24;
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 48 + 15, 14, kWindowWidth - 110, 15)];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = kRGB(40, 40, 40);
    _nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 48 + 15, 38, kWindowWidth - 110, 12)];
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textColor = kRGB(86, 86, 86);
    _timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 59.5, kWindowWidth - 30, .5)];
    line.backgroundColor = kRGB(242, 242, 242);
    [self.contentView addSubview:line];
}

- (void)refreshCell:(id)obj
{
    if ([obj isKindOfClass:[VisitorM class]])
    {
        VisitorM *m = (VisitorM *)obj;
        _nameLab.text = m.nickname;
        NSString *str = [kCommonConfig.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:m.create_time]];
        NSArray *arr = [str componentsSeparatedByString:@" "];
        if (arr.count >= 2)
        {
            _timeLab.text = arr[1];
        }
        [_headImg sd_setImageWithUrlStr:m.avatar];
        return;
    }
    else if ([obj isKindOfClass:[ReviewsListM class]])
    {
        ReviewsListM *m = (ReviewsListM *)obj;
        _nameLab.text = m.nickname;
        _timeLab.text = m.content;
        [_headImg sd_setImageWithUrlStr:m.avatar];
        return;
    }
    _nameLab.text = @"嘟嘟";
    _timeLab.text = @"12:30访问过您";
    [_headImg sd_setImageWithUrlStr:@"http://img.bitscn.com/upimg/allimg/c160120/1453262W253120-12J05.jpg"];
}

@end
