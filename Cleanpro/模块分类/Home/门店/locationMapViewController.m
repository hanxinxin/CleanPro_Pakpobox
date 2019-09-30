//
//  locationMapViewController.m
//  Cleanpro
//
//  Created by mac on 2018/7/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "locationMapViewController.h"
#import <MapKit/MKAnnotation.h>
#import "AircraftAnnotationView.h"
#import "AircraftAnnotation.h"
#import "RouteAnnotion.h"
#import "RouteAnnotationView.h"

@implementation LocationClass

- (IBAction)DaoHang_btn:(id)sender {
}
@end

@interface locationMapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationCoordinate2D My_Loca;
    
    AircraftAnnotation *airAnnotation;
}

@property (nonatomic ,strong) AFNetWrokingAssistant * AFnet;
@property (nonatomic ,strong) NSMutableArray * MD_MUtableArr;
@property (weak,nonatomic) MBProgressHUD* HUD;
@end

@implementation locationMapViewController
@synthesize MD_MUtableArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MD_MUtableArr=[NSMutableArray arrayWithCapacity:0];
    My_Loca.latitude=0;
    My_Loca.longitude=0;
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //定位功能可用
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:FGGetStringWithKeyFromTable(@"Tisp", @"Language")message:FGGetStringWithKeyFromTable(@"\" Settings - privacy - location service \" opens location service and allows StorHub to use location-based services.", @"Language") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
            [self dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
//    self.title=FGGetStringWithKeyFromTable(@"Nearby_A", @"Language");
    //    设置-隐私-定位服务”打开定位服务，并允许StorHub使用定位服务的提示窗口
    airAnnotation = [[AircraftAnnotation alloc] init];
    [self addMapView_c];
    
//    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAppleMap:)];
//    self.mendianMiaoShu.userInteractionEnabled=YES;
//    [self.mendianMiaoShu addGestureRecognizer:labelTapGestureRecognizer];
    

}

- (void)viewWillAppear:(BOOL)animated {
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏导航栏
    //    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:2.0 sinceDate:[NSDate date]]];
    //    self.tabBarController.tabBar.hidden = NO;
    //    [self.navigationController.tabBarController.tabBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=FGGetStringWithKeyFromTable(@"Nearby", @"Language");;
//    self.navigationController.title=@"Location";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [MD_MUtableArr removeAllObjects];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self getLocationList];
        [self down_viewHidden];
        [self setLabelFrame];
        [self updateMessage];
    });
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)updateMessage
{
    NSString * Message_flage = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
    if([Message_flage intValue]==1)
    {
        [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:3];
    }else
    {
        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:3];
    }
}

-(void)setLabelFrame
{
    [self.daohangBtn setImage:[UIImage imageNamed:@"go"] forState:(UIControlStateNormal)];
    self.mendianLabel.frame=CGRectMake(self.daohangBtn.right, 20, SCREEN_WIDTH-self.daohangBtn.right*2, 22);
    self.mendianMiaoShu.frame=CGRectMake(self.daohangBtn.right, self.mendianLabel.bottom+5, SCREEN_WIDTH-self.daohangBtn.right*2, 44);
}

-(void)returnSize1:(UILabel *) strLabel
{
    //3.设置自动换行
    strLabel.numberOfLines = 0;
    
    //4.设置UIFont
//    text.font = [UIFont systemFontOfSize:14];
    
    /**
     5.根据text的font和字符串自动算出size（重点）
     200:你希望的最大宽度
     MAXFLOAT:最大高度为最大浮点数
     **/
    CGSize size = [strLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-55-20*2, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:strLabel.font}
                                          context:nil].size;
    strLabel.frame=CGRectMake(20, 30, SCREEN_WIDTH-55-20*2, size.height);
//    NSLog(@"width11 =   %f",self.daohangBtn.right);
}
-(void)returnSize2:(UILabel *) strLabel
{
    //3.设置自动换行
    strLabel.numberOfLines = 0;
    CGSize size = [strLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-55-20*2, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:strLabel.font}
                                              context:nil].size;
    strLabel.frame=CGRectMake(20, self.mendianLabel.bottom+5, SCREEN_WIDTH-55-20*2, size.height);
//    NSLog(@"width22 =   %f",SCREEN_WIDTH-55-20*2);
}

- (IBAction)DaoHang_touch:(id)sender {
    
    for (int i=0; i<MD_MUtableArr.count; i++) {
        LocationClass * MD_Mode = (LocationClass * )MD_MUtableArr[i];
        if([self.mendianLabel.text isEqualToString:MD_Mode.MDName])
        {
            CLLocationDegrees lat = [MD_Mode.MenDian_lat doubleValue];
            CLLocationDegrees lon = [MD_Mode.MenDian_lon doubleValue];
            //终点坐标
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
            //当前位置
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            //传入目的地，会显示在苹果自带地图上面目的地一栏
            toLocation.name = MD_Mode.MDName;
            //导航方式选择walking
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }
    }
    
}


