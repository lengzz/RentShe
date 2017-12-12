//
//  PublicMethod.h
//  RentShe
//
//  Created by Lengzz on 17/5/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>

#ifndef PublicMethod_h
#define PublicMethod_h

NSString * MD5Str(NSString *inputText);

NSString * SHA1Str(NSString *inputText);

BOOL isLogin(UIViewController *ctl);

void payByAlipay(NSString *orderStr, void (^callBack)(BOOL isSuccess));

#endif /* PublicMethod_h */
