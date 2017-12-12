//
//  FilterVC.m
//  RentShe
//
//  Created by Lengzz on 2017/7/4.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "FilterVC.h"
#import "FilterGenderCell.h"
#import "FilterSectionCell.h"

#import "SearchVC.h"

@interface FilterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _min_age;    //年龄筛选区间，最小年龄，
    CGFloat _max_age;
//    page       //分页必须，初始页，从1开始
    NSString *_gender;                  //0 男，1女。空代码全部
//    vocation
//    city_code               //城市编码，必须
    CGFloat _rental_start_time;
    CGFloat _rental_end_time;
//    sun     // 礼拜日，0 不出租 1 出租
//    mon
//    tue
//    wed
//    thu
//    fri
//    sat
//    skill_id        //筛选技能 技能列表还没有给
    CGFloat _min_price;
    CGFloat _max_price;
}
@property (nonatomic, strong) UITableView *myTabV;
@end

@implementation FilterVC

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStyleGrouped
                   ];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB(242, 242, 242);
        _myTabV.showsVerticalScrollIndicator = NO;
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTabV];
        _myTabV.tableHeaderView = [self headerV];
    }
    return _myTabV;
}

- (UIView *)headerV
{
    UIView *searchV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 44)];
    searchV.backgroundColor = [UIColor whiteColor];
    
    UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(12, 7, kWindowWidth - 32, 30)];
    contentV.backgroundColor = kRGB(242, 242, 242);
    contentV.layer.cornerRadius = 5.0;
    contentV.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick)];
    [contentV addGestureRecognizer:tap];
    [searchV addSubview:contentV];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_search"]];
    img.frame = CGRectMake(15, 9.5, 11, 11);
    [contentV addSubview:img];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, kWindowWidth - 32 - 35 - 20, 20)];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = kRGB(40, 40, 40);
    lab.text = @"请输入关键词/账号/昵称";
    [contentV addSubview:lab];
    return searchV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];
    [self createNavbar];
    [self myTabV];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"筛选"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
    UIButton *btn = [CustomNavVC getRightDefaultButtonWithTarget:self action:@selector(completed) titile:@"完成"];
    [btn setTitleColor:kRGB(255, 117, 26) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
}

- (void)searchClick
{
    [self.navigationController pushViewController:[SearchVC new] animated:YES];
}

- (void)configData
{
    NSDictionary *dic = [UserDefaultsManager getFilterInfo];
    if (!dic)
    {
        _min_age = 18;
        _max_age = 70;
        _rental_start_time = 0;
        _rental_end_time = 24;
        _min_price = 0;
        _max_price = 2000;
        _gender = @"";
        return;
    }
    _min_age = dic[kFilterAgeMin] ? [dic[kFilterAgeMin] integerValue] : 18;
    _max_age = dic[kFilterAgeMax] ? [dic[kFilterAgeMax] integerValue] : 70;
    _rental_start_time = dic[kFilterTimeMin] ? [dic[kFilterTimeMin] integerValue] : 0;
    _rental_end_time = dic[kFilterTimeMax] ? [dic[kFilterTimeMax] integerValue] : 24;
    _min_price = dic[kFilterMoneyMin] ? [dic[kFilterMoneyMin] integerValue] : 0;
    _max_price = dic[kFilterMoneyMax] ? [dic[kFilterMoneyMax] integerValue] : 2000;
    _gender = dic[kFilterGender] ? dic[kFilterGender] : @"";
}

- (void)completed
{
    NSDictionary *dic = @{kFilterAgeMin:@(_min_age),
                          kFilterAgeMax:@(_max_age),
                          kFilterTimeMin:@(_rental_start_time),
                          kFilterTimeMax:@(_rental_end_time),
                          kFilterMoneyMin:@(_min_price),
                          kFilterMoneyMax:@(_max_price),
                          kFilterGender:_gender};
    [UserDefaultsManager setFilterInfo:dic];
    if (self.filterBlock) {
        self.filterBlock(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeData:(CGFloat)min andMax:(CGFloat)max withType:(FilterType)type
{
    switch (type) {
        case FilterTypeOfAge:
            _min_age = min;
            _max_age = max;
            break;
            
        case FilterTypeOfPrice:
            _min_price = min;
            _max_price = max;
            break;
            
        case FilterTypeOfTime:
            _rental_start_time = min;
            _rental_end_time = max;
            break;
            
        default:
            break;
    }
}

- (void)changeGender:(NSString *)str
{
    if ([str isEqualToString:@"男"])
    {
        _gender = @"0";
    }
    else if ([str isEqualToString:@"女"])
    {
        _gender = @"1";
    }
    else
    {
        _gender = @"";
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wself = self;
    if (!indexPath.section)
    {
        FilterGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterGenderCell"];
        if (!cell) {
            cell = [[FilterGenderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterGenderCell"];
            cell.genderBlock = ^(NSString *obj){
                [wself changeGender:obj];
            };
        }
        [cell refreshCell:_gender];
        return cell;
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            case 1:
            case 2:
            {
                FilterSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionCell"];
                if (!cell) {
                    cell = [[FilterSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.isChanged = ^(CGFloat min, CGFloat max, FilterType type){
                        [wself changeData:min andMax:max withType:type];
                    };
                }
                if (!indexPath.row)
                {
                    cell.titleStr = @"年龄";
                    cell.min = 18;
                    cell.max = 70;
                    cell.start = _min_age;
                    cell.end = _max_age;
                    [cell setInfo];
                    cell.type = FilterTypeOfAge;
                }
                else if (indexPath.row == 2)
                {
                    cell.titleStr = @"时间";
                    cell.min = 0;
                    cell.max = 24;
                    cell.start = _rental_start_time;
                    cell.end = _rental_end_time;
                    [cell setInfo];
                    cell.type = FilterTypeOfTime;
                }
                else
                {
                    cell.titleStr = @"租金";
                    cell.min = 0;
                    cell.max = 2000;
                    cell.start = _min_price;
                    cell.end = _max_price;
                    [cell setInfo];
                    cell.type = FilterTypeOfPrice;
                }
                return cell;
                break;
            }
            case 3:
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"locationCell"];
                    cell.textLabel.font = [UIFont systemFontOfSize:16];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
                    cell.textLabel.textColor = kRGB(40, 40, 40);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIView *line = [[UIView alloc] init];
                    line.backgroundColor = kRGB_Value(0xf2f2f2);
                    [cell.contentView addSubview:line];
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.contentView.mas_left);
                        make.height.equalTo(@.5);
                        make.width.equalTo(@(kWindowWidth));
                        make.bottom.equalTo(cell.contentView.mas_bottom);
                    }];
                }
                cell.textLabel.text = @"出租范围";
                cell.detailTextLabel.text = @"全部";
                
                return cell;
                break;
            }
            default:
                break;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            return 44 + 67;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"locationHeader"];
    if (!header) {
        header = [UIView new];
        header.backgroundColor = [UIColor clearColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 0, 0)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = kRGB(152, 152, 152);
        lab.tag = 1;
        [header addSubview:lab];
    }
    UILabel *lab = (UILabel *)[header viewWithTag:1];
    lab.text = section ? ([UserDefaultsManager getAuditStatus] ? @"聘请对象" : @"租约对象") : @"高级筛选";
    [lab sizeToFit];
    return header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