-(void)getLocationList
{
    [HudViewFZ labelExample:self.view];
    __block locationMapViewController *  blockSelf = self;
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_location] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject=  %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictionary = (NSDictionary*)responseObject;
        
        NSArray * resultListArr=[dictionary objectForKey:@"resultList"];
        for (int i=0; i<resultListArr.count; i++) {
            NSDictionary * dic=resultListArr[i];
            LocationClass * MD_Mode = [[LocationClass alloc] init];
//            NSNumber * LatNum=[dic objectForKey:@"latitude"];
            MD_Mode.MenDian_lat=[dic objectForKey:@"latitude"];
            MD_Mode.MenDian_lon=[dic objectForKey:@"longitude"];
            MD_Mode.MDenName=[dic objectForKey:@"enName"];
            NSLog(@"address === %@",[dic objectForKey:@"address"]);
            MD_Mode.MDName=[dic objectForKey:@"name"];
            MD_Mode.MDaddress=[dic objectForKey:@"address"];
            
            [blockSelf->MD_MUtableArr addObject:MD_Mode];
            
//            }
//        }
//        for (int i=0; i<blockSelf->MD_MUtableArr.count; i++) {
//            LocationClass * MD_Mode = blockSelf->MD_MUtableArr[i];
        AircraftAnnotation * airAnnotation2 = [[AircraftAnnotation alloc] init];
        CLLocationDegrees latitude1 = [MD_Mode.MenDian_lat doubleValue];
        CLLocationDegrees longtitude1 = [MD_Mode.MenDian_lon doubleValue] ;
        airAnnotation2.coordinate= CLLocationCoordinate2DMake(latitude1, longtitude1);
        airAnnotation2.title=[NSString stringWithFormat:@"%@",MD_Mode.MDName];
        airAnnotation2.tagg=i;
        //            airAnnotation2.title=[NSString stringWithFormat:@" "];
        //            if(i==0)
        //            {
        if(airAnnotation2.coordinate.latitude!=0 && airAnnotation2.coordinate.longitude!=0)
        {
            //                        [self.MapView setRegion:MKCoordinateRegionMakeWithDistance(airAnnotation2.coordinate, 3000, 3000) animated:NO];
            [self.MapView addAnnotation:airAnnotation2];
        }
        }
    } failure:^(NSError *error) {
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
        
}

