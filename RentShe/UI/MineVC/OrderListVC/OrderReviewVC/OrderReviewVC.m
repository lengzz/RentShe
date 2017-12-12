//
//  OrderReviewVC.m
//  RentShe
//
//  Created by Lengzz on 2017/10/24.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "OrderReviewVC.h"

@interface OrderReviewVC ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textV;
@property (nonatomic, strong) UIButton *cryptonymBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UILabel *placeHolderLab;
@end

@implementation OrderReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self createV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)createV
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textV = [[UITextView alloc] init];
    textV.backgroundColor = kRGB(242, 242, 242);
    textV.font = [UIFont systemFontOfSize:14];
    textV.delegate = self;
    textV.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:textV];
    _textV = textV;
    
    UIButton *cryptonymBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cryptonymBtn setImage:[UIImage imageNamed:@"order_review"] forState:UIControlStateNormal];
    [cryptonymBtn setImage:[UIImage imageNamed:@"order_review_selected"] forState:UIControlStateSelected];
    [cryptonymBtn addTarget:self action:@selector(cryptonymClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cryptonymBtn];
    _cryptonymBtn = cryptonymBtn;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交评论" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = kRGB(253, 114, 29);
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    _submitBtn = submitBtn;
    
    UILabel *placeHolderLab = [[UILabel alloc] init];
    placeHolderLab.font = [UIFont systemFontOfSize:14];
    placeHolderLab.textColor = kRGB(138, 138, 138);
    placeHolderLab.text = @"请您对本次租约做出评价，比如：对方长的是否漂亮，服务是否到位等等。您的建议是对方成长的动力";
    placeHolderLab.numberOfLines = 0;
    [self.view addSubview:placeHolderLab];
    _placeHolderLab = placeHolderLab;
    
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(10 + kNavBarHeight);
        make.bottom.equalTo(self.view.mas_centerY).offset(-30);
    }];
    [cryptonymBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.left.equalTo(self.view).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@108);
    }];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.left.equalTo(cryptonymBtn.mas_right).offset(20);
        make.height.equalTo(@40);
        make.right.equalTo(self.view).offset(-20);
    }];
    [placeHolderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(textV).offset(5);
        make.right.equalTo(textV).offset(-5);
    }];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"评论"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cryptonymClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)submitAction
{
    if (!_textV.text.length) {
        return;
    }
    NSDictionary *dic = @{@"lender_id":_lenderId,
                          @"order_id":_orderId,
                          @"type":_cryptonymBtn.selected ? @"anonymous" : @"real_name",
                          @"content":_textV.text};
    [NetAPIManager orderReview:dic callBack:^(BOOL success, id object) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"评价成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolderLab.hidden = YES;
    
    if (textView.text.length >= 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    
    if (textView.text.length == 0) {
        self.placeHolderLab.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView endEditing:YES];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
