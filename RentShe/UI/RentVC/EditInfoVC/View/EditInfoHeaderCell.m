//
//  EditInfoHeaderCell.m
//  RentShe
//
//  Created by Lengzz on 2017/9/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "EditInfoHeaderCell.h"

@interface EditInfoHeaderCell ()
{
    UIImageView *_bgImg;
    UIView *_coverV;
}
@end

@implementation EditInfoHeaderCell

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
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"editinfo_photo"]];
    [self.contentView addSubview:bgImg];
    _bgImg = bgImg;
    
    UIImageView *photoV = [[UIImageView alloc] init];
    photoV.layer.cornerRadius = 5;
    photoV.layer.masksToBounds = YES;
    [self.contentView addSubview:photoV];
    _photoV = photoV;
    
    UIImageView *delImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rent_delete"]];
    [photoV addSubview:delImg];
    
    UIView *coverV = [[UIView alloc] init];
    coverV.backgroundColor = [UIColor whiteColor];
    coverV.alpha = 0.3;
    coverV.hidden = YES;
    [self.contentView addSubview:coverV];
    _coverV = coverV;
    
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(5);
        make.right.bottom.equalTo(self.contentView).offset(-5);
    }];
    [photoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(5);
        make.right.bottom.equalTo(self.contentView).offset(-5);
    }];
    [delImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(photoV);
        make.height.width.equalTo(@15);
    }];
    [coverV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setIsMove:(BOOL)isMove
{
    _coverV.hidden = !isMove;
}

- (void)refreshCell:(id)obj
{
    if (!obj) {
        _photoV.hidden = YES;
        _bgImg.hidden = NO;
        return;
    }
    _photoV.hidden = NO;
    _bgImg.hidden = YES;
    if ([obj isKindOfClass:[UIImage class]])
    {
        _photoV.image = (UIImage *)obj;
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        [_photoV sd_setImageWithUrlStr:(NSString *)obj];
    }
}
@end
