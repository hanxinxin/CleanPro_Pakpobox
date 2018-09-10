//
//  BarViewController.h
//  StorHub
//
//  Created by Pakpobox on 2018/2/23.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "MyViewController.h"
#import "NAvigationViewController.h"
#import "MapViewController.h"
@interface BarViewController : UITabBarController

@property (nonatomic,strong)UINavigationController *navHome;
@property (nonatomic,strong)UINavigationController *navMy;
@property (nonatomic,strong)UINavigationController *StorHub;
@property (nonatomic,strong)UINavigationController *GYHub;

-(void)setTitle;
@end
