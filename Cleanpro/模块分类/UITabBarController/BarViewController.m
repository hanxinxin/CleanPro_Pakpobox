//
//  BarViewController.m
//  StorHub
//
//  Created by Pakpobox on 2018/2/23.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import "BarViewController.h"
#import "OrdersViewController.h"
#import "MyAccountViewController.h"
#import "NewHomeViewController.h"
#import "locationMapViewController.h"
#import "IMessageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WCQRCodeScanningVC.h"
#import "LoginViewController.h"
#import "versionView.h"
#import "EwashMyViewController.h"

@interface BarViewController ()<MCTabBarControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerPreviewingDelegate,versionViewDelegate>


@end

@implementation BarViewController
@synthesize navHome,location,WC,navMy,Massage;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化两个视图控制器
    //    HomeViewController *HomeVc = [[HomeViewController alloc]init];
    ///修改4.21日 屏蔽mcTabbar
    /*
    //选中时的颜色
    self.mcTabbar.tintColor = [UIColor colorWithRed:251.0/255.0 green:199.0/255.0 blue:115/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    self.mcTabbar.translucent = NO;
    ///3.30修改屏蔽凸起的bar
    
    self.mcTabbar.position = MCTabBarCenterButtonPositionBulge;
    self.mcTabbar.centerWidth=70.f;
    self.mcTabbar.centerHeight=70.f;
    self.mcTabbar.centerImage = [UIImage imageNamed:@"scan"];
    self.mcDelegate = self;
     */
    // 改变分割线的颜色 禁止透明
//    self.tabBar.layer.borderWidth = 0.20;
//    self.tabBar.layer.borderColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1].CGColor;
//    //去掉tabBar顶部线条
//    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
////    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1].CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.tabBar setBackgroundImage:img];
//    [self.tabBar setShadowImage:img];
    
//    self.tabBar.barStyle = UIBarStyleBlackOpaque;
    
//    /// 20年3.30日修改TabBar 展示屏蔽以前的洗衣的，只展示预约洗衣的。
//    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
//
//        if([strPhoen isEqualToString:@"1"])
//        {
//            [self setTitleAndview_lll];
//        }else
//        {
//            [self setTitleAndview];
//        }
    
    [self tongzhi_UpdateTabbar]; ///监测是否快递员  4.17日屏蔽
//    [self setTitleAndview];
    
    
    
    //注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_SXUI)name:@"UIshuaxin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_SXUI1)name:@"UIshuaxin1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_SXUI2)name:@"UIshuaxinLog" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_SXUI3)name:@"UIshuaxinScan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_UpdateTabbar)name:@"tongzhi_UpdateTabbar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addVersionView:forcedFlag:)name:@"addVersionView" object:nil];
    
    [self get_version_URL];
}
-(void)setTitleAndview
{
    /// 20年3.30日修改TabBar 展示屏蔽以前的洗衣的，只展示预约洗衣的。
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HomeViewController *HomeVc=[main instantiateViewControllerWithIdentifier:@"HomeViewController"];
    NewHomeViewController*HomeVc=[main instantiateViewControllerWithIdentifier:@"NewHomeViewController"];
    locationMapViewController *locationVC=[main instantiateViewControllerWithIdentifier:@"locationMapViewController"];
//    WCQRCodeScanningVC *WCVC = [[WCQRCodeScanningVC alloc] init];
//    WCVC.hidesBottomBarWhenPushed = YES;
    IMessageViewController *OrderVc=[main instantiateViewControllerWithIdentifier:@"IMessageViewController"];
    OrderVc.MessageStyle=2;
//    MyAccountViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
    EwashMyViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"EwashMyViewController"];
    MyVc.QuAndUser=1;
    //为两个视图控制器添加导航栏控制器
    navHome = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    location = [[UINavigationController alloc]initWithRootViewController:locationVC];
//    WC = [[UINavigationController alloc]initWithRootViewController:WCVC];
    navMy = [[UINavigationController alloc]initWithRootViewController:MyVc];
    Massage = [[UINavigationController alloc]initWithRootViewController:OrderVc];
