//
//  RentSkillM.m
//  RentShe
//
//  Created by Lengzz on 2017/7/3.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "RentSkillM.h"

@implementation RentSkillM

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"layer_info"])
    {
        id arr = value;
        if ([arr isKindOfClass:[NSArray class]])
        {
            self.layer_info = value;
        }
        else
        {
            self.layer_info = @[];
        }
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end
