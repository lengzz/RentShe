//
//  DisRecommendCell.m
//  RentShe
//
//  Created by Lzz on 2018/1/19.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "DisRecommendCell.h"
@interface DisRecommendCell ()
{
    UIImageView *_headImg;
    UIImageView *_coverImg;
    UILabel *_praiseLab;
}

@end

@implementation DisRecommendCell
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
    self.contentView.backgroundColor = [UIColor clearColor];
    UIImageView *coverImg = [[UIImageView alloc] init];
    coverImg.layer.cornerRadius = 4.0;
    coverImg.layer.masksToBounds = YES;
    _coverImg = coverImg;
    [self.contentView addSubview:coverImg];
    
    UIImageView *headImg = [[UIImageView alloc] init];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 10.0;
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    UIImageView *praiseImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dis_recommend_praise"]];
    [self.contentView addSubview:praiseImg];
    
    UILabel *praiseLab = [[UILabel alloc] init];
    praiseLab.font = [UIFont systemFontOfSize:10];
    praiseLab.textColor = [UIColor whiteColor];
    [self.contentView addSubview:praiseLab];
    _praiseLab = praiseLab;
    
    [coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(self.contentView).offset(6);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
    [praiseImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImg);
        make.left.equalTo(headImg.mas_right).offset(4);
        make.width.height.equalTo(@15);
    }];
    [praiseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImg);
        make.left.equalTo(praiseImg.mas_right).offset(3);
    }];
}

- (void)refreshCell:(id)obj
{
    NSArray *imgArr = @[@"http://img3.duitang.com/uploads/item/201609/18/20160918000527_GZfkP.thumb.224_0.jpeg",@"http://www.qqzi.net/uploads/allimg/160324/021410I11-0-lp.jpg",@"http://img.bitscn.com/upimg/allimg/c160120/1453262W253120-12J05.jpg",@"http://v1.qzone.cc/avatar/201508/24/10/45/55da854d208b0119.jpg%21200x200.jpg"];
    NSInteger i = arc4random()%4;
    
    [_coverImg sd_setImageWithUrlStr:imgArr[i]];
    [_headImg sd_setImageWithUrlStr:imgArr[3 - i]];
    _praiseLab.text = [NSString stringWithFormat:@"%zd",1111 * (i + 1)];
}
@end
