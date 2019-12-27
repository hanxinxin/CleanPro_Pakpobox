//
//  LaundryDetailsViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LaundryDetailsViewController.h"
#import "LaundrySuccessViewController.h"
#import "HomeViewController.h"
#import "SelectTableViewCell.h"
#import "integralTableViewCell.h"
#import "RechargeViewController.h"
#import "Ipay.h"
#import "IpayPayment.h"
#import "newPhoneViewController.h"
#import "ExistingPayViewController.h"
#import "AppDelegate.h"


#define SelectTableViewCellID @"SelectTableViewCell"
#define integralTableViewCellID @"integralTableViewCell"
@interface LaundryDetailsViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,integralTableViewCellCellDelegate,PaymentResultDelegate>
{
    /////全屏透明色view和 button Lable
    UIView * Tuicang_View;
    UIView * TC_CenterView;
    UILabel * tisp_lable;
    UILabel * miaoshu_lable;
    UIButton * Come_btn;
    UIButton * back_btn;
    UITapGestureRecognizer *tapSuperGesture22;
    
    ///// textfiledView
    TPPasswordTextView *textfiledView;
    UIButton * closeBtn;
    
    
    NSInteger payAndSet;
    NSInteger payCheck;
}
@property (nonatomic,strong)NSMutableArray * arr_title;
@property (nonatomic,strong)NSNumber * credit;////积分
@property (nonatomic,strong)NSNumber * balance;///余额
@property (nonatomic,strong)NSString * currencyUnit;////货币单位
@property (nonatomic,strong)NSString * payment;////默认支付方式
@property (nonatomic,strong)NSString * credit_yn;////是否使用积分

@property (nonatomic, strong) IpayPayment *IPaypayment;
@property (nonatomic, strong) Ipay *paymentSdk;
@property (nonatomic, strong) UIView *paymentView;


@property (nonatomic, strong)NSString * order_noStr; ////支付成功的订单ID

@end

@implementation LaundryDetailsViewController
@synthesize arr_title,IPaypayment;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arr_title = [NSMutableArray arrayWithCapacity:0];
//    [self.arr_title addObject:[NSArray arrayWithObjects:@"Payment method",@"Payment online",@"Wallet", nil]];
    [self.arr_title addObject:[NSArray arrayWithObjects:FGGetStringWithKeyFromTable(@"Payment method", @"Language"),FGGetStringWithKeyFromTable(@"Wallet", @"Language"), nil]];
    payAndSet=0;
    payCheck=0;
    [self.arr_title addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@:",FGGetStringWithKeyFromTable(@"Credits", @"Language")], nil]];
    self.credit=[[NSNumber alloc] initWithInt:0];
    self.balance=[[NSNumber alloc] initWithInt:0];
    self.payment=@"2";
    self.credit_yn=@"1";////默认不使用积分
    self.order_noStr = @"";////默认是空字符串
    [self settopViewText];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self AddtableView];
        [HudViewFZ labelJuHua:self.view andDelay:0.5];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bearerDidOpen:) name:@"bearerDidOpen" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.title = self.order_c.order_type;
    [self.machineNo setText:[NSString stringWithFormat:@"%@ :", FGGetStringWithKeyFromTable(@"Machine No.", @"Language")]];
    if([self.order_c.order_type isEqualToString:@"LAUNDRY"])
    {
        self.title =FGGetStringWithKeyFromTable(@"Washer", @"Language");
        [self.Order_type setText:@"Washer"];
        [self.Temperature setText:[NSString stringWithFormat:@"%@ :", FGGetStringWithKeyFromTable(@"Temperature", @"Language")]];
    }else if([self.order_c.order_type isEqualToString:@"DRYER"])
    {
        self.title =FGGetStringWithKeyFromTable(@"Dryer", @"Language");
        [self.Temperature setText:[NSString stringWithFormat:@"%@ :", FGGetStringWithKeyFromTable(@"Duration", @"Language")]];
        [self.Order_type setText:self.order_c.order_type];
    }
    
    [self hidden_TCview];
    [self Get_wallet_A];
    
    [super viewWillAppear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bearerDidOpen" object:nil];
    self->payCheck=0;
    [super viewDidDisappear:animated];
}

