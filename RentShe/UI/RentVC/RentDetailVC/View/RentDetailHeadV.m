//
//  RentDetailHeadV.m
//  RentShe
//
//  Created by Lengzz on 17/6/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RentDetailHeadV.h"
#import "NearbyM.h"

#import "HeadImgV.h"

@interface RentDetailHeadV ()
{
    HeadImgV *_headImg;
    UIImageView *_isCertification;
    UILabel *_nameLab;
    UILabel *_visitorLab;
    UILabel *_distanceLab;
    UILabel *_commentLab;
    UILabel *_sexLab;
    UILabel *_ageLab;
    
    BOOL _isSelf;
}
@end

@implementation RentDetailHeadV

- (instancetype)initWithFrame:(CGRect)frame andIsSelf:(BOOL)isSelf
{
    _isSelf = isSelf;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createV];
    }
    return self;
}

- (void)createV
{
    HeadImgV *headImg = [[HeadImgV alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowWidth)];
    _headImg = headImg;
    [self addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:18];
    nameLab.textColor = kRGB(40, 40, 40);
    _nameLab = nameLab;
    [self addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(headImg.mas_bottom).offset(10);
    }];
    
    UIImageView *isCertification = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rent_certification"]];
    _isCertification = isCertification;
    [self addSubview:isCertification];
    [isCertification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLab.mas_centerY);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
        make.left.equalTo(nameLab.mas_right).offset(5);
    }];
    
    UIView *sexV = [[UIView alloc] init];
    sexV.layer.masksToBounds = YES;
    sexV.layer.cornerRadius = 7.5;
    sexV.backgroundColor = kRGB(254, 225, 242);
    [self addSubview:sexV];
    UILabel *sexLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 43, 15)];
    sexLab.font = [UIFont systemFontOfSize:10];
    sexLab.textColor = kRGB(40, 40, 40);
    sexLab.textAlignment = NSTextAlignmentCenter;
    _sexLab = sexLab;
    [sexV addSubview:sexLab];
    
    UIView *ageV = [[UIView alloc] init];
    ageV.layer.masksToBounds = YES;
    ageV.layer.cornerRadius = 7.5;
    ageV.backgroundColor = kRGB(230, 248, 255);
    [self addSubview:ageV];
    UILabel *ageLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 43, 15)];
    ageLab.font = [UIFont systemFontOfSize:10];
    ageLab.textColor = kRGB(40, 40, 40);
    ageLab.textAlignment = NSTextAlignmentCenter;
    _ageLab = ageLab;
    [ageV addSubview:ageLab];
    [sexV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@43);
        make.height.equalTo(@15);
        make.top.equalTo(nameLab.mas_bottom).offset(7);
        make.right.equalTo(self.mas_centerX).offset(-5);
    }];
    [ageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@43);
        make.height.equalTo(@15);
        make.top.equalTo(nameLab.mas_bottom).offset(7);
        make.left.equalTo(sexV.mas_right).offset(10);
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowWidth + 61.5, kWindowWidth, .5)];
    line.backgroundColor = kRGB(242, 242, 242);
    [self addSubview:line];
    
    UILabel *lab;
    UIView *commentV = [self addFunctionVWithLab:&lab andImg:@"rent_comment"];
    _commentLab = lab;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentClick)];
    [commentV addGestureRecognizer:tap];
    [self addSubview:commentV];
    commentV.frame = CGRectMake(kWindowWidth - kWindowWidth/3.0, kWindowWidth + 62, kWindowWidth/3.0, 44);
    
    if (_isSelf)
    {
        UILabel *lab;
        UIView *visitorV = [self addFunctionVWithLab:&lab andImg:@"rent_visitor"];
        _visitorLab = lab;
        visitorV.frame = CGRectMake(0, kWindowWidth + 62, kWindowWidth/3.0, 44);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visitorClick)];
        [visitorV addGestureRecognizer:tap];
        [self addSubview:visitorV];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/3.0 - .5, kWindowWidth + 62, .5, 44)];
        line.backgroundColor = kRGB(242, 242, 242);
        [self addSubview:line];
        
        UIView *editV = [self addFunctionVWithLab:&lab andImg:@"rent_edit"];
        lab.text = @"编辑资料";
        editV.frame = CGRectMake(kWindowWidth/3.0, kWindowWidth + 62, kWindowWidth/3.0, 44);
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editClick)];
        [editV addGestureRecognizer:tap];
        [self addSubview:editV];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth * 2/3.0 - .5, kWindowWidth + 62, .5, 44)];
        line.backgroundColor = kRGB(242, 242, 242);
        [self addSubview:line];
    }
    else
    {
        UILabel *lab;
        UIView *visitorV = [self addFunctionVWithLab:&lab andImg:@"rent_visitor"];
        _visitorLab = lab;
        visitorV.frame = CGRectMake(0, kWindowWidth + 62, kWindowWidth/3.0, 44);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visitorClick)];
        [visitorV addGestureRecognizer:tap];
        [self addSubview:visitorV];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/3.0 - .5, kWindowWidth + 62, .5, 44)];
        line.backgroundColor = kRGB(242, 242, 242);
        [self addSubview:line];
        
        UIView *distanceV = [self addFunctionVWithLab:&lab andImg:@"rent_info_distance"];
        _distanceLab = lab;
        distanceV.frame = CGRectMake(kWindowWidth/3.0, kWindowWidth + 62, kWindowWidth/3.0, 44);
        [self addSubview:distanceV];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth * 2/3.0 - .5, kWindowWidth + 62, .5, 44)];
        line.backgroundColor = kRGB(242, 242, 242);
        [self addSubview:line];
    }
}

