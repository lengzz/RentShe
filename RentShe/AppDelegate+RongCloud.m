//
//  AppDelegate+RongCloud.m
//  RentShe
//
//  Created by Lengzz on 17/6/1.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "AppDelegate+RongCloud.h"
#import "RootTabbarVC.h"

@implementation AppDelegate (RongCloud)

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    if ([userId isEqualToString:[UserDefaultsManager getUserId]]) {
        return completion([RCIM sharedRCIM].currentUserInfo);
    }
    [NetAPIManager getUserSimpleInfo:@{@"uid_string":userId} callBack:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dic = [object[@"data"] firstObject];
            RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:dic[@"id"] name:dic[@"nickname"] portrait:dic[@"avatar"]];
            return completion(user);
        }
    }];
    
    return completion(nil);
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBadageNum];
    });
}

- (void)setBadageNum{
    
    NSInteger unreadMessageCount = [self getUnreadCount];
    UITabBarItem *item = [self.tabVC.tabBar.items objectAtIndex:1];
    
    if (unreadMessageCount == 0) {
        item.badgeValue = nil ;
        return ;
    }
    item.badgeValue = [NSString stringWithFormat:@"%ld",(long)unreadMessageCount];
}

- (NSInteger)getUnreadCount
{
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
    return unreadMsgCount ;
}

@end