-(void)AddtableView
{
    self.tableViewDonw = [[UITableView alloc] init];
    self.tableViewDonw.frame=CGRectMake(self.topView.left, self.topView.bottom+8, SCREEN_WIDTH-self.topView.left*2, 3*56+8);
    self.tableViewDonw.delegate=self;
    self.tableViewDonw.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.tableViewDonw.scrollEnabled = NO;  ////设置tableview不上下滑动
    self.tableViewDonw.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.Set_tableView.separatorColor = [UIColor blackColor];
    //    [self.view addSubview:self.Down_tableView];
    self.tableViewDonw.layer.cornerRadius = 4;
    self.topView.layer.cornerRadius = 4;
    self.pay_btn.layer.cornerRadius = 4;
     NSIndexPath *firstPath = [NSIndexPath indexPathForRow:1 inSection:0];
    payAndSet=1;
    [self.tableViewDonw selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableViewDonw registerNib:[UINib nibWithNibName:@"SelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SelectTableViewCellID];
    [self.tableViewDonw registerNib:[UINib nibWithNibName:@"integralTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:integralTableViewCellID];
    [self.view addSubview:self.tableViewDonw];
    
}
/**
 获取用户钱包
 */
-(void)Get_wallet_A
{
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_wallet] parameters:nil progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
        
        
        if([statusCode intValue] ==401)
        {
            //            [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//
//            }
        }else{
            
            self.balance = [dictObject objectForKey:@"balance"];
            self.currencyUnit = [dictObject objectForKey:@"currencyUnit"];
            self.credit = [dictObject objectForKey:@"credit"];
            [self.tableViewDonw reloadData];
            
            
        }
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

-(void)settopViewText
{
    
    self.machineNo_label.text=[NSString stringWithFormat:@"%@",self.arrayList[1]];
    if([self.order_c.order_type isEqualToString:@"LAUNDRY"])
    {
        self.Temperature_label.text=[self.order_c.goods_info objectForKey:@"temperature"];
    }else if([self.order_c.order_type isEqualToString:@"DRYER"])
    {
        self.Temperature_label.text=[NSString stringWithFormat:@"%@m",[self.order_c.goods_info objectForKey:@"time"]];
    }
    
    self.priceL.text=[NSString stringWithFormat:@"%@ :",FGGetStringWithKeyFromTable(@"Charges", @"Language")];
    [self setprice_labelText:self.order_c.total_amount];
    [self updatePostValue];
}

-(void)updatePostValue
{
    if([self.credit_yn isEqualToString:@"1"])
    {
        self.order_c.pay_amount=self.order_c.total_amount;
        self.order_c.credits=@"0";
    }else if ([self.credit_yn isEqualToString:@"2"])
    {
        if([self.credit doubleValue]/100 >=[self.order_c.total_amount doubleValue])
        {
            //            self.order_c.pay_amount = [NSString stringWithFormat:@"%.2f",[self.credit doubleValue]/100-[self.order_c.total_amount doubleValue]];
            self.order_c.pay_amount=@"0";
            self.order_c.credits = [NSString stringWithFormat:@"%.2f",[self.order_c.total_amount doubleValue]*100];
        }else
        {
            self.order_c.pay_amount = [NSString stringWithFormat:@"%.2f",[self.order_c.total_amount doubleValue]-[self.credit doubleValue]/100];
            self.order_c.credits = [NSString stringWithFormat:@"%.2f",[self.credit doubleValue]];
        }
        
    }
//    [self setprice_labelText:self.order_c.pay_amount];
    [self.pay_btn setTitle:[NSString stringWithFormat:@"%@ %@",FGGetStringWithKeyFromTable(@"Pay", @"Language"),self.order_c.pay_amount] forState:UIControlStateNormal];
}

-(void)setprice_labelText:(NSString *)str
{
    NSString * stringZ= [NSString stringWithFormat:@"%@",str];
     NSString * string= [NSString stringWithFormat:@"%@",str];
    NSRange rang_3 = [stringZ rangeOfString:string];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    self.price_label.attributedText = attributStr;
}

-(void)buttonText:(NSString *)str
{
    NSString * string= [NSString stringWithFormat:@"%@",str];
    NSRange rang_3 = [string rangeOfString:string];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    self.price_label.attributedText = attributStr;
}



- (IBAction)pay_touch:(id)sender {
//
    
    if([self.payment isEqualToString:@"1"])
    {
            self.order_c.payment_platform=@"IPAY88";
            self.order_c.coupon_code=@"";
       
        [self postOrder];
//        [self push_IPay];
    }else if([self.payment isEqualToString:@"2"])
    {
        NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([ModeUser.payPassword isEqualToString:@""] && ModeUser.payPassword != nil)
        {
        
            [self addselect_view:2];
        }else
        {
            [self addtextView_view];
        }
        
    }
    self.pay_btn.userInteractionEnabled=NO;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.pay_btn.userInteractionEnabled=YES;
    });
//    [self addselect_view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


#pragma mark ------- 全屏View 背景透明 --------

/**
 全屏View 背景透明 //没钱支付的时候提示他需要充值
 index  1是 没钱提醒充值  2是 没有设置支付密码
 */
-(void)addselect_view:(NSInteger)index
{
    Tuicang_View=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    [Tuicang_View setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.3]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [Tuicang_View addGestureRecognizer:tapSuperGesture22];
    TC_CenterView = [[UIView alloc] initWithFrame:CGRectMake(38*autoSizeScaleX_6, 220*autoSizeScaleY_6, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 175)];
    [TC_CenterView setBackgroundColor:[UIColor whiteColor]];
    TC_CenterView.layer.cornerRadius=4;
    [Tuicang_View addSubview:TC_CenterView];
    tisp_lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 0)];
    [tisp_lable setText:@""];
    tisp_lable.font = [UIFont systemFontOfSize:14];
    //文字居中显示
    tisp_lable.textAlignment = NSTextAlignmentCenter;
    
    miaoshu_lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 70)];
    if(index==1)
    {
        [miaoshu_lable setText:FGGetStringWithKeyFromTable(@"You balance is insufficient,please recharge", @"Language")];
    }else if(index==2)
    {
        [miaoshu_lable setText:FGGetStringWithKeyFromTable(@"Please set your payment password!", @"Language")];
    }
    miaoshu_lable.font = [UIFont systemFontOfSize:16];
    //文字居中显示
    miaoshu_lable.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    miaoshu_lable.numberOfLines = 0;
    back_btn = [[UIButton alloc] initWithFrame:CGRectMake(29*autoSizeScaleX_6, 80+15, 100, 40)];
    [back_btn setTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language") forState:UIControlStateNormal];
    [back_btn setBackgroundColor:[UIColor whiteColor]];
    [back_btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    back_btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    back_btn.layer.cornerRadius=4;
    back_btn.layer.borderColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0].CGColor;//设置边框颜色
    back_btn.layer.borderWidth = 1.0f;//设置边框颜色
    [back_btn addTarget:self action:@selector(Touch_two:) forControlEvents:UIControlEventTouchDown];
    Come_btn = [[UIButton alloc] initWithFrame:CGRectMake(29*autoSizeScaleX_6+(SCREEN_WIDTH-(38*autoSizeScaleX_6*2)-100*2-29*autoSizeScaleX_6*2)+100, 80+15, 100, 40)];
    if(index==1)
    {
        [Come_btn setTitle:FGGetStringWithKeyFromTable(@"Recharge", @"Language") forState:UIControlStateNormal];
        Come_btn.tag=1002;  ////标记为充值
    }else if(index==2)
    {
        [Come_btn setTitle:FGGetStringWithKeyFromTable(@"Setting", @"Language") forState:UIControlStateNormal];
        Come_btn.tag=1001;  ////标记为设置密码
    }
    
    [Come_btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [Come_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    Come_btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    Come_btn.layer.cornerRadius=4;
    Come_btn.layer.borderColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0].CGColor;//设置边框颜色
    Come_btn.layer.borderWidth = 1.0f;//设置边框颜色
    [Come_btn addTarget:self action:@selector(Touch_one:) forControlEvents:UIControlEventTouchDown];
    
    [TC_CenterView addSubview:tisp_lable];
    [TC_CenterView addSubview:miaoshu_lable];
    [TC_CenterView addSubview:Come_btn];
    [TC_CenterView addSubview:back_btn];
    [self.view addSubview:Tuicang_View];
    [self show_TCview];
}

/**
 密码输入框、、、弹出支付框
 */
-(void)addtextView_view
{
    __block LaundryDetailsViewController *  blockSelf = self;
    Tuicang_View=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    [Tuicang_View setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.9]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [Tuicang_View addGestureRecognizer:tapSuperGesture22];
    TC_CenterView = [[UIView alloc] initWithFrame:CGRectMake(38*autoSizeScaleX_6, 220*autoSizeScaleY_6, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 175)];
    [TC_CenterView setBackgroundColor:[UIColor whiteColor]];
    TC_CenterView.layer.cornerRadius=4;
    [Tuicang_View addSubview:TC_CenterView];
    tisp_lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 0)];
    [tisp_lable setText:@""];
    tisp_lable.font = [UIFont systemFontOfSize:14];
    //文字居中显示
    tisp_lable.textAlignment = NSTextAlignmentCenter;
    
    miaoshu_lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 70)];
    [miaoshu_lable setText:@"Please enter payment password"];
    miaoshu_lable.font = [UIFont systemFontOfSize:14];
    //文字居中显示
    miaoshu_lable.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    miaoshu_lable.numberOfLines = 0;
    textfiledView = [[TPPasswordTextView alloc] initWithFrame:CGRectMake((TC_CenterView.width-240)/2, 80+15, 240, 40)];
    textfiledView.elementCount = 6;
    //  背景色 方便  看
    textfiledView.backgroundColor = [UIColor whiteColor];
    //  距离
    textfiledView.elementMargin = 0;
    // 边框宽度
    textfiledView.elementBorderWidth = 1;
    closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(TC_CenterView.width-25, 5, 20, 20)];
    [closeBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [closeBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(Touch_two:) forControlEvents:UIControlEventTouchDown];
    [TC_CenterView addSubview:tisp_lable];
    [TC_CenterView addSubview:miaoshu_lable];
    [TC_CenterView addSubview:textfiledView];
    [TC_CenterView addSubview:closeBtn];
    [TC_CenterView addSubview:textfiledView];
//    [self.view addSubview:view1];
    
    textfiledView.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        if(password.length==6)
        {
            blockSelf.Pay_passwordStr=password;
            [blockSelf JYPayPassword];
        }
    };
    [self.view addSubview:Tuicang_View];
    [self show_TCview];
}
-(void)show_TCview
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
        self->Tuicang_View.frame=self.view.bounds;
    }];
    
}
-(void)hidden_TCview
{
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self->Tuicang_View.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        [self->Tuicang_View removeFromSuperview];
    }];
}
- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//    CGPoint location = [gesture locationInView:Tuicang_View];
//    CGRect rec = [self.view convertRect:TC_CenterView.frame   fromView:Tuicang_View];
////    NSLog(@"%@",NSStringFromCGRect(rec));
//    NSLog(@"location.x== %f,location.y== %f,",location.x,location.y);
//    NSLog(@"x== %f,y== %f,",rec.origin.x,rec.origin.y);
//    if(location.x<TC_CenterView.left)
//    {
//            [self hidden_TCview];
//            [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
//
//    }
}
-(void)Touch_one:(UIButton*)sender
{
    if([self.payment isEqualToString:@"1"])
    {
//        [self push_IPay];
    }else if([self.payment isEqualToString:@"2"])
    {
        NSLog(@"BTN.tag=%ld",(long)sender.tag);
        if(sender.tag==1002)
        {
            [self pushDetailsListViewController];
        }else{
        NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([ModeUser.payPassword isEqualToString:@""] && ModeUser.payPassword != nil)
        {
        
            [self hidden_TCview];
            [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            newPhoneViewController *vc=[main instantiateViewControllerWithIdentifier:@"newPhoneViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
                [self hidden_TCview];
                [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7/*延迟执行时间*/ * NSEC_PER_SEC));

                dispatch_after(delayTime, dispatch_get_main_queue(), ^{

                    [self addtextView_view];
                });
            
        }
        }
    }
}
-(void)Touch_two:(id)semder
{
    [self hidden_TCview];
    [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
//    [self pushDetailsListViewController];
}
/*
-(void)push_IPay:(NSString*)RefNo UrlStr:(NSString *)Url Remark:(NSString *)Remark Amount:(NSString *)Amount
{
    self.paymentSdk=nil;
    IPaypayment=nil;
    self.paymentSdk = [[Ipay alloc] init];
    self.paymentSdk.delegate = self;
    IPaypayment = [[IpayPayment alloc] init];
    [IPaypayment setPaymentId:@""];
    [IPaypayment setMerchantKey:@"KqeL5dOvy5"];
    [IPaypayment setMerchantCode:@"M13405"];
    [IPaypayment setRefNo:RefNo];
//    [IPaypayment setAmount:@"1.0"];/////暂时定为1元
    [IPaypayment setAmount:Amount];/////暂时定为1元
    [IPaypayment setCurrency:@"MYR"];
    [IPaypayment setProdDesc:[NSString stringWithFormat:@"%@%@",@"Payment for ",Remark]];
    [IPaypayment setUserName:@"John Woo"];
    [IPaypayment setUserEmail:@"johnwoo@yahoo.com"];
    [IPaypayment setUserContact:@"0123456789"];
    [IPaypayment setRemark:Remark];
//    [IPaypayment setRemark:@"ORD11881"];
    [IPaypayment setLang:@"ISO-8859-1"];
    [IPaypayment setCountry:@"MY"];
    [IPaypayment setBackendPostURL:Url];
    self.paymentView = [self.paymentSdk checkout:IPaypayment];
    self.paymentView.frame = self.view.bounds;
    [self.view addSubview:self.paymentView];
    
}
#pragma mark ------- Ipay 代理
//付款成功
- (void)paymentSuccess:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withAuthCode:(NSString *)authCode
{
    NSLog(@"paymentSuccess = %@",refNo);
    [self.paymentView removeFromSuperview];
    [self pushView:self.order_noStr];
}
//付款失败
- (void)paymentFailed:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc
{
    NSLog(@"paymentFailed refNo= %@ ,transId = %@ ,amount  = %@ ,remark = %@ ,errDesc = %@ ,",refNo,transId,amount,remark,errDesc);
}
//// 取消付款
- (void)paymentCancelled:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc
{
    NSLog(@"paymentCancelled = %@",refNo);
}
//重新查询成功
- (void)requerySuccess:(NSString *)refNo withMerchantCode:(NSString *)merchantCode withAmount:(NSString *)amount withResult:(NSString *)result
{
    NSLog(@"requerySuccess = %@",refNo);
}
//重新查询失败
- (void)requeryFailed:(NSString *)refNo withMerchantCode:(NSString *)merchantCode withAmount:(NSString *)amount withErrDesc:(NSString *)errDesc
{
    NSLog(@"requeryFailed = %@",refNo);
}
*/



-(void)pushView:(NSString *)orderidStr taskCommandStr:(NSString *)taskCommandStr
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LaundrySuccessViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundrySuccessViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.order_c=self.order_c;
    vc.orderidStr = orderidStr;
//    vc.taskCommandStr = taskCommandStr;
    vc.arrayList = self.arrayList;
    vc.addrStr = self.addrStr;
    vc.OrderAndRenewal = self.OrderAndRenewal;
    vc.OrderIdTime=self.OrderIdTime;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushDetailsListViewController
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RechargeViewController *vc=[main instantiateViewControllerWithIdentifier:@"RechargeViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//  校验支付密码
-(void)JYPayPassword
{
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"payPassword":self.Pay_passwordStr};
    NSLog(@"dict=== %@",dict);
    __block LaundryDetailsViewController *  blockSelf = self;
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_jiaoyanPayPassword] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"ObjectJY = %@",responseObject);
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * code= [dictObject objectForKey:@"result"];
        NSNumber * statusCodeBer =[dictObject objectForKey:@"statusCode"];
        
        
        if([statusCodeBer intValue] ==401)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
            self->payCheck=0;
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[HomeViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    
                }
            }
        }else{
        if([code intValue]==0)
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
            self->payCheck=0;
            [blockSelf->textfiledView clearPassword];
            [blockSelf tisp];
            
        }else
        {
            /* 屏蔽以前的直接创建订单。
            if([blockSelf.payment isEqualToString:@"1"])
                       {
                           self.order_c.payment_platform=@"Payment online";
                           self.order_c.coupon_code=@"";
                       }else if([blockSelf.payment isEqualToString:@"2"])
                       {
                           self.order_c.payment_platform=@"WALLET";
                           self.order_c.coupon_code=@"";
                       }
                       [blockSelf postOrder];
             */
            self->payCheck=1;
            [self nextPushView];
            
        }
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [blockSelf->textfiledView clearPassword];
        [HudViewFZ HiddenHud];
        self->payCheck=0;
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
////// 新创建订单
-(void)postOrder
{
//    [HudViewFZ labelExample:self.view];
    //    __block LaundryDetailsViewController *  blockSelf = self;
    NSDictionary *dict = @{@"machine_no":self.order_c.machine_no,
                           @"total_amount":self.order_c.total_amount,
                           @"order_type":self.order_c.order_type,
                           @"client_type":self.order_c.client_type,
                           @"goods_info":[jiamiStr convertToJSONData:self.order_c.goods_info],
                           @"pay_amount":self.order_c.pay_amount,/////需要支付金额
                           @"credits":self.order_c.credits, ////使用多少积分
                           @"coupon_code":self.order_c.coupon_code,//优惠券 先默认nil
                           @"payment_platform":self.order_c.payment_platform,//支付平台。 钱包:WALLET, iPay88:IPAY88
                           
                           };
    NSLog(@"dict ====%@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Pay_Newzhifu] parameters:dict progress:^(id progress) {
        NSLog(@"111  %@",progress);
    } Success:^(NSInteger statusCode,id responseObject) {
//        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
//        [HudViewFZ HiddenHud];
        if(statusCode==200)
        {
            
            NSDictionary * resp=(NSDictionary *)responseObject;
            NSNumber * code= [resp objectForKey:@"statusCode"];
            NSString * errorMessage= [resp objectForKey:@"errorMessage"];
            self->payAndSet=0;
            if([code intValue]==500){
                [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
            }else if([code intValue]==400509)
            {
                [HudViewFZ showMessageTitle:errorMessage andDelay:2.8];
                [self hidden_TCview];
                self->payAndSet=1;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self addselect_view:1];
                });
                
            }else
            {
                if([code intValue]==0)
                {
                    
                    if([self.payment isEqualToString:@"1"])
                    {
                        [self Touch_two:nil];
//                        NSString * pay_req_no= [resp objectForKey:@"pay_req_no"];
//                        NSString * notify_url= [resp objectForKey:@"notify_url"];
//                        NSString * pay_order_no= [resp objectForKey:@"pay_order_no"];
//                        NSString * strOrderID = [resp objectForKey:@"pay_order_id"];
//                        self.order_noStr = strOrderID;
//                        [self push_IPay:pay_req_no UrlStr:notify_url Remark:pay_order_no Amount:self.order_c.pay_amount];
                    }else if([self.payment isEqualToString:@"2"])
                    {
                        NSDictionary * orderDic = [resp objectForKey:@"order"];
                        NSString * order_no = [orderDic objectForKey:@"order_no"];
                        self.order_noStr = order_no;
//                        [self pushView:order_no];
                        [self pushView:self.order_noStr taskCommandStr:nil];
//                        [self Touch_two:nil];
//                        [self get_order_task_ZL:order_no];
                    }
                    
                }else
                {
                    [HudViewFZ HiddenHud];
                    
                    [HudViewFZ showMessageTitle:errorMessage andDelay:2.5];
                    [self Touch_two:nil];
                }
                
            }
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"3333   %@",error);
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
////// 新创建烘干续时订单
-(void)postOrderOrderRenewal
{
    NSDictionary *dict = @{@"mainOrderId":self.OrderIdTime,
                            @"total_amount":self.order_c.total_amount,
                            @"pay_amount":self.order_c.pay_amount,
                            @"goods_info":[jiamiStr convertToJSONData:self.order_c.goods_info],
                            @"credits":self.order_c.credits
    };
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_Ordertime] parameters:dict progress:^(id progress) {
        
    } Success:^(NSInteger statusCode, id responseObject) {
                NSLog(@"responseObject = %@",responseObject);
        //        [HudViewFZ HiddenHud];
                if(statusCode==200)
                {
                    
                    NSDictionary * resp=(NSDictionary *)responseObject;
                    NSNumber * code= [resp objectForKey:@"statusCode"];
                    NSString * errorMessage= [resp objectForKey:@"errorMessage"];
                    self->payAndSet=0;
                    if([code intValue]==500){
                        [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
                    }else if([code intValue]==400509)
                    {
                        [HudViewFZ showMessageTitle:errorMessage andDelay:2.8];
                        [self hidden_TCview];
                        self->payAndSet=1;
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7/*延迟执行时间*/ * NSEC_PER_SEC));
                        
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            [self addselect_view:1];
                        });
                        
                    }else
                    {
                        if([code intValue]==0)
                        {
                            if([self.payment isEqualToString:@"1"])
                            {
                                [self Touch_two:nil];
                        //                        NSString * pay_req_no= [resp objectForKey:@"pay_req_no"];
                        //                        NSString * notify_url= [resp objectForKey:@"notify_url"];
                        //                        NSString * pay_order_no= [resp objectForKey:@"pay_order_no"];
                        //                        NSString * strOrderID = [resp objectForKey:@"pay_order_id"];
                        //                        self.order_noStr = strOrderID;
                        //                        [self push_IPay:pay_req_no UrlStr:notify_url Remark:pay_order_no Amount:self.order_c.pay_amount];
                            }else if([self.payment isEqualToString:@"2"])
                            {
                                NSDictionary * orderDic = [resp objectForKey:@"order"];
                                NSString * order_no = [orderDic objectForKey:@"order_no"];
                                self.order_noStr = order_no;
//                                [self pushView:order_no];
                                [self pushView:self.order_noStr taskCommandStr:nil];
                        //                        [self Touch_two:nil];
                        //                        [self get_order_task_ZL:order_no];
                            }
                        }else
                        {
                            [HudViewFZ HiddenHud];
                            [HudViewFZ showMessageTitle:errorMessage andDelay:2.5];
                            [self Touch_two:nil];
                        }
                                        
                    }
                }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"44444   %@",error);
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

