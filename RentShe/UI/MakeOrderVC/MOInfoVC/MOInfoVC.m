//
//  MOInfoVC.m
//  RentShe
//
//  Created by Lengzz on 2017/8/12.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MOInfoVC.h"
#import "MOSelLocationVC.h"
#import "CusAnnotation.h"
#import "CustomPickV.h"

#import "PayForOrderVC.h"
#import "PayForOrderM.h"

#import "RentInfoM.h"

@interface MOInfoVC ()<UITableViewDelegate,UITableViewDataSource,CustomPickVDelegate,CustomPickVDataSource>
{
    NSString *_starTime;
    NSString *_duration;
    NSString *_address;
    NSString *_notes;
    
    /**    用于标记：1->预见时间；2->时长    */
    NSInteger _type;
    NSTimeInterval _meetTime;
    NSString *_hours;
    CLLocationCoordinate2D _meetPoint;
    
    NSArray *_dateArr;
    NSArray *_hourArr;
    NSArray *_minuteArr;
    NSArray *_durationArr;
}
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) CustomPickV *pickV;
@end

@implementation MOInfoVC

- (void)dealloc
{
    NSLog(@"MOInfoVC dealloc");
}

- (CustomPickV *)pickV
{
    if (!_pickV) {
        _pickV = [[CustomPickV alloc] init];
        _pickV.delegate = self;
        _pickV.dataSource = self;
    }
    return _pickV;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [@[@"预约内容",@"预见时间",@"时长",@"地点"] mutableCopy];
    }
    return _dataArr;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStylePlain];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
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
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"预约订单"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)configData
{
    NSDate *date = [NSDate date];
    [date dateByAddingTimeInterval:60 * 60 * 2];
    NSMutableArray *dateArr = [@[] mutableCopy];
    for (NSInteger i = 0; i < 7; i++) {
        NSString *str = [kCommonConfig.week_DateFormatter stringFromDate:[date dateByAddingTimeInterval:i * (60 * 60 * 24)]];
        str = [str substringToIndex:13];
        [dateArr addObject:str];
    }
    _dateArr = [dateArr copy];
    NSMutableArray *arr = [@[] mutableCopy];
    NSMutableArray *arr1 = [@[] mutableCopy];
    for (NSInteger i = 0; i<24; i++) {
        NSString *hours = [NSString stringWithFormat:@"%02ld",(long)i];
        [arr addObject:hours];
        NSString *dutations = [NSString stringWithFormat:@"%zd小时",i + 1];
        [arr1 addObject:dutations];
    }
    _hourArr = [arr copy];
    _durationArr = [arr1 copy];
    
    _minuteArr = @[@"00",@"10",@"20",@"30",@"40",@"50"];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commitClick
{
    if (!_address || !CLLocationCoordinate2DIsValid(_meetPoint) || ! _meetTime || !_hours) {
        return;
    }
    NSDictionary *params = @{
                             @"lender_id":self.rentInfo.user_id,
                             @"rent_skill_id":self.skill[@"rent_skill_id"],
                             @"rent_hours":_hours,
                             @"meeting_time":[NSString stringWithFormat:@"%.0f",_meetTime],
                             @"addr_name":_address,
                             @"addr_lat":[NSString stringWithFormat:@"%f",_meetPoint.latitude],
                             @"addr_lng":[NSString stringWithFormat:@"%f",_meetPoint.longitude],
                             @"explain": _notes ? _notes : @""
                             };
    [SVProgressHUD show];
    [NetAPIManager makeOrder:params callBack:^(BOOL success, id object) {
        [SVProgressHUD dismiss];
        if (success) {
            PayForOrderM *orderM = [[PayForOrderM alloc] init];
            [orderM setValuesForKeysWithDictionary:object[@"data"]];
            PayForOrderVC *ctl = [[PayForOrderVC alloc] init];
            ctl.orderM = orderM;
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }];
}

/**    设置提前半个小时    */
- (NSArray *)setTimePick:(NSInteger)component
{
    NSDate *date = [NSDate date];
    date = [date dateByAddingTimeInterval:60 * 30];
    NSString *str = [kCommonConfig.week_DateFormatter stringFromDate:date];
    NSString *hour = [str substringWithRange:NSMakeRange(14, 2)];
    NSString *minute = [str substringWithRange:NSMakeRange(17, 2)];
    if (component == 1)
    {
        NSInteger i = [_hourArr indexOfObject:hour];
        NSInteger j = [minute integerValue]/10 + 1;
        if (j >= 5) {
            i += 1;
        }
        return [_hourArr subarrayWithRange:NSMakeRange(i, _hourArr.count - i)];
    }
    else
    {
        NSInteger i = [minute integerValue]/10 + 1;
        if (i >= 5) {
            i = 0;
        }
        return [_minuteArr subarrayWithRange:NSMakeRange(i, _minuteArr.count - i)];
    }
}

- (void)setAddress:(CusAnnotation *)annotation
{
    _meetPoint = annotation.coordinate;
    _address = annotation.subtitle;
    [self.myTabV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark - _____UITableViewDelegate,UITableViewDataSource______

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOInfoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MOInfoCell"];
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.textColor = kRGB_Value(0x282828);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = self.skill[@"skill_name"];
            break;
            
        case 1:
            cell.detailTextLabel.text = _starTime.length ? _starTime : @"请选择";
            break;
            
        case 2:
            cell.detailTextLabel.text = _duration.length ? _duration : @"请选择";
            break;
            
        case 3:
            cell.detailTextLabel.text = _address.length ? _address : @"请选择";
            break;
            
        case 4:
            cell.detailTextLabel.text = _notes.length ? _notes : @"请选择";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44 + 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    UIView *exitV = [[UIView alloc] initWithFrame:CGRectMake(15, 25, kWindowWidth - 30, 44)];
    exitV.backgroundColor = kRGB_Value(0xff751a);
    exitV.layer.masksToBounds = YES;
    exitV.layer.cornerRadius = 5.0;
    [footer addSubview:exitV];
        
    UILabel *lab = [[UILabel alloc] initWithFrame:exitV.bounds];
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"提交订单";
    [exitV addSubview:lab];
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commitClick)];
    [exitV addGestureRecognizer:tap];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        return;
    }
    __block typeof(self) wself = self;
    switch (indexPath.row) {
        case 1:
            _type = 1;
            [self.pickV showPickV];
            break;
            
        case 2:
            _type = 2;
            [self.pickV showPickV];
            break;
            
        case 3:
        {
            MOSelLocationVC *ctl = [[MOSelLocationVC alloc] init];
            ctl.callBack = ^(CusAnnotation *annotation){
                [wself setAddress:annotation];
            };
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 4:
            
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - CustomPickVDelegate,CustomPickVDataSource
- (NSInteger)numberOfComponentsInCustomPickV:(CustomPickV *)customPickV
{
    if (_type == 1)
    {
        return 3;
    }
    else if (_type == 2)
    {
        return 1;
    }
    else
        return 0;
}

- (NSArray *)customPickV:(CustomPickV *)customPickV contentOfRowsInComponent:(NSInteger)component
{
    if (_type == 1)
    {
        NSArray *arr;
        switch (component) {
            case 0:
                arr = _dateArr;
                break;
                
            case 1:
                if ([self.pickV selectedRowInComponent:0])
                {
                    arr = _hourArr;
                }
                else
                    arr = [self setTimePick:1];
                break;
                
            case 2:
                if (![self.pickV selectedRowInComponent:0]&&![self.pickV selectedRowInComponent:1])
                {
                    arr = [self setTimePick:2];
                }
                else
                    arr = _minuteArr;
                break;
                
            default:
                arr = @[];
                break;
        }
        return arr;
    }
    else if (_type == 2)
    {
        return _durationArr;
    }
    else
        return @[];
}

- (void)customPickV:(CustomPickV *)customPickV didSelectRows:(NSArray *)rows inComponents:(NSInteger)components
{
    if (_type == 1)
    {
        NSMutableString *str = [@"" mutableCopy];
        if (components >= 3)
        {
            NSInteger index0 = [rows[0] integerValue];
            NSInteger index1 = [rows[1] integerValue];
            NSInteger index2 = [rows[2] integerValue];
            [str appendString:_dateArr[index0]];
            if(!index0)
            {
                if (index1 >= [self setTimePick:1].count)
                {
                    [str appendFormat:@" %@",[[self setTimePick:1] lastObject]];
                }
                else
                {
                    [str appendFormat:@" %@",[self setTimePick:1][index1]];
                }
                if (index2 >= [self setTimePick:2].count)
                {
                    [str appendFormat:@" %@",[[self setTimePick:2] lastObject]];
                }
                else
                {
                    [str appendFormat:@":%@",[self setTimePick:2][index2]];
                }
            }
            else
            {
                [str appendFormat:@" %@:%@",_hourArr[index1],_minuteArr[index2]];
            }
        }
        _starTime = [str copy];
        if (_starTime.length)
        {
            NSDate *date = [kCommonConfig.week_DateFormatter dateFromString:_starTime];
            _meetTime = date.timeIntervalSince1970;
        }
        [self.myTabV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (_type == 2)
    {
        if (rows.count)
        {
            _duration = _durationArr[[rows[0] integerValue]];
            _hours = [NSString stringWithFormat:@"%zd",[rows[0] integerValue] + 1];
            [self.myTabV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
