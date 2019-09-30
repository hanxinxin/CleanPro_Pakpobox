//
//  lineItemViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "lineItemViewController.h"

@interface lineItemViewController ()

@end

@implementation lineItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)setLabelText
{
    if([self.mode.order_type isEqualToString:@"DRYER"])
    {
        self.OrderType.text=[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Dryer", @"Language")];
//        self.OrderType.text=[NSString stringWithFormat:@"%@",self.mode.order_type];
    }else if([self.mode.order_type isEqualToString:@"LAUNDRY"])
    {
       self.OrderType.text=[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Washer", @"Language")];
    }
    self.orderNo.text = [NSString stringWithFormat:@"%@:",FGGetStringWithKeyFromTable(@"Transaction NO.", @"Language")];
    self.NoLabel.text=[NSString stringWithFormat:@"%@",self.mode.order_no];
    [self.Location setText:[NSString stringWithFormat:@"%@:",FGGetStringWithKeyFromTable(@"Outlet ", @"Language")]];
    self.LocationLabel.text=[NSString stringWithFormat:@"%@",self.mode.LocationName];
    [self.Machine setText:[NSString stringWithFormat:@"%@:",FGGetStringWithKeyFromTable(@"Machine No. ", @"Language")]];
    self.MachineLabel.text=[NSString stringWithFormat:@"%@",[self getString:self.mode.machine_no]];
    
    if([self.mode.order_type isEqualToString:@"DRYER"])
    {
        [self.BtnType_image setImage:[UIImage imageNamed:@"icon_dryer2"] forState:(UIControlStateNormal)];
        [self.Temperature setText:[NSString stringWithFormat:@"%@ :",FGGetStringWithKeyFromTable(@"Duration", @"Language")]];
        self.temperatureLabel.text=[NSString stringWithFormat:@"%@m",[[self Json_returnDict:self.mode.goods_info]objectForKey:@"time"]];
    }else if([self.mode.order_type isEqualToString:@"LAUNDRY"])
    {
        [self.BtnType_image setImage:[UIImage imageNamed:@"icon_laundry2"] forState:(UIControlStateNormal)];
        [self.Temperature setText:[NSString stringWithFormat:@"%@ :",FGGetStringWithKeyFromTable(@"Temperature", @"Language")]];
        self.temperatureLabel.text=[NSString stringWithFormat:@"%@",[[self Json_returnDict:self.mode.goods_info]objectForKey:@"temperature"]];
    }
    
    [self.Time setText:[NSString stringWithFormat:@"%@:",FGGetStringWithKeyFromTable(@"Time", @"Language")]];
    self.TimeLabel.text=[NSString stringWithFormat:@"%@",[PublicLibrary timeString:[self.mode.create_time stringValue]]];
    [self.price setText:[NSString stringWithFormat:@"%@:",FGGetStringWithKeyFromTable(@"Charges ", @"Language")]];
    self.PriceLabel.text=[NSString stringWithFormat:@"%@",self.mode.total_amount];
    
}

-(NSString *)getString:(NSString *) str
{
    NSArray *array = [str componentsSeparatedByString:@"#"];
    NSString * getStr = array[1];
    return getStr;
}

-(NSDictionary *)Json_returnDict:(NSString *)responseString
{
    //将字符窜转化成字典
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *configFirstDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return configFirstDic;
}
- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.title=@"Cleapro";
    self.navigationController.title=FGGetStringWithKeyFromTable(@"Order", @"Language");
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setLabelText];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
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