//    GYHub = [[UINavigationController alloc]initWithRootViewController:GYHub_cc];
    navHome.tabBarItem.image=[[UIImage imageNamed:@"lab_home_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_home_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    location.tabBarItem.image=[[UIImage imageNamed:@"lab_Nearby_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    location.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_Nearby_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Massage.tabBarItem.image=[[UIImage imageNamed:@"inbox_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Massage.tabBarItem.selectedImage = [[UIImage imageNamed:@"inbox_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMy.tabBarItem.image=[[UIImage imageNamed:@"lab_me_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMy.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_me_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置控制器文字
    navHome.title = FGGetStringWithKeyFromTable(@"Home", @"Language");
    location.title = FGGetStringWithKeyFromTable(@"Nearby", @"Language");
    Massage.title = FGGetStringWithKeyFromTable(@"Inbox", @"Language");
    navMy.title = FGGetStringWithKeyFromTable(@"Me", @"Language");
    //改变tabbarController 文字选中颜色(默认渲染为蓝色)
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1]} forState:UIControlStateSelected];
    //创建一个数组包含四个导航栏控制器
    NSArray *vcArry = [NSArray arrayWithObjects:navHome,location,Massage,navMy,nil];
    //将数组传给UITabBarController
    self.viewControllers = vcArry;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        sendMessage(@"ReturnMessage");//发送通知
    });
    self.navigationController.navigationBarHidden=YES;

    
//    /// 3.30日添加的   4.17日屏蔽
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
////    //    HomeViewController *HomeVc=[main instantiateViewControllerWithIdentifier:@"HomeViewController"];
//        NewHomeViewController*HomeVc=[main instantiateViewControllerWithIdentifier:@"NewHomeViewController"];
////        locationMapViewController *locationVC=[main instantiateViewControllerWithIdentifier:@"locationMapViewController"];
////        WCQRCodeScanningVC *WCVC = [[WCQRCodeScanningVC alloc] init];
////    //    WCVC.hidesBottomBarWhenPushed = YES;
//        IMessageViewController *OrderVc=[main instantiateViewControllerWithIdentifier:@"IMessageViewController"];
//        OrderVc.MessageStyle=2;
////        MyAccountViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
//    EwashMyViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"EwashMyViewController"];
////    MyVc.QuAndUser=2;
//        //为两个视图控制器添加导航栏控制器
//        navHome = [[UINavigationController alloc]initWithRootViewController:HomeVc];
////        location = [[UINavigationController alloc]initWithRootViewController:locationVC];
////        WC = [[UINavigationController alloc]initWithRootViewController:WCVC];
//        navMy = [[UINavigationController alloc]initWithRootViewController:MyVc];
//        Massage = [[UINavigationController alloc]initWithRootViewController:OrderVc];
//    //    GYHub = [[UINavigationController alloc]initWithRootViewController:GYHub_cc];
//        navHome.tabBarItem.image=[[UIImage imageNamed:@"lab_home_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_home_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////        location.tabBarItem.image=[[UIImage imageNamed:@"lab_Nearby_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////        location.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_Nearby_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        Massage.tabBarItem.image=[[UIImage imageNamed:@"inbox_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        Massage.tabBarItem.selectedImage = [[UIImage imageNamed:@"inbox_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        navMy.tabBarItem.image=[[UIImage imageNamed:@"lab_me_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        navMy.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_me_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        //设置控制器文字
//        navHome.title = FGGetStringWithKeyFromTable(@"Home", @"Language");
////        location.title = FGGetStringWithKeyFromTable(@"Nearby", @"Language");
//        Massage.title = FGGetStringWithKeyFromTable(@"Inbox", @"Language");
//        navMy.title = FGGetStringWithKeyFromTable(@"Me", @"Language");
//        //改变tabbarController 文字选中颜色(默认渲染为蓝色)
//        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
//        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1]} forState:UIControlStateSelected];
//        //创建一个数组包含四个导航栏控制器
////        NSArray *vcArry = [NSArray arrayWithObjects:navHome,location,WC,Massage,navMy,nil];
//    NSArray *vcArry = [NSArray arrayWithObjects:navHome,Massage,navMy,nil];
//        //将数组传给UITabBarController
//        self.viewControllers = vcArry;
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            sendMessage(@"ReturnMessage");//发送通知
//        });
//        self.navigationController.navigationBarHidden=YES;
//
}
-(void)setTitleAndview_lll
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    HomeViewController *HomeVc=[main instantiateViewControllerWithIdentifier:@"HomeViewController"];
    NewHomeViewController*HomeVc=[main instantiateViewControllerWithIdentifier:@"NewHomeViewController"];
    
    //    NAvigationViewController *NAV=[main instantiateViewControllerWithIdentifier:@"NAvigationViewController"];
    //        MyViewController *MyVc = [[MyViewController alloc]init];
    locationMapViewController *locationVC=[main instantiateViewControllerWithIdentifier:@"locationMapViewController"];
