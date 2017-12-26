//
//  NetAPIManager.m
//  RentShe
//
//  Created by Lengzz on 17/5/22.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "NetAPIManager.h"
//#define [NSString stringWithFormat: kCommonConfig.apiHostUrl//@"https://api.rentshe.com/Nip"
@implementation NetAPIManager

#pragma mark -
#pragma mark - 网络请求配置
+ (AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];//[NSSet setWithObject:@"text/html"];
//
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    NSString *token = [UserDefaultsManager getToken];
//    NSString *cookie = [NSString stringWithFormat:@"device=ios;version=%@;token=%@",[kAPPInfo objectForKey:@"CFBundleShortVersionString"],token];
//    
//    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    return manager;
}

#pragma mark -
#pragma mark - 参数配置
+ (id)configParams:(id)params
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValuesForKeysWithDictionary:params];
    
    NSString *token = [UserDefaultsManager getToken];
    [dic setValue:token?token:@"" forKey:@"token"];
    [dic setValue:@"ios" forKey:@"device"];
    return dic;
}

#pragma mark -
#pragma mark - 解析返回数据
+ (BOOL)analyzeRetrunData:(id)obj withTask:(NSURLSessionDataTask *)task andResult:(NSDictionary **)res
{
    if (!obj || obj == [NSNull null] || ![obj isKindOfClass:[NSDictionary class]])
    {
        res = nil;
        return NO;
    }
    
    *res = obj;
    NSObject *code = [obj objectForKey:@"code"];
    if(code!=nil)
    {
        if([code isKindOfClass:[NSString class]])
        {
            if([(NSString *)code isEqualToString:@"200"])
            {
                return YES;
            }
            else 
            {
                [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"message"]];
            }
        }
        
        if([code isKindOfClass:[NSNumber class]])
        {
            if([(NSNumber *)code intValue ] == 200)
            {
                return YES;
            }
            else if ([(NSNumber *)code intValue ] == kTokenDisabled)
            {
                [UserDefaultsManager logOut];
                [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"message"]];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"message"]];
            }
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - 审核配置信息
+ (void)auditConfig:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Config/mineConfig",kCommonConfig.apiHostUrl] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 版本更新
+ (void)appCheckUpdate:(HttpCallBackWithObject)callBack
{
    NSDictionary *dic = @{@"version":kAppVersion,@"device":@"ios"};
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Config/appCheckUpdate",kCommonConfig.apiHostUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 拉黑用户
+ (void)shieldUser:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/addBlackList",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 移除拉黑
+ (void)cancelShieldUser:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/removeBlackList",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 黑名单列表
+ (void)shieldList:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/userBlackList",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 举报
+ (void)reportUser:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/report",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark - 应用层接口
#pragma mark - 登录
+ (void)login:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/login",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 登出
+ (void)logoutWithCallBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/logout",kCommonConfig.apiHostUrl] parameters:[self configParams:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 获取验证码
+ (void)takeCode:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/mobileCaptcha",kCommonConfig.apiHostUrl] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 确认验证码
+ (void)verifyCode:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/verifyCaptcha",kCommonConfig.apiHostUrl] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 查询绑定信息
+ (void)getBindingInfoWithCallBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/queryBindingInfo",kCommonConfig.apiHostUrl] parameters:[self configParams:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 绑定和解绑第三方账号
+ (void)bindOrUndrawAccount:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/bindThirdParty",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 绑定手机号
+ (void)bindMobilePhone:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/mobileBind",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 注册
+ (void)regist:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/register",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 修改密码
+ (void)modifyPsw:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Acount/setPassword",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 设置用户信息
+ (void)setUserInfo:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/setUserInfo",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 上传图片
+ (void)uploadImg:(UIImage *)img withParams:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/imageUploadResUrl",kCommonConfig.apiHostUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
        [formData appendPartWithFileData:imgData name:@"name" fileName:@"rentshe.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 实名认证
+ (void)cardAuth:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/cardAuth",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 热门城市
+ (void)hotCityWithCallBack:(HttpCallBackWithObject)callBack
{
    NSString *token = [UserDefaultsManager getToken];
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Rent/hotCity",kCommonConfig.apiHostUrl] parameters:@{@"token":token?token:@""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 附近的人
+ (void)nearbyPeople:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Rent/nearbyForRentPeople",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 推荐列表
+ (void)recommendPeople:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Rent/searchRentList",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 昵称搜索
+ (void)searchPeople:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/userNickSearch",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 获取个人主页
+ (void)myHomeInfoWithCallBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/myHome",kCommonConfig.apiHostUrl] parameters:[self configParams:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 获取他人主页
+ (void)othersHomeInfo:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/hisHome",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 访客记录列表
+ (void)visitorList:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Visitor/visitorHistoryList",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 添加访客记录
+ (void)visitRecord:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Visitor/addVisitorRecord",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 获取用户简单信息
+ (void)getUserSimpleInfo:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/getUserSimpleInfo",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 更新位置
+ (void)updateLocation:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Rent/updateLocation",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 设置私信开关
+ (void)setReceiveLetter:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/setFlag",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 提交订单
+ (void)makeOrder:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Payment/submitPaymentInfo",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 充值接口
+ (void)recharge:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Purse/rechargeInfo",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 提现接口
+ (void)withdraw:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Purse/withdraw",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 系统余额支付
+ (void)balancePay:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Payment/sysPay",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 支付宝支付
+ (void)zfbPay:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Payment/alipayInfo",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 支付状态
+ (void)payStatus:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Payment/getPaymentStatus",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 获取系统技能
+ (void)getSkills:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Skill/getSystemSkill",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 发布出租信息
+ (void)submitRentInfo:(id)params callBack:(HttpCallBackWithObject)callBack
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self configParams:params]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSString *jsonString = @"";
    
    if (jsonData)
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Rent/postRentInfo",kCommonConfig.apiHostUrl] parameters:@{@"json":jsonString} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 修改出租状态
+ (void)changeRentInfo:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Rent/changeRentInfo",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 我租了谁
+ (void)myRentOrderList:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Order/iRentOrder",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 谁租了我
+ (void)rentMeOrderList:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Order/lessorOrder",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 我租了谁订单状态更新
+ (void)myRentUpdateOrder:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Order/updateEmployerOrder",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 谁租了我订单状态更新
+ (void)rentMeUpdateOrder:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Order/updateLessorOrder",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 订单评论
+ (void)orderReview:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/OrderEva/orderReview",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 评论列表
+ (void)orderReviewsList:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/OrderEva/orderReviewList",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 钱包列表
+ (void)walletList:(id)params callBack:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/Purse/purseList",kCommonConfig.apiHostUrl] parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}

#pragma mark -
#pragma mark - 我的余额
+ (void)myWallet:(HttpCallBackWithObject)callBack
{
    [[NetAPIManager manager] POST:[NSString stringWithFormat:@"%@/User/myAmount",kCommonConfig.apiHostUrl] parameters:[self configParams:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}
@end
