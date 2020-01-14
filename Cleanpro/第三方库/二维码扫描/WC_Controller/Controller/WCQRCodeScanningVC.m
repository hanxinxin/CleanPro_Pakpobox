//
//  WCQRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "WCQRCodeScanningVC.h"
#import "AppDelegate.h"
#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
#import "DryerViewController.h"
#import "NSString+AES256.h"
//#import <luckysdk/Manager.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "HxShopCartViewController.h"
//#import <luckysdk/NetworkConfig.h>
@interface WCQRCodeScanningVC () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate,CBCentralManagerDelegate>
{
    BOOL QRBool;
}
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSString *orderStr; //////扫描二维码得到的信息

@property (nonatomic, strong) NSString * addr; ///获取二维码的加密字节

//@property CBCentralManager *centralManager;


@end

@implementation WCQRCodeScanningVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [Manager.inst disconnect];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [self removeScanningView];
    [self.promptLabel removeFromSuperview];
    [self.flashlightBtn removeFromSuperview];
    [self.bottomView removeFromSuperview];
    NSArray<CALayer *> *subLayers = self.view.layer.sublayers;
    NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[AVCaptureVideoPreviewLayer class]];
    }]];
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    [_manager cancelSampleBufferDelegate];
//    [_managerd dealloc];
    _manager=nil;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"ImportError" object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ImportError:) name:@"ImportError" object:nil];
}

- (void)dealloc {
    NSLog(@"WCQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ImportError:) name:@"ImportError" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddConnectState:)name:@"AddConnectState" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.orderStr =@"";
    self.addr = @"";
        /// 为了 UI 效果
        [self.view addSubview:self.scanningView];
        [self.view addSubview:self.promptLabel];
        [self.view addSubview:self.bottomView];
        
        [self setupNavigationBar];
//        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        [self QRCodeScanVC];
        if(self->QRBool==YES)
        {
            [self setupQRCodeScanning];
        }else
        {
            NSLog(@"ACE,ACE");
        }
//    });
    
    [super viewWillAppear:animated];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    //第一次打开或者每次蓝牙状态改变都会调用这个函数
    if(central.state==CBCentralManagerStatePoweredOn)
    {
        NSLog(@"蓝牙设备开着");
        
    } else
    {
        NSLog(@"蓝牙设备关着");
    }
    
    
    
}

/**
 扫描二维码 需要先检测相机
 
 */
- (void)QRCodeScanVC{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    QRBool = NO;
//    __weak __typeof(self) weakSelf = self;
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
//                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            [self.navigationController pushViewController:scanVC animated:YES];
//                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        self->QRBool = YES;
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
                        
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            [self setupQRCodeScanning];
                        });
                        
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        self->QRBool = NO;
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
//                [self.navigationController pushViewController:scanVC animated:YES];
                self->QRBool = YES;
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warm prompt" message:@"Please-> [Settings - Privacy - Camera - Cleanpro] Open access switch" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                self->QRBool = NO;
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                self->QRBool = NO;
                break;
            }
                
            default:
                self->QRBool = NO;
                break;
        }
        
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warm prompt" message:@"Your camera has not been detected" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
    self->QRBool = NO;
}

- (void)setupNavigationBar {
//    self.navigationItem.title = @"扫一扫";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
//        _scanningView.backgroundColor = [UIColor blueColor];
    }
    return _scanningView;
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;

    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    if ([result hasPrefix:@"http"]) {
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
        jumpVC.jump_URL = result;
        [self.navigationController pushViewController:jumpVC animated:YES];
        
    } else {
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
        jumpVC.jump_bar_code = result;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    NSLog(@"暂未识别出二维码");
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    [HudViewFZ labelExample:self.view];
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
//        [scanManager videoPreviewLayerRemoveFromSuperlayer];
//
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
//        NSLog(@"metadataObjects - - %@ ，，， obj String=%@", obj,[obj stringValue]);
        
        NSString * orderStr1=[jiamiStr AesDecrypt:[obj stringValue]];////屏蔽以前的j解密方式
        NSLog(@"orderStr1 === %@", orderStr1);
        NSArray *array = [orderStr1 componentsSeparatedByString:@"#"];
        if(array.count==3)
        {
        self.orderStr =orderStr1;
        /*
        if([Manager.inst isConnected])
        {
            NSLog(@"已连接偶忆蓝牙");
            NSArray *array = [self.orderStr componentsSeparatedByString:@"#"];
            [self get_zuwangmessage:array[0]];
        }else
        {
            [self zuwang:orderStr1];
        }
         */
            NSArray *array = [self.orderStr componentsSeparatedByString:@"#"];
//            [self get_zuwangmessage:array[0]];
            [self getBLEMac:array[0] NumberStr:array[1]];
        }else if(array.count==2)
        {
//            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            HxShopCartViewController *vc=[main instantiateViewControllerWithIdentifier:@"HxShopCartViewController"];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            NSLog(@"暂未识别出扫描的二维码1");
            [HudViewFZ HiddenHud];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The scanned qr code has not been identified yet", @"Language") andDelay:2.5];
            [scanManager startRunning];
            [self setupQRCodeScanning];
        }
        
        
//        NSString * orderStr =[obj stringValue];
//        NSArray *arrys= [orderStr DiscountPricecomponentsSeparatedByString:@"."];
        
    } else {
        NSLog(@"暂未识别出扫描的二维码2");
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The scanned qr code has not been identified yet", @"Language") andDelay:2.5];
        [scanManager startRunning];
        [self setupQRCodeScanning];
    }
}

