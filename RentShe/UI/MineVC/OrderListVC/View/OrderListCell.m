//
//  OrderListCell.m
//  RentShe
//
//  Created by Lengzz on 2017/9/3.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "OrderListCell.h"
#import "OrderListM.h"

typedef NS_ENUM(NSInteger, MyRentOrder)
{
    MyRentOrderOfWaitConfirm = 0, //等待对方确认
    MyRentOrderOfWaitMeet,         //待见面
    MyRentOrderOfRefund,            //申请退款
    MyRentOrderOfCancelRefund,      //撤销退款
    MyRentOrderOfArrived = 8,           //对方已经到达
    MyRentOrderOfWaitComment,       //待评价
    MyRentOrderOfOver,              //已结束
    MyRentOrderOfTimeout,           //超时已取消
    MyRentOrderOfCancel,            //取消订单
    MyRentOrderOfRefuseRefund = 14,      //对方拒绝您退款
    MyRentOrderOfOtherRefuse
};

typedef NS_ENUM(NSInteger, RentMeOrder)
{
    RentMeOrderOfWaitConfirm = 20, //等待您的确认
    RentMeOrderOfWaitMeet,//待见面
    RentMeOrderOfRefund,//对方申请退款       // Apply for refund
    RentMeOrderOfCancel = 24,//取消预约
    RentMeOrderOfArrived = 26, //已到达
    RentMeOrderOfRefuseRefund = 27, //拒绝退款
    RentMeOrderOfOver = 28, //已结束
    RentMeOrderOfTimeout = 29, //超时已取消
    RentMeOrderOfRefuse = 30, //拒绝预约
    RentMeOrderOfAgreeRefund = 31 //同意对方退款
};

typedef NS_ENUM(NSInteger, FunctionType)
{
    FunctionTypeOfChat = 100,
    FunctionTypeOfCancel,
    FunctionTypeOfApplyRefund,
    FunctionTypeOfCancelRefund,
    FunctionTypeOfCompletion,
    FunctionTypeOfGoReview,
    
    FunctionTypeOfAccept = 201,
    FunctionTypeOfRefuse,
    FunctionTypeOfArrive,
    FunctionTypeOfAgreeRefund,
    FunctionTypeOfRefuseRefund
};

static const NSString *OrderOfCancel = @"cancel_order";
static const NSString *OrderOfApplyRefund = @"apply_refund";
static const NSString *OrderOfCancelRefund = @"cancle_refund";
static const NSString *OrderOfCompletion = @"confirm_completion";

static const NSString *OrderOfAccept = @"accept_order";
static const NSString *OrderOfRefuse = @"refuse_order";
static const NSString *OrderOfArrive = @"arrive";
static const NSString *OrderOfAgreeRefund = @"agree_to_refund";
static const NSString *OrderOfRefuseRefund = @"refuse_refund";

@interface OrderListCell ()
{
    UIImageView *_headImg;
    UIImageView *_flagImg;
    UILabel *_nameLab;
    UILabel *_titleLab;
    UILabel *_amountLab;
    UILabel *_addressLab;
    UILabel *_timeLab;
    UILabel *_statusLab;
    UILabel *_explainLab;
    UILabel *_explainLabel;
    
    UIView *_functionV;
}
@property (nonatomic, strong) OrderListM *model;

@end

