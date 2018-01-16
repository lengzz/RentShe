//
//  MyFansVC.m
//  RentShe
//
//  Created by Lzz on 2018/1/15.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "MyFansVC.h"
#import "MyFansCell.h"

@interface MyFansVC ()<UITableViewDelegate,UITableViewDataSource,MyFansCellDelegate>
@property (nonatomic, strong) UITableView *myTabV;
@end

@implementation MyFansVC

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTabV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.estimatedRowHeight = 68;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self createV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    self.view.backgroundColor = kRGB_Value(0xf2f2f2);
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"我的粉丝"]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)createV
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self myTabV];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFansCell *cell = [MyFansCell cellWithTableView:tableView indexPath:indexPath];
    [cell refreshCell:@(indexPath.row%2)];
    return cell;
}

#pragma mark -
#pragma mark - MyFansCellDelegate
- (void)myFansCell:(MyFansCell *)cell clickWithIndex:(NSIndexPath *)index
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
