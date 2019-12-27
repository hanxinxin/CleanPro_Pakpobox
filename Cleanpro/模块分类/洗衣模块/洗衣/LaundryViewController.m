//
//  LaundryViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LaundryViewController.h"
#import "AppDelegate.h"
#import "LaundryDetailsViewController.h"

@interface LaundryViewController ()
{
    
    CreateOrder * order_c;
    
    
}
@property (nonatomic ,strong)NSMutableArray * arrPrice;
@property (nonatomic ,strong)NSMutableAttributedString *stringLog;
@end

@implementation LaundryViewController
@synthesize left_view,center_view,right_view,xuandian,stringLog;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topView.layer.cornerRadius=2;
    self.next_btn.layer.cornerRadius=4;
    order_c=[[CreateOrder alloc] init];
    self.arrPrice=[NSMutableArray arrayWithCapacity:0];
    stringLog=[[NSMutableAttributedString alloc] init];
//    order_c.machine_no=@"P2018070401";
    self.machine_label.text=[NSString stringWithFormat:@"%@",self.arrayList[1]];
    order_c.machine_no=[NSString stringWithFormat:@"%@#%@",self.arrayList[0],self.arrayList[1]];
//    order_c.total_amount=@"3";
    order_c.client_type=@"IOS";
    order_c.order_type=self.arrayList[2];;
    order_c.goods_info= @{@"temperature":@"Warm"};
    [self.miaoshu_label setText:FGGetStringWithKeyFromTable(@"Choose water temperature", @"Language")];
    [self.next_btn setTitle:FGGetStringWithKeyFromTable(@"Next", @"Language") forState:(UIControlStateNormal)];
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
        if([self->order_c.order_type isEqualToString:@"LAUNDRY"])
        {
            self.title =FGGetStringWithKeyFromTable(@"Washer", @"Language");
        }else if([self->order_c.order_type isEqualToString:@"DRYER"])
        {
            self.title =FGGetStringWithKeyFromTable(@"Dryer", @"Language");
        }
        [self getPriceMache];
    });
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate addFCViewSet];
}
- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationController.navigationBar.translucent = YES;
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate.appdelegate1 dataSendWithNameStr:@"Pakpobox"];
    if([appDelegate.appdelegate1 isConnected_to])
    {
        NSLog(@"已连接蓝牙");
    }else
    {
        NSLog(@"未连接蓝牙");
    }
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerNSLog:) name:@"bearerNSLog" object:nil];
    /*
    if([Manager.inst isConnected])
    {
        NSLog(@"已连接偶忆蓝牙L2");
        
    }else
    {
        [self zuwang:nil];
        //        [HudViewFZ showMessageTitle:@"Bluetooth connection failed" andDelay:2.5];
    }
     */
     // 禁用返回手势
       if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
           self.navigationController.interactivePopGestureRecognizer.enabled = NO;
       }  
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

-(void)bearerNSLog:(NSNotification *)noti {
    NSDictionary *advertisementData = [noti userInfo];
//    NSData *data  =[advertisementData objectForKey:@"kCBAdvDataLeBluetoothDeviceAddress"];
    NSData *data  =[advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    
    NSString * uuid = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
    NSString * kCBAdvDataLocalName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    NSString *mac =[[self convertToNSStringWithNSData:data] uppercaseString];
//    NSLog(@"uuid= %@",uuid);
    
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n mac = %@",mac]];
    [SubStr1 appendAttributedString:substring1];
    [stringLog appendAttributedString:SubStr1];
    NSMutableAttributedString * SubStr3=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Name = %@",kCBAdvDataLocalName]];
    [SubStr3 appendAttributedString:substring3];
    [stringLog appendAttributedString:SubStr3];
    NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n uuid = %@",uuid]];
    [SubStr2 appendAttributedString:substring2];
    [stringLog appendAttributedString:SubStr2];
    
    
    self.TextViewAA.text = stringLog.string;;
}
//MARK: mac地址解析处理
- (NSString *)convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=2; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
}


// 点击back按钮后调用 引用的他人写的一个extension
- (BOOL)navigationShouldPopOnBackButton {
    NSLog(@"点击返回按钮");
    //    [self.navigationController popToRootViewControllerAnimated:YES];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate.appdelegate1 closeConnected];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.ManagerBLE closeConnected];
    [appDelegate hiddenFCViewNO];
    
    return YES;
}

