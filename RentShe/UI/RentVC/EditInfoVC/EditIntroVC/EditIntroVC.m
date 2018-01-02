//
//  EditIntroVC.m
//  RentShe
//
//  Created by Lzz on 2018/1/2.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "EditIntroVC.h"

@interface EditIntroVC ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textV;
@property (nonatomic, strong) UILabel *placeholderLab;
@property (nonatomic, strong) UILabel *numLab;
@end

@implementation EditIntroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self createV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"自我介绍"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
    UIButton *btn = [CustomNavVC getRightDefaultButtonWithTarget:self action:@selector(completed) titile:@"完成"];
    [btn setTitleColor:kRGB(255, 117, 26) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
}

- (void)createV
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 15, kWindowWidth, 100)];
    contentV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentV];
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, kWindowWidth - 40, 100)];
    textV.font = [UIFont systemFontOfSize:15];
    textV.delegate = self;
    textV.backgroundColor = [UIColor whiteColor];
    [contentV addSubview:textV];
    _textV = textV;
    
    UILabel *placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 6 , kWindowWidth - 40, 20)];
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @" ";
    placeholderLab.textColor = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
    placeholderLab.font = textV.font;
    placeholderLab.text = @"请介绍你自己";
    [contentV addSubview:placeholderLab];
    _placeholderLab = placeholderLab;
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, kNavBarHeight + 120 , kWindowWidth - 40, 20)];
    numLab.textColor = [UIColor blackColor];
    numLab.textAlignment = NSTextAlignmentRight;
    numLab.font = [UIFont systemFontOfSize:15];
    numLab.text = @"0/80";
    [self.view addSubview:numLab];
    _numLab = numLab;
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completed
{
    if (self.textV.text.length) {
        if (self.callBack) {
            self.callBack(self.textV.text);
            [self backClick];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请介绍自己"];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLab.hidden = textView.text.length;
    self.numLab.text = [NSString stringWithFormat:@"%ld/80",(unsigned long)textView.text.length];
    if (textView.text.length > 79) {
        [textView resignFirstResponder];
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 80) {
        return NO;
    }else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
