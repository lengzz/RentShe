//
//  AppDelegate.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabbarVC.h"

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import <BQMMRongCloudExt/BQMMRongCloudExt.h>

#import "AppDelegate+RongCloud.h"
#import "IQKeyboardManager.h"

#import "JPUSHService.h"

// iOS10注册APNs所需头文件

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif



@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NetAPIManager auditConfig:^(BOOL success, id object) {
        if (success)
        {
            NSDictionary *dic = object[@"data"];
            BOOL isAudit = [dic[@"verify"] boolValue];
            [UserDefaultsManager setAuditStatus:isAudit];
            [UserDefaultsManager setRangeSensor:[NSString stringWithFormat:@"%@",dic[@"range"]]];
        }
        else
            [UserDefaultsManager setAuditStatus:NO];
    }];
    
    RootTabbarVC *tabVC = [[RootTabbarVC alloc] init];
    self.window.rootViewController = tabVC;
    _tabVC = tabVC;
    [self.window reloadInputViews];
    [self.window makeKeyAndVisible];
    
    [UMConfigure initWithAppkey:kUmeng_APPKey channel:nil];
    [MobClick setScenarioType:E_UM_NORMAL];
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmeng_APPKey];
    //微信注册
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWeCaht_APPID appSecret:kWeCaht_Secret redirectURL:nil];
    //QQ注册
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQ_APPID appSecret:nil redirectURL:nil];
    
    //极光注册
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:kCommonConfig.jPushAppKey
                          channel:@"App Store"
                 apsForProduction:kCommonConfig.isProduction
            advertisingIdentifier:nil];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //融云
    [[RCIM sharedRCIM] initWithAppKey:kCommonConfig.rongCAppKey];
    
//    [[MMEmotionCentre defaultCentre] setAppId:@"d85169a2cc3b4e19bb180dd3a7e9815c"                                         secret:@"cb748c02f5bd449abcf179b3e2ba2caa"];//AppId:d85169a2cc3b4e19bb180dd3a7e9815c
//AppSecret:cb748c02f5bd449abcf179b3e2ba2caa
    [MMEmotionCentre defaultCentre].sdkRegion = MMRegionChina;
    
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    //高德地图
    [AMapServices sharedServices].apiKey = kAMapKey;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    //检查登录
    [self loginRC];
    
    //检查版本
    [self checkAppVersion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRC) name:kLoginStatusIsChange object:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result) {
       return result;
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    else if([url.host isEqualToString:@"pay"])
    {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"1110   %@",userInfo);
}

#pragma mark -
#pragma mark - JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSLog(@"!!!!@@@ %@",userInfo);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"0.0" message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark - 检查登录
- (void)loginRC
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadageNum) name:kUnreadMessageIsChange object:nil]; 
    if ([UserDefaultsManager getToken].length)
    {
        [JPUSHService setAlias:[UserDefaultsManager getUserId] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:1];
        [[RCIM sharedRCIM] connectWithToken:[UserDefaultsManager getRYToken] success:^(NSString *userId) {
            NSLog(@"RongYun is Login !!!");
            [RCIM sharedRCIM].userInfoDataSource = self;
            [RCIM sharedRCIM].receiveMessageDelegate = self;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageIsChange object:self];
            RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userId name:[UserDefaultsManager getNickName] portrait:[UserDefaultsManager getAvatar]];
            [RCIM sharedRCIM].currentUserInfo = info;
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            
        }];
    }
    else
    {
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:0];
    }
}

#pragma mark -
#pragma mark - 检查版本
- (void)checkAppVersion
{
    [NetAPIManager appCheckUpdate:^(BOOL success, id object) {
        if (success) {
            BOOL isShow = [object[@"data"][@"isShow"] boolValue];
            BOOL isForce = [object[@"data"][@"isForce"] boolValue];
            NSString *msg = object[@"data"][@"msg"];
            NSString *url = object[@"data"][@"updateAddr"];
            if (isShow)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:msg preferredStyle:UIAlertControllerStyleAlert];
                if (isForce)
                {
                    [alert addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }]];
                }
                else
                {
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }]];
                }
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
}
@end
