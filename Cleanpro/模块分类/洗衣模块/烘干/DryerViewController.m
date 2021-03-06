//
//  DryerViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DryerViewController.h"
#import "LaundryDetailsViewController.h"
#import "AppDelegate.h"
#import "NewAddTimeView.h"

@interface DryerViewController ()<UIGestureRecognizerDelegate>
{
    CreateOrder * order_c;
    
//    /////全屏透明色view和 button Lable
//    UIView * backgroundView;
//    UITapGestureRecognizer *tapSuperGesture22;
//    NewAddTimeView * CenterView;
}
@property (nonatomic ,strong)NSMutableArray * arrPrice;
@property (nonatomic ,strong)NSMutableArray * SPArray;

@property (nonatomic ,strong)NSString * MoRen_time_str;
@property (nonatomic ,strong)NSString * Price_str;
@property (nonatomic ,strong)NSString * continue_price_str;
@property (nonatomic ,strong)NSString * continue_value_str;
@end

@implementation DryerViewController
@synthesize TimeTeger,morenTimeSj,timeJiaJian;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.Charges_label setText:[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Charges", @"Language")]];
    [self.Time_label setText:[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Time(MIN)", @"Language")]];
    [self.pay_btn setTitle:FGGetStringWithKeyFromTable(@"Pay", @"Language") forState:(UIControlStateNormal)];
    if(self.OrderAndRenewal==1 || self.OrderAndRenewal==2)
    {
        [self.JQImage setImage:[UIImage imageNamed:@"dryerNew.png"]];
    }else if(self.OrderAndRenewal==3)
    {
        [self.JQImage setImage:[UIImage imageNamed:@"picyudou"]];
    }
    self.topView.layer.cornerRadius=2;
    self.pay_btn.layer.cornerRadius=4;
    order_c=[[CreateOrder alloc] init];
    self.arrPrice=[NSMutableArray arrayWithCapacity:0];
    self.SPArray=[NSMutableArray arrayWithCapacity:0];
    self.machine_label.text=[NSString stringWithFormat:@"%@",self.arrayList[1]];
    order_c.machine_no=[NSString stringWithFormat:@"%@#%@",self.arrayList[0],self.arrayList[1]];
    
    order_c.client_type=@"IOS";
    order_c.order_type=self.arrayList[2];;
    timeJiaJian=0;
//    self.TimeTeger = 23;
//    order_c.goods_info=@"temperature";
    morenTimeSj=23;
    
    [self setTimeLabel_text:0];
    self.Charges_label.textAlignment=NSTextAlignmentCenter;
    self.money_label.textAlignment=NSTextAlignmentCenter;
    [self setmoney_label_text:0];
    [self setbtn_jian_NO];
    [self setbtn_jia_yes];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    if([self->order_c.order_type isEqualToString:@"LAUNDRY"])
    {
        self.title =FGGetStringWithKeyFromTable(@"Laundry", @"Language");
    }else if([self->order_c.order_type isEqualToString:@"DRYER"])
    {
        self.title =FGGetStringWithKeyFromTable(@"Dryer", @"Language");
    }else if([self->order_c.order_type isEqualToString:@"IRONING"])
    {
        self.title =FGGetStringWithKeyFromTable(@"Ironing", @"Language");
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
    /*
    if([Manager.inst isConnected])
    {
        NSLog(@"已连接偶忆蓝牙1");
        
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
-(void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
        if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
            //push
        } else if ([viewControllers indexOfObject:self] == NSNotFound) {
            //pop
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.ManagerBLE closeConnected];
            [appDelegate hiddenFCViewNO];
        }

    [super viewWillDisappear:animated];
    
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
            NSLog(@"链接成功偶忆蓝牙D");
            
            
        }else{
            //            NSLog(@"未连接");
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Bluetooth connection failed", @"Language") andDelay:2.5];
        }
        
    });
}


-(void)setbtn_jian_yes
{
//    [self.jian_btn setTitleColor:[UIColor colorWithRed:30/255.0 green:149/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
//    self.jian_btn.layer.cornerRadius=14;
//    self.jian_btn.layer.borderWidth=1;
//    self.jian_btn.layer.borderColor=[UIColor colorWithRed:30/255.0 green:149/255.0 blue:227/255.0 alpha:1].CGColor;
    [self.jian_btn setImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
    
}
-(void)setbtn_jian_NO
{
//    [self.jian_btn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]forState:UIControlStateNormal];
//    self.jian_btn.layer.cornerRadius=14;
//    self.jian_btn.layer.borderWidth=1;
//    self.jian_btn.layer.borderColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1].CGColor;
    [self.jian_btn setImage:[UIImage imageNamed:@"minus_unavailable"] forState:UIControlStateNormal];
}

-(void)setbtn_jia_yes
{
//    [self.jia_btn setTitleColor:[UIColor colorWithRed:30/255.0 green:149/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
//    self.jia_btn.layer.cornerRadius=14;
//    self.jia_btn.layer.borderWidth=1;
//    self.jia_btn.layer.borderColor=[UIColor colorWithRed:30/255.0 green:149/255.0 blue:227/255.0 alpha:1].CGColor;
    [self.jia_btn setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
}
-(void)setbtn_jia_NO
{
//    [self.jia_btn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];;
//    self.jia_btn.layer.cornerRadius=14;
//    self.jia_btn.layer.borderWidth=1;
//    self.jia_btn.layer.borderColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1].CGColor;
    [self.jia_btn setImage:[UIImage imageNamed:@"plus_unavailable"] forState:UIControlStateNormal];
    
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

- (IBAction)pay_touch:(id)sender {
/*
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
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
    if([appDelegate.appdelegate1 isConnected_to])
    {
        NSLog(@"已连接偶忆蓝牙2");
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LaundryDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryDetailsViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.order_c=order_c;
        vc.arrayList=self.arrayList;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:FGGetStringWithKeyFromTable(@"Tips", @"Language") message:FGGetStringWithKeyFromTable(@"Bluetooth connection", @"Language") preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"点击取消");
//        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            NSLog(@"点击确认");
            NSLog(@"未连接直接跳转");
//            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            LaundryDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundryDetailsViewController"];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.order_c=self->order_c;
//            vc.arrayList=self.arrayList;
//            [self.navigationController pushViewController:vc animated:YES];
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
    vc.order_c=order_c;
    vc.arrayList=self.arrayList;
    vc.addrStr = self.addrStr;
    vc.OrderAndRenewal = self.OrderAndRenewal;
    vc.OrderIdTime=self.OrderIdTime;
    vc.siteIdStr= self.siteIdStr;
    vc.timeTotal=TimeTeger;
    vc.NewOrderType=1;///洗衣
    vc.arrPrice=self.arrPrice;
    vc.SPArray=self.SPArray;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getPriceMache
{
    [HudViewFZ labelExample:self.view];
    __block DryerViewController *  blockSelf = self;
    [blockSelf.arrPrice removeAllObjects];
    NSLog(@"URL=== %@",[NSString stringWithFormat:@"%@%@%@",E_FuWuQiUrl,E_Getquery,self.siteIdStr]);
    NSString *escapedPathURL = [[NSString stringWithFormat:@"%@%@%@",E_FuWuQiUrl,E_Getquery,self.siteIdStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"URL=== %@",escapedPathURL);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:escapedPathURL parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"E_Getquery=  %@",responseObject);
//        NSDictionary * dictA=(NSDictionary *)responseObject;
        NSArray * dictArr= (NSArray*)responseObject;
        for (int Q=0; Q<dictArr.count; Q++) {

        NSDictionary * dictA= (NSDictionary*)dictArr[Q];

            if(dictA)
            {
                productsMode * ModeProducts = [[productsMode alloc] init];
//                NSDictionary * dictA=array[i];
                NSArray * attributeList = [dictA objectForKey:@"attributeList"];
                NSArray * productVariantList = [dictA objectForKey:@"productVariantList"];
                ModeProducts.productId = [dictA objectForKey:@"productId"];
                ModeProducts.productName = [dictA objectForKey:@"productName"];
                ModeProducts.productNameEn = [dictA objectForKey:@"productNameEn"];
                ModeProducts.serviceId = [dictA objectForKey:@"serviceId"];
                for(int j=0;j<attributeList.count;j++)
                {
                    NSDictionary * dictJ=attributeList[j];
                    attributeListsMode * mode = [[attributeListsMode alloc] init];
                    mode.attributeType = [dictJ objectForKey:@"attributeType"];
                    mode.name = [dictJ objectForKey:@"name"];
                    mode.productAttributeId = [dictJ objectForKey:@"productAttributeId"];
                    NSArray * valueList = [dictJ objectForKey:@"valueList"];
                    NSMutableArray * ArrayMu= [NSMutableArray arrayWithCapacity:0];
                    NSMutableArray * ArrayvalueListMode= [NSMutableArray arrayWithCapacity:0];
                    for(int B=0;B<valueList.count;B++)
                    {
                        NSDictionary * dictObject=valueList[B];
                        valueListMode * modeValue = [[valueListMode alloc] init];
                        modeValue.productAttributeValue=[dictObject objectForKey:@"productAttributeValue"];
                        modeValue.productAttributeValueId=[dictObject objectForKey:@"productAttributeValueId"];
                        [ArrayvalueListMode addObject:modeValue];
                    }
                    mode.valueList = ArrayvalueListMode;
                    [ArrayMu addObject:mode];
                    ModeProducts.attributeList=ArrayMu;
                }
                NSMutableArray * productArrayMu= [NSMutableArray arrayWithCapacity:0];
                for(int k=0;k<productVariantList.count;k++)
                {
                    NSDictionary * dictJ=productVariantList[k];
                    NSArray * productAttributeValueIds = [dictJ objectForKey:@"productAttributeValueIds"];
                    productVariantListMode * modeP = [[productVariantListMode alloc] init];
                    modeP.priceValue = [dictJ objectForKey:@"priceValue"];
                    modeP.productAttributeValueName = [dictJ objectForKey:@"productAttributeValueName"];
                    modeP.productVariantId = [dictJ objectForKey:@"productVariantId"];
                    NSMutableArray * ValueIds= [NSMutableArray arrayWithCapacity:0];
                    for(int B=0;B<productAttributeValueIds.count;B++)
                    {
                        NSString * productAttributeValueId=productAttributeValueIds[B];
                        [ValueIds addObject:productAttributeValueId];
                    }
                    modeP.productAttributeValueIds = ValueIds;
                    [productArrayMu addObject:modeP];
                }
                ModeProducts.productVariantList=productArrayMu;
                [self.arrPrice addObject:ModeProducts];
                
                [HudViewFZ HiddenHud];
            }
                
            }
        if(self.arrPrice.count>0)
        {
            if(self.OrderAndRenewal==1)
            {
                self.SPArray=[self SParray];
                valueListMode * mode2 =self.SPArray[0];
                self.Price_str=[NSString stringWithFormat:@"%.2f",[[self getPriceStr:mode2.productAttributeValueId] floatValue]];
                self->order_c.total_amount=[NSString stringWithFormat:@"%.2f",[[self getPriceStr:mode2.productAttributeValueId] floatValue]];
                self->morenTimeSj=[[self getPriceTimeStr:mode2.productAttributeValue] integerValue];
                self.MoRen_time_str=[self getPriceTimeStr:mode2.productAttributeValue];
                self->TimeTeger = self->morenTimeSj;
                
            }else if(self.OrderAndRenewal==2)
            {
                self.SPArray=[self SParray];
                valueListMode * mode2 =self.SPArray[1];
                self.Price_str=[NSString stringWithFormat:@"%.2f",[[self getPriceStr:mode2.productAttributeValueId] floatValue]];
                
                self->order_c.total_amount=[NSString stringWithFormat:@"%.2f",[[self getPriceStr:mode2.productAttributeValueId] floatValue]];
                self->morenTimeSj=[[self getPriceTimeStr:mode2.productAttributeValue] integerValue];
                 self.MoRen_time_str=[self getPriceTimeStr:mode2.productAttributeValue];
                self->TimeTeger = self->morenTimeSj;
                
            }else if(self.OrderAndRenewal==3)
            {
                self.SPArray=[self SParray_Ironing];
                valueListMode * mode2 =self.SPArray[0];
                self.Price_str=[NSString stringWithFormat:@"%.2f",[[self getPriceStr:mode2.productAttributeValueId] floatValue]];
                self->order_c.total_amount=[NSString stringWithFormat:@"%.2f",[[self getPriceStr:mode2.productAttributeValueId] floatValue]];
                self->morenTimeSj=[[self getPriceTimeStr:mode2.productAttributeValue] integerValue];
                self.MoRen_time_str=[self getPriceTimeStr:mode2.productAttributeValue];
                self->TimeTeger = self->morenTimeSj;
                
            }
            
        [self updateText];
        }
    } failure:^(NSError *error) {
        [HudViewFZ HiddenHud];
    }];
}
-(NSString*)getPriceTimeStr:(NSString*)productAttributeValue
{
    
    NSString *Price = [productAttributeValue stringByReplacingOccurrencesOfString:@" mins" withString:@""];
    return Price;
}
-(NSString * )getPriceStr:(NSString*)productAttributeValueId
{
    for (int C=0; C<self.arrPrice.count; C++) {
        productsMode *mode=self.arrPrice[C];
    for (int i =0 ; i<mode.productVariantList.count; i++) {
        productVariantListMode * mode1 =mode.productVariantList[i];

        for (int j =0 ; j<mode1.productAttributeValueIds.count; j++) {

                NSString * strID = mode1.productAttributeValueIds[j];
                if([strID isEqualToString:productAttributeValueId])
                {
                    return mode1.priceValue;
                }
        }
    }
    }
    
    return @"0";
}

-(NSMutableArray*)SParray
{
    NSMutableArray * arrTime =[NSMutableArray arrayWithCapacity:0];
    for (int C=0; C<self.arrPrice.count; C++) {
        productsMode *mode=self.arrPrice[C];
    for (int i =0 ; i<mode.attributeList.count; i++) {
        attributeListsMode * mode1 =mode.attributeList[i];
        if([mode1.name isEqualToString:@"Dry time"])
        {
        for (int j =0 ; j<mode1.valueList.count; j++) {
            valueListMode * mode2 =mode1.valueList[j];
            
            if(arrTime.count>0)
            {
                valueListMode * mode3 =arrTime[0];
                NSString * timeStr=[self getPriceTimeStr:mode2.productAttributeValue];
                NSString * timeStr1=[self getPriceTimeStr:mode3.productAttributeValue];
                if(([timeStr integerValue])>([timeStr1 integerValue]))
                {
                    [arrTime insertObject:mode2 atIndex:0];
                }else{
                    [arrTime addObject:mode2];
                }
            }else{
                [arrTime addObject:mode2];
            }
        }
        }
    }
    }
    return arrTime;
}

-(NSMutableArray*)SParray_Ironing
{
    NSMutableArray * arrTime =[NSMutableArray arrayWithCapacity:0];
    for (int C=0; C<self.arrPrice.count; C++) {
        productsMode *mode=self.arrPrice[C];
    for (int i =0 ; i<mode.attributeList.count; i++) {
        attributeListsMode * mode1 =mode.attributeList[i];
        if([mode1.name isEqualToString:@"lroning time"])
        {
        for (int j =0 ; j<mode1.valueList.count; j++) {
            valueListMode * mode2 =mode1.valueList[j];
            
            if(arrTime.count>0)
            {
                valueListMode * mode3 =arrTime[0];
                NSString * timeStr=[self getPriceTimeStr:mode2.productAttributeValue];
                NSString * timeStr1=[self getPriceTimeStr:mode3.productAttributeValue];
                if(([timeStr integerValue])>([timeStr1 integerValue]))
                {
                    [arrTime insertObject:mode2 atIndex:0];
                }else{
                    [arrTime addObject:mode2];
                }
            }else{
                [arrTime addObject:mode2];
            }
        }
        }
    }
    }
    return arrTime;
}
/*
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
            NSArray * prop_valuesArr = [zong_Dict objectForKey:@"prop_values"];
//            [blockSelf.arrPrice addObject:[NSString stringWithFormat:@"%.2f",[priceNumber floatValue]]];
            
            
            
            self.continue_price_str=[NSString stringWithFormat:@"%.2f",[continue_price floatValue]];
            self.continue_value_str=[NSString stringWithFormat:@"%.2f",[continue_value floatValue]];
            
            if(self.OrderAndRenewal==1)
            {
                self.Price_str=[NSString stringWithFormat:@"%.2f",[priceNumber floatValue]];
                self->order_c.total_amount=[NSString stringWithFormat:@"%.2f",[priceNumber floatValue]];
            }else if(self.OrderAndRenewal==2)
            {
                self.Price_str=self.continue_price_str;
                self->order_c.total_amount=self.continue_price_str;
            }
            for (int cout=0; cout<prop_valuesArr.count; cout++) {
                if(cout==1)
                {
                NSDictionary * prop=prop_valuesArr[cout];
                NSNumber * DryerValue =[prop objectForKey:@"value"];
                    if(self.OrderAndRenewal==1)
                    {
                        self.MoRen_time_str=[NSString stringWithFormat:@"%d",[DryerValue intValue]];
                    
                        self->morenTimeSj = [DryerValue integerValue];
                    }else if(self.OrderAndRenewal==2)
                    {
                        self.MoRen_time_str=self.continue_value_str;
                        self->morenTimeSj =[self.continue_value_str integerValue];
                    }
                        self->order_c.goods_info= @{@"time":self.MoRen_time_str};
                    self->TimeTeger=[self.MoRen_time_str integerValue];
                    
                }
            }
        }

            [self updateText];
    } failure:^(NSError *error) {
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];

}
 */


-(void)updateText
{
    
    
    valueListMode * mode2 =self.SPArray[1];
    timeJiaJian=[[self getPriceTimeStr:mode2.productAttributeValue] integerValue];
    [self setmoney_label_text:[self.Price_str floatValue]];
    [self setTimeLabel_text:morenTimeSj];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Jian_Min_touch:(id)sender {
    if(TimeTeger==morenTimeSj)
    {
         [self setbtn_jian_NO];
        [self setbtn_jia_yes];
    }else
    {
        TimeTeger-=timeJiaJian;
        if(TimeTeger==morenTimeSj)
        {
            [self setbtn_jian_NO];
            [self setbtn_jia_yes];
        }else{
            [self setbtn_jian_yes];
            [self setbtn_jia_yes];
        }
    }
    [self setTimeLabel_text:TimeTeger];
    [self setMoneyInt:TimeTeger];
}
- (IBAction)Jia_Min_touch:(id)sender {
    if(TimeTeger<200)
    {
        TimeTeger+=timeJiaJian;
//        [self setbtn_jia_yes];
        if(TimeTeger<200)
        {
            [self setbtn_jian_yes];
            [self setbtn_jia_yes];
        }else
        {
            [self setbtn_jia_NO];
            [self setbtn_jian_yes];
        }
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
//    int money_s = (int)(TimeTeger-[self.MoRen_time_str integerValue])/[self.continue_value_str intValue];
    valueListMode * mode2 =self.SPArray[1];
    int money_s = (int)(TimeTeger-[self.MoRen_time_str integerValue])/timeJiaJian;
     NSLog(@"money_s=   %d",money_s);
    float money_float = [self.Price_str floatValue]+(money_s*[[self getPriceStr:mode2.productAttributeValueId] floatValue]);
    NSLog(@"money_float=   %f",money_float);
    [self setmoney_label_text:money_float];
}


-(void)setTimeLabel_text:(NSInteger)tiem
{
    NSString * price_3 =[NSString stringWithFormat:@"%d",(int)tiem];
    NSString * price =FGGetStringWithKeyFromTable(@"", @"Language");
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
    NSString * price =FGGetStringWithKeyFromTable(@"", @"Language");
    NSString * string= [NSString stringWithFormat:@"%@ %@",price,price_3];
    self.money_label.numberOfLines=0;
    //获取需要改变的字符串在完整字符串的范围
        NSRange rang = [string rangeOfString:price];
    NSRange rang_3 = [string rangeOfString:price_3];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] range:rang];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] range:rang_3];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:rang];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:24] range:rang_3];
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
