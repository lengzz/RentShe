//
//  NetAPIManager.h
//  RentShe
//
//  Created by Lengzz on 17/5/22.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


//请求回调
typedef void (^HttpCallBackWithObject)(BOOL success,id object);
@interface NetAPIManager : NSObject

//审核配置信息
+ (void)auditConfig:(HttpCallBackWithObject)callBack;

//拉黑用户
+ (void)shieldUser:(id)params callBack:(HttpCallBackWithObject)callBack;

//移除拉黑
+ (void)cancelShieldUser:(id)params callBack:(HttpCallBackWithObject)callBack;

//黑名单列表
+ (void)shieldList:(id)params callBack:(HttpCallBackWithObject)callBack;

//举报
+ (void)reportUser:(id)params callBack:(HttpCallBackWithObject)callBack;

//登录
+ (void)login:(id)params callBack:(HttpCallBackWithObject)callBack;

//登出
+ (void)logoutWithCallBack:(HttpCallBackWithObject)callBack;

//获取验证码
+ (void)takeCode:(id)params callBack:(HttpCallBackWithObject)callBack;

//确认验证码
+ (void)verifyCode:(id)params callBack:(HttpCallBackWithObject)callBack;

//查询绑定信息
+ (void)getBindingInfoWithCallBack:(HttpCallBackWithObject)callBack;

//绑定和解绑第三方账号
+ (void)bindOrUndrawAccount:(id)params callBack:(HttpCallBackWithObject)callBack;

//绑定手机号
+ (void)bindMobilePhone:(id)params callBack:(HttpCallBackWithObject)callBack;

//注册
+ (void)regist:(id)params callBack:(HttpCallBackWithObject)callBack;

//修改密码
+ (void)modifyPsw:(id)params callBack:(HttpCallBackWithObject)callBack;

//设置用户信息
+ (void)setUserInfo:(id)params callBack:(HttpCallBackWithObject)callBack;

//上传图片
+ (void)uploadImg:(UIImage *)img withParams:(id)params callBack:(HttpCallBackWithObject)callBack;

//实名认证
+ (void)cardAuth:(id)params callBack:(HttpCallBackWithObject)callBack;

//热门城市
+ (void)hotCityWithCallBack:(HttpCallBackWithObject)callBack;

//附近的人
+ (void)nearbyPeople:(id)params callBack:(HttpCallBackWithObject)callBack;

//推荐列表
+ (void)recommendPeople:(id)params callBack:(HttpCallBackWithObject)callBack;

//昵称搜索
+ (void)searchPeople:(id)params callBack:(HttpCallBackWithObject)callBack;

//获取个人主页
+ (void)myHomeInfoWithCallBack:(HttpCallBackWithObject)callBack;

//获取他人主页
+ (void)othersHomeInfo:(id)params callBack:(HttpCallBackWithObject)callBack;

//访客记录列表
+ (void)visitorList:(id)params callBack:(HttpCallBackWithObject)callBack;

//添加访客记录
+ (void)visitRecord:(id)params callBack:(HttpCallBackWithObject)callBack;

//获取用户简单信息
+ (void)getUserSimpleInfo:(id)params callBack:(HttpCallBackWithObject)callBack;

//设置私信开关
+ (void)setReceiveLetter:(id)params callBack:(HttpCallBackWithObject)callBack;

//提交订单
+ (void)makeOrder:(id)params callBack:(HttpCallBackWithObject)callBack;

//充值接口
+ (void)recharge:(id)params callBack:(HttpCallBackWithObject)callBack;

//提现接口
+ (void)withdraw:(id)params callBack:(HttpCallBackWithObject)callBack;

//系统余额支付
+ (void)balancePay:(id)params callBack:(HttpCallBackWithObject)callBack;

//支付宝支付
+ (void)zfbPay:(id)params callBack:(HttpCallBackWithObject)callBack;

//支付状态
+ (void)payStatus:(id)params callBack:(HttpCallBackWithObject)callBack;

//获取系统技能
+ (void)getSkills:(id)params callBack:(HttpCallBackWithObject)callBack;

//发布出租信息
+ (void)submitRentInfo:(id)params callBack:(HttpCallBackWithObject)callBack;

//修改出租状态
+ (void)changeRentInfo:(id)params callBack:(HttpCallBackWithObject)callBack;

//我租了谁
+ (void)myRentOrderList:(id)params callBack:(HttpCallBackWithObject)callBack;

//我租了谁订单状态更新
+ (void)myRentUpdateOrder:(id)params callBack:(HttpCallBackWithObject)callBack;

//谁租了我
+ (void)rentMeOrderList:(id)params callBack:(HttpCallBackWithObject)callBack;

//谁租了我订单状态更新
+ (void)rentMeUpdateOrder:(id)params callBack:(HttpCallBackWithObject)callBack;

//订单评论
+ (void)orderReview:(id)params callBack:(HttpCallBackWithObject)callBack;

//评论列表
+ (void)orderReviewsList:(id)params callBack:(HttpCallBackWithObject)callBack;

//钱包列表
+ (void)walletList:(id)params callBack:(HttpCallBackWithObject)callBack;
@end
