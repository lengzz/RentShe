//
//  DQBroswerItemView.h
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQPhotoModel;
@interface DQBroswerItemView : UIView
@property (nonatomic,strong) DQPhotoModel *pModel;
- (void)resetToDismiss:(BOOL)dismiss;//将放大的图片复原
@end
