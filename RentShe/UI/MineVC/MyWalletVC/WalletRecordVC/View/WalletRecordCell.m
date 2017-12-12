//
//  WalletRecordCell.m
//  RentShe
//
//  Created by Lengzz on 17/6/11.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "WalletRecordCell.h"
#import "WalletRecordM.h"

@interface WalletRecordCell ()
{
    UILabel *_titleLab;
    UILabel *_timeLab;
    UILabel *_priceLab;
}
@end

@implementation WalletRecordCell

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
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 100, 14)];
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = kRGB(86, 86, 86);
    _titleLab = titleLab;
    [self.contentView addSubview:titleLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 26, 200, 10)];
    timeLab.font = [UIFont systemFontOfSize:9];
    timeLab.textColor = kRGB(195, 195, 195);
    _timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 16, 14, kWindowWidth/2.0, 16)];
    priceLab.font = [UIFont systemFontOfSize:15];
//    priceLab.textColor = kRGB(86, 86, 86);
    priceLab.textAlignment = NSTextAlignmentRight;
    _priceLab = priceLab;
    [self.contentView addSubview:priceLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kWindowWidth, 0.5)];
    line.backgroundColor = kRGB(242, 242, 242);
    [self.contentView addSubview:line];
}

- (void)refreshCell:(WalletRecordM *)data
{
    switch (data.type) {
        case WalletTypeOfSystem:
        {
            switch (data.purpose) {
                case WalletPurposeOfOut:
                {
                    _titleLab.text = @"提现记录";
                    _priceLab.text = [NSString stringWithFormat:@"-%@",data.price];
                    _priceLab.textColor = [UIColor redColor];
                    break;
                }
                case WalletPurposeOfIn:
                {
                    _titleLab.text = @"充值记录";
                    _priceLab.text = [NSString stringWithFormat:@"%@",data.price];
                    _priceLab.textColor = [UIColor greenColor];
                    break;
                }
                default:
                {
                    _titleLab.text = @"其他记录";
                    _priceLab.text = [NSString stringWithFormat:@"%@",data.price];
                    _priceLab.textColor = kRGB(86, 86, 86);
                    break;
                }
            }
            break;
        }
        case WalletTypeOfOrder:
        {
            _titleLab.text = @"订单记录";
            switch (data.purpose) {
                case WalletPurposeOfOut:
                {
                    _priceLab.text = [NSString stringWithFormat:@"-%@",data.price];
                    _priceLab.textColor = [UIColor redColor];
                    break;
                }
                case WalletPurposeOfIn:
                {
                    _priceLab.text = [NSString stringWithFormat:@"%@",data.price];
                    _priceLab.textColor = [UIColor greenColor];
                    break;
                }
                default:
                {
                    _titleLab.text = @"其他记录";
                    _priceLab.text = [NSString stringWithFormat:@"%@",data.price];
                    _priceLab.textColor = kRGB(86, 86, 86);
                    break;
                }
            }
            break;
        }
        default:
            _titleLab.text = @"其他记录";
            _priceLab.text = [NSString stringWithFormat:@"%@",data.price];
            _priceLab.textColor = kRGB(86, 86, 86);
            break;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:data.create_time];
    NSString *time = [kCommonConfig.dateFormatter stringFromDate:date];
    _timeLab.text = time;
}

@end
