//
//  LocationManager.h
//  Cleanpro
//
//  Created by mac on 2020/4/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LocationManagerDelegate <NSObject>
@optional

- (void)returnLoction:(CLLocationCoordinate2D)CLLocation;
@end


@interface LocationManager : NSObject
{
     
}
@property (nonatomic, weak) id<LocationManagerDelegate> delegate;
@property (nonatomic, strong) CLLocationManager * locationManager; ///// 定位
+ (id)sharedInstance;
-(void)setStartUpdatingLocation;
-(void)setStopUpdatingLocation;
@end

NS_ASSUME_NONNULL_END
