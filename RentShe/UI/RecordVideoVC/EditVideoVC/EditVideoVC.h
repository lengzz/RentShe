//
//  EditVideoVC.h
//  RentShe
//
//  Created by Lzz on 2018/3/7.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface EditVideoVC : UIViewController

@property (strong,nonatomic) NSString *videoPath;

@property (strong,nonatomic) AVAsset  *videoAsset;
@end
