//
//  lineItemViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "lineItemViewController.h"
#import "NewAddTimeView.h"
#import "DryerViewController.h"
#import "AppDelegate.h"

@interface lineItemViewController ()<UIGestureRecognizerDelegate,NewAddTimeViewDelegate>
{
    /////全屏透明色view和 button Lable
    UIView * backgroundView;
    UITapGestureRecognizer *tapSuperGesture22;
    
    NSArray * arrayList;
    NSString * address;
    NSString * OrderIdStr;
    
}
@property (nonatomic ,assign) NewAddTimeView * CenterView;
@end

@implementation lineItemViewController
@synthesize CenterView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.AddTimeBtn.layer.cornerRadius=4;
    if([self.mode.order_type isEqualToString:@"DRYER"])
    {
        
    
    }else if([self.mode.order_type isEqualToString:@"LAUNDRY"])
    {
       self.AddTimeBtn.hidden = YES;
    }
    OrderIdStr=nil;
    address=nil;
//    arrayList=[NSMutableArray arrayWithCapacity:0];
    arrayList = [[NSArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.title=@"Cleapro";
    self.navigationController.title=FGGetStringWithKeyFromTable(@"Order", @"Language");
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.overtimeFlag=0;
    [self setLabelText];
    [self Get_OrderDetailView:self.mode.OrderId];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddTime_Touch:(id)sender {
//    [self addBackgroundView:1];
    if(arrayList.count>0)
    {
        [self getBLEMac:arrayList[0] NumberStr:arrayList[1]];
    }else
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Information acquisition error", @"Language") andDelay:2.0];
    }

}
-(void)pushViewControllerDryer
{
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DryerViewController *vc=[main instantiateViewControllerWithIdentifier:@"DryerViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.arrayList=arrayList;
        vc.addrStr = address;
        vc.OrderAndRenewal=2;
        vc.OrderIdTime=self.mode.OrderId;
        [self.navigationController pushViewController:vc animated:YES];
}

-(void)Get_OrderDetailView:(NSString *)OrderID
{
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,Get_OrderDetail,OrderID] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"Get_OrderDetail = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * DictZ=(NSDictionary *)responseObject;
        
        NSString * machine_no = [DictZ objectForKey:@"machine_no"];
        NSString * order_type = [DictZ objectForKey:@"order_type"];
        NSString * strArray = [NSString stringWithFormat:@"%@#%@",machine_no,order_type];
        NSArray *array = [strArray componentsSeparatedByString:@"#"];
        NSNumber * timeFlag= [DictZ objectForKey:@"overtimeFlag"];///"overtimeFlag": false //false不可以加时，true可以加时
//        self.overtimeFlag = ;
        if([timeFlag integerValue]==0)
        {
            self.AddTimeBtn.hidden=YES;
        }else
        {
            self.AddTimeBtn.hidden=NO;
        }
        self->arrayList = array;
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        if(statusCode==401)
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else{
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            
        }
    }];
}

//-(void)setBtnHidden:(NSNumber*)timeFlag
//{
//    if([timeFlag integerValue]==0)
//    {
//        self.AddTimeBtn.hidden=YES;
//    }else
//    {
//        self.AddTimeBtn.hidden=NO;
//    }
//}

-(void)getBLEMac:(NSString *)siteNo NumberStr:(NSString*)NumStr
{
    NSLog(@"URL = %@",[NSString stringWithFormat:@"%@%@%@#%@",FuWuQiUrl,get_BLEmacAddress,siteNo,NumStr]);
    NSString *escapedPathURL = [[NSString stringWithFormat:@"%@%@%@#%@",FuWuQiUrl,get_BLEmacAddress,siteNo,NumStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"URL2 = %@",escapedPathURL);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:escapedPathURL parameters:nil progress:^(id progress) {
            
        } success:^(id responseObject) {
//            addr = 0016;
//            mac = "F5:13:44:A9:73:F6";
//            machineNo = 03;
//            siteNo = P2018080603;
            NSLog(@"responseObject ORder=  %@",responseObject);
            NSDictionary * dictList=(NSDictionary *)responseObject;
                NSString * statusCode =[dictList objectForKey:@"statusCode"];
            if([statusCode integerValue] == 403)
            {
               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
               [userDefaults setObject:@"1" forKey:@"Token"];
               [userDefaults setObject:@"1" forKey:@"phoneNumber"];
               [userDefaults setObject:nil forKey:@"SaveUserMode"];
               [userDefaults setObject:@"1" forKey:@"logCamera"];
               NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
               //通过通知中心发送通知
               [[NSNotificationCenter defaultCenter] postNotification:notification];
            }else{
                NSString * addr = [dictList objectForKey:@"addr"];;
                NSString * mac = [dictList objectForKey:@"mac"];
                NSString * machineNo = [dictList objectForKey:@"machineNo"];
//                NSString * siteNo = [dictList objectForKey:@"siteNo"];
                NSString * macByte=[mac stringByReplacingOccurrencesOfString:@":" withString:@""];
                if(macByte)
                {
                    self->address = addr;
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.ManagerBLE scanPeripherals];
                    [appDelegate.ManagerBLE setAddressName:macByte];
//                    [appDelegate.ManagerBLE setMacName:machineNo];
//                    [self AddConnected];
                    [self pushViewControllerDryer];
                }
            }
           
        } failure:^(NSInteger statusCode, NSError *error) {
            [HudViewFZ HiddenHud];
            NSLog(@"error ORder=  %@",error);
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Bluetooth connection failed", @"Language") andDelay:2.0];
        }];
}
/**
 全屏View 背景透明 //弹出 选择加时
 */
-(void)addBackgroundView:(NSInteger)index
{
    backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 1)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.3]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [backgroundView addGestureRecognizer:tapSuperGesture22];
    UINib *nib = [UINib nibWithNibName:@"NewAddTimeView" bundle:nil];
    NSArray *objs = [nib instantiateWithOwner:nil options:nil];
    CenterView=objs[0];
    CenterView.frame=CGRectMake(44 , (SCREEN_HEIGHT-180)/3, SCREEN_WIDTH-(44*2), 180);
    CenterView.delegate = self;
//    CenterView.backgroundColor = [UIColor redColor];
    [self.view addSubview:backgroundView];
    
    
    [self show_TCview];
}

-(void)show_TCview
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
//        self->CenterView.frame=CGRectMake(44 , (SCREEN_HEIGHT-180)/3, SCREEN_WIDTH-(44*2), 180);
//        self->backgroundView.frame=self.view.bounds;
        self->backgroundView.frame=CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self->backgroundView addSubview:self->CenterView];
    }];
    
}
-(void)hidden_TCview
{
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self->backgroundView.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        [self->backgroundView removeFromSuperview];
    }];
}
- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    [self hidden_TCview];
}

#pragma mark ----- NewAddTimeViewDelegate -----

-(void)CloseTouch
{
    [self hidden_TCview];
}
-(void)NextTouch:(NSString *)jine timeStr:(NSString *)time
{
    
}
-(void)Jia_Jian_Touch:(NSInteger)time
{
    
}



@end