-(void)nextPushView
{
    [HudViewFZ labelExample:self.view];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    NSLog(@"Connected1=== %d",[appDelegate.appdelegate1 isConnected_to]);
        NSString * strMM = [NSString stringWithFormat:@"%@",self.arrayList[0]];
        if([strMM isEqualToString:@"20190605"]|| [strMM isEqualToString:@"P20191011"])//P2018080603
        {
            if([self.payment isEqualToString:@"1"])
            {
                self.order_c.payment_platform=@"Payment online";
                self.order_c.coupon_code=@"";
            }else if([self.payment isEqualToString:@"2"])
            {
                self.order_c.payment_platform=@"WALLET";
                self.order_c.coupon_code=@"";
            }
            if(self.OrderAndRenewal==1)
            {
                [self postOrder];
            }else if (self.OrderAndRenewal==2)
            {
                [self postOrderOrderRenewal];
            }
        }else
        {
            if([appDelegate.ManagerBLE returnConnect])
            {
//                [HudViewFZ HiddenHud];
                if([self.payment isEqualToString:@"1"])
                {
                    self.order_c.payment_platform=@"Payment online";
                    self.order_c.coupon_code=@"";
                }else if([self.payment isEqualToString:@"2"])
                {
                    self.order_c.payment_platform=@"WALLET";
                    self.order_c.coupon_code=@"";
                }
                if(self.OrderAndRenewal==1)
                {
                    [self postOrder];
                }else if (self.OrderAndRenewal==2)
                {
                    [self postOrderOrderRenewal];
                }
            }else
            {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self CycleNextPushView];
                });
            }
        }
}

