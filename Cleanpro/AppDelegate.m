//
//  AppDelegate.m
//  Cleanpro
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "KNMovieViewController.h"
#import "NAvigationViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AVFoundation/AVFoundation.h>

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import <AVKit/AVKit.h>
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#define UMAppKey @"5df88e760cafb25f3400037a"

#define sendNotification(key)  [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];//发送通知
//#define sendMessage(key)  [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];//发送通知

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o; //引用self

@import Firebase;
//@import FIRMessaging;
@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong, nullable) UIVisualEffectView *visualEffectView;
@property (strong,nonatomic)AFHTTPSessionManager *manager;
@property (nullable,strong)ChangeLanguage * Change;
@property (nonatomic,strong) dispatch_source_t timer;
@end
NSString *const kGCMMessageIDKey = @"gcm.message_id";
@implementation AppDelegate
@synthesize Change;
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    NSDictionary* remoteNotification=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSLog(@"remoteNotification= %@",remoteNotification);
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:41.0/255.0 green:209.0/255.0 blue:255.0/255.0 alpha:1]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
//    self.navigationController.navigationBar.barTintColor = tintColor;
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow(infoDicti donary);
    // app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app_Name=%@,app_Version=%@,app_build=%@",app_Name,app_Version,app_build);
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次启动
        
        [userDefaults setObject:@"1" forKey:@"Token"];
        [userDefaults setObject:@"1" forKey:@"phoneNumber"];
        [userDefaults setObject:@"1" forKey:@"logCamera"];
        [userDefaults setObject:@"100" forKey:@"TokenError"];
        [userDefaults setObject:nil forKey:@"SaveUserMode"];
        [jiamiStr base64Data_encrypt:@"1"];
        [userDefaults setObject:@"0" forKey:@"Message"];
        [userDefaults setObject:@"1" forKey:@"YHToken"];
        //存到本地UserDefaults 里面
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLoad"];
        [userDefaults setObject:nil forKey:@"SYbanner"];
        [self get_Language];
    }else
    {
        //不是第一次启动
    }
    ////// 谷歌推送
    [FIRApp configure];
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    if (@available(iOS 10.0, *)) {
        if ([UNUserNotificationCenter class] != nil) {
            // iOS 10 or later
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
            UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
                 // ...
             }];
        } else {
            // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
        }
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    [application registerForRemoteNotifications];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSLog(@"app  launchOptions =%@",launchOptions);
    if(launchOptions!=nil)
    {
        sendNotification(@"Messagenotification");//发送通知
    }
    if(userInfo!=nil)
    {
        sendNotification(@"Messagenotification");//发送通知
    }
//    NSLog(@"app  userInfo =%@",userInfo);
    

        
    // 启动图片延时: 1秒
   
////    //然后再跳转到播放视频的画面
   
    //自定义图标
    UIApplicationShortcutIcon * icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3D-touch_scan"];
    
    //创建带着有自定义图标项
    UIMutableApplicationShortcutItem * item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"Scan" localizedTitle:@"Sacn" localizedSubtitle:@"" icon:icon1 userInfo:nil];
//    [self get_Language];
    //创建带着有自定义图标项
//     UIApplicationShortcutItem *shortItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"Share" localizedTitle:[NSString stringWithFormat:@"Share“%@”",app_Name] localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypeShare] userInfo:nil];;
    [[UIApplication sharedApplication] setShortcutItems:@[item1]];
//    KNMovieViewController *KNVC = [[KNMovieViewController alloc]init];
//    // 1、获取媒体资源地址
//    NSString *path =  [[NSBundle mainBundle] pathForResource:@"LaundryHome.mp4" ofType:nil];
//    KNVC.movieURL = [NSURL fileURLWithPath:path];
//    NAvigationViewController *navCtrlr = [[NAvigationViewController alloc]initWithRootViewController:KNVC];
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NAvigationViewController *navCtrlr =[main instantiateViewControllerWithIdentifier:@"NAvigationViewController"];
//    [navCtrlr ]
//    self.window.rootViewController = KNVC;
//    self.window.rootViewController = KNVC;
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    self.appdelegate1 = [[MeshNetworkManagerAppdelegate alloc] instanceMeshApp];
    self.ManagerBLE = [HXBleManager sharedInstance];
//    [self.appdelegate1 setMesh];
//    self.appdelegate1.connection
    ////友盟崩溃统计
    [UMConfigure initWithAppkey:UMAppKey channel:@"App Store"];
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerDidConnect:) name:@"bearerDidConnect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerClose:) name:@"bearerClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerDeliverData:) name:@"bearerDeliverData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerDidOpen:) name:@"bearerDidOpen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerDidConnectHX:) name:@"bearerDidConnectHX" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerCloseHX:) name:@"bearerCloseHX" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerDidOpenHX:) name:@"bearerDidOpenHX" object:nil];
 
    return YES;
}

