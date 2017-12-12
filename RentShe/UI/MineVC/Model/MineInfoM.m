//
//  MineInfoM.m
//  RentShe
//
//  Created by Lengzz on 2017/7/16.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MineInfoM.h"

@implementation MineInfoM
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"userinfo"])
    {
        
    }
    else if ([key isEqualToString:@"id"])
    {
        [super setValue:value forKey:@"userId"];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}
@end