-(void)CycleNextPushView
{
//    [HudViewFZ labelExample:self.view];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    NSLog(@"Connected1=== %d",[appDelegate.appdelegate1 isConnected_to]);
        NSString * strMM = [NSString stringWithFormat:@"%@",self.arrayList[0]];
        if([strMM isEqualToString:@"20190605"]|| [strMM isEqualToString:@"P20191011"])//P2018080603
        {
            if([self.payment isEqualToString:@"1"])
            {
                self.order_c.payment_platform=@"Payment online";
                self.order_c.coupon_code=@"";
            }else if([self.payment isEqualToString:@"2"])
            {
                self.order_c.payment_platform=@"WALLET";
                self.order_c.coupon_code=@"";
            }
            
            [self postOrder];
        }else
        {
            if([appDelegate.ManagerBLE returnConnect])
            {
//                [HudViewFZ HiddenHud];
                if([self.payment isEqualToString:@"1"])
                {
                    self.order_c.payment_platform=@"Payment online";
                    self.order_c.coupon_code=@"";
                }else if([self.payment isEqualToString:@"2"])
                {
                    self.order_c.payment_platform=@"WALLET";
                    self.order_c.coupon_code=@"";
                }
                [self postOrder];
            }else
            {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self CycleNextPushView];
                });
            }
        }
}
/*
-(void)nextPushView
{
    [HudViewFZ labelExample:self.view];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    NSLog(@"Connected1=== %d",[appDelegate.appdelegate1 isConnected_to]);
        NSString * strMM = [NSString stringWithFormat:@"%@",self.arrayList[0]];
        if([strMM isEqualToString:@"20190605"]|| [strMM isEqualToString:@"P20191011"])//P2018080603
        {
            if([self.payment isEqualToString:@"1"])
            {
                self.order_c.payment_platform=@"Payment online";
                self.order_c.coupon_code=@"";
            }else if([self.payment isEqualToString:@"2"])
            {
                self.order_c.payment_platform=@"WALLET";
                self.order_c.coupon_code=@"";
            }
            
            [self postOrder];
        }else
        {
            if([appDelegate.appdelegate1 isConnected_to])
            {
//                [HudViewFZ HiddenHud];
                if([self.payment isEqualToString:@"1"])
                {
                    self.order_c.payment_platform=@"Payment online";
                    self.order_c.coupon_code=@"";
                }else if([self.payment isEqualToString:@"2"])
                {
                    self.order_c.payment_platform=@"WALLET";
                    self.order_c.coupon_code=@"";
                }
                [self postOrder];
            }else
            {
                
            }
        }
}
 */
