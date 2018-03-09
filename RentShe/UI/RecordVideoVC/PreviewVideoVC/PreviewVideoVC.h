//
//  PreviewVideoVC.h
//  RentShe
//
//  Created by Lzz on 2018/3/7.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXLiteAVSDK_UGC/TXLivePlayer.h"
/**
 *  短视频预览VC
 */
@class TXRecordResult;
@interface PreviewVideoVC : UIViewController
- (instancetype)initWithCoverImage:(UIImage *)coverImage
                         videoPath:(NSString*)videoPath
                        renderMode:(TX_Enum_Type_RenderMode)renderMode
                      isFromRecord:(BOOL)isFromRecord;
@end
