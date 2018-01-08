//
//  RentDetailVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RentDetailVC.h"
#import "RentDetailHeadV.h"
#import "NearbyM.h"

#import "MOSelSkillVC.h"
#import "VisitorVC.h"
#import "ReviewsListVC.h"
#import "ConversationDetailVC.h"
#import "EditInfoVC.h"
#import "InformVC.h"

@interface RentDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) RentDetailHeadV *headV;
@end

@implementation RentDetailVC

- (RentDetailHeadV *)headV
{
    if (!_headV) {
        _headV = [[RentDetailHeadV alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowWidth + 62 + 44) andIsSelf:self.isSelf];
        __weak typeof(self) wSelf = self;
        _headV.clickBlock = ^(NSInteger tag){
            switch (tag) {
                case 1://评论
                    [wSelf commentAction];
                    break;
                case 2://访客
                    [wSelf visitorAction];
                    break;
                case 3://编辑
                    [wSelf editAction];
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _headV;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)){
            [_myTabV setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        if (self.isSelf)
        {
            _myTabV.frame = self.view.bounds;
        }
        else
        {
            _myTabV.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight - 44);
            [self addFunctionV];
        }
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        _myTabV.tableHeaderView = self.headV;
        _myTabV.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestInfo];
    [self createNavBar];
//    [self myTabV];
    
    //添加访客记录
    if (!self.isSelf)
    {
        [NetAPIManager visitRecord:@{@"user_id":self.user_id ? self.user_id : @""} callBack:^(BOOL success, id object) {
            
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)createNavBar
{
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"btn_back_white"] hilightImg:[UIImage imageNamed:@"btn_back_white"]]];

    [self.navigationItem setRightBarButtonItem:[CustomNavVC getRightBarButtonItemWithTarget:self action:@selector(shareClick) normalImg:[UIImage imageNamed:@"share_more"] hilightImg:[UIImage imageNamed:@"share_more"]]];
}

- (void)addFunctionV
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 44, kWindowWidth, 44)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = CGRectMake(0, 0, kWindowWidth/2.0, 44);
    [chatBtn setTitle:@"私信" forState:UIControlStateNormal];
    [chatBtn setTitleColor:kRGB(40, 40, 40) forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [v addSubview:chatBtn];
    
    UIButton *appointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    appointmentBtn.backgroundColor = kRGB(253, 114, 29);
    appointmentBtn.frame = CGRectMake(kWindowWidth/2.0, 0, kWindowWidth/2.0, 44);
    [appointmentBtn setTitle:@"预约" forState:UIControlStateNormal];
    [appointmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appointmentBtn addTarget:self action:@selector(appointmentClick) forControlEvents:UIControlEventTouchUpInside];
    appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [v addSubview:appointmentBtn];
}

- (void)requestInfo
{
    if (self.isSelf)
    {
        [NetAPIManager myHomeInfoWithCallBack:^(BOOL success, id object) {
            if (success)
            {
                self.infoM = [NearbyM new];
                [self.infoM setValuesForKeysWithDictionary:object[@"data"]];
                [self.headV refreshHead:self.infoM];
                [self.myTabV reloadData];
            }
        }];
    }
    else
    {
        if (self.infoM)
        {
            
            RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:self.infoM.user_info.user_id name:self.infoM.user_info.nickname portrait:self.infoM.user_info.avatar];
            [kCommonConfig.userInfo setValue:user forKey:self.infoM.user_info.user_id];
            
            [self.headV refreshHead:self.infoM];
            [self.myTabV reloadData];
            return;
        }
        NSDictionary *dic = @{@"user_id":self.user_id};
        [NetAPIManager othersHomeInfo:dic callBack:^(BOOL success, id object) {
            if (success) {
                self.infoM = [NearbyM new];
                [self.infoM setValuesForKeysWithDictionary:object[@"data"]];
                
                RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:self.infoM.user_info.user_id name:self.infoM.user_info.nickname portrait:self.infoM.user_info.avatar];
                [kCommonConfig.userInfo setValue:user forKey:self.infoM.user_info.user_id];
                
                [self.headV refreshHead:self.infoM];
                [self.myTabV reloadData];
            }
        }];
    }
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareClick
{
    ShareToV *shareV = kShareTo;
    shareV.shareImg = self.infoM.user_info.share_avatar;
    shareV.shareTitle = self.infoM.user_info.share_title;
    shareV.shareContent = self.infoM.user_info.share_content;
    shareV.shareUrl = self.infoM.user_info.share_url;
    __block typeof(self)wself = self;
    shareV.feebackBlock = ^(UMSocialPlatformType type) {
        [wself feebackAciton:type];
    };
    [shareV show];
}