-(void)zuwang:(NSString*)contentStr
{
//    [Manager.inst checkConnect];
//    [Manager.inst addLsnr:self];
    if(![self.orderStr isEqualToString:@""])
    {
        NSArray *array = [self.orderStr componentsSeparatedByString:@"#"];
//        [self get_zuwangmessage:array[0]];
        [self getBLEMac:array[0] NumberStr:array[1]];
    }
}

#pragma mark - ManagerLsnr method
- (void)onConnect:(bool)isBleConn :(bool)isWiFiConn {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        _bleIndicatorBtn.selected = isBleConn;
        if(isBleConn==YES)
        {
            NSLog(@"链接成功偶忆蓝牙WCQ");
            
            
        }else{
//            NSLog(@"未连接");
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Bluetooth connection failed", @"Language") andDelay:2.0];
        }
        
    });
}

//-(void)iseqOrder:(NSString*)orderStr DeviceStr:(Device *)DeviceStr
//{
//    if(orderStr!=nil && ![orderStr isEqualToString:@""])
//    {
//        [HudViewFZ HiddenHud];
//        NSArray *array = [orderStr componentsSeparatedByString:@"#"];
//        NSLog(@"解密2 ===  %@",array);
//        if([array[2] isEqualToString:@"LAUNDRY"])
//            //        if(_tag_int==1)
//        {
//            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            LaundryViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryViewController"];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.arrayList=array;
//            vc.DeviceStr=DeviceStr;
//            [self.navigationController pushViewController:vc animated:YES];
//            //        }else if (_tag_int==2)
//        }else if([array[2] isEqualToString:@"DRYER"])
//        {
//            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            DryerViewController *vc=[main instantiateViewControllerWithIdentifier:@"DryerViewController"];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.arrayList=array;
//            vc.DeviceStr=DeviceStr;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }else {
//        NSLog(@"暂未识别出扫描的二维码");
//        NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//        [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
//        [HudViewFZ HiddenHud];
//        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The scanned qr code has not been identified yet", @"Language") andDelay:2.0];
//    }
//}

-(void)iseqOrder:(NSString*)orderStr DeviceStr:(NSString *)DeviceStr
{
    if(orderStr!=nil && ![orderStr isEqualToString:@""])
    {
        [HudViewFZ HiddenHud];
        NSArray *array = [orderStr componentsSeparatedByString:@"#"];
//        NSLog(@"解密2 ===  %@",array);
        if([array[2] isEqualToString:@"LAUNDRY"])
            //        if(_tag_int==1)
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LaundryViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.arrayList=array;
            vc.addrStr = self.addr;
            [self.navigationController pushViewController:vc animated:YES];
            //        }else if (_tag_int==2)
        }else if([array[2] isEqualToString:@"DRYER"])
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DryerViewController *vc=[main instantiateViewControllerWithIdentifier:@"DryerViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.arrayList=array;
            vc.addrStr = self.addr;
            vc.OrderAndRenewal=1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        NSLog(@"暂未识别出扫描的二维码");
        NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The scanned qr code has not been identified yet", @"Language") andDelay:2.0];
    }
}


-(void)getBLEMac:(NSString *)siteNo NumberStr:(NSString*)NumStr
{
    NSLog(@"URL = %@",[NSString stringWithFormat:@"%@%@%@#%@",FuWuQiUrl,get_BLEmacAddress,siteNo,NumStr]);
    NSString *escapedPathURL = [[NSString stringWithFormat:@"%@%@%@#%@",FuWuQiUrl,get_BLEmacAddress,siteNo,NumStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"URL2 = %@",escapedPathURL);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:escapedPathURL parameters:nil progress:^(id progress) {
            
        } success:^(id responseObject) {
//            addr = 0016;
//            mac = "F5:13:44:A9:73:F6";
//            machineNo = 03;
//            siteNo = P2018080603;
            NSLog(@"responseObject ORder=  %@",responseObject);
            NSDictionary * dictList=(NSDictionary *)responseObject;
                NSString * statusCode =[dictList objectForKey:@"statusCode"];
            if([statusCode integerValue] == 403)
            {
               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
               [userDefaults setObject:@"1" forKey:@"Token"];
               [userDefaults setObject:@"1" forKey:@"phoneNumber"];
               [userDefaults setObject:nil forKey:@"SaveUserMode"];
               [userDefaults setObject:@"1" forKey:@"logCamera"];
               NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
               //通过通知中心发送通知
               [[NSNotificationCenter defaultCenter] postNotification:notification];
            }else{
                NSString * addr = [dictList objectForKey:@"addr"];;
                NSString * mac = [dictList objectForKey:@"mac"];
                NSString * machineNo = [dictList objectForKey:@"machineNo"];
//                NSString * siteNo = [dictList objectForKey:@"siteNo"];
                NSString * macByte=[mac stringByReplacingOccurrencesOfString:@":" withString:@""];
                if(macByte)
                {
                    self.addr = addr;
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.ManagerBLE scanPeripherals];
                    [appDelegate.ManagerBLE setAddressName:macByte];
//                    [appDelegate.ManagerBLE setMacName:machineNo];
                    [self AddConnected];
                }
            }
           
        } failure:^(NSInteger statusCode, NSError *error) {
            [HudViewFZ HiddenHud];
            NSLog(@"error ORder=  %@",error);
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Bluetooth connection failed", @"Language") andDelay:2.0];
        }];
}




