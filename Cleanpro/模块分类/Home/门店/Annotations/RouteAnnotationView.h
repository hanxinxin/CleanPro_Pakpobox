//
//  RouteAnnotationView.h
//  xEagle1
//
//  Created by xiaoxingxing on 16/4/15.
//  Copyright © 2016年 xiaoxingxing. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RouteAnnotion.h"


@interface RouteAnnotationView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *image_tu;
@property (nonatomic,strong) RouteAnnotion *routeAnnotation;
@property (weak, nonatomic) IBOutlet UILabel *didian_label;
@property (weak, nonatomic) IBOutlet UILabel *xiangxi_dizhi_label;


@end
