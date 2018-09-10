//
//  BarViewController.m
//  StorHub
//
//  Created by Pakpobox on 2018/2/23.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import "BarViewController.h"
#import "aboutViewController.h"

@interface BarViewController ()


@end

@implementation BarViewController
@synthesize navHome,navMy,StorHub,GYHub;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化两个视图控制器
    //    HomeViewController *HomeVc = [[HomeViewController alloc]init];
    [self setTitleAndview];
    //注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_SXUI)name:@"UIshuaxin" object:nil];
}
-(void)setTitleAndview
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *HomeVc=[main instantiateViewControllerWithIdentifier:@"HomeViewController"];
    //    NAvigationViewController *NAV=[main instantiateViewControllerWithIdentifier:@"NAvigationViewController"];
    //    MyViewController *MyVc = [[MyViewController alloc]init];
    MyViewController *MyVc=[main instantiateViewControllerWithIdentifier:@"MyViewController"];
    MapViewController *StorHubVc=[main instantiateViewControllerWithIdentifier:@"MapViewController"];
    //    MyViewController *StorHubVc = [[MyViewController alloc]init];
    aboutViewController *GYHub_cc=[main instantiateViewControllerWithIdentifier:@"aboutViewController"];
    
    //为两个视图控制器添加导航栏控制器
    navHome = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    navMy = [[UINavigationController alloc]initWithRootViewController:MyVc];
    StorHub = [[UINavigationController alloc]initWithRootViewController:StorHubVc];
    GYHub = [[UINavigationController alloc]initWithRootViewController:GYHub_cc];
    navHome.tabBarItem.image=[[UIImage imageNamed:@"icon_home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_put"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    StorHub.tabBarItem.image=[[UIImage imageNamed:@"icon_nearby"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    StorHub.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_nearby_put"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMy.tabBarItem.image=[[UIImage imageNamed:@"icon_my"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMy.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_my_put"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    GYHub.tabBarItem.image=[[UIImage imageNamed:@"icon_about"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    GYHub.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_about_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_put"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navHome.tabBarItem.selectedImage=[UIImage imageNamed:@"tabBar_new_click_icon"];
    //设置控制器文字
    navHome.title = FGGetStringWithKeyFromTable(@"Home Page", @"Language");
    StorHub.title = FGGetStringWithKeyFromTable(@"Nearby", @"Language");
    navMy.title = FGGetStringWithKeyFromTable(@"My Account", @"Language");
    GYHub.title = FGGetStringWithKeyFromTable(@"About us", @"Language");
    //设置控制器图片(使用imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal,不被系统渲染成蓝色)
    //    navOne.tabBarItem.image = [[UIImage imageNamed:@"icon_home_bottom_statist"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navOne.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_bottom_statist_hl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navTwo.tabBarItem.image = [[UIImage imageNamed:@"icon_home_bottom_search"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navTwo.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_bottom_search_hl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //改变tabbarController 文字选中颜色(默认渲染为蓝色)
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateSelected];
    
    //创建一个数组包含四个导航栏控制器
    NSArray *vcArry = [NSArray arrayWithObjects:navHome,StorHub,navMy,GYHub,nil];
    
    //将数组传给UITabBarController
    self.viewControllers = vcArry;
    
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewWillAppear:(BOOL)animated {
    
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        [backBtn setTintColor:[UIColor blackColor]];
        backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
        self.navigationItem.backBarButtonItem = backBtn;

    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
