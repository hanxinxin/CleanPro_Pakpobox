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




@property (weak, nonatomic) IBOutlet UILabel *Money_text;

@property (weak, nonatomic) IBOutlet UIButton *pay_btn;

@property (nonatomic, strong)NSString * Pay_passwordStr;

//// 传值类
@property (nonatomic, strong)CreateOrder * order_c;

@property (nonatomic, strong)NSArray * arrayList;

@end