//    WCQRCodeScanningVC *WCVC = [[WCQRCodeScanningVC alloc] init];
//    LoginViewController*login=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
    //    WCVC.hidesBottomBarWhenPushed = YES;
    LoginViewController *OrderVc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
    MyAccountViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
    //    //    MyViewController *StorHubVc = [[MyViewController alloc]init];
    //    aboutViewController *GYHub_cc=[main instantiateViewControllerWithIdentifier:@"aboutViewController"];
    
    //为两个视图控制器添加导航栏控制器
    navHome = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    location = [[UINavigationController alloc]initWithRootViewController:locationVC];
//    WC = [[UINavigationController alloc]initWithRootViewController:login];
    navMy = [[UINavigationController alloc]initWithRootViewController:MyVc];
    Massage = [[UINavigationController alloc]initWithRootViewController:OrderVc];
    //    GYHub = [[UINavigationController alloc]initWithRootViewController:GYHub_cc];
    navHome.tabBarItem.image=[[UIImage imageNamed:@"lab_home_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_home_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    location.tabBarItem.image=[[UIImage imageNamed:@"lab_Nearby_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    location.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_Nearby_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Massage.tabBarItem.image=[[UIImage imageNamed:@"inbox_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Massage.tabBarItem.selectedImage = [[UIImage imageNamed:@"inbox_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMy.tabBarItem.image=[[UIImage imageNamed:@"lab_me_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMy.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_me_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置控制器文字
    navHome.title = FGGetStringWithKeyFromTable(@"Home", @"Language");
    location.title = FGGetStringWithKeyFromTable(@"Nearby", @"Language");
    Massage.title = FGGetStringWithKeyFromTable(@"Inbox", @"Language");
    navMy.title = FGGetStringWithKeyFromTable(@"Me", @"Language");
    
    //改变tabbarController 文字选中颜色(默认渲染为蓝色)
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]} forState:UIControlStateSelected];
    // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
//    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName];
//    [self.navigationController.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    
    //创建一个数组包含四个导航栏控制器
    NSArray *vcArry = [NSArray arrayWithObjects:navHome,location,Massage,navMy,nil];
    
    //将数组传给UITabBarController
    self.viewControllers = vcArry;
    
    self.navigationController.navigationBarHidden=YES;
}


-(void)setTabbarCout
{
        /// 3.30日添加的
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    //    HomeViewController *HomeVc=[main instantiateViewControllerWithIdentifier:@"HomeViewController"];
//            NewHomeViewController*HomeVc=[main instantiateViewControllerWithIdentifier:@"NewHomeViewController"];
    //        locationMapViewController *locationVC=[main instantiateViewControllerWithIdentifier:@"locationMapViewController"];
    //        WCQRCodeScanningVC *WCVC = [[WCQRCodeScanningVC alloc] init];
    //    //    WCVC.hidesBottomBarWhenPushed = YES;
            IMessageViewController *OrderVc=[main instantiateViewControllerWithIdentifier:@"IMessageViewController"];
            OrderVc.MessageStyle=2;
    //        MyAccountViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
        EwashMyViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"EwashMyViewController"];
    //    MyVc.QuAndUser=2;
            //为两个视图控制器添加导航栏控制器
//            navHome = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    //        location = [[UINavigationController alloc]initWithRootViewController:locationVC];
    //        WC = [[UINavigationController alloc]initWithRootViewController:WCVC];
            navMy = [[UINavigationController alloc]initWithRootViewController:MyVc];
            Massage = [[UINavigationController alloc]initWithRootViewController:OrderVc];
        //    GYHub = [[UINavigationController alloc]initWithRootViewController:GYHub_cc];
//            navHome.tabBarItem.image=[[UIImage imageNamed:@"lab_home_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_home_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //        location.tabBarItem.image=[[UIImage imageNamed:@"lab_Nearby_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //        location.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_Nearby_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            Massage.tabBarItem.image=[[UIImage imageNamed:@"inbox_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            Massage.tabBarItem.selectedImage = [[UIImage imageNamed:@"inbox_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navMy.tabBarItem.image=[[UIImage imageNamed:@"lab_me_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navMy.tabBarItem.selectedImage = [[UIImage imageNamed:@"lab_me_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            //设置控制器文字
//            navHome.title = FGGetStringWithKeyFromTable(@"Home", @"Language");
    //        location.title = FGGetStringWithKeyFromTable(@"Nearby", @"Language");
            Massage.title = FGGetStringWithKeyFromTable(@"Inbox", @"Language");
            navMy.title = FGGetStringWithKeyFromTable(@"Me", @"Language");
            //改变tabbarController 文字选中颜色(默认渲染为蓝色)
            [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
            [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1]} forState:UIControlStateSelected];
            //创建一个数组包含四个导航栏控制器
    //        NSArray *vcArry = [NSArray arrayWithObjects:navHome,location,WC,Massage,navMy,nil];
        NSArray *vcArry = [NSArray arrayWithObjects:Massage,navMy,nil];
            //将数组传给UITabBarController
            self.viewControllers = vcArry;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                sendMessage(@"ReturnMessage");//发送通知
            });
            self.navigationController.navigationBarHidden=YES;

            [self setSelectedIndex:1];
            
    
}




