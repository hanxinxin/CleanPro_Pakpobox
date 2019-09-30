//
//  BirthdayRViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "BirthdayRViewController.h"
#import "GenderRViewController.h"
@interface BirthdayRViewController ()

@end

@implementation BirthdayRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.next_btn.layer.cornerRadius=4;
    self.Skip_btn.layer.cornerRadius=4;
    self.DateStr=@""; //默认为空字符串
    [self setdatePicker];
    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    
}
- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}


- (IBAction)Next_touch:(id)sender {
    if(self.DateStr!=nil && ![self.DateStr isEqualToString:@""])
    {
    self.Nextmode.birthday=self.DateStr;
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GenderRViewController *vc=[main instantiateViewControllerWithIdentifier:@"GenderRViewController"];
    vc.hidesBottomBarWhenPushed = YES;
        vc.Nextmode=self.Nextmode;
    [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)Skip_touch:(id)sender {
//    if(self.DateStr!=nil && ![self.DateStr isEqualToString:@""])
//    {
        self.Nextmode.birthday=self.DateStr;
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GenderRViewController *vc=[main instantiateViewControllerWithIdentifier:@"GenderRViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.Nextmode=self.Nextmode;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}




-(void)setdatePicker
{
    //
    // 只显示时间
    
    self.date_picker.datePickerMode = UIDatePickerModeDate;
    // 1.1选择datePickr的显示风格
    [self.date_picker setDatePickerMode:UIDatePickerModeDate];
    // 1.2查询所有可用的地区
    NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
//     1.3设置datePickr的地区语言, zh_Han后面是s的就为简体中文,zh_Han后面是t的就为繁体中文， zh_Hans_CN 简体中文 zh_Hant_CN 繁体中文 en_US 英文
    //获取当前设备语言
//    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    NSString *languageName = [appLanguages objectAtIndex:0];
    [self.date_picker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [self.date_picker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:languageName]];
    // 1.4监听datePickr的数值变化
    [self.date_picker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.date_picker setValue:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forKey:@"textColor"];
    //设置最大值时间
    self.date_picker.maximumDate= [NSDate date];//今天
    // 1.5 设置默认时间
    [self.date_picker setDate:[NSDate date]];
    

}
- (void)datePickerValueChanged:(UIDatePicker *)datePicker

{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 格式化日期格式
    
    formatter.dateFormat = @"yyyyMMdd";
    
    NSString *date = [formatter stringFromDate:datePicker.date];
    self.DateStr=date;
    // 显示时间
    NSLog(@"选择的时间是 ：= %@",date);
    
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
