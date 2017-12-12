//
//  RentInfoTimeCell.m
//  RentShe
//
//  Created by Lengzz on 17/5/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RentInfoTimeCell.h"
#import "CustomSlider.h"

@interface RentInfoTimeCell ()
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) CustomSlider *slider;
@end

@implementation RentInfoTimeCell

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
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 40, 15)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = kRGB(40, 40, 40);
    lab.text = @"时间";
    [self.contentView addSubview:lab];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textColor = kRGB(255, 117, 26);
    timeLab.frame = CGRectMake(45, 17, 100, 12);
    timeLab.text = @"(8-16点)";
    self.timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    
    UIImageView *arrowsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_right"]];
    arrowsImg.frame = CGRectMake(kWindowWidth - 5  - 17, 13.5, 17, 17);
    [self.contentView addSubview:arrowsImg];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth - 100 - 5 - 5 - 17, 15.5, 100, 13)];
    infoLab.font = [UIFont systemFontOfSize:13];
    infoLab.textColor = kRGB(86, 86, 86);
    infoLab.textAlignment = NSTextAlignmentRight;
    infoLab.text = @"节假日";
    [self.contentView addSubview:infoLab];
    self.infoLab = infoLab;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kWindowWidth, 44);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(chooseWeekDay) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(44, 43.5, kWindowWidth - 44, 0.5)];
    line.backgroundColor = kRGB(227, 227, 229);
    [self.contentView addSubview:line];
    
    CustomSlider *slider = [[CustomSlider alloc] initWithFrame:CGRectMake(44, 44, kWindowWidth - 44 - 34, 67)];
    slider.minValue = 0;
    slider.maxValue = 24;
    __weak typeof(self) wself = self;
    slider.resultBlock = ^(CGFloat min, CGFloat max)
    {
        [wself changeTime:min withMax:max];
    };
    self.slider = slider;
    [self.contentView addSubview:slider];
}

- (void)chooseWeekDay
{
    if (self.chooseWeekBlock) {
        self.chooseWeekBlock();
    }
}

- (void)setDayDic:(NSDictionary *)dayDic
{
    NSMutableString *string = [NSMutableString string];
    NSInteger x = 0,y = 0;
    if ([dayDic[kMon] integerValue]) {
        [string appendString:@"一"];
        x = 1;
    }
    if ([dayDic[kTue] integerValue]) {
        [string appendString:@"二"];
        x = 1;
    }
    if ([dayDic[kWed] integerValue]) {
        [string appendString:@"三"];
        x = 1;
    }
    if ([dayDic[kThu] integerValue]) {
        [string appendString:@"四"];
        x = 1;
    }
    if ([dayDic[kFri] integerValue]) {
        [string appendString:@"五"];
        x = 1;
    }
    if ([dayDic[kSat] integerValue]) {
        [string appendString:@"六"];
        y = 1;
    }
    if ([dayDic[kSun] integerValue]) {
        [string appendString:@"日"];
        y = 1;
    }
    
    if (x && y && string.length == 7)
    {
        self.infoLab.text = @"每天";
    }
    else if (!x && y && string.length == 2)
    {
        self.infoLab.text = @"周末";
    }
    else if (x && !y && string.length == 5)
    {
        self.infoLab.text = @"工作日";
    }
    else
        self.infoLab.text = string;
}

- (void)changeTime:(CGFloat)min withMax:(CGFloat)max
{
    _beginTime = min;
    _endTime = max;
    self.timeLab.text = [NSString stringWithFormat:@"(%.f-%.f点)",_beginTime,_endTime];
    if (self.timeBlock) {
        self.timeBlock([NSString stringWithFormat:@"%.f",min], [NSString stringWithFormat:@"%.f",max]);
    }
}

- (void)setBeginTime:(CGFloat)beginTime
{
    _beginTime = beginTime;
    self.slider.leftValue = beginTime;
    self.timeLab.text = [NSString stringWithFormat:@"(%.f-%.f点)",_beginTime,_endTime];
}

- (void)setEndTime:(CGFloat)endTime
{
    _endTime = endTime;
    self.slider.rightValue = endTime;
    self.timeLab.text = [NSString stringWithFormat:@"(%.f-%.f点)",_beginTime,_endTime];
}
@end