- (void)feebackAciton:(UMSocialPlatformType)type
{
    if(!isLogin(self))
    {
        return;
    }
    switch (type) {
        case UMSocialPlatformType_UserDefine_Report:
        {
            if (self.isSelf) {
                [SVProgressHUD showErrorWithStatus:@"不能举报自己哦"];
                return;
            }
            InformVC *vc = [[InformVC alloc] init];
            vc.userId = self.user_id;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case UMSocialPlatformType_UserDefine_Shield:
        {
            if (self.isSelf) {
                [SVProgressHUD showErrorWithStatus:@"不能拉黑自己哦"];
                return;
            }
            [NetAPIManager shieldUser:@{@"his_id":self.user_id} callBack:^(BOOL success, id object) {
                if (success) {
                    [[RCIMClient sharedRCIMClient] addToBlacklist:self.user_id success:^{
                        
                    } error:^(RCErrorCode status) {
                        
                    }];
                    NSString *string = object[@"message"];
                    float time = (float)string.length*0.12 + 0.5;
                    [SVProgressHUD showSuccessWithStatus:object[@"message"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)chatClick
{
    if(!isLogin(self))
    {
        return;
    }
    if (!self.infoM.user_info.flag) {
        [SVProgressHUD showErrorWithStatus:@"用户拒绝私信！"];
        return;
    }
    RCConversationModel *model = [RCConversationModel new];
    model.conversationType = ConversationType_PRIVATE;
    model.targetId = self.infoM.user_info.user_id;
    model.conversationTitle = self.infoM.user_info.nickname;
    
    ConversationDetailVC *_conversationVC = [[ConversationDetailVC alloc] init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = model.targetId;
    _conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:_conversationVC
                                         animated:YES];
}


- (void)appointmentClick
{
    if(!isLogin(self))
    {
        return;
    }
    MOSelSkillVC *vc = [[MOSelSkillVC alloc] init];
    vc.skillsArr = self.infoM.rent_skill;
    vc.rentInfo = self.infoM.rent_info;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentAction
{
    ReviewsListVC *vc = [ReviewsListVC new];
    vc.userId = self.infoM.user_info.user_id;
    vc.reviewsNum = self.infoM.rent_info.comment_num;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)visitorAction
{
    VisitorVC *vc = [VisitorVC new];
    vc.visitorNum = self.infoM.user_info.visitornum;
    vc.userId = self.infoM.user_info.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editAction
{
    EditInfoVC *vc = [EditInfoVC new];
    vc.infoM = self.infoM;
    __weak typeof(self) wself = self;
    vc.isChange = ^{
        [wself requestInfo];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - _______UITableViewDelegate,UITableViewDataSource_______
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return self.infoM.rent_skill.count + 1;
    }
    if (section == 1) {
        return 2;
    }
    return 1;//self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rentDetailCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rentDetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = kRGB(40, 40, 40);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = kRGB(101, 101, 101);
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row)
            {
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = kRGB(101, 101, 101);
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
                cell.detailTextLabel.textColor = kRGB(255, 117, 26);
                RentSkillM *skill = self.infoM.rent_skill[indexPath.row - 1];
                NSMutableString *skillDes = [NSMutableString string];
                for (id obj in skill.layer_info) {
                    [skillDes appendFormat:@"、%@",obj[@"skill_name"]];
                }
                cell.textLabel.text = [skillDes substringFromIndex:1];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/小时",skill.price];
            }
            else
            {
                cell.textLabel.text = @"我的技能";
            }
            break;
        }
        case 1:
        {
            if (indexPath.row)
            {
                cell.textLabel.textColor = kRGB(101, 101, 101);
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.text = self.infoM.user_info.introduction.length ? self.infoM.user_info.introduction : @"我就是我，不一样烟火。";
            }
            else
            {
                cell.textLabel.text = @"自我介绍";
            }
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"职业";
            cell.detailTextLabel.text = self.infoM.user_info.vocation;
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"身高";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@cm",self.infoM.user_info.height];
            break;
        }
        case 4:
        {
            cell.textLabel.text = @"档期";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@~%@ (时间段)",self.infoM.rent_info.rental_start_time ? self.infoM.rent_info.rental_start_time : @"0",self.infoM.rent_info.rental_end_time ? self.infoM.rent_info.rental_end_time : @"0"];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 10;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