@implementation OrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createCell
{
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = kRGB(242, 242, 242);
    [self.contentView addSubview:lineV];
    
    UIImageView *headImg = [[UIImageView alloc] init];
    headImg.layer.cornerRadius = 27.5;
    headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:headImg];
    _headImg = headImg;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = kRGB(40, 40, 40);
    [self.contentView addSubview:nameLab];
    _nameLab = nameLab;
    
    UIImageView *flagImg = [[UIImageView alloc] init];
    [self.contentView addSubview:flagImg];
    _flagImg = flagImg;
    
    UIImageView *moneyImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.contentView addSubview:moneyImg];
    
    UILabel *amountLab = [[UILabel alloc] init];
    amountLab.font = [UIFont systemFontOfSize:12];
    amountLab.textColor = kRGB(255, 8, 0);
    [self.contentView addSubview:amountLab];
    _amountLab = amountLab;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = kRGB(40, 40, 40);
    titleLabel.text = @"主题 :";
    [self.contentView addSubview:titleLabel];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = kRGB(152, 152, 152);
    [self.contentView addSubview:titleLab];
    _titleLab = titleLab;
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textColor = kRGB(40, 40, 40);
    addressLabel.text = @"地点 :";
    [addressLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:addressLabel];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.font = [UIFont systemFontOfSize:12];
    addressLab.textColor = kRGB(152, 152, 152);
    addressLab.numberOfLines = 2;
    [self.contentView addSubview:addressLab];
    _addressLab = addressLab;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = kRGB(40, 40, 40);
    timeLabel.text = @"时间 :";
    [self.contentView addSubview:timeLabel];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textColor = kRGB(152, 152, 152);
    [self.contentView addSubview:timeLab];
    _timeLab = timeLab;
    
    UILabel *explainLabel = [[UILabel alloc] init];
    explainLabel.font = [UIFont systemFontOfSize:12];
    explainLabel.textColor = kRGB(40, 40, 40);
    explainLabel.text = @"说明 :";
    [self.contentView addSubview:explainLabel];
    _explainLabel = explainLabel;
    
    UILabel *explainLab = [[UILabel alloc] init];
    explainLab.font = [UIFont systemFontOfSize:12];
    explainLab.textColor = kRGB(152, 152, 152);
    [self.contentView addSubview:explainLab];
    _explainLab = explainLab;
    
    UILabel *statusLab = [[UILabel alloc] init];
    statusLab.font = [UIFont systemFontOfSize:18];
    statusLab.textColor = kRGB(0, 169, 99);
    [self.contentView addSubview:statusLab];
    _statusLab = statusLab;
    
    UIView *functionV = [[UIView alloc] init];
    functionV.backgroundColor = kRGB(242, 242, 242);
    [self.contentView addSubview:functionV];
    _functionV = functionV;
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(@10);
    }];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.left.equalTo(self.contentView).offset(15);
        make.height.width.equalTo(@55);
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.left.equalTo(headImg.mas_right).offset(10);
        make.height.equalTo(@16);
    }];
    [flagImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLab);
        make.left.equalTo(nameLab.mas_right).offset(5);
        make.width.height.equalTo(@16);
    }];
    [moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLab);
        make.width.height.equalTo(@16);
        make.right.equalTo(amountLab.mas_left).offset(-5);
    }];
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLab);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@14);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab);
        make.top.equalTo(nameLab.mas_bottom).offset(5);
        make.height.equalTo(@14);
    }];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(3);
        make.height.equalTo(@14);
    }];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@14);
    }];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo(addressLabel.mas_right).offset(3);
        make.right.lessThanOrEqualTo(self.contentView).offset(-kWindowWidth/3.0);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab);
        make.top.equalTo(addressLab.mas_bottom).offset(5);
        make.height.equalTo(@14);
    }];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(timeLabel.mas_right).offset(3);
        make.height.equalTo(@14);
    }];
    [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.height.equalTo(@14);
    }];
    [explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(explainLabel);
        make.left.equalTo(explainLabel.mas_right).offset(3);
        make.height.equalTo(@14);
    }];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.greaterThanOrEqualTo(addressLab.mas_right).offset(5);
    }];
    [functionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@44);
        make.top.equalTo(timeLab.mas_bottom).offset(24);
    }];
}

- (void)refreshCell:(OrderListM *)model
{
    _model = model;
    
    _nameLab.text = model.nickname;
    _titleLab.text = model.rent_skill_name;
    _addressLab.text = model.addr_name;
    _amountLab.text = [NSString stringWithFormat:@"%@/%@小时",model.rent_price,model.rent_hours];
    _statusLab.text = model.order_state_name;
    [_headImg sd_setImageWithUrlStr:model.avatar];
    _timeLab.text = [kCommonConfig.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.meeting_time doubleValue]]];
    
    if (![model.certified integerValue])
    {
        _flagImg.image = [UIImage imageNamed:@""];
    }
    else
    {
        _flagImg.image = [UIImage imageNamed:@""];
    }
    if (model.explain.length)
    {
        _explainLab.text = model.explain;
        _explainLab.hidden = NO;
        _explainLabel.hidden = NO;
        [_functionV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLab.mas_bottom).offset(24);
        }];
    }
    else
    {
        _explainLab.hidden = YES;
        _explainLabel.hidden = YES;
        [_functionV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLab.mas_bottom).offset(5);
        }];
    }
    [self chooseFunctionWithStatus:[model.order_state_index integerValue]];
}