-(void)bearerDidOpen:(NSNotification *)noti {
//    NSDictionary *dic = [noti userInfo];
    NSLog(@"LaundryDetailsViewController重连蓝牙连接成功");
    if(self->payCheck==1)
    {
        [self nextPushView ];
    }
}


//-(void)postOrder
//{
//    [HudViewFZ labelExample:self.view];
////    __block LaundryDetailsViewController *  blockSelf = self;
//    NSDictionary *dict = @{@"machine_no":self.order_c.machine_no, @"total_amount":self.order_c.total_amount, @"order_type":self.order_c.order_type, @"client_type":self.order_c.client_type, @"goods_info":[jiamiStr convertToJSONData:self.order_c.goods_info]};
//    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_order] parameters:dict progress:^(id progress) {
//        NSLog(@"111  %@",progress);
//    } Success:^(NSInteger statusCode,id responseObject) {
//        [HudViewFZ HiddenHud];
//        NSLog(@"responseObject = %@",responseObject);
//        [HudViewFZ HiddenHud];
//        if(statusCode==200)
//        {
//
//            NSDictionary * resp=(NSDictionary *)responseObject;
//            NSNumber * code= [resp objectForKey:@"statusCode"];
//            NSString * errorMessage= [resp objectForKey:@"errorMessage"];
//            if([code intValue]==500){
//                 [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
//            }else if([code intValue]==400509)
//            {
//                [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
//            }else
//            {
//                [self pushView];
//            }
//
//        }
//
//    } failure:^(NSInteger statusCode, NSError *error) {
//        NSLog(@"3333   %@",error);
//        [HudViewFZ HiddenHud];
//        if(statusCode==401)
//        {
//            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
//            //创建一个消息对象
//            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
//            //发送消息
//            [[NSNotificationCenter defaultCenter]postNotification:notice];
//
//        }else{
//            [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
//
//        }
//    }];
//
//}
-(void)tisp
{
    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Wrong password", @"Language") andDelay:2.0];
}

