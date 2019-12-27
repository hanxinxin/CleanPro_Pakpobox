//
//  WelcomeViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WelcomeViewController.h"
#import "nameRViewController.h"
#import "YinsiViewController.h"
#import "PhoneRViewController.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.next_btn.layer.cornerRadius=4;
    [self.selectBtn setImage:[UIImage imageNamed:@"logup_checkbox_off"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"logup_checkbox_on"] forState:UIControlStateSelected];
    [self.come_title setText:FGGetStringWithKeyFromTable(@"Join Cleanpro", @"Language")];
    [self.miaoshu_title setText:FGGetStringWithKeyFromTable(@"We'll help you create a new account in a few easy step.", @"Language")];
    [self.next_btn setTitle:FGGetStringWithKeyFromTable(@"Next", @"Language") forState:(UIControlStateNormal)];
    self.selectBtn.selected=NO;
    [self.next_btn setUserInteractionEnabled:NO];
    [self.next_btn setBackgroundColor:[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0]];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.view sendSubviewToBack:self.BJ_image];
        [self setTispLabel];
    });
}
//https://cleanpro.pakpobox.com/english.html
- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    self.title=FGGetStringWithKeyFromTable(@"Welcome", @"Language");
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    //    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    //    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    //    self.navigationItem.backBarButtonItem = backBtn;
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
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    nameRViewController *vc=[main instantiateViewControllerWithIdentifier:@"nameRViewController"];
    vc.index=1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    /*  12月20日 修改 业务需求 需要填写名字
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhoneRViewController *vc=[main instantiateViewControllerWithIdentifier:@"PhoneRViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    userIDMode * Nextmode = [[userIDMode alloc] init];
    Nextmode.firstName=@"";
    Nextmode.lastName=@"";
    Nextmode.birthday=@"";
    Nextmode.gender=@"MALE";
    Nextmode.postCode=@"";
    vc.Nextmode=Nextmode;
    [self.navigationController pushViewController:vc animated:YES];
     */
}
- (IBAction)select_touch:(id)sender {
    
    if(self.selectBtn.selected==NO)
    {
        self.selectBtn.selected=YES;
        if(self.selectBtn.selected==YES){
            [self.next_btn setUserInteractionEnabled:YES];
            [self.next_btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
        }
    }else
    {
        self.selectBtn.selected=NO;
        if(self.selectBtn.selected==NO){
            [self.next_btn setUserInteractionEnabled:NO];
            [self.next_btn setBackgroundColor:[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0]];
        }
    }
    
}


-(void)setTispLabel
{
    //需要特殊显示的价格,因为可能会动态改变,所以单独写出来了
    NSString *price = FGGetStringWithKeyFromTable(@"terms", @"Language");
    //拼接需要显示的完整字符串
    NSString *string = [NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"I agree to the personal data protection terms of Cleanpro.", @"Language")];
    //获取需要改变的字符串在完整字符串的范围
    NSRange rang = [string rangeOfString:price];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:rang];
    
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang];
    [self.tispLabel setAttributedText:attributStr];
    
    self.tispLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture_tiaoyue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tiaoyue_html:)];
    tapGesture_tiaoyue.cancelsTouchesInView = NO;
    [self.tispLabel addGestureRecognizer:tapGesture_tiaoyue];
}

-(void)tiaoyue_html:(UITapGestureRecognizer *)gesture
{
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YinsiViewController *vc=[main instantiateViewControllerWithIdentifier:@"YinsiViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
