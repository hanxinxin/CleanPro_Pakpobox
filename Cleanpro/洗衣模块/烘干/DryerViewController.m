//
//  DryerViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DryerViewController.h"
#import "LaundryDetailsViewController.h"

@interface DryerViewController ()
{
    CreateOrder * order_c;
}
@property (nonatomic ,strong)NSMutableArray * arrPrice;
@property (nonatomic ,strong)NSString * MoRen_time_str;
@property (nonatomic ,strong)NSString * Price_str;
@property (nonatomic ,strong)NSString * continue_price_str;
@property (nonatomic ,strong)NSString * continue_value_str;
@end

@implementation DryerViewController
@synthesize TimeTeger;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    order_c=[[CreateOrder alloc] init];
    self.arrPrice=[NSMutableArray arrayWithCapacity:0];
    self.machine_label.text=[NSString stringWithFormat:@"#%@",self.arrayList[1]];
    order_c.machine_no=[NSString stringWithFormat:@"%@#%@",self.arrayList[0],self.arrayList[1]];
    
    order_c.client_type=@"IOS";
    order_c.order_type=self.arrayList[2];;
//    order_c.goods_info=@"temperature";
    [self setTimeLabel_text:0];
    [self setmoney_label_text:0];
    [self setbtn_jian_NO];
    [self setbtn_jia_yes];
    self.jian_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.jia_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.jian_btn.titleEdgeInsets = UIEdgeInsetsMake(-4, 0, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    self.jia_btn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
}

-(void)setbtn_jian_yes
{
    [self.jian_btn setTitleColor:[UIColor colorWithRed:30/255.0 green:149/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
    self.jian_btn.layer.cornerRadius=14;
    self.jian_btn.layer.borderWidth=1;
    self.jian_btn.layer.borderColor=[UIColor colorWithRed:30/255.0 green:149/255.0 blue:227/255.0 alpha:1].CGColor;
}
-(void)setbtn_jian_NO
{
    [self.jian_btn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]forState:UIControlStateNormal];
    self.jian_btn.layer.cornerRadius=14;
    self.jian_btn.layer.borderWidth=1;
    self.jian_btn.layer.borderColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1].CGColor;
}

-(void)setbtn_jia_yes
{
    [self.jia_btn setTitleColor:[UIColor colorWithRed:30/255.0 green:149/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
    self.jia_btn.layer.cornerRadius=14;
    self.jia_btn.layer.borderWidth=1;
    self.jia_btn.layer.borderColor=[UIColor colorWithRed:30/255.0 green:149/255.0 blue:227/255.0 alpha:1].CGColor;
}
-(void)setbtn_jia_NO
{
    [self.jia_btn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];;
    self.jia_btn.layer.cornerRadius=14;
    self.jia_btn.layer.borderWidth=1;
    self.jia_btn.layer.borderColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1].CGColor;
}
- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getPriceMache];
    [super viewWillAppear:animated];
}

