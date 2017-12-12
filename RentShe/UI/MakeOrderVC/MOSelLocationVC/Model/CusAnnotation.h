//
//  CusAnnotation.h
//  RentShe
//
//  Created by Lengzz on 2017/8/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface CusAnnotation : NSObject<MAAnnotation>
- (id)initWithPOI:(AMapPOI *)poi;

@property (nonatomic, strong) AMapPOI *poi;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (NSString *)title;

- (NSString *)subtitle;
@end
