//
//  CusAnnotation.m
//  RentShe
//
//  Created by Lengzz on 2017/8/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CusAnnotation.h"

@interface CusAnnotation ()

@end

@implementation CusAnnotation

- (NSString *)title
{
    return self.poi.name;
}

- (NSString *)subtitle
{
    return self.poi.address;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithPOI:(AMapPOI *)poi
{
    if (self = [super init])
    {
        self.poi = poi;
    }
    
    return self;
}
@end
