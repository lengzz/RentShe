//
//  NetAPIManager.m
//  RentShe
//
//  Created by Lengzz on 17/5/22.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "NetAPIManager.h"
#define base_url @"https://api.rentshe.com/Nip"//@"http://119.23.76.192:8000/Nip"
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
    [[NetAPIManager manager] POST:base_url@"/Config/mineConfig" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/addBlackList" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/removeBlackList" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/userBlackList" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/report" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/login" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/logout" parameters:[self configParams:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/mobileCaptcha" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/verifyCaptcha" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/queryBindingInfo" parameters:[self configParams:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/bindThirdParty" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/mobileBind" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/register" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Acount/setPassword" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/setUserInfo" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/imageUploadResUrl" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
    [[NetAPIManager manager] POST:base_url@"/User/cardAuth" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Rent/hotCity" parameters:@{@"token":token?token:@""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Rent/nearbyForRentPeople" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Rent/searchRentList" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/userNickSearch" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/myHome" parameters:[self configParams:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/hisHome" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Visitor/visitorHistoryList" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Visitor/addVisitorRecord" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/getUserSimpleInfo" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/User/setFlag" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Payment/submitPaymentInfo" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Purse/rechargeInfo" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Purse/withdraw" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Payment/sysPay" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Payment/alipayInfo" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Payment/getPaymentStatus" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Skill/getSystemSkill" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    
    [[NetAPIManager manager] POST:base_url@"/Rent/postRentInfo" parameters:@{@"json":jsonString} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Rent/changeRentInfo" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Order/iRentOrder" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Order/lessorOrder" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Order/updateEmployerOrder" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Order/updateLessorOrder" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/OrderEva/orderReview" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/OrderEva/orderReviewList" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NetAPIManager manager] POST:base_url@"/Purse/purseList" parameters:[self configParams:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = nil;
        BOOL status = [NetAPIManager analyzeRetrunData:responseObject withTask:task andResult:&dic];
        callBack(status,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO,nil);
    }];
}
@end
