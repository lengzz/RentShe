//
//  ConversationDetailVC.m
//  RentShe
//
//  Created by Lengzz on 17/6/1.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ConversationDetailVC.h"
#import "RentDetailVC.h"

#import "RealTimeLocationEndCell.h"
#import "RealTimeLocationStartCell.h"
#import "RealTimeLocationStatusView.h"
#import "RealTimeLocationViewController.h"

@interface ConversationDetailVC ()<UIActionSheetDelegate, RCRealTimeLocationObserver,
RealTimeLocationStatusViewDelegate, UIAlertViewDelegate, RCMessageCellDelegate>
@property(nonatomic, weak) id<RCRealTimeLocationProxy> realTimeLocation;
@property(nonatomic, strong) RealTimeLocationStatusView *realTimeLocationStatusView;

@end

@implementation ConversationDetailVC

- (RealTimeLocationStatusView *)realTimeLocationStatusView
{
    if (!_realTimeLocationStatusView) {
        _realTimeLocationStatusView =
        [[RealTimeLocationStatusView alloc] initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
        _realTimeLocationStatusView.delegate = self;
        [self.view addSubview:_realTimeLocationStatusView];
    }
    return _realTimeLocationStatusView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageIsChange object:self];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:kRGB_Value(0xfde23d)];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.shadowImage = nil;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    
    [self registerClass:[RealTimeLocationStartCell class]
        forMessageClass:[RCRealTimeLocationStartMessage class]];
    [self registerClass:[RealTimeLocationEndCell class]
        forMessageClass:[RCRealTimeLocationEndMessage class]];
    
    __weak typeof(&*self) weakSelf = self;
    [[RCRealTimeLocationManager sharedManager] getRealTimeLocationProxy:self.conversationType
                                                               targetId:self.targetId
                                                                success:^(id<RCRealTimeLocationProxy> realTimeLocation) {
                                                                    weakSelf.realTimeLocation = realTimeLocation;
                                                                    [weakSelf.realTimeLocation addRealTimeLocationObserver:self];
                                                                    [weakSelf updateRealTimeLocationStatus];
                                                                }
                                                                  error:^(RCRealTimeLocationErrorCode status) {
                                                                      NSLog(@"get location share failure with code %d", (int)status);
                                                                  }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        [self.realTimeLocation removeRealTimeLocationObserver:self];
        self.realTimeLocation = nil;
    }
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:self.title]];
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_OUTGOING ||
        [self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_CONNECTED) {
        UIAlertController *ctl = [UIAlertController alertControllerWithTitle:nil message:@"离开聊天，位置共享也会结束，确认离开" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.realTimeLocation removeRealTimeLocationObserver:self];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [ctl addAction:confirm];
        [ctl addAction:cancel];
        [self presentViewController:ctl animated:YES completion:nil];
    } else {
        [self.realTimeLocation removeRealTimeLocationObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updateRealTimeLocationStatus {
    if (self.realTimeLocation) {
        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
        __weak typeof(&*self) weakSelf = self;
        NSArray *participants = nil;
        switch ([self.realTimeLocation getStatus]) {
            case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
                [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
                break;
            case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
            case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
                participants = [self.realTimeLocation getParticipants];
                if (participants.count == 1) {
                    NSString *userId = participants[0];
                    [weakSelf.realTimeLocationStatusView
                     updateText:[NSString stringWithFormat:@"user<%@>正在共享位置", userId]];
                    [[RCIM sharedRCIM].userInfoDataSource
                     getUserInfoWithUserId:userId
                     completion:^(RCUserInfo *userInfo) {
                         if (userInfo.name.length) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [weakSelf.realTimeLocationStatusView
                                  updateText:[NSString stringWithFormat:@"%@正在共享位置", userInfo.name]];
                             });
                         }
                     }];
                } else {
                    if (participants.count < 1)
                        [self.realTimeLocationStatusView removeFromSuperview];
                    else
                        [self.realTimeLocationStatusView
                         updateText:[NSString stringWithFormat:@"%d人正在共享地理位置", (int)participants.count]];
                }
                break;
            default:
                break;
        }
    }
}

- (void)showRealTimeLocationViewController {
    RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    } else if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE) {
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc
                                            animated:YES
                                          completion:^{
                                              }];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[RCMessageCell class]]) {
        RCMessageCell *messageCell = (RCMessageCell *)cell;
        messageCell.portraitStyle = RC_USER_AVATAR_CYCLE;
    }
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    switch (tag) {
        case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
            if (self.realTimeLocation) {
                UIAlertController *ctl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *location = [UIAlertAction actionWithTitle:@"发送位置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
                }];
                UIAlertAction *realLocation = [UIAlertAction actionWithTitle:@"位置实时共享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showRealTimeLocationViewController];
                }];
                [ctl addAction:location];
                [ctl addAction:realLocation];
                [ctl addAction:cancel];
                [self presentViewController:ctl animated:YES completion:nil];
            } else {
                [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            }
            
        } break;
            
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}

- (void)didTapCellPortrait:(NSString *)userId
{
    if ([userId isEqualToString:[UserDefaultsManager getUserId]])
    {
        return;
    }
    RentDetailVC *vc = [[RentDetailVC alloc] init];
    vc.isSelf = NO;
    vc.user_id = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - RealTimeLocationStatusViewDelegate
- (void)onJoin {
    [self showRealTimeLocationViewController];
}
- (RCRealTimeLocationStatus)getStatus
{
    return [self.realTimeLocation getStatus];
}

- (void)onShowRealTimeLocationView
{
    [self showRealTimeLocationViewController];
}

#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model
{
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    }
}

#pragma mark override
- (void)resendMessage:(RCMessageContent *)messageContent {
    if ([messageContent isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    } else {
        [super resendMessage:messageContent];
    }
}

#pragma mark - RCRealTimeLocationObserver
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onParticipantsJoin:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你加入了地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource
         getUserInfoWithUserId:userId
         completion:^(RCUserInfo *userInfo) {
             if (userInfo.name.length) {
                 [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@加入地理位置共享",
                                                    userInfo.name]];
             } else {
                 [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>加入地理位置共享",
                                                    userId]];
             }
         }];
    }
}

- (void)onParticipantsQuit:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你退出地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource
         getUserInfoWithUserId:userId
         completion:^(RCUserInfo *userInfo) {
             if (userInfo.name.length) {
                 [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@退出地理位置共享",
                                                    userInfo.name]];
             } else {
                 [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>退出地理位置共享",
                                                    userId]];
             }
         }];
    }
}

- (void)onRealTimeLocationStartFailed:(long)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.conversationDataRepository.count; i++) {
            RCMessageModel *model = [self.conversationDataRepository objectAtIndex:i];
            if (model.messageId == messageId) {
                model.sentStatus = SentStatus_FAILED;
            }
        }
        NSArray *visibleItem = [self.conversationMessageCollectionView indexPathsForVisibleItems];
        for (int i = 0; i < visibleItem.count; i++) {
            NSIndexPath *indexPath = visibleItem[i];
            RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
            if (model.messageId == messageId) {
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[ indexPath ]];
            }
        }
    });
}

- (void)notifyParticipantChange:(NSString *)text {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.realTimeLocationStatusView updateText:text];
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
    });
}

@end
