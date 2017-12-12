//
//  MOSelSkillVC.m
//  RentShe
//
//  Created by Lengzz on 2017/8/5.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MOSelSkillVC.h"
#import "RentSkillM.h"
#import "MOInfoVC.h"

@interface MOSelSkillVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *myTabV;
@end

@implementation MOSelSkillVC

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB(242, 242, 242);
        _myTabV.showsVerticalScrollIndicator = NO;
//        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTabV.rowHeight = 44;
        _myTabV.sectionFooterHeight = 0.001;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBar];
    [self myTabV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)createNavBar
{
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
    
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"预约"]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.skillsArr && [self.skillsArr isKindOfClass:[NSArray class]])
    {
        return self.skillsArr.count;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RentSkillM *model = self.skillsArr[section];
    if (model && model.layer_info.count)
    {
        return model.layer_info.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelSkillCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelSkillCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = kRGB(40, 40, 40);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    RentSkillM *model = self.skillsArr[indexPath.section];
    NSDictionary *dic = model.layer_info[indexPath.row];
    cell.textLabel.text = dic[@"skill_name"];
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"locationHeader"];
    if (!header) {
        header = [UIView new];
        header.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 10, 2, 20)];
        line.backgroundColor = kRGB(255, 117, 26);
        [header addSubview:line];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 0, 0)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = kRGB(152, 152, 152);
        lab.tag = 1;
        [header addSubview:lab];
    }
    UILabel *lab = (UILabel *)[header viewWithTag:1];
    RentSkillM *model = self.skillsArr[section];
    lab.text = [NSString stringWithFormat:@"%@元/小时",model.price];
    [lab sizeToFit];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentSkillM *model = self.skillsArr[indexPath.section];
    NSDictionary *dic = model.layer_info[indexPath.row];
    MOInfoVC *ctl = [[MOInfoVC alloc] init];
    ctl.skill = dic;
    ctl.rentInfo = self.rentInfo;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