- (UIView *)addFunctionVWithLab:(UILabel **)lab andImg:(NSString *)img
{
    UIView *v = [[UIView alloc] init];
    *lab = [[UILabel alloc] init];
    (*lab).font = [UIFont systemFontOfSize:13];
    (*lab).textColor = kRGB(40, 40, 40);
    [v addSubview:*lab];
    UIImageView *contentImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    [v addSubview:contentImg];
    [*lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(v.mas_centerX);
        make.centerY.equalTo(v.mas_centerY);
        make.right.lessThanOrEqualTo(v.mas_right).offset(-15);
    }];
    [contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(v.mas_centerY);
        make.width.equalTo(@17);
        make.height.equalTo(@17);
        make.right.equalTo((*lab).mas_left).offset(-10);
        make.left.greaterThanOrEqualTo(v.mas_left).offset(15);
        make.right.lessThanOrEqualTo(v.mas_centerX).offset(-5);
    }];
    return v;
}

- (void)refreshHead:(id)obj
{
    if ([obj isKindOfClass:[NearbyM class]]) {
        NearbyM *model = obj;
        NSString *distanceStr;
        CGFloat distance = model.rent_info.distance;
        if (distance < 0.01)
        {
            distance = distance * 1000;
            distanceStr = [NSString stringWithFormat:@"%.0fm",distance];
        }
        else
            distanceStr = [NSString stringWithFormat:@"%.0fkm",distance];
        _visitorLab.text = [NSString stringWithFormat:@"%zd访客",model.user_info.visitornum];
        _distanceLab.text = distanceStr;
        _commentLab.text = [NSString stringWithFormat:@"%zd条评论",model.rent_info.comment_num];
        _nameLab.text = model.user_info.nickname;
        _sexLab.text = [model.user_info.gender integerValue]? @"女" : @"男";
        _ageLab.text = model.user_info.year;
        _isCertification.hidden = ![model.user_info.certified boolValue];
        NSArray *strArr = [model.user_info.photo componentsSeparatedByString:@","];
        if (strArr.count) {
            
            _headImg.dataArr = [strArr mutableCopy];
        }
        return;
    }
    _visitorLab.text = @"1235+访客";
    _distanceLab.text = @"距离12KM";
    _commentLab.text = @"1213条评论";
    _nameLab.text = @"阿琳娜";
    _sexLab.text = @"女";
    _ageLab.text = @"90后";
    _isCertification.hidden = NO;
}

- (void)commentClick
{
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

- (void)visitorClick
{
    if (self.clickBlock) {
        self.clickBlock(2);
    }
}

- (void)editClick
{
    if (self.clickBlock) {
        self.clickBlock(3);
    }
}

@end
