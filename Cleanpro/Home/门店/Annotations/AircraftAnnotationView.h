//
//  AircraftAnnotationView.h
//  xEagle1
//
//  Created by xiaoxingxing on 16/4/16.
//  Copyright © 2016年 xiaoxingxing. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AircraftAnnotation.h"

@interface AircraftAnnotationView : MKAnnotationView

@property (nonatomic,strong) AircraftAnnotation *airAnnotation;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,retain)UIView *contentView;
@end
