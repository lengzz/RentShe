//
//  TipsV.m
//  RentShe
//
//  Created by Lengzz on 17/5/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "TipsV.h"

@interface TipsV ()
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation TipsV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createV];
    }
    return self;
}

- (void)createV
{
    self.backgroundColor = kRGBA_Value(0x1c1c1c, 0.4);
    UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 166)];
    contentV.center = self.center;
    self.contentV = contentV;
    [self addSubview:contentV];
    
    UIView *infoV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 166)];
    infoV.layer.masksToBounds = YES;
    infoV.layer.cornerRadius = 5.0;
    infoV.backgroundColor = [UIColor whiteColor];
    [contentV addSubview:infoV];
    
    UIView *upV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 44)];
    upV.backgroundColor = kRGB(253, 97, 6);
    [infoV addSubview:upV];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30 + 53, 12, 275 - 45 - 53, 20)];
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    titleLab.textColor = kRGB(245, 237, 232);
    titleLab.text = @"提示";
    self.titleLab = titleLab;
    [upV addSubview:titleLab];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 44 + 15, 275 - 30, 47)];
    infoLab.font = [UIFont systemFontOfSize:15];
    infoLab.textColor = kRGB(86, 86, 86);
    infoLab.numberOfLines = 2;
    infoLab.text = @"确认要隐身？隐身之后其他人将无法在首页看到你的信息，确定隐身？";
    self.infoLab = infoLab;
    [infoV addSubview:infoLab];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 166 - 45, 137.5, 45);
    [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
    [leftBtn setTitleColor:kRGB(40, 40, 40) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    leftBtn.tag = 1;
    [leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
    [infoV addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(137.5, 166 - 45, 137.5, 45);
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    rightBtn.backgroundColor = kRGB(253, 97, 6);
    [rightBtn setTitleColor:kRGB(255, 255, 255) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [infoV addSubview:rightBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 166 - 45, 275, .5)];
    line.backgroundColor = kRGB(241, 241, 241);
    [infoV addSubview:line];
    
    UIImageView *tipsImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 36 - 53, 53, 53)];
    tipsImg.image = [UIImage imageNamed:@"rentinfo_tips_img"];
    self.tipsImg = tipsImg;
    [contentV addSubview:tipsImg];
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)hidden
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.clickBlock) {
        self.clickBlock(NO);
    }
    [self removeFromSuperview];
}

- (void)buttonClick:(UIButton *)btn
{
    if (self.clickBlock) {
        self.clickBlock(btn.tag == 1 ? YES : NO);
    }
    [self removeFromSuperview];
}

@end