-(void)get_order_task_ZL:(NSString *)orderidStr
{
    [HudViewFZ labelExample:self.view];
    NSLog(@"GetOrder URL = %@",[NSString stringWithFormat:@"%@%@%@/task",FuWuQiUrl,get_order_task,orderidStr]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@%@/task",FuWuQiUrl,get_order_task,orderidStr] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject=  %@",responseObject);
        
        //        NSDictionary * dictionary = (NSDictionary*)responseObject;
        //
        //        NSArray * resultListArr=[dictionary objectForKey:@"resultList"];
        
        NSDictionary * dictionary = (NSDictionary *)responseObject;
        NSString * taskCommand=[dictionary objectForKey:@"taskCommand"];
//        self.taskCommandStr = taskCommand;
        [self sendStrCmd:taskCommand];
//        [self sendDeviceData:@"01017880-0000-0000-83cd-c0bb04840000" taskCommand:taskCommand];
        
//        @"031119190001110e0066";
        
    } failure:^(NSInteger statusCode, NSError *error) {
    
        [HudViewFZ HiddenHud];
   
    }];
}
-(void)sendStrCmd:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@";"];
    for (int i=0; i<array.count; i++) {
        NSString * strCommand = array[i];
        /*
        [self sendDeviceData:@"" taskCommand:strCommand];
         */
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //    [appDelegate.appdelegate1 closeConnected];
        NSString * deviceName = self.arrayList[1];
        NSData * dataAAA = [self getData:strCommand];
        if([appDelegate.appdelegate1 isConnected_to])
        {
            [appDelegate.appdelegate1 dataSendWithNameStr:deviceName dataA:dataAAA];
        }else{
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Bluetooth disconnected", @"Language") andDelay:2.5];
        }
//    [HudViewFZ HiddenHud];
        if(array.count==1)
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [HudViewFZ HiddenHud];
//                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"未收到Return data", @"Language") andDelay:2.5];
                
                [self pushView:self.order_noStr taskCommandStr:str];
            });
        }else{
        if(i==1)
        {
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [HudViewFZ HiddenHud];
//                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"未收到Return data", @"Language") andDelay:2.5];
                
                [self pushView:self.order_noStr taskCommandStr:str];
            });
            
            break;
        }
            [NSThread sleepForTimeInterval:10.0];
        }
        
    }
}
- (NSData *) getData: (NSString *) t {
    NSString * d = t;
    if (d == nil || d.length == 0) d = @"00";
    
//    NSLog(@"数据 ： = %@",[NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]);
//    return decodeHex([NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]);
    return [self convertHexStrToData:[NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]];
    
}
// 十六进制字符串转换成NSData
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = arr_title[section];
    return arr.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arr_title.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0)
    {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
//        cell.textLabel.backgroundColor=[UIColor redColor];
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [cell.contentView addSubview:lbl];
        NSArray * arr =arr_title[indexPath.section];
        cell.textLabel.text = arr[indexPath.row];
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==0)
    {
        if( indexPath.row==1 ||  indexPath.row==2)
        {
        SelectTableViewCell *cell1 = (SelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableViewCellID];
        if (cell1 == nil) {
            cell1= (SelectTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"SelectTableViewCell" owner:self options:nil]  lastObject];
        }
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell1.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [cell1.contentView addSubview:lbl];
            NSArray * arr =arr_title[indexPath.section];
            cell1.title_label.text = arr[indexPath.row];
            
                if(indexPath.row==1)
                {
                    /*
                    [cell1.left_btn setImage:[UIImage imageNamed:@"payment-method_IPy88"] forState:UIControlStateNormal];
                    if([self.payment isEqualToString:@"1"])
                    {
                        [cell1.right_btn setImage:[UIImage imageNamed:@"check-circle-fill"] forState:UIControlStateNormal];
                    }else if ([self.payment isEqualToString:@"2"])
                    {
                       [cell1.right_btn setImage:[UIImage imageNamed:@"circleNil"] forState:UIControlStateNormal];
                    }
                    
                }else if(indexPath.row==2)
                {*/
                    [cell1.left_btn setImage:[UIImage imageNamed:@"payment-method_wallet"] forState:UIControlStateNormal];
                    if([self.payment isEqualToString:@"1"])
                    {
                        [cell1.right_btn setImage:[UIImage imageNamed:@"circleNil"] forState:UIControlStateNormal];
                    }else if ([self.payment isEqualToString:@"2"])
                    {
                        
                        [cell1.right_btn setImage:[UIImage imageNamed:@"check-circle-fill"] forState:UIControlStateNormal];
                    }
                }
                
            
        //cell选中效果
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
            
        }
    }else if(indexPath.section==1 && indexPath.row==0)
    {
        integralTableViewCell *cell1 = (integralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:integralTableViewCellID];
        if (cell1 == nil) {
            cell1= (integralTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"integralTableViewCell" owner:self options:nil]  lastObject];
        }
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell1.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [cell1.contentView addSubview:lbl];
        cell1.delegate=self;
        NSArray * arr =arr_title[indexPath.section];
        cell1.topLabel.text = [NSString stringWithFormat:@"%@%@",arr[indexPath.row],self.credit];
        NSLog(@"对比 = %f,%f",[self.credit floatValue] ,[self.order_c.total_amount floatValue]*100);
        if([self.credit floatValue] >= [self.order_c.total_amount floatValue]*100 ){
            cell1.downLabel.text = [NSString stringWithFormat:@"%@:%@,%@ :%.2f",FGGetStringWithKeyFromTable(@"Total", @"Language"),self.credit,FGGetStringWithKeyFromTable(@"discount", @"Language"),[self.credit floatValue]/100.f];
            cell1.right_switch.hidden=NO;
        }else
        {
            cell1.downLabel.text = [NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Reward points isn’t not enough to pay", @"Language")];
            cell1.right_switch.hidden=YES;
        }
        if([self.credit_yn isEqualToString:@"1"])
        {
            [cell1.right_switch setOn:NO];
        }else if ([self.credit_yn isEqualToString:@"2"])
        {
            [cell1.right_switch setOn:YES];
        }
        
        
        //定制开关颜色UI
        //tintColor 关状态下的背景颜色
//        cell1.right_switch.tintColor = [UIColor whiteColor];
        //onTintColor 开状态下的背景颜色
        cell1.right_switch.onTintColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
        //cell选中效果
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.layer.cornerRadius = 4;
        return cell1;
    }
    
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
    {
        return 0;
    }
    return 8.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
        return CGFLOAT_MIN;//最小数，相当于0
    }
    return 0;//机器不可识别，然后自动返回默认高度
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //自定义间隔view，可以不写默认用系统的
    UIView * view_c= [[UIView alloc] init];
    view_c.frame=CGRectMake(0, 0, 0, 0);
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    integralTableViewCell * cell1 = (integralTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0)
    {
        if(indexPath.row==1)
        {
            /*
            self.payment = @"1";
            [self.tableViewDonw reloadData];
            
        }else if(indexPath.row==2)
        {*/
            self.payment = @"2";
            
            [self.tableViewDonw reloadData];
            /////屏蔽
//            NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
//            SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//            if([ModeUser.payPassword isEqualToString:@""] && ModeUser.payPassword != nil)
//            {
////                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
////                newPhoneViewController *vc=[main instantiateViewControllerWithIdentifier:@"newPhoneViewController"];
////                vc.hidesBottomBarWhenPushed = YES;
////                [self.navigationController pushViewController:vc animated:YES];
//                payAndSet=2;
//                [self addselect_view:2];
//            }else
//            {
            
                payAndSet=0;
//            }
        }
    }else if (indexPath.section==1)
    {
       
    }
}


#pragma mark   -----  integralTableViewCellCellDelegate  -----
-(void)switchtouch:(NSInteger)key_Int
{
    if(key_Int==0)
    {
        self.credit_yn=@"1";
        [self updatePostValue];
    }else if(key_Int==1)
    {
        self.credit_yn=@"2";
        [self updatePostValue];
    }
}

@end
