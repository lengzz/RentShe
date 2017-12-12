//
//  MOSelLocationHearderV.m
//  RentShe
//
//  Created by Lengzz on 2017/8/6.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "MOSelLocationHearderV.h"

@interface MOSelLocationHearderV ()<MAMapViewDelegate>

@end

@implementation MOSelLocationHearderV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createV];
    }
    return self;
}

- (void) createV
{
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.bounds];
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    mapView.showsUserLocation = YES;
    mapView.zoomLevel = 13.5;
    self.mapView = mapView;
    [self addSubview:mapView];
}

- (void)setResArr:(NSArray *)resArr
{
    if (resArr.count)
    {
        _resArr = resArr;
        for (id<MAAnnotation> annotation in resArr)
        {
            if (annotation)
            {
                [self addAnnotationToMapView:annotation];
            }
        }
        [self.mapView setCenterCoordinate:[resArr[0] coordinate]];
    }
}

- (void)setCenterPoint:(CLLocationCoordinate2D)centerPoint
{
    _centerPoint = centerPoint;
    [self.mapView setCenterCoordinate:centerPoint animated:YES];
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
//    [self.mapView setZoomLevel:15.1 animated:NO];
//    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

#pragma mark -
#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if (1||[annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}

@end
