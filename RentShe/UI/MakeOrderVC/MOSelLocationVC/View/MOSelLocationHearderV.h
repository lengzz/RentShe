//
//  MOSelLocationHearderV.h
//  RentShe
//
//  Created by Lengzz on 2017/8/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface MOSelLocationHearderV : UIView
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSArray *resArr;

@property (nonatomic, assign) CLLocationCoordinate2D centerPoint;
@end