-(void)get_zuwangmessage:(NSString *)siteNo
{
    
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_ZuwangMessage,siteNo] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
        NSDictionary * dictList=(NSDictionary *)responseObject;
            NSString * statusCode =[dictList objectForKey:@"statusCode"];
        if([statusCode integerValue] == 403)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:@"Token"];
            [userDefaults setObject:@"1" forKey:@"phoneNumber"];
            [userDefaults setObject:nil forKey:@"SaveUserMode"];
            [userDefaults setObject:@"1" forKey:@"logCamera"];
            NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
        NSString * content =[dictList objectForKey:@"content"];
        NSData * dataNew = [content dataUsingEncoding:NSUTF8StringEncoding];

                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.appdelegate1 setImportMeshNetWorkWithDataJson:dataNew];
        
       
        }
        /*
        BOOL bp = [Manager.inst restoreNetworkConfig:content :true];
        //            NSLog(@"bp = %d",bp);
        if(bp==YES)
        {
            
            [HudViewFZ HiddenHud];
            NSLog(@"组网成功");
            
            NSArray * devArr = [Manager.inst getDevices];
            if(devArr.count>0)
            {
                NSLog(@"inf0 = %@",devArr);
            for (int i =0; i<devArr.count; i++) {
                Device * dev = devArr[i];
                NSArray *array = [self.orderStr componentsSeparatedByString:@"#"];
//                [self get_zuwangmessage:array[0]];
                NSLog(@"信息= %@,%@",dev.name,array[1]);
                if([dev.name isEqualToString:array[1]])
                {
//                    deveiceStr = dev.name;
                    [self iseqOrder:self.orderStr DeviceStr:dev];
                }
            }
            }else
            {
                [HudViewFZ HiddenHud];
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The machine has not been found", @"Language") andDelay:3.0];
                [self.manager startRunning];
                [self setupQRCodeScanning];
            }
            
            
            
        }else
        {
            [HudViewFZ HiddenHud];
            //                NSLog(@"组网未成功");
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Bluetooth connection failed", @"Language") andDelay:2.0];
        }
*/
    } failure:^(NSInteger statusCode, NSError *error) {
        [HudViewFZ HiddenHud];
        NSLog(@"error ORder=  %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Bluetooth connection failed", @"Language") andDelay:2.0];
    }];
}
-(void)AddConnectState:(NSNotification *)noti
{
    NSDictionary *dic = [noti userInfo];
        NSString * Strdata = [dic objectForKey:@"data"];
        if([Strdata isEqualToString:@"112"])
        {
    //        NSLog(@"111111122222");
            [HudViewFZ HiddenHud];
            [self AddConnected];
        }
}
-(void)ImportError:(NSNotification *)noti
{
    NSDictionary *dic = [noti userInfo];
    NSString * Strdata = [dic objectForKey:@"data"];
    if([Strdata isEqualToString:@"112"])
    {
//        NSLog(@"111111122222");
        [HudViewFZ HiddenHud];
        [self AddConnected];
    }else if([Strdata isEqualToString:@"110"])
    {
//        NSLog(@"333333444444");
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Data parsing error", @"Language") andDelay:2.5];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.3/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{

                [self.manager startRunning];
                 });
    }
    
}
-(void)AddConnected
{
    
    [self iseqOrder:self.orderStr DeviceStr:nil];
    
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
//    
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate.appdelegate1 AddConnected];
//        
//   
//        
//         });
}

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    if (brightnessValue < - 1) {
        [self.view addSubview:self.flashlightBtn];
    } else {
        if (self.isSelectedFlashlightBtn == NO) {
            [self removeFlashlightBtn];
        }
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
//        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
        _promptLabel.text = @"Scan the QR code on the machine";
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
//         _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.view.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        _flashlightBtn.backgroundColor=[UIColor blueColor];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (SCREEN_WIDTH - flashlightBtnW);
        CGFloat flashlightBtnY = _promptLabel.bottom+15;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [SGQRCodeHelperTool SG_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SGQRCodeHelperTool SG_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}



@end