-(void)zuwang:(NSString*)contentStr
{
//    [Manager.inst checkConnect];
//    [Manager.inst addLsnr:self];
    
}
#pragma mark - ManagerLsnr method
- (void)onConnect:(bool)isBleConn :(bool)isWiFiConn {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        _bleIndicatorBtn.selected = isBleConn;
        if(isBleConn==YES)
        {
            NSLog(@"链接成功偶忆蓝牙L");
            
            
        }else{
            //            NSLog(@"未连接");
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Bluetooth connection failed", @"Language") andDelay:2.5];
        }
        
    });
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
//        NSLog(@"responseObject=  %@",responseObject);
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
//                    NSLog(@"arrPrice = %@",blockSelf.arrPrice);
//                    NSLog(@"price===  %@",priceNumber);
                }
        if(self.arrPrice.count>0)
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
    NSString * price = FGGetStringWithKeyFromTable(@"", @"Language");
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
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:17] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _left_label.attributedText = attributStr;
    order_c.goods_info= @{@"temperature":@"Cold"};
}

-(void)setLeft_label_Text_black:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Cold", @"Language"),price,price_3];
    _left_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:17] range:rang_3];
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
    NSString * price = FGGetStringWithKeyFromTable(@"", @"Language");
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
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:17] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _center_label.attributedText = attributStr;
//    order_c.goods_info=@"Warm";
    order_c.goods_info= @{@"temperature":@"Warm"};
}

-(void)setCenter_label_Text_black:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Warm", @"Language"),price,price_3];
    _center_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:17] range:rang_3];
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
    NSString * price = FGGetStringWithKeyFromTable(@"", @"Language");
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
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:17] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _right_label.attributedText = attributStr;
//    order_c.goods_info=@"Hot";
    order_c.goods_info= @{@"temperature":@"Hot"};
}

-(void)setRight_label_Text_black:(NSString*)price_3
{
    NSString * price = FGGetStringWithKeyFromTable(@"", @"Language");
//    NSString * price_3 = FGGetStringWithKeyFromTable(@"3", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@\n%@ %@",FGGetStringWithKeyFromTable(@"Hot", @"Language"),price,price_3];
    _right_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
    //    NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:17] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    _right_label.attributedText = attributStr;
}
- (IBAction)next_touch:(id)sender {
    
    /*暂时先屏蔽  修改判断逻辑
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSLog(@"Connected1=== %d",[appDelegate.appdelegate1 isConnected_to]);
    NSString * strMM = [NSString stringWithFormat:@"%@",self.arrayList[0]];
    if([strMM isEqualToString:@"20190605"]|| [strMM isEqualToString:@"P20191011"])//P2018080603
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    LaundryDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryDetailsViewController"];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.order_c=self->order_c;
                    vc.arrayList=self.arrayList;
        //            vc.DeviceStr = self.DeviceStr;
                    [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        if([appDelegate.appdelegate1 isConnected_to])
        {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LaundryDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryDetailsViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.order_c=order_c;
        vc.arrayList=self.arrayList;
    //    vc.DeviceStr = self.DeviceStr;
        [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:FGGetStringWithKeyFromTable(@"Tips", @"Language") message:FGGetStringWithKeyFromTable(@"Bluetooth connection", @"Language") preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                NSLog(@"点击取消");
//            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
    //            NSLog(@"点击确认");
                NSLog(@"未连接直接跳转");
//                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                LaundryDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryDetailsViewController"];
//                vc.hidesBottomBarWhenPushed = YES;
//                vc.order_c=self->order_c;
//                vc.arrayList=self.arrayList;
//    //            vc.DeviceStr = self.DeviceStr;
//                [self.navigationController pushViewController:vc animated:YES];
            }]];
            // 由于它是一个控制器 直接modal出来就好了
            
            [self presentViewController:alertController animated:YES completion:nil];
            //        [HudViewFZ showMessageTitle:@"Bluetooth connection failed" andDelay:2.5];
    }
    }
    */
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LaundryDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryDetailsViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.order_c=self->order_c;
    vc.arrayList=self.arrayList;
    vc.addrStr = self.addrStr;
//    vc.DeviceStr = self.DeviceStr;
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
