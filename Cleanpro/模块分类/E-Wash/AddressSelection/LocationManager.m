//
//  LocationManager.m
//  Cleanpro
//
//  Created by mac on 2020/4/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "LocationManager.h"
#import <MapKit/MKAnnotation.h>
@interface LocationManager()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationCoordinate2D My_Loca;
}
@end

@implementation LocationManager
+ (id)sharedInstance {
  static LocationManager *Manager = nil;
  @synchronized(self) {
    if (Manager == nil)
      Manager = [[self alloc] init];
  }
  return Manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [_locationManager requestWhenInUseAuthorization];
        }
        
        _locationManager.activityType=CLActivityTypeOther;
        _locationManager.distanceFilter =0;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        [_locationManager startUpdatingHeading];
    }
     return self;
}


-(BOOL)ReturnLocationStart
{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status ||kCLAuthorizationStatusRestricted == status) {
        //这里是未开通时调用的方法
       return NO;
    }else if(kCLAuthorizationStatusNotDetermined == status)
    {
        return NO;
    }else{
       return YES;
    }
    return NO;
}

-(void)setStartUpdatingLocation
{
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
}
-(void)setStopUpdatingLocation
{
//    [_locationManager stopUpdatingLocation];
    [_locationManager stopUpdatingLocation];
    [_locationManager stopUpdatingHeading];
}
// 定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    
    NSLog(@"locations =   %@",locations);
    CLLocation *location = [locations objectAtIndex:0];
    //            NSLog(@"----    %f",location.horizontalAccuracy);
    CLLocationCoordinate2D loc =  [location coordinate];
    //    CLLocationCoordinate2D loc = [userLocation coordinate];
    My_Loca=loc;
    if ([self.delegate respondsToSelector:@selector(returnLoction:)]) {
        [self.delegate returnLoction:My_Loca];
    }
    //放大地图到自身的经纬度位置。
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 3000, 3000);
//    [self.MapView setRegion:region animated:YES];
    [manager stopUpdatingLocation];
    [manager stopUpdatingHeading];
    
}
@end
