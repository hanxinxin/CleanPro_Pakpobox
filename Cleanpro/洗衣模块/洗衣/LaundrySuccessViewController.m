//
//  LaundrySuccessViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LaundrySuccessViewController.h"
#import "HomeViewController.h"
#import "MyAccountViewController.h"

@interface LaundrySuccessViewController ()

@end

@implementation LaundrySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self postOrder];
    self.Compelet_btn.layer.cornerRadius = 18;//2.0是圆角的弧度，根据需求自己更改
    
}



- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}


- (IBAction)Compelet_touch:(id)sender {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[HomeViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        
        }
    }
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MyAccountViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