- (void)viewWillAppear:(BOOL)animated {
    
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//        [backBtn setTintColor:[UIColor blackColor]];
        backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
        self.navigationItem.backBarButtonItem = backBtn;
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString * strCamera=[[NSUserDefaults standardUserDefaults] objectForKey:@"logCamera"];
    
    if([strPhoen isEqualToString:@"1"])
    {
        
    }else if([strPhoen isEqualToString:@"2"])
    {

        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"phoneNumber"];
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [self setSelectedIndex:0];

        
    }
    if([strCamera isEqualToString:@"2"])
    {
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"logCamera"];
//        [self setSelectedIndex:3];
    }
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    self.navigationItem.backBarButtonItem = backBtn;
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tongzhi_SXUI1
{
////   [self setTitleAndview];
//    [self setSelectedIndex:0];
//    self.tabBar.hidden=NO;
}

-(void)tongzhi_SXUI2
{
    NSString * userIdString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if([userIdString isEqualToString:@"1"])
        {
            [self setTitleAndview];
            [self setSelectedIndex:0];
        }else
        {
            [self setTabbarCout];
        }
}

-(void)tongzhi_SXUI3
{
//    //   [self setTitleAndview];
//    [self setSelectedIndex:2];
//    self.tabBar.hidden=NO;
}

-(void)tongzhi_SXUI
{
    [self setTitleAndview];
}

-(void)tongzhi_UpdateTabbar
{
    NSString * userIdString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
//userIdStr
//    if([userIdStr isEqualToString:@"1"])
//    {
    if([userIdString isEqualToString:@"1"])
    {
        [self setTitleAndview];
        
    }else
    {
        
        [self setTabbarCout];
    }
}

-(void)Message_tongzhi
{
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 使用MCTabBarController 自定义的 选中代理
- (void)mcTabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 2){
//        [self rotationAnimation];
        
//        NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
//        if([strPhoen isEqualToString:@"1"])
//        {
//            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else
//        {
//            WCQRCodeScanningVC *WCVC = [[WCQRCodeScanningVC alloc] init];
//            WCVC.hidesBottomBarWhenPushed = YES;
//            WCVC.tag_int=1;
//            [self QRCodeScanVC:viewController];
//        }
    }else if(tabBarController.selectedIndex == 3)
    {
        NSLog(@"点击了  massage ,取消消息显示");
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
        
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                sendMessage(kRegisterMessageList);//发送通知
            });
        
    }else {
        [self.mcTabbar.centerBtn.layer removeAllAnimations];
    }
}