-(void)bearerDidConnect:(NSNotification *)noti {
//    NSDictionary *dic = [noti userInfo];
    NSLog(@"正在连接蓝牙");
//     [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"正在连接蓝牙", @"Language") andDelay:1.5];
}
-(void)bearerClose:(NSNotification *)noti {
//    NSDictionary *dic = [noti userInfo];
    NSLog(@"蓝牙关闭");
//    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"蓝牙关闭", @"Language") andDelay:1.5];
}
-(void)bearerDeliverData:(NSNotification *)noti {
    NSDictionary *dic = [noti userInfo];
    NSData * dataA = [dic objectForKey:@"data"];
    NSLog(@"接受到数据22");
    NSLog(@"接受 Data  ====%@",dataA);
}
-(void)bearerDidOpen:(NSNotification *)noti {
//    NSDictionary *dic = [noti userInfo];
    NSLog(@"蓝牙连接成功");
//    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"蓝牙连接成功", @"Language") andDelay:1.5];
}

-(void)bearerDidConnectHX:(NSNotification *)noti {
//    NSDictionary *dic = [noti userInfo];
    NSLog(@"正在连接蓝牙");
}
-(void)bearerCloseHX:(NSNotification *)noti {
//    NSDictionary *dic = [noti userInfo];
    NSLog(@"蓝牙关闭");
//    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"蓝牙已断开", @"Language") andDelay:1.5];
}

-(void)bearerDidOpenHX:(NSNotification *)noti {
//    NSDictionary *dic = [noti userInfo];
    NSLog(@"蓝牙连接成功");
//    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"蓝牙连接成功", @"Language") andDelay:1.5];
}


-(void)addFCViewSet
{
    self.FCViewLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.FCViewLabel.frame = CGRectMake(SCREEN_WIDTH-90, 90, 90, 30);
    self.FCViewLabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    self.FCViewLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.FCViewLabel setImage:[UIImage imageNamed:@"fasdfdaf"] forState:(UIControlStateNormal)];
    [self.FCViewLabel setTitleColor:[UIColor colorWithRed:56/255.0 green:107/255.0 blue:169/255.0 alpha:1] forState:(UIControlStateNormal)];
    [self.FCViewLabel.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.FCViewLabel setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:0.27]];
    [self.FCViewLabel setTitle:@"00:00" forState:(UIControlStateNormal)];
//    self.FCViewLabel.layer.cornerRadius= 15;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.FCViewLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.FCViewLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.FCViewLabel.layer.mask = maskLayer;
    [self.window addSubview:self.FCViewLabel ];
    [self JSTimer:900];
}
-(void)hiddenFCViewYES
{
    self.FCViewLabel.hidden=NO;
}
-(void)hiddenFCViewNO
{
    self.FCViewLabel.hidden=YES;
    [self stopTimer];
}
/**
 GCD停止计时

 */
- (void)stopTimer {
    if(_timer)
    {
        dispatch_source_cancel(_timer) ;
        _timer=nil;
    }
}

-(void)JSTimer:(NSInteger)secondsCountDown
{
    __weak __typeof(self) weakSelf = self;
       
       if (_timer == nil) {
           __block NSInteger timeout = secondsCountDown; // 倒计时时间
           
           if (timeout!=0) {
               dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
               _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
               dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
               dispatch_source_set_event_handler(_timer, ^{
                   if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                       dispatch_source_cancel(self->_timer);
                       self->_timer = nil;
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [weakSelf.FCViewLabel setTitle:@"00:00" forState:(UIControlStateNormal)];
                           [weakSelf.ManagerBLE closeConnected];
                       });
                   } else { // 倒计时重新计算 时/分/秒
//                       NSInteger days = (int)(timeout/(3600*24));
//                       NSInteger hours = (int)((timeout-days*24*3600)/3600);
                       NSInteger minute = (int)(timeout)/60;
                       NSInteger second = timeout - (minute*60);
//                       NSString *strTime = [NSString stringWithFormat:@"活动倒计时 %02ld : %02ld : %02ld", hours, minute, second];
                       dispatch_async(dispatch_get_main_queue(), ^{

                               [weakSelf.FCViewLabel setTitle:[NSString stringWithFormat:@"%02ld : %02ld",minute, second] forState:(UIControlStateNormal)];
                                
                           
                       });
                       timeout--; // 递减 倒计时-1(总时间以秒来计算)
                   }
               });
               dispatch_resume(_timer);
           }
       }
}

