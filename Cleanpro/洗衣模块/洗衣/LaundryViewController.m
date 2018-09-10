//
//  LaundryViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LaundryViewController.h"
#import "LaundryDetailsViewController.h"

@interface LaundryViewController ()
{
    
    CreateOrder * order_c;
    
    
}
@property (nonatomic ,strong)NSMutableArray * arrPrice;
@end

@implementation LaundryViewController
@synthesize left_view,center_view,right_view,xuandian;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    order_c=[[CreateOrder alloc] init];
    self.arrPrice=[NSMutableArray arrayWithCapacity:0];
//    order_c.machine_no=@"P2018070401";
    self.machine_label.text=[NSString stringWithFormat:@"#%@",self.arrayList[1]];
    order_c.machine_no=[NSString stringWithFormat:@"%@#%@",self.arrayList[0],self.arrayList[1]];
//    order_c.total_amount=@"3";
    order_c.client_type=@"IOS";
    order_c.order_type=self.arrayList[2];;
    order_c.goods_info= @{@"temperature":@"Warm"};
    
    UITapGestureRecognizer *tap_left = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(left_viewTouch:)];
    tap_left.numberOfTapsRequired = 1;
    [left_view addGestureRecognizer:tap_left];
    UITapGestureRecognizer *tap_center = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(center_viewTouch:)];
    tap_center.numberOfTapsRequired = 1;
    [center_view addGestureRecognizer:tap_center];
    UITapGestureRecognizer *tap_right = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(right_viewTouch:)];
    tap_right.numberOfTapsRequired = 1;
    [right_view addGestureRecognizer:tap_right];
    
    
    
    self.Select_teger=0;
    xuandian=[[UIButton alloc] init];
    xuandian.frame=CGRectMake(left_view.left+(left_view.width-6)/2, left_view.top-9, 6, 6);
    xuandian.backgroundColor = [UIColor colorWithRed:239/255.0 green:93/255.0 blue:123/255.0 alpha:1];
    xuandian.layer.cornerRadius = 3;//2.0是圆角的弧度，根据需求自己更改
    [self.topView addSubview:xuandian];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//    [self center_viewTouch:nil];////默认选择Warm
        
        [self getPriceMache];
    });
    
}
- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

-(void)getPriceMache
{
    [HudViewFZ labelExample:self.view];
    __block LaundryViewController *  blockSelf = self;
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
                    NSNumber * priceNumber =[zong_Dict objectForKey:@"price"];
                    
                    [blockSelf.arrPrice addObject:[NSString stringWithFormat:@"%.2f",[priceNumber floatValue]]];
                }
        if(blockSelf.arrPrice.count>0)
        {
        [self updateText];
        }
    } failure:^(NSError *error) {
        [HudViewFZ HiddenHud];
    }];
}
-(void)updateText
{
    [self center_viewTouch:nil];
    
}

-(void)left_viewTouch:(UIGestureRecognizer*)tag
{
    NSLog(@"left");
    [self setLeft_label_Text_Z:self.arrPrice[0]];
    [self setCenter_label_Text_black:self.arrPrice[1]];
    [self setRight_label_Text_black:self.arrPrice[2]];
    xuandian.frame=CGRectMake(left_view.left+(left_view.width-6)/2, left_view.top-9, 6, 6);
    [self.topView addSubview:xuandian];
    self.Select_teger=0;
    order_c.total_amount=self.arrPrice[self.Select_teger];
}

-(void)setLeft_label_Text_Z:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"RM", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Cold", @"Language"),price,price_3];
    _left_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:238/255.0 green:84/255.0 blue:117/255.0 alpha:1] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:238/255.0 green:84/255.0 blue:117/255.0 alpha:1] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _left_label.attributedText = attributStr;
    order_c.goods_info= @{@"temperature":@"Cold"};
}

-(void)setLeft_label_Text_black:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"RM", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Cold", @"Language"),price,price_3];
    _left_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101.997/255.0 green:101.997/255.0 blue:101.997/255.0 alpha:1] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101.997/255.0 green:101.997/255.0 blue:101.997/255.0 alpha:1] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _left_label.attributedText = attributStr;
}


-(void)center_viewTouch:(UIGestureRecognizer*)tag
{
    NSLog(@"center");
    [self setLeft_label_Text_black:self.arrPrice[0]];
    [self setCenter_label_Text_Z:self.arrPrice[1]];
    [self setRight_label_Text_black:self.arrPrice[2]];
    xuandian.frame=CGRectMake(center_view.left+(center_view.width-6)/2, center_view.top-9, 6, 6);
    [self.topView addSubview:xuandian];
    self.Select_teger=1;
    order_c.total_amount=self.arrPrice[self.Select_teger];
}

-(void)setCenter_label_Text_Z:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"RM", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Warm", @"Language"),price,price_3];
    _center_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:238/255.0 green:84/255.0 blue:117/255.0 alpha:1] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:238/255.0 green:84/255.0 blue:117/255.0 alpha:1] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _center_label.attributedText = attributStr;
//    order_c.goods_info=@"Warm";
    order_c.goods_info= @{@"temperature":@"Warm"};
}

-(void)setCenter_label_Text_black:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"RM", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Warm", @"Language"),price,price_3];
    _center_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101.997/255.0 green:101.997/255.0 blue:101.997/255.0 alpha:1] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101.997/255.0 green:101.997/255.0 blue:101.997/255.0 alpha:1] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _center_label.attributedText = attributStr;
}
-(void)right_viewTouch:(UIGestureRecognizer*)tag
{
    NSLog(@"right");
    [self setLeft_label_Text_black:self.arrPrice[0]];
    [self setCenter_label_Text_black:self.arrPrice[1]];
    [self setRight_label_Text_Z:self.arrPrice[2]];
    xuandian.frame=CGRectMake(right_view.left+(right_view.width-6)/2, right_view.top-9, 6, 6);
    [self.topView addSubview:xuandian];
    self.Select_teger=2;
    order_c.total_amount=self.arrPrice[self.Select_teger];
}

-(void)setRight_label_Text_Z:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"RM", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Hot", @"Language"),price,price_3];
    _right_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:238/255.0 green:84/255.0 blue:117/255.0 alpha:1] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:238/255.0 green:84/255.0 blue:117/255.0 alpha:1] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _right_label.attributedText = attributStr;
//    order_c.goods_info=@"Hot";
    order_c.goods_info= @{@"temperature":@"Hot"};
}

-(void)setRight_label_Text_black:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"RM", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Hot", @"Language"),price,price_3];
    _right_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101.997/255.0 green:101.997/255.0 blue:101.997/255.0 alpha:1] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101.997/255.0 green:101.997/255.0 blue:101.997/255.0 alpha:1] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _right_label.attributedText = attributStr;
}
- (IBAction)next_touch:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LaundryDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryDetailsViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.order_c=order_c;
    vc.arrayList=self.arrayList;
    [self.navigationController pushViewController:vc animated:YES];
    
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
