//
//  ShareToV.h
//  CustomNavBar
//
//  Created by Lzz on 2017/11/7.
//  Copyright © 2017年 Lzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

#define kShareTo [ShareToV shareInstance]

@interface ShareToV : UIView
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareImg;

@property (nonatomic, copy) void (^feebackBlock)(UMSocialPlatformType type);

+ (instancetype)shareInstance;
- (void)show;

+ (BOOL)isShare;
@end
