//
//  PublishVideoVC.h
//  RentShe
//
//  Created by Lzz on 2018/3/7.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishVideoVC : UIViewController
- (instancetype)initWithCoverImage:(UIImage *)coverImage
                         videoPath:(NSString*)videoPath
                            isAuth:(BOOL)isAuth;
@end
