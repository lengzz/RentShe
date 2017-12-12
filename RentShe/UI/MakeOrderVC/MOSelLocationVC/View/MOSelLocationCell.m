//
//  MOSelLocationCell.m
//  RentShe
//
//  Created by Lengzz on 2017/8/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MOSelLocationCell.h"
#import "CusAnnotation.h"

@interface MOSelLocationCell ()
{
    UILabel *_titleLab;
    UILabel *_desLab;
}

@end

@implementation MOSelLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void) createCell
{
    for (UIView *v in self.contentView.subviews) {
        [v removeFromSuperview];
    }
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, kWindowWidth - 32, 16)];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = kRGB(40, 40, 40);
    _titleLab = titleLab;
    [self.contentView addSubview:titleLab];
    
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 32, kWindowWidth - 32, 14)];
    desLab.font = [UIFont systemFontOfSize:13];
    desLab.textColor = kRGB(153, 153, 153);
    _desLab = desLab;
    [self.contentView addSubview:desLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, kWindowWidth, .5)];
    line.backgroundColor = kRGB(229, 229, 229);
    [self.contentView addSubview:line];
}

- (void)refreshCell:(id)obj
{
    CusAnnotation *annotation = obj;
    _titleLab.text = annotation.title;
    _desLab.text = annotation.subtitle;
}

@end