- (IBAction)pay_touch:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LaundryDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryDetailsViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.order_c=order_c;
    vc.arrayList=self.arrayList;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)getPriceMache
{
    [HudViewFZ labelExample:self.view];
    __block DryerViewController *  blockSelf = self;
    [blockSelf.arrPrice removeAllObjects];
    NSLog(@"URL=== %@",[NSString stringWithFormat:@"%@%@%@#%@",FuWuQiUrl,Get_PriceMache,self.arrayList[0],self.arrayList[1]]);
    NSString *escapedPathURL = [[NSString stringWithFormat:@"%@%@%@#%@",FuWuQiUrl,Get_PriceMache,self.arrayList[0],self.arrayList[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"URL=== %@",escapedPathURL);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:escapedPathURL parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject=  %@",responseObject);
        [HudViewFZ HiddenHud];
        //        NSDictionary * dictionary = (NSDictionary*)responseObject;
        //
        //        NSArray * resultListArr=[dictionary objectForKey:@"resultList"];
        NSArray * arrList = (NSArray *)responseObject;
        NSDictionary * dictionary = arrList[0];
        NSArray * sku_list_Arr=[dictionary objectForKey:@"sku_list"];
        for (int j=0; j<sku_list_Arr.count; j++) {

            NSDictionary * zong_Dict=sku_list_Arr[j];
            NSNumber * MoRen_time_name =[zong_Dict objectForKey:@"name"];
            NSNumber * priceNumber =[zong_Dict objectForKey:@"price"];
            NSNumber * continue_price =[zong_Dict objectForKey:@"continue_price"];
            NSNumber * continue_value =[zong_Dict objectForKey:@"continue_value"];
//            [blockSelf.arrPrice addObject:[NSString stringWithFormat:@"%.2f",[priceNumber floatValue]]];
            
            self.Price_str=[NSString stringWithFormat:@"%.2f",[priceNumber floatValue]];
            self.continue_price_str=[NSString stringWithFormat:@"%.2f",[continue_price floatValue]];
            self.continue_value_str=[NSString stringWithFormat:@"%.2f",[continue_value floatValue]];
            self.MoRen_time_str=[NSString stringWithFormat:@"%d",[MoRen_time_name intValue]];
            self->order_c.goods_info= @{@"time":self.MoRen_time_str};
            self->order_c.total_amount=[NSString stringWithFormat:@"%.2f",[priceNumber floatValue]];
            self->TimeTeger=[self.MoRen_time_str integerValue];
        }

            [self updateText];
    } failure:^(NSError *error) {
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
    }];

}

-(void)updateText
{
    [self setmoney_label_text:[self.Price_str floatValue]];
    [self setTimeLabel_text:TimeTeger];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Jian_Min_touch:(id)sender {
    if(TimeTeger==23)
    {
         [self setbtn_jian_NO];
        [self setbtn_jia_yes];
    }else
    {
        TimeTeger-=5;
        [self setbtn_jian_yes];
        [self setbtn_jia_yes];
    }
    [self setTimeLabel_text:TimeTeger];
    [self setMoneyInt:TimeTeger];
}
- (IBAction)Jia_Min_touch:(id)sender {
    if(TimeTeger<200)
    {
        TimeTeger+=5;
//        [self setbtn_jia_yes];
        [self setbtn_jian_yes];
        [self setbtn_jia_yes];
    }else
    {
        [self setbtn_jia_NO];
        [self setbtn_jian_yes];
    }
    [self setTimeLabel_text:TimeTeger];
    [self setMoneyInt:TimeTeger];
    
}

-(void)setMoneyInt:(NSInteger)TimeTeger
{
    int money_s = (int)(TimeTeger-[self.MoRen_time_str integerValue])/[self.continue_value_str intValue];
     NSLog(@"money_s=   %d",money_s);
    float money_float = [self.Price_str floatValue]+(money_s*[self.continue_price_str floatValue]);
    NSLog(@"money_float=   %f",money_float);
    [self setmoney_label_text:money_float];
}


-(void)setTimeLabel_text:(NSInteger)tiem
{
    NSString * price_3 =[NSString stringWithFormat:@"%d",(int)tiem];
    NSString * price =FGGetStringWithKeyFromTable(@"MIN", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@ %@",price_3,price];
    self.time_minute_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
        NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rang];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_3];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:rang];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    self.time_minute_label.attributedText = attributStr;
//    order_c.goods_info=price_3;
    order_c.goods_info= @{@"time":price_3};
}

-(void)setmoney_label_text:(float)tiem
{
    NSString * price_3 =[NSString stringWithFormat:@"%.2f",tiem];
    NSString * price =FGGetStringWithKeyFromTable(@"RM", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@ %@",price,price_3];
    self.money_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
        NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rang];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_3];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:rang];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    self.money_label.attributedText = attributStr;
    self->order_c.total_amount=price_3;
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