+(instancetype)shareAppDelegate{
    return [[self alloc]init];
}

-(void)get_Language
{
    Change = [ChangeLanguage sharedInstance];;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog(@"currentLanguage =%@",currentLanguage);
    /*
        if( [currentLanguage isEqualToString:@"zh-Hans-US"]|| [currentLanguage isEqualToString:@"zh-Hans-CN"] || [currentLanguage isEqualToString:@"zh-Hant-CN"] || [currentLanguage isEqualToString:@"zh-Hant-TW"] || [currentLanguage isEqualToString:@"zh-Hant-HK"] || [currentLanguage isEqualToString:@"zh-Hant-MO"])
        {
            NSLog(@"中");
            [Change setNewLanguage:CNS];
        }else
            */
            if([currentLanguage isEqualToString:@"ms-CN"])
        {
            NSLog(@"马来文");
            [Change setNewLanguage:malai];
        }else if([currentLanguage isEqualToString:@"th-CN"])
        {
            NSLog(@"泰文");
            [Change setNewLanguage:TaiWen];
        }else if([currentLanguage isEqualToString:@"en"])
        {
            NSLog(@"英");
            [Change setNewLanguage:EN];
        }else
        {
            NSLog(@"默认英文");
            [Change setNewLanguage:EN];
        }
    
//    [Change setNewLanguage:EN];
    
    
    
}



-(void)addGoogleTuisong:(UIApplication *)application
{
    
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    // 1.获得shortcutItem的type type就是初始化shortcutItem的时候传入的唯一标识符
    NSString *type = shortcutItem.type;
    
    //2.可以通过type来判断点击的是哪一个快捷按钮 并进行每个按钮相应的点击事件
    if ([type isEqualToString:@"Scan"]) {
        // do something
        NSLog(@"选择 scan");
        NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinScan" object: nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if ([type isEqualToString:@"Share"]){
        // do something
        NSLog(@"选择 Share");
    }
//    else if ([type isEqualToString:@"pic3"]){
//        // do something
//    }else if ([type isEqualToString:@"pic4"]){
//        // do something
//    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    // Add any custom logic here.
    return handled;

}



- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    //    NSString *fcmToken1 = [FIRMessaging messaging].FCMToken;
    //    NSLog(@"FCM registration token: %@", fcmToken1);
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    NSString * YonghuID = [jiamiStr base64Data_decrypt];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * tokenStr = [userDefaults objectForKey:@"YHToken"];
    if(!([YonghuID isEqualToString:@"1"] || YonghuID==nil))
    {
        if(!([tokenStr isEqualToString:fcmToken]))
        {
            NSLog(@"新token");
            
            [self Post_Message_Token:YonghuID token:fcmToken];
        }
    }
}

-(void)Post_Message_Token:(NSString*)YonghuID token:(NSString *)token
{
    
    //    NSLog(@"url == %@",[NSString stringWithFormat:@"%@%@CustomerID=%@&ID=%@",XJP_China(DIQU_Number),Delete_Message,YonghuID,MessageID]);
    NSDictionary * dict =
    @{@"id":YonghuID,
      @"pushToken":token
      };
    NSLog(@"上传 dict = %@",dict);
    
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manager.requestSerializer setTimeoutInterval:50];
    // 加上这行代码，https ssl 验证。
//    [_manager setSecurityPolicy:[jiamiStr customSecurityPolicy]];
    [_manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    self.manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    
    [self.manager POST:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,PostbindToken] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"token上传请求成功: %@",responseObject);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:@"YHToken"];
        //        NSNumber * dict1_number=[responseObject objectForKey:@"StatusCode"];
        //        if([dict1_number intValue]==0)
        //        {
        //
        //        }else if([dict1_number intValue]==2)
        //        {
        //
        //        }else
        //        {
        //
        //        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Request timed out!", @"Language") andDelay:1.5];
    }];
}

