//
//  OrderListM.m
//  RentShe
//
//  Created by Lengzz on 2017/9/3.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "OrderListM.h"

@implementation OrderListM

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"his_info"])
    {
        [self setValuesForKeysWithDictionary:value];
    }
}

@end
