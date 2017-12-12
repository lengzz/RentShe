//
//  ReviewsListM.h
//  RentShe
//
//  Created by Lengzz on 2017/10/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kReviewsTitle @"title"
#define kReviewsContent @"content"

@interface ReviewsListM : NSObject
@property(nonatomic, copy) NSString *reviewId;
@property(nonatomic, copy) NSString *rent_price;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, copy) NSString *score;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, assign) double create_time;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *nickname;

+ (NSMutableArray *)packetFilter:(NSMutableArray *)dataArr andNewArr:(NSArray *)newArr;
@end
