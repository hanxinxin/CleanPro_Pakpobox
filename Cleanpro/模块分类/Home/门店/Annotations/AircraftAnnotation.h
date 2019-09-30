//
//  AircraftAnnotation.h
//  xEagle1
//
//  Created by xiaoxingxing on 16/4/15.
//  Copyright © 2016年 xiaoxingxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//@interface AircraftAnnotation : NSObject <MKAnnotation>
@interface AircraftAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 *  大头针标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  大头针的子标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  大头针的  tag
 */
@property (nonatomic, assign) NSInteger tagg;
@end
