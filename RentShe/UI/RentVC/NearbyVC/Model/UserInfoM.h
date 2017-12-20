//
//  UserInfoM.h
//  RentShe
//
//  Created by Lengzz on 2017/7/3.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoM : NSObject

@property (nonatomic, copy) NSString *user_id;//"192",
@property (nonatomic, copy) NSString *nickname;//"xianxue",
@property (nonatomic, copy) NSString *certified;//"0",
@property (nonatomic, copy) NSString *describe;//"",
@property (nonatomic, copy) NSString *photo;//"http://119.23.76.192:8000/Uploads/2017-05-20/591ff18c5df47.jpg",
@property (nonatomic, copy) NSString *avatar;//"http://119.23.76.192:8000/Uploads/2017-05-20/591fec11e8fb3.jpg",
@property (nonatomic, copy) NSString *gender;//"0",
@property (nonatomic, copy) NSString *age;//"19",
@property (nonatomic, copy) NSString *birthday;//"1998-01-01",
@property (nonatomic, copy) NSString *height;//"0",
@property (nonatomic, copy) NSString *weight;//"0",
@property (nonatomic, copy) NSString *vocation;//"漂亮",
@property (nonatomic, assign) NSInteger visitornum;//"0",
@property (nonatomic, assign) NSInteger flag;//"1"
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *share_title;
@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, copy) NSString *share_avatar;
@property (nonatomic, copy) NSString *share_content;
@property (nonatomic, copy) NSString *introduction;//":"自我介绍",
@end
