//
//  LaundrySuccessViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
//#ifdef __cplusplus
//extern "C" {
//#endif
//    NSString *json2String(NSDictionary *json);
//    NSMutableDictionary *string2Json(NSString *str);
//    NSMutableArray *string2JsonArr(NSString *str);
//    NSMutableData *decodeHex(NSString *data);
//#ifdef __cplusplus
//};
//#endif
@interface LaundrySuccessViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *iamge_set;
@property (weak, nonatomic) IBOutlet UILabel *title_text;

@property (weak, nonatomic) IBOutlet UILabel *tips_text;
@property (weak, nonatomic) IBOutlet UIButton *Compelet_btn;

//// 传值类
@property (nonatomic, strong)CreateOrder * order_c;

@property (nonatomic, strong)NSArray * arrayList;

@property (nonatomic, strong) NSString * orderidStr;

//@property(nonatomic,strong)Device * DeviceStr;///蓝牙设备
@end
