//
//  lineItemViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lineItemViewController : UIViewController

@property(nonatomic,strong)OrderListClass * mode;
@property(nonatomic,strong)NewOrderList * Newmode;
@property (weak, nonatomic) IBOutlet UIButton *BtnType_image;

@property (weak, nonatomic) IBOutlet UILabel *OrderType;

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *NoLabel;

@property (weak, nonatomic) IBOutlet UILabel *Location;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;

@property (weak, nonatomic) IBOutlet UILabel *Machine;
@property (weak, nonatomic) IBOutlet UILabel *MachineLabel;

@property (weak, nonatomic) IBOutlet UILabel *Temperature;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *AddTimeBtn;

//@property (assign, nonatomic) NSInteger overtimeFlag;///"overtimeFlag": false //false不可以加时，true可以加时

-(NSDictionary *)Json_returnDict:(NSString *)responseString;
@end
