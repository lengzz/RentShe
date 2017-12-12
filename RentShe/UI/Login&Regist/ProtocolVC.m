//
//  ProtocolVC.m
//  RentShe
//
//  Created by Lengzz on 2017/11/5.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ProtocolVC.h"


#define kUrlProtocol @"https://api.rentshe.com/Nip/Web/terms"
@interface ProtocolVC () <UIWebViewDelegate,UIScrollViewDelegate>{
    BOOL isRepeat;
}

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.prefersNavigationBarHidden = YES;
    [self createNavBar];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kWindowWidth, kWindowHeight - kNavBarHeight)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:kUrlProtocol]];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
}

- (void)createNavBar
{
    self.view.backgroundColor = kRGB(242, 242, 242);
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kNavBarHeight)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, kNavBarHeight - 42, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"setting_back"] forState:UIControlStateNormal];
    [v addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, kNavBarHeight - 42, kWindowWidth - 100, 40)];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = kRGB(51, 51, 51);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = self.titleStr;
    [v addSubview:titleLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight - 0.5, kWindowWidth, 0.5)];
    line.backgroundColor = kRGB(242, 242, 242);
    [v addSubview:line];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _webView.scrollView.scrollEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


@end
