//
//  WalletRecordM.m
//  RentShe
//
//  Created by Lengzz on 2017/10/28.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "WalletRecordM.h"

@implementation WalletRecordM
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        [self setValue:value forKey:@"recordId"];
    }
}
@end
