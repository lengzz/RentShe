//
//  RecordVideoVC.h
//  RentShe
//
//  Created by Lzz on 2018/3/6.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordVideoVC : UIViewController

@end

@interface RecordMusicInfo : NSObject
@property (nonatomic, copy) NSString* filePath;
@property (nonatomic, copy) NSString* soneName;
@property (nonatomic, copy) NSString* singerName;
@property (nonatomic, assign) CGFloat duration;
@end
