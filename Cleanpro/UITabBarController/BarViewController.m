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

@interface BarViewController ()


@end

@implementation BarViewController
@synthesize navHome,navMy,Order;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化两个视图控制器
    //    HomeViewController *HomeVc = [[HomeViewController alloc]init];
    [self setTitleAndview];
    //注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_SXUI)name:@"UIshuaxin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_SXUI1)name:@"UIshuaxin1" object:nil];
}
-(void)setTitleAndview
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *HomeVc=[main instantiateViewControllerWithIdentifier:@"HomeViewController"];
    //    NAvigationViewController *NAV=[main instantiateViewControllerWithIdentifier:@"NAvigationViewController"];
//        MyViewController *MyVc = [[MyViewController alloc]init];
    OrdersViewController *OrderVc=[main instantiateViewControllerWithIdentifier:@"OrdersViewController"];
    MyAccountViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
//    //    MyViewController *StorHubVc = [[MyViewController alloc]init];
//    aboutViewController *GYHub_cc=[main instantiateViewControllerWithIdentifier:@"aboutViewController"];
    
    //为两个视图控制器添加导航栏控制器
    navHome = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    navMy = [[UINavigationController alloc]initWithRootViewController:MyVc];
    Order = [[UINavigationController alloc]initWithRootViewController:OrderVc];
//    GYHub = [[UINavigationController alloc]initWithRootViewController:GYHub_cc];
    navHome.tabBarItem.image=[[UIImage imageNamed:@"icon_home_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Order.tabBarItem.image=[[UIImage imageNamed:@"icon_orders_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Order.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_orders_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMy.tabBarItem.image=[[UIImage imageNamed:@"mine"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMy.tabBarItem.selectedImage = [[UIImage imageNamed:@"mine_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    GYHub.tabBarItem.image=[[UIImage imageNamed:@"icon_about"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    GYHub.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_about_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_put"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navHome.tabBarItem.selectedImage=[UIImage imageNamed:@"tabBar_new_click_icon"];
    //设置控制器文字
    navHome.title = FGGetStringWithKeyFromTable(@"Home", @"Language");
    Order.title = FGGetStringWithKeyFromTable(@"Orders", @"Language");
    navMy.title = FGGetStringWithKeyFromTable(@"My Account", @"Language");
//    GYHub.title = FGGetStringWithKeyFromTable(@"About us", @"Language");
    //设置控制器图片(使用imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal,不被系统渲染成蓝色)
    //    navOne.tabBarItem.image = [[UIImage imageNamed:@"icon_home_bottom_statist"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navOne.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_bottom_statist_hl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navTwo.tabBarItem.image = [[UIImage imageNamed:@"icon_home_bottom_search"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navTwo.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_bottom_search_hl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //改变tabbarController 文字选中颜色(默认渲染为蓝色)
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1]} forState:UIControlStateSelected];
    
    //创建一个数组包含四个导航栏控制器
    NSArray *vcArry = [NSArray arrayWithObjects:navHome,Order,navMy,nil];
    
    //将数组传给UITabBarController
    self.viewControllers = vcArry;
    
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewWillAppear:(BOOL)animated {
    
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//        [backBtn setTintColor:[UIColor blackColor]];
        backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
        self.navigationItem.backBarButtonItem = backBtn;

    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tongzhi_SXUI1
{
//   [self setTitleAndview];
    [self setSelectedIndex:0];
    self.tabBar.hidden=NO;
}

-(void)tongzhi_SXUI
{
    [self setTitleAndview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
