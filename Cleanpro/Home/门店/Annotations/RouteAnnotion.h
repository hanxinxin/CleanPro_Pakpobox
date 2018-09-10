//
//  RouteAnnotion.h
//  xEagle1
//
//  Created by xiaoxingxing on 16/4/15.
//  Copyright © 2016年 xiaoxingxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RouteAnnotion : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic, copy) NSString *title;


@end
