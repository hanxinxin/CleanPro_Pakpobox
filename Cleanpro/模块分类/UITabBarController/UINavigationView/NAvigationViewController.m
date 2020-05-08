//
//  NAvigationViewController.m
//  StorHub
//
//  Created by Pakpobox on 2018/2/23.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import "NAvigationViewController.h"

@interface NAvigationViewController ()<UINavigationControllerDelegate>


@end

@implementation NAvigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置导航控制器的代理为self
//    self.navigationController.delegate = self;
//    self.navigationBar.frame = CGRectMake(0, 0,SCREEN_WIDTH, NAVIGATION_HEIGHT);

}
- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark - UINavigationControllerDelegate
//// 将要显示控制器
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//
//    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
//}
//
///**
// * 可以在这个方法中拦截所有push进来的控制器
// */
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
////    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
////        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////        [button setTitle:FGGetStringWithKeyFromTable(@"Back", @"Language") forState:UIControlStateNormal];
////        [button setImage:[UIImage imageNamed:@"en1"] forState:UIControlStateNormal];
////        [button setImage:[UIImage imageNamed:@"en2"] forState:UIControlStateHighlighted];
//////        button.frame.size = CGSizeMake(80, 30);
////
////        // 让按钮内部的所有内容左对齐
////        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
////        // 让按钮的内容往左边偏移10
////        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
////
////        // 更简单的处理方式：
////        // [button sizeToFit]; // 让按钮的尺寸跟随内容而变化
////
////        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
////
////        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
////        // 隐藏tabbar
////        viewController.hidesBottomBarWhenPushed = YES;
////    }
//
//    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
//    [super pushViewController:viewController animated:animated];
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
