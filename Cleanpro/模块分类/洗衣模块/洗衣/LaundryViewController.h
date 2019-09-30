//
//  LaundryViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaundryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *machine_label;

@property (weak, nonatomic) IBOutlet UIView *left_view;
@property (weak, nonatomic) IBOutlet UILabel *left_label;

@property (weak, nonatomic) IBOutlet UIView *center_view;
@property (weak, nonatomic) IBOutlet UILabel *center_label;

@property (weak, nonatomic) IBOutlet UIView *right_view;
@property (weak, nonatomic) IBOutlet UILabel *right_label;

@property (weak, nonatomic) IBOutlet UILabel *miaoshu_label;



@property (weak, nonatomic) IBOutlet UIButton *next_btn;

@property (strong ,nonatomic)UIButton * xuandian;

///////定义选择什么价位
@property (assign,nonatomic) NSInteger Select_teger; //// 0是Cold 1是Warm 2是Hot

@property(nonatomic,strong)NSArray * arrayList;

//@property(nonatomic,strong)Device * DeviceStr;///蓝牙设备

@end