- (void)chooseFunctionWithStatus:(NSInteger)status
{
    switch (status) {
        case MyRentOrderOfWaitConfirm: //等待对方确认
        {
            [self addFunctionBtn:@[[self button:@"聊天" withTag:FunctionTypeOfChat],[self button:@"取消预约" withTag:FunctionTypeOfCancel]]];
            break;
        }
        case MyRentOrderOfWaitMeet:         //待见面
        case MyRentOrderOfCancelRefund:      //撤销退款
        case MyRentOrderOfRefuseRefund:      //对方拒绝您退款
        case MyRentOrderOfArrived:           //对方已经到达
        {
            [self addFunctionBtn:@[[self button:@"聊天" withTag:FunctionTypeOfChat],[self button:@"完成" withTag:FunctionTypeOfCompletion],[self button:@"退款" withTag:FunctionTypeOfApplyRefund]]];
            break;
        }
        case MyRentOrderOfRefund:            //申请退款
        {
            [self addFunctionBtn:@[[self button:@"聊天" withTag:FunctionTypeOfChat],[self button:@"撤销退款" withTag:FunctionTypeOfCancelRefund]]];
            break;
        }
        case MyRentOrderOfWaitComment:       //待评价
        {
            [self addFunctionBtn:@[[self button:@"聊天" withTag:FunctionTypeOfChat],[self button:@"去评论" withTag:FunctionTypeOfGoReview]]];
            break;
        }
        case MyRentOrderOfOtherRefuse:       //对方取消订单
        case MyRentOrderOfTimeout:           //超时已取消
        case MyRentOrderOfCancel:            //取消订单
        case MyRentOrderOfOver:              //已结束
        {
            [self addFunctionBtn:nil];
            break;
        }
            
        case RentMeOrderOfWaitConfirm: //等待您的确认
        {
            [self addFunctionBtn:@[[self button:@"同意" withTag:FunctionTypeOfAccept],[self button:@"拒绝" withTag:FunctionTypeOfRefuse],[self button:@"聊天" withTag:FunctionTypeOfChat]]];
            break;
        }
        case RentMeOrderOfWaitMeet://待见面
        {
            [self addFunctionBtn:@[[self button:@"聊天" withTag:FunctionTypeOfChat],[self button:@"已到达" withTag:FunctionTypeOfArrive]]];
            break;
        }
        case RentMeOrderOfRefund://对方申请退款       // Apply for refund
        {
            [self addFunctionBtn:@[[self button:@"同意" withTag:FunctionTypeOfAgreeRefund],[self button:@"拒绝" withTag:FunctionTypeOfRefuseRefund],[self button:@"聊天" withTag:FunctionTypeOfChat]]];
            break;
        }
        case RentMeOrderOfArrived: //已到达
        case RentMeOrderOfRefuseRefund: //拒绝退款
        {
            [self addFunctionBtn:@[[self button:@"聊天" withTag:FunctionTypeOfChat]]];
            break;
        }
        case RentMeOrderOfCancel://取消预约
        case RentMeOrderOfOver: //已结束
        case RentMeOrderOfTimeout: //超时已取消
        case RentMeOrderOfRefuse: //拒绝预约
        case RentMeOrderOfAgreeRefund :
        {
            [self addFunctionBtn:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)addFunctionBtn:(NSArray<UIButton *> *)arr
{
    for (UIView *v in _functionV.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    if (!arr) {
        [_functionV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
        }];
        return;
    }
    else
    {
        [_functionV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
        }];
    }
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *btn = arr[i];
        btn.frame = CGRectMake(kWindowWidth/arr.count * i, 0, kWindowWidth/arr.count, 44);
        [_functionV addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn
{
    if (self.functionBlock) {
        switch (btn.tag) {
            case FunctionTypeOfChat:
            {
                self.functionBlock(@"0",_model);
                break;
            }
            case FunctionTypeOfCancel:
            {
                self.functionBlock([OrderOfCancel copy],_model.order_id);
                break;
            }
            case FunctionTypeOfApplyRefund:
            {
                self.functionBlock([OrderOfApplyRefund copy],_model.order_id);
                break;
            }
            case FunctionTypeOfCancelRefund:
            {
                self.functionBlock([OrderOfCancelRefund copy],_model.order_id);
                break;
            }
            case FunctionTypeOfCompletion:
            {
                self.functionBlock([OrderOfCompletion copy],_model.order_id);
                break;
            }
            case FunctionTypeOfGoReview:
            {
                self.functionBlock(@"1",_model);
                break;
            }
            case FunctionTypeOfAccept:
            {
                self.functionBlock([OrderOfAccept copy],_model.order_id);
                break;
            }
            case FunctionTypeOfRefuse:
            {
                self.functionBlock([OrderOfRefuse copy],_model.order_id);
                break;
            }
            case FunctionTypeOfArrive:
            {
                self.functionBlock([OrderOfArrive copy],_model.order_id);
                break;
            }
            case FunctionTypeOfAgreeRefund:
            {
                self.functionBlock([OrderOfAgreeRefund copy],_model.order_id);
                break;
            }
            case FunctionTypeOfRefuseRefund:
            {
                self.functionBlock([OrderOfRefuseRefund copy],_model.order_id);
                break;
            }
            default:
                break;
        }
    }
}

- (UIButton *)button:(NSString *)title withTag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kRGB(40, 40, 40) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = kRGB(242, 242, 242).CGColor;
    btn.tag = tag;
    return btn;
}

@end