//旋转动画
- (void)rotationAnimation{
    if ([@"key" isEqualToString:[self.mcTabbar.centerBtn.layer animationKeys].firstObject]){
        return;
    }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 3.0;
    rotationAnimation.repeatCount = HUGE;
    [self.mcTabbar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
}

//////// 添加view提示
-(void)addVersionView:(NSString *)contentStr forcedFlag:(NSString*)forcedFlagStr
{
    versionView *versionView1 = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([versionView class]) owner:nil options:nil] lastObject];
    versionView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [versionView1 setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.6]];
    versionView1.centerView .layer.cornerRadius = 4;
    versionView1.titleLabel.text = FGGetStringWithKeyFromTable(@"Version Update", @"Language");
    versionView1.Label_Center.text = contentStr;
    versionView1.Cancel_btn.hidden=YES;
    versionView1.Update_btn.hidden=YES;
    versionView1.forcedFlagStr=forcedFlagStr;
    if([forcedFlagStr intValue]==0)
    {
        versionView1.Cancel_btn.hidden=NO;
        versionView1.Update_btn.hidden=NO;
        [versionView1.Cancel_btn setTitle:FGGetStringWithKeyFromTable(@"Later", @"Language") forState:(UIControlStateNormal)];
        versionView1.Cancel_btn .layer.borderColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0].CGColor;
        versionView1.Cancel_btn .layer.borderWidth = 1;
        versionView1.Cancel_btn .layer.cornerRadius = 4;
        [versionView1.Update_btn setTitle:FGGetStringWithKeyFromTable(@"Update", @"Language") forState:(UIControlStateNormal)];
        versionView1.Update_btn .layer.cornerRadius = 4;
    }else
    {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            versionView1.Cancel_btn.hidden=YES;
            versionView1.Update_btn.hidden=NO;
           versionView1.Update_btn.frame = CGRectMake((versionView1.centerView.width-80)/2, versionView1.centerView.height-54, 80, 34);
        });
        
        [versionView1.Update_btn setTitle:FGGetStringWithKeyFromTable(@"Update", @"Language") forState:(UIControlStateNormal)];
        versionView1.Update_btn .layer.cornerRadius = 4;
    }
    versionView1.delegate=self;
    [self.view addSubview:versionView1];
 
}
-(void)Buttontouch:(NSInteger)key_Int View:(UIView *)view forcedFlag:(nonnull NSString *)forcedFlagStr
{
    if([forcedFlagStr integerValue]==0)
    {
        [view removeFromSuperview];
    }
    if(key_Int==0) ////取消按钮
    {
        
    }else if (key_Int==1) ////更新按钮
    {
//
        NSString *strurl = @"https://apps.apple.com/us/app/cleanpro/id1464618101?l=zh&ls=1"; //更换id即可
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strurl] options:nil completionHandler:^(BOOL success) {
            NSLog(@"跳转成功");
        }];
    }
}

//-(void)get_version_URL
//{
////    NSLog(@"Version==== %@",[NSString stringWithFormat:@"%@%@?clientType=IOS",FuWuQiUrl,get_version]);
//    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?clientType=IOS",FuWuQiUrl,get_version] parameters:nil progress:^(id progress) {
//        //        NSLog(@"请求成功 = %@",progress);
//    } success:^(id responseObject) {
//        NSLog(@"Version_responseObject = %@",responseObject);
//        [HudViewFZ HiddenHud];
//        NSDictionary * dictObject=(NSDictionary *)responseObject;
//        NSString * versionStr =[dictObject objectForKey:@"version"];
//        NSString * contentStr =[dictObject objectForKey:@"content"];
//        NSString * forcedFlagStr =[dictObject objectForKey:@"forcedFlag"];
//        NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        // app名称
////        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//        // app版本
////        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        // app build版本
//        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
//        NSArray *versionArray = [versionStr componentsSeparatedByString:@"."];//服务器返回版
//
//        NSArray *currentVesionArray = [app_build componentsSeparatedByString:@"."];//当前版本
//        NSInteger a = (versionArray.count> currentVesionArray.count)?currentVesionArray.count : versionArray.count;
//        for (int i = 0; i< a; i++) {
//
//            NSInteger a1 = [versionArray[i] integerValue];
//            NSInteger b = [currentVesionArray[i] integerValue];
//            if (a1 > b) {
//                NSLog(@"有新版本");
//                [self addVersionView:contentStr forcedFlag:forcedFlagStr];
//            }else if(a1 == b){
//               NSLog(@"没有新版本1");
//
//            }else if(a1 < b){
//                if(i==0 || i==1)
//                {
//                    NSLog(@"直接跳出");
//                    break;
//                }
//               NSLog(@"没有新版本2");
//
//            }
//
//        }
//
//    } failure:^(NSInteger statusCode, NSError *error) {
//        NSLog(@"error = %@",error);
//        [HudViewFZ HiddenHud];
//
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
//    }];
//}


