//
//  locationMapViewController.h
//  Cleanpro
//
//  Created by mac on 2018/7/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


////LocationClass类
@interface LocationClass : NSObject

//@property (nonatomic,assign)CLLocationCoordinate2D LocationeCoor;
@property (nonatomic,strong)NSString * MenDian_lat;
@property (nonatomic,strong)NSString * MenDian_lon;
@property (nonatomic,strong)NSString * showApp; //是否支持APP操作
@property (nonatomic,strong)NSString * MDName;
@property (nonatomic,strong)NSString * MDenName;
@property (nonatomic,strong)NSString * MDaddress;
@end



@interface locationMapViewController : UIViewController
{
    CLLocationManager * _locationManager; ///// 定位
}
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UIView *Down_view;
@property (weak, nonatomic) IBOutlet UILabel *mendianLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *mendianMiaoShu;
@property (weak, nonatomic) IBOutlet UIButton *daohangBtn;

@end
