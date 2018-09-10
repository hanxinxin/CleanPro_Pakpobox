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
    self.OrderType.text=[NSString stringWithFormat:@"%@",self.mode.order_type];
    self.NoLabel.text=[NSString stringWithFormat:@"%@",self.mode.OrderId];
    self.LocationLabel.text=[NSString stringWithFormat:@"615 Toa Payoh"];
    self.MachineLabel.text=[NSString stringWithFormat:@"%@",self.mode.machine_no];
    
    self.temperatureLabel.text=[NSString stringWithFormat:@"%@",[[self Json_returnDict:self.mode.goods_info]objectForKey:@"temperature"]];
    self.TimeLabel.text=[NSString stringWithFormat:@"%@",[PublicLibrary timeString:[self.mode.create_time stringValue]]];
    self.PriceLabel.text=[NSString stringWithFormat:@"RM %@",self.mode.total_amount];
    
}
-(NSDictionary *)Json_returnDict:(NSString *)responseString
{
    //将字符窜转化成字典
    
    
    
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *configFirstDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                    
                                                                   options:NSJSONReadingMutableContainers
                                    
                                                                     error:&err];
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
