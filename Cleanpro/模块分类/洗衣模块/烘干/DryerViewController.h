//
//  DryerViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DryerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *machine_label;
@property (weak, nonatomic) IBOutlet UILabel *Charges_label;

@property (weak, nonatomic) IBOutlet UILabel *Time_label;
@property (weak, nonatomic) IBOutlet UILabel *money_label;
@property (weak, nonatomic) IBOutlet UIButton *jian_btn;
@property (weak, nonatomic) IBOutlet UILabel *time_minute_label;
@property (weak, nonatomic) IBOutlet UIButton *jia_btn;


@property (weak, nonatomic) IBOutlet UIButton *pay_btn;

//// 定义选择分钟数  默认是23分钟
@property (assign, nonatomic) NSInteger TimeTeger;

@property(nonatomic,strong)NSArray * arrayList;

//@property(nonatomic,strong)Device * DeviceStr;///蓝牙设备
@property(nonatomic,strong)NSString * addrStr;  ///加密字节
@end
