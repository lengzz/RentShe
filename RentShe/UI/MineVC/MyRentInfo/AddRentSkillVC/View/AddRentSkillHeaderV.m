//
//  AddRentSkillHeaderV.m
//  RentShe
//
//  Created by Lengzz on 2017/9/16.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "AddRentSkillHeaderV.h"

@interface AddRentSkillHeaderV ()<UITextFieldDelegate>
{
    UITextField *_priceTF;
}
@end

@implementation AddRentSkillHeaderV

- (void)dealloc
{
    
}

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
    self.backgroundColor = [UIColor whiteColor];
    UIView *titleV1,*titleV2;
    for (NSInteger i = 0; i < 2; i ++) {
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = kRGB(242, 242, 242);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 2, 16)];
        line.backgroundColor = kRGB_Value(0xff751a);
        [v addSubview:line];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, kWindowWidth - 60, 16)];
        titleLab.textColor = kRGB_Value(0x989898);
        titleLab.font = [UIFont systemFontOfSize:16];
        [v addSubview:titleLab];
        
        [self addSubview:v];
        switch (i) {
            case 0:
                titleV1 = v;
                titleLab.text = @"租金（元／小时）";
                break;
            case 1:
                titleV2 = v;
                titleLab.text = @"添加技能（最多3个）";
                break;
                
            default:
                break;
        }
    }
    UIView *priceV = [[UIView alloc] init];
    priceV.backgroundColor = [UIColor whiteColor];
    [self addSubview:priceV];
    
    UILabel *iconLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 55, 16)];
    iconLab.font = [UIFont systemFontOfSize:16];
    iconLab.textColor = kRGB_Value(0x282828);
    iconLab.text = @"¥";
    iconLab.textAlignment = NSTextAlignmentRight;
    [priceV addSubview:iconLab];
    
    UITextField *priceTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 12, kWindowWidth - 90, 16)];
    priceTF.placeholder = @"建议价格区间：1-200元／小时";
    priceTF.font = [UIFont systemFontOfSize:13];
    priceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    priceTF.borderStyle = UITextBorderStyleNone;
    [priceTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    priceTF.delegate = self;
    [priceV addSubview:priceTF];
    _priceTF = priceTF;
    
    [titleV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@40);
    }];
    [priceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleV1.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@40);
    }];
    [titleV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceV.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@40);
    }];
}

- (void)textFieldDidChange
{
    if (!_priceTF.text.length) {
        return;
    }
    NSInteger price = [_priceTF.text integerValue];
    if (price < 1) {
        _priceTF.text = @"";
        return;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!_priceTF.text.length) {
        return;
    }
    NSInteger price = [_priceTF.text integerValue];
    if (price < 1) {
        _priceTF.text = @"";
        return;
    }
    _priceTF.text = [NSString stringWithFormat:@"%ld",(long)price];
    if (self.priceBlock) {
        self.priceBlock(_priceTF.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_priceTF endEditing:YES];
    return YES;
}

@end
