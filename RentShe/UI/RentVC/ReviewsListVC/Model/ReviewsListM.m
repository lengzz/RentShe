//
//  ReviewsListM.m
//  RentShe
//
//  Created by Lengzz on 2017/10/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ReviewsListM.h"

@implementation ReviewsListM

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forUndefinedKey:@"reviewId"];
    }
}

+ (NSMutableArray *)packetFilter:(NSMutableArray *)dataArr andNewArr:(NSArray *)newArr
{
    NSMutableArray *contentArr, *resArr = [NSMutableArray array];
    if (dataArr.count) {
        [resArr addObjectsFromArray:dataArr];
    }
    for (ReviewsListM *m in newArr) {
        NSString *str = [kCommonConfig.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:m.create_time]];
        NSArray *arr = [str componentsSeparatedByString:@" "];
        
        if (!arr.count) continue;
        
        if (!resArr.count)
        {
            contentArr = [NSMutableArray array];
            NSDictionary *dic = @{kReviewsTitle:arr[0],kReviewsContent:contentArr};
            [contentArr addObject:m];
            [resArr addObject:dic];
        }
        else
        {
            NSDictionary *dic = [resArr lastObject];
            if ([dic[kReviewsTitle] isEqualToString:arr[0]])
            {
                contentArr = dic[kReviewsContent];
                [contentArr addObject:m];
            }
            else
            {
                contentArr = [NSMutableArray array];
                NSDictionary *dic = @{kReviewsTitle:arr[0],kReviewsContent:contentArr};
                [contentArr addObject:m];
                [resArr addObject:dic];
            }
        }
    }
    return resArr;
}
@end
