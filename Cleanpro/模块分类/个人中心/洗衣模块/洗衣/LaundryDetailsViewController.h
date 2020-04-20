//
//  LaundryDetailsViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaundryDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *Order_type;
@property (weak, nonatomic) IBOutlet UILabel *machineNo;
@property (weak, nonatomic) IBOutlet UILabel *machineNo_label;

@property (weak, nonatomic) IBOutlet UILabel *Temperature;
@property (weak, nonatomic) IBOutlet UILabel *Temperature_label;

@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *price_label;


////UITableView 选择框
@property (nonatomic, strong)UITableView * tableViewDonw;


@property (weak, nonatomic) IBOutlet UILabel *Money_text;

@property (weak, nonatomic) IBOutlet UIButton *pay_btn;

@property (nonatomic, strong)NSString * Pay_passwordStr;

//// 传值类
@property (nonatomic, strong)CreateOrder * order_c;

@property (nonatomic, strong)NSArray * arrayList;

//@property(nonatomic,strong)Device * DeviceStr;///蓝牙设备
@property(nonatomic,strong)NSString * addrStr;  ///加密字节
@property(nonatomic,assign)NSInteger overtimeYN;  ///加密字节

@property(nonatomic,assign)NSInteger OrderAndRenewal;  ///判断是正常下单还是加时烘干 1:正常下单 2:烘干加时
@property(nonatomic,strong)NSString *  OrderIdTime;

@property(nonatomic,assign)NSInteger NewOrderType;  ///判断是洗衣还是贩卖机 1:洗衣 2:贩卖机
@property (nonatomic, strong)NSArray * FMJArray; ///贩卖机物品数组


@end
