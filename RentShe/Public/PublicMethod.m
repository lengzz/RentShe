//
//  PublicMethod.m
//  RentShe
//
//  Created by Lengzz on 17/5/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "PublicMethod.h"
#import <CommonCrypto/CommonDigest.h>

NSString * MD5Str(NSString *input)
{
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

NSString * SHA1Str(NSString *inputText)
{
    const char *cstr = [inputText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inputText.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

BOOL isLogin(UIViewController *ctl)
{
    if (![UserDefaultsManager getToken].length) {
        [UserDefaultsManager logOut];
        LoginVC *loginVC = [[LoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginVC.navigationController.navigationBar.hidden = YES;
        [ctl presentViewController:nav animated:YES completion:nil];
        return NO;
    }
    return YES;
}

void payByAlipay(NSString *orderStr, void (^callBack)(BOOL isSuccess))
{
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:kAliScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
        if (resultStatus == 9000){//订单支付成功
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            if (callBack)
            {
                callBack(YES);
            }
        }else{//网络连接出错
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            if (callBack)
            {
                callBack(NO);
            }
        }
    }];
}