-(void)get_version_URL
{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = infoDict[@"CFBundleShortVersionString"];
    //    NSString *bundleId   = infoDict[@"CFBundleIdentifier"];
        NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", @"1499447258"];
        //两种请求appStore最新版本app信息 通过bundleId与appleId判断
        //[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?bundleid=%@", bundleId]
        //[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", appleid]
        NSURL *urlStr = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlStr];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (connectionError) {
                return ;
            }
            NSError *error;
            NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//            NSLog(@"返回%@",resultsDict);
            if (error) {
                return;
            }
            NSArray *sourceArray = resultsDict[@"results"];
            if (sourceArray.count >= 1) {
                //AppStore内最新App的版本号
                NSDictionary *sourceDict = sourceArray[0];
                NSString *newVersion = sourceDict[@"version"];
                NSLog(@"newVersion===  %@",newVersion);
                if([self judgeNewVersion:newVersion withOldVersion:appVersion])
                {
                    //    NSLog(@"Version==== %@",[NSString stringWithFormat:@"%@%@?clientType=IOS",FuWuQiUrl,get_version]);
                        [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_GetloadAppVersion] parameters:nil progress:^(id progress) {
                            //        NSLog(@"请求成功 = %@",progress);
                        } success:^(id responseObject) {
                            NSLog(@"Version_responseObject = %@",responseObject);
                            [HudViewFZ HiddenHud];
                            
                            NSDictionary * dictObject=(NSDictionary *)responseObject;
                            if(dictObject!=nil)
                            {
                            NSString * versionStr =[dictObject objectForKey:@"version"];
                            NSString * contentStr =[dictObject objectForKey:@"content"];
                            NSString * forcedFlagStr =[dictObject objectForKey:@"forcedFlag"];
                            NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
                            // app名称
                    //        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                            // app版本
                    //        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                            // app build版本
                            NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
                            NSArray *versionArray = [versionStr componentsSeparatedByString:@"."];//服务器返回版
                            
                            NSArray *currentVesionArray = [app_build componentsSeparatedByString:@"."];//当前版本
                            NSInteger a = (versionArray.count> currentVesionArray.count)?currentVesionArray.count : versionArray.count;
                            for (int i = 0; i< a; i++) {
                                
                                NSInteger a1 = [versionArray[i] integerValue];
                                NSInteger b = [currentVesionArray[i] integerValue];
                                if (a1 > b) {
                                    NSLog(@"有新版本");
                                    [self addVersionView:contentStr forcedFlag:forcedFlagStr];
                                }else if(a1 == b){
                                   NSLog(@"没有新版本1");
                                    
                                }else if(a1 < b){
                                    if(i==0 || i==1)
                                    {
                                        NSLog(@"直接跳出");
                                        break;
                                    }
                                   NSLog(@"没有新版本2");
                                    
                                }
                                
                            }
                            }
                            
                        } failure:^(NSInteger statusCode, NSError *error) {
                            NSLog(@"error = %@",error);
                            [HudViewFZ HiddenHud];
                            
                    //            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
                        }];
                }
            }
        }];

}
//判断当前app版本和AppStore最新app版本大小
- (BOOL)judgeNewVersion:(NSString *)newVersion withOldVersion:(NSString *)oldVersion {
    NSArray *newArray = [newVersion componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    NSArray *oldArray = [oldVersion componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    for (NSInteger i = 0; i < newArray.count; i ++) {
        if ([newArray[i] integerValue] > [oldArray[i] integerValue]) {
            return YES;
        } else if ([newArray[i] integerValue] < [oldArray[i] integerValue]) {
            return NO;
        } else { }
    }
    return NO;
}






/**
 扫描二维码 需要先检测相机
 
 @param scanVC UIViewController
 */
- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:scanVC animated:YES];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - Cleanpro] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
