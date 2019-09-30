//
//  BarViewController.h
//  StorHub
//
//  Created by Pakpobox on 2018/2/23.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
//#import "MyViewController.h"
#import "MCTabBarController.h"
//@interface BarViewController : UITabBarController
@interface BarViewController : MCTabBarController

@property (nonatomic,strong)UINavigationController *navHome;
@property (nonatomic,strong)UINavigationController *location;
@property (nonatomic,strong)UINavigationController *WC;
@property (nonatomic,strong)UINavigationController *navMy;
@property (nonatomic,strong)UINavigationController *Massage;
//@property (nonatomic,strong)UINavigationController *GYHub;

-(void)setTitle;
@end