// With "FirebaseAppDelegateProxyEnabled": NO
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
    
    
    
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualEffectView.alpha = 0;
    self.visualEffectView.frame = self.window.frame;
    [self.window addSubview:self.visualEffectView];
    [UIView animateWithDuration:0.5 animations:^{
        self.visualEffectView.alpha = 1;
    }];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    HomeViewController.sensitivefield1.hidden = YES;
    //    HomeViewController.sensitivefield2.hidden = YES;
    //进入后台时要进行的处理
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:@"1" forKey:@"Message"];
    NSString * str = [userDefaults objectForKey:@"Message"];
    if(![str isEqualToString:@"1"])
    {
//        application.applicationIconBadgeNumber = 0;
        //使用这个方法清除角标，如果置为0的话会把之前收到的通知内容都清空；置为-1的话，不但能保留以前的通知内容，还有角标消失动画，iOS10之前这样设置是没有作用的 ，iOS10之后才有效果 。
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }
    sendNotification(kRegisterBackgroundNoti)
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //进入前台时要进行的处理
    //    app.applicationIconBadgeNumber = badge;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:@"1" forKey:@"Message"];
    NSString * str = [userDefaults objectForKey:@"Message"];
    if(![str isEqualToString:@"1"])
    {
        application.applicationIconBadgeNumber = 0;
    }
    sendNotification(kRegisterFrontNoti)
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [UIView animateWithDuration:0.5 animations:^{
        self.visualEffectView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.visualEffectView removeFromSuperview];
    }];
    
    //    [self addGoogleTuisong:application];
    //    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    //    NSLog(@"bage ====   %ld",badge);
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer  API_AVAILABLE(ios(10.0)){
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            if (@available(iOS 10.0, *)) {
                _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"StorHub"];
            } else {
                // Fallback on earlier versions
            }
            if (@available(iOS 10.0, *)) {
                [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                    if (error != nil) {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        
                        /*
                         Typical reasons for an error here include:
                         * The parent directory does not exist, cannot be created, or disallows writing.
                         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                         * The device is out of space.
                         * The store could not be migrated to the current model version.
                         Check the error message to determine what the actual problem was.
                         */
                        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                        abort();
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


#pragma mark ---- Google 推送  ----

// 如果在应用内展示通知 （如果不想在应用内展示，可以不实现这个方法）
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)){
//
//    // 展示
//    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
//
//    //    // 不展示
//    //    completionHandler(UNNotificationPresentationOptionNone);
//}

#pragma mark - UNUserNotificationCenterDelegate

/*
 此方法是新的用于响应远程推送通知的方法
 1.如果应用程序在后台，则通知到，点击查看，该方法自动执行
 2.如果应用程序在前台，则通知到，该方法自动执行
 3.如果应用程序被关闭，则通知到，点击查看，先执行didFinish方法，再执行该方法
 4.可以开启后台刷新数据的功能
 step1：点击target-->Capabilities-->Background Modes-->Remote Notification勾上
 step2：在给APNs服务器发送的要推送的信息中，添加一组字符串如：
 {"aps":{"content-available":"999","alert":"bbbbb.","badge":1}}
 其中content-availabel就是为了配合后台刷新而添加的内容，999可以随意定义
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    NSLog(@"userInfo =  %@", userInfo);
    NSDictionary * aps = [userInfo objectForKey:@"aps"];
    NSDictionary * alert = [aps objectForKey:@"alert"];
    NSString * body = [alert objectForKey:@"body"];
    NSString * title = [alert objectForKey:@"title"];
    NSLog(@"标题：%@ ， 内容：%@",title,body);
    //
    if (application.applicationState == UIApplicationStateActive) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        //        [AGPushNoteView showWithNotificationMessage:title completion:^{
        //
        //        }];
        application.applicationIconBadgeNumber = 1;
        sendNotification(@"chanegeMessage_upadte");
        sendMessage(kRegisterMessage)
    }
    //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
    else if (application.applicationState == UIApplicationStateInactive){
        //......
        //        application.applicationIconBadgeNumber = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        //        sendNotification(@"chanegeMessage_upadte");
        sendNotification(@"Messagenotification");//发送通知
        sendMessage(kRegisterMessage)
    }else if (application.applicationState == UIApplicationStateBackground){
        //......
        application.applicationIconBadgeNumber = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        sendNotification(@"chanegeMessage_upadte");
        sendMessage(kRegisterMessage)
        //        sendNotification(@"Messagenotification");//发送通知
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Print full message.
    NSLog(@"userInfo3 ====  %@", userInfo);
    //    app.applicationIconBadgeNumber = 0;
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:@"1" forKey:@"Message"];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        sendNotification(@"chanegeMessage_upadte");
        sendMessage(kRegisterMessage)
    }
    //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        //......
        //        application.applicationIconBadgeNumber = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        //            sendNotification(@"chanegeMessage_upadte");
        sendNotification(@"Messagenotification");//发送通知
        sendMessage(kRegisterMessage)
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        //......
        //        application.applicationIconBadgeNumber = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        //            sendNotification(@"chanegeMessage_upadte");
        sendNotification(@"Messagenotification");//发送通知
        sendMessage(kRegisterMessage)
    }else
    {
        sendNotification(@"Messagenotification");//发送通知
        sendMessage(kRegisterMessage)
    }
    
    completionHandler();
}






@end