-(void)addMapView_c
{
    self.MapView.showsUserLocation = YES;
    self.MapView.mapType = MKMapTypeStandard;
    if (@available(iOS 9.0, *)) {
        self.MapView.showsScale=YES;
    } else {
        // Fallback on earlier versions
    } ////显示比例尺
    if (@available(iOS 9.0, *)) {
        self.MapView.showsCompass=YES;
    } else {
        // Fallback on earlier versions
    } ////显示指南针
    //设置地图可旋转
    self.MapView.rotateEnabled = NO;
    self.MapView.zoomEnabled = YES;////缩放
    self.MapView.scrollEnabled = YES;/////滑动
    // 交通
    if (@available(iOS 9.0, *)) {
        self.MapView.showsTraffic = YES;
    } else {
        // Fallback on earlier versions
    }
    self.MapView.userTrackingMode = MKUserTrackingModeFollow;
    self.MapView.userInteractionEnabled=YES;
    self.MapView.delegate=self;
    
    //标注自身位置
    [self.MapView setShowsUserLocation:YES];
    
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

-(void)load_mapView
{
//    //    [self.MapView removeAnnotations:self.MapView.annotations];
    for (int i=0; i<MD_MUtableArr.count;i++) {
        LocationClass * MD_Mode = MD_MUtableArr[i];
        CLLocationCoordinate2D ListLoca;
        ListLoca.latitude = [MD_Mode.MenDian_lat doubleValue];
        ListLoca.longitude = [MD_Mode.MenDian_lon doubleValue];
        airAnnotation.coordinate=ListLoca;
        [self.MapView addAnnotation:airAnnotation];
        AircraftAnnotation * airAnnotation2 = [[AircraftAnnotation alloc] init];
        CLLocationDegrees latitude1 = [MD_Mode.MenDian_lat doubleValue];
        CLLocationDegrees longtitude1 = [MD_Mode.MenDian_lon doubleValue] ;
        airAnnotation2.coordinate= CLLocationCoordinate2DMake(latitude1, longtitude1);
        airAnnotation2.tagg=i;
//        airAnnotation2.title=[NSString stringWithFormat:@"%@",MD_Mode.MDName];
//        airAnnotation2.subtitle=[NSString stringWithFormat:@"%@ %@",MD_Mode.MenDian_Street,MD_Mode.MenDian_Block];
        if(airAnnotation2.coordinate.latitude!=0 && airAnnotation2.coordinate.longitude!=0)
        {
            [self.MapView addAnnotation:airAnnotation2];
        }
    }
}

-(void)down_viewShow
{
    [UIView animateWithDuration:0.3/*动画持续时间*/animations:^{
        //执行的动画
        self.Down_view.frame =CGRectMake(0, (self.MapView.height-120), SCREEN_WIDTH, 120);
        [self.Down_view setHidden:NO];
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        
    }];
}
-(void)down_viewHidden
{

        [UIView animateWithDuration:0.3/*动画持续时间*/animations:^{
            //执行的动画
            self.Down_view.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
            [self.Down_view setHidden:YES];
        }completion:^(BOOL finished){
            //动画执行完毕后的操作
            
        }];
}


-(void)pushAppleMap:(UITapGestureRecognizer*)tap
{
    for (int i=0; i<MD_MUtableArr.count; i++) {
        LocationClass * MD_Mode = (LocationClass * )MD_MUtableArr[i];
        if([self.mendianLabel.text isEqualToString:MD_Mode.MDName])
        {
            CLLocationDegrees lat = [MD_Mode.MenDian_lat doubleValue];
            CLLocationDegrees lon = [MD_Mode.MenDian_lon doubleValue];
            //终点坐标
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
            //当前位置
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            //传入目的地，会显示在苹果自带地图上面目的地一栏
            toLocation.name = MD_Mode.MDName;
            //导航方式选择walking
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }
    }
    
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"用iPhone自带地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        //当前位置
//        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
//        //传入目的地，会显示在苹果自带地图上面目的地一栏
//        toLocation.name = self.destination;
//        //导航方式选择walking
//        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
//                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
//    }];
//    [alert addAction:action];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //放大地图到自身的经纬度位置。
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 3000, 3000);
//    [self.MapView setRegion:region animated:YES];
    [manager stopUpdatingLocation];
    [manager stopUpdatingHeading];
    
}
//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //    self.MapView.centerCoordinate = userLocation.coordinate;
    //
    //    [self.MapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.3, 0.3)) animated:YES];
    static int index=0;
    if(index<5){
    [self load_mapView];
        index++;
    }
    //    如果在ViewDidLoad中调用  添加大头针的话会没有掉落效果  定位结束后再添加大头针才会有掉落效果
    //    [self loadData];
    //    [_locationManager stopUpdatingLocation];
    //    [_locationManager stopUpdatingHeading];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    else if ([annotation isKindOfClass:[AircraftAnnotation class]])
    {
        //        AircraftAnnotationView *annotationView = (AircraftAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AircraftAnnotationView"];
        AircraftAnnotationView *annotationView =(AircraftAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AircraftAnnotationView"];
        
        if (annotationView == nil) {
            annotationView = (AircraftAnnotationView *)[[MKAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:@"AircraftAnnotationView"];
            //            annotationView.drop = YES; // 设置大头针坠落的动画
            annotationView.canShowCallout = YES; // 设置点击大头针是否显示气泡
            annotationView.calloutOffset = CGPointMake(0, 0); // 设置大头针气泡的偏移

        }
        annotationView.image = [UIImage imageNamed:@"location_mark_app"];
        ///无  APP门店图标  location_mark@2x
        //有 app门店图标  location_mark_app
        //        annotationView.canShowCallout = YES;//显示气泡
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMissionSetView:)];
        //        [annotationView addGestureRecognizer:tap];
        annotationView.annotation = annotation;
        return annotationView;
        
    }
    return nil;
}
#pragma mark-点击按钮的时候的调用
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"点击按钮的时候的调用 == %@",view.annotation.subtitle);
    //    self.myLocationAnnotation.coordinate=self.moveingAnnotation.coordinate;
    //    mapView.userLocation.coordinate=self.moveingAnnotation.coordinate;
    
}
#pragma mark 选中了标注的处理事件
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    NSLog(@"选中了标注 %f %f %f %f",view.top,view.left,view.width,view.height);
    NSLog(@"选中了标注");
   
    if ([view.annotation isKindOfClass:[AircraftAnnotation class]])
    {
        AircraftAnnotation * mac=(AircraftAnnotation*)view.annotation;
//        NSLog(@"title===%ld",mac.tagg);
         LocationClass * MD_Mode = (LocationClass * )MD_MUtableArr[mac.tagg];
        self.mendianLabel.text=MD_Mode.MDName;
        [self returnSize1:self.mendianLabel];
//        self.mendianMiaoShu.frame=CGRectMake(self.daohangBtn.right, self.mendianLabel.bottom+5, SCREEN_WIDTH-self.daohangBtn.right*2, 44);
        self.mendianMiaoShu.text=MD_Mode.MDaddress;
        [self returnSize2:self.mendianMiaoShu];
        NSLog(@"mendianMiaoShu===%@",self.mendianMiaoShu.text);
    }
     [self down_viewShow];
}

#pragma mark 取消选中标注的处理事件
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"取消了标注");
    [self down_viewHidden];
}
//大头针显示在视图上时调用，在这里给大头针设置显示动画
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    
    
    //    获得mapView的Frame
    CGRect visibleRect = [mapView annotationVisibleRect];
    
    for (MKAnnotationView *view in views) {
        
        CGRect endFrame = view.frame;
        CGRect startFrame = endFrame;
        startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
        view.frame = startFrame;
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:1];
        view.frame = endFrame;
        [UIView commitAnimations];
        
        
    }
    
    
}

// 点击大头针显示单个任务详情
- (void)showMissionSetView:(UITapGestureRecognizer *)tapGuest
{
    
    NSLog(@"点击了自定义气泡");
}


@end
