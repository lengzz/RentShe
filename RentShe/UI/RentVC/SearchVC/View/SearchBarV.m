//
//  SearchBarV.m
//  RentShe
//
//  Created by Feng on 2017/11/12.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "SearchBarV.h"

@implementation SearchBarV

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
    self.backgroundColor = kRGB(242, 242, 242);
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_search"]];
    img.frame = CGRectMake(15, 9.5, 11, 11);
    [self addSubview:img];
    
    UITextField *searchTF = [[UITextField alloc] init];
    searchTF.placeholder = @"请输入关键词/账号/昵称";
    searchTF.font = [UIFont systemFontOfSize:13];
    searchTF.returnKeyType = UIReturnKeySearch;
    [self addSubview:searchTF];
    _searchTF = searchTF;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@11);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(img.mas_right).offset(9);
        make.height.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(kWindowWidth, 30);
}

@end
