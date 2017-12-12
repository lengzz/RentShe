//
//  FilterSectionCell.m
//  RentShe
//
//  Created by Lengzz on 2017/7/8.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "FilterSectionCell.h"
#import "CustomSlider.h"

@interface FilterSectionCell ()
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) CustomSlider *slider;
@end

@implementation FilterSectionCell

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
    _titleLab = lab;
    [self.contentView addSubview:lab];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth - 150 - 15, 15.5, 150, 13)];
    infoLab.font = [UIFont systemFontOfSize:13];
    infoLab.textColor = kRGB(86, 86, 86);
    infoLab.textAlignment = NSTextAlignmentRight;
    _infoLab = infoLab;
    [self.contentView addSubview:infoLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(44, 43.5, kWindowWidth - 44, 0.5)];
    line.backgroundColor = kRGB(227, 227, 229);
    [self.contentView addSubview:line];
    
    CustomSlider *slider = [[CustomSlider alloc] initWithFrame:CGRectMake(44, 44, kWindowWidth - 44 - 34, 67)];
    __weak __typeof(self) wself = self;
    slider.resultBlock = ^(CGFloat min,CGFloat max){
        [wself changed:min withMax:max];
    };
    self.slider = slider;
    [self.contentView addSubview:slider];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5 + 67, kWindowWidth, 0.5)];
    line.backgroundColor = kRGB(227, 227, 229);
    [self.contentView addSubview:line];
}

- (void)changed:(CGFloat)min withMax:(CGFloat)max
{
    _start = min;
    _end = max;
    [self setInfo];
    if (self.isChanged) {
        self.isChanged(min, max, self.type);
    }
}

- (void)setInfo
{
    NSString *str = [NSString stringWithFormat:@"%.f-%.f",self.start,self.end];
    _infoLab.text = str;
    _titleLab.text = self.titleStr;
}

- (void)setStart:(CGFloat)start
{
    _start = start;
    self.slider.leftValue = start;
}

- (void)setEnd:(CGFloat)end
{
    _end = end;
    self.slider.rightValue = end;
}

- (void)setMax:(CGFloat)max
{
    _max = max;
    self.slider.maxValue = max;
}

- (void)setMin:(CGFloat)min
{
    _min = min;
    self.slider.minValue = min;
}
@end
