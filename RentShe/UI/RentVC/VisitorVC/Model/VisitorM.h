//
//  VisitorM.h
//  RentShe
//
//  Created by Lengzz on 2017/10/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kVisitorMTitle @"title"
#define kVisitorMContent @"content"

@interface VisitorM : NSObject
@property(nonatomic, copy) NSString *visitor_id;
@property(nonatomic, assign) double create_time;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *avatar;

+ (NSMutableArray *)packetFilter:(NSMutableArray *)dataArr andNewArr:(NSArray *)newArr;
@end
