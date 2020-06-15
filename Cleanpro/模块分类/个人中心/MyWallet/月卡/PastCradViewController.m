//
//  PastCradViewController.m
//  Cleanpro
//
//  Created by mac on 2020/6/11.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PastCradViewController.h"
#import "PastCradTableViewCell.h"
#import "PastCardCenterTableViewCell.h"
#import "PastCardPayView.h"
#import "newPhoneViewController.h"


#define tableID @"PastCradTableViewCell"
#define tableID1 @"PastCardCenterTableViewCell"
@interface PastCradViewController ()<UITableViewDelegate,UITableViewDataSource,PastCardPayViewDelegate>
{
    UIView * Tuicang_View1;
    UITapGestureRecognizer *tapSuperGesture22;
    UIView * Tuicang_View;
    UIView * TC_CenterView;
    UILabel * tisp_lable;
    UILabel * miaoshu_lable;
    UIButton * Come_btn;
    UIButton * back_btn;
    
    ///// textfiledView
    TPPasswordTextView *textfiledView;
    UIButton * closeBtn;
}
@property (nonatomic,strong)NSNumber * credit;////积分
@property (nonatomic,strong)NSNumber * balance;///余额
@property (nonatomic,strong)NSNumber * totalAmount;///总金额
@property(strong,nonatomic)NSMutableArray * CellArray;
@property(strong,nonatomic)NSMutableArray * SelectCellArray;
@property(strong,nonatomic)NSMutableArray * MONTHLYCellArray;
@property(strong,nonatomic)NSMutableArray * HOURCellArray;
@property(strong,nonatomic)NSArray * PaymentArray;
@end

@implementation PastCradViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {//解决iOS 10 版本scrollView下滑问题。
            
            self.TableviewS.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
    self.title = FGGetStringWithKeyFromTable(@"Past Card", @"Language");
    self.view.backgroundColor=rgba(243, 243, 243, 1);
    self.CellArray = [NSMutableArray arrayWithCapacity:0];
    self.SelectCellArray= [NSMutableArray arrayWithCapacity:0];
    self.MONTHLYCellArray= [NSMutableArray arrayWithCapacity:0];
    self.HOURCellArray= [NSMutableArray arrayWithCapacity:0];
    self.PaymentArray=@[@"Wallet Pay"];
    
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self addTableViewList];
            [self loadNewData];
        });
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
//    self.title=FGGetStringWithKeyFromTable(@"Details", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.credit=[[NSNumber alloc] initWithInt:0];
    self.balance=[[NSNumber alloc] initWithInt:0];
    self.totalAmount=[[NSNumber alloc] initWithInt:0];
    [self.Right_PriceBtn setBackgroundColor:rgba(152, 169, 179, 1)];
    self.Right_PriceBtn.userInteractionEnabled=NO;
    [self.Right_PriceBtn setTitle:[NSString stringWithFormat:@"%@",self.totalAmount] forState:(UIControlStateNormal)];
    [self.Right_PriceBtn setTintColor:[UIColor whiteColor]];
    [self getToken];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)getToken
{
    [HudViewFZ labelExample:self.view];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * tokenStr = [userDefaults objectForKey:@"Token"];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_GetToken] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"111responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
        
        
        if([statusCode intValue] ==401)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:@"Token"];
            [userDefaults setObject:@"1" forKey:@"phoneNumber"];
            [userDefaults setObject:nil forKey:@"SaveUserMode"];
            [userDefaults setObject:@"1" forKey:@"logCamera"];
            //    [defaults synchronize];
            NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else if([statusCode intValue] ==401)
        {
            NSString * errorMessage =[dictObject objectForKey:@"errorMessage"];;
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
        }else{
                    NSString*tokenStr = [dictObject objectForKey:@"token"];
                    NSString*phoneNumberStr = [dictObject objectForKey:@"mobile"];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:tokenStr forKey:@"Token"];
                    [userDefaults setObject:phoneNumberStr forKey:@"phoneNumber"];
                    [userDefaults setObject:@"2" forKey:@"logCamera"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
                    //            NSString * IDStr = [dictObject objectForKey:@"id"];
                    NSDictionary * wallet = [dictObject objectForKey:@"wallet"];
                    NSNumber * ba = [wallet objectForKey:@"balance"];
                    NSString * balanceStr =[ba stringValue];
                    //            NSString * currencyUnitStr = [wallet objectForKey:@"currencyUnit"];
                    //            self.currencyUnitStr = [cur stringValue];
                    NSNumber * credit = [wallet objectForKey:@"credit"];
                    NSString * creditStr = [credit stringValue];
                    NSNumber * coupon = [dictObject objectForKey:@"couponCount"];
                    NSString *couponCountStr = [coupon stringValue];
                    self.balance = ba;
//                    self.currencyUnit = [dictObject objectForKey:@"currencyUnit"];
                    self.credit = [dictObject objectForKey:@"credit"];
//            self.currencyUnit = [dictObject objectForKey:@"currencyUnit"];
                    //            用来储存用户信息
                    
                    SaveUserIDMode * mode = [[SaveUserIDMode alloc] init];
                    
                    mode.phoneNumber = [dictObject objectForKey:@"mobile"];//   手机号码
                    mode.loginName = [dictObject objectForKey:@"username"];//   与手机号码相同
                    mode.yonghuID = [dictObject objectForKey:@"memberId"]; ////用户ID
                    //            mode.randomPassword = [dictObject objectForKey:@"randomPassword"];//  验证码
                    //            mode.password = [dictObject objectForKey:@"password"];//  登录密码
                    //            mode.payPassword = [dictObject objectForKey:@"payPassword"];//    支付密码
                    mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
                    mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
                    NSString * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
                    if(![birthdayNum isEqual:[NSNull null]])
                    {
        //                mode.birthday = [birthdayNum ];;
                        NSInteger num = [birthdayNum integerValue];
                        NSNumber * nums = @(num);
                        mode.birthday = [nums stringValue];;
                    }
                    mode.gender = [dictObject objectForKey:@"gender"];//       MALE:男，FEMALE:女
                    mode.postCode = [dictObject objectForKey:@"postCode"];//   Post Code inviteCode
                    mode.EmailStr = [dictObject objectForKey:@"email"];//   email
                    mode.inviteCode = [dictObject objectForKey:@"inviteCode"];//       我填写的邀请码
                    mode.myInviteCode = [dictObject objectForKey:@"myInviteCode"];//       我的邀请码
                    mode.headImageUrl = [dictObject objectForKey:@"headImageId"];
                    mode.payPassword = [dictObject objectForKey:@"payPassword"];
                    ////个人中心需要用到积分
                    mode.credit = creditStr;
                    mode.balance = balanceStr;
                    mode.couponCount = couponCountStr;
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    //存储到NSUserDefaults（转NSData存）
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
                     NSLog(@"测试断点5555");
                    [defaults setObject:data forKey:@"SaveUserMode"];
                    [defaults synchronize];
                    [jiamiStr base64Data_encrypt:mode.yonghuID];
        //            [self addDownScroller];
                     
                }
    } failure:^(NSInteger statusCode, NSError *error) {
           NSLog(@"error = %@",error);
           [HudViewFZ HiddenHud];
           if(statusCode==401)
           {
               [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
               [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"SetNSUserDefaults" object:nil userInfo:nil]];
               [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil]];
           }else{
               [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
               
           }
       }];
}



- (IBAction)Pay_touch:(id)sender {
   
    [self Popupview];
}

-(void)Popupview
{
//    __block PastCradViewController *  blockSelf = self;
    Tuicang_View1=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    [Tuicang_View1 setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.9]];
    
//    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView1:)];
//    tapSuperGesture22.delegate = self;
//    [Tuicang_View1 addGestureRecognizer:tapSuperGesture22];
    
    PastCardPayView * PayView=[[PastCardPayView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-(220+80*(self.PaymentArray.count-1)), SCREEN_WIDTH, (220+80*(self.PaymentArray.count-1))) array:self.PaymentArray balance:self.balance totalAmount:self.totalAmount];
    PayView.delegate=self;
    [Tuicang_View1 addSubview:PayView];
    [self.view addSubview:Tuicang_View1];
    [self show_TCview1];
}
-(void)show_TCview1
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
        self->Tuicang_View1.frame=self.view.bounds;
    }];
    
}
-(void)hidden_TCview1
{
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self->Tuicang_View1.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
//        [self->Tuicang_View removeFromSuperview];
        [self->Tuicang_View1 setHidden:YES];
    }];
}
#pragma mark ------ PastCardPayViewDelegate  -----
-(void)SelectTouch:(NSInteger)CellIndex selectArr:(NSMutableArray*)selectArr
{
    ///   //100 代表删除 Close  101表示 Pay
    if(CellIndex==100)
    {
        [self hidden_TCview1];
    }else if(CellIndex==101)
    {
        for (int i=0; i<self.PaymentArray.count; i++) {
            NSString * str=selectArr[0];
            NSString * strA=self.PaymentArray[i];
            if([str isEqualToString:strA])
            {
//                [self buyCard:<#(NSString *)#> Cradarray:<#(NSArray *)#>];
                 [self Get_existPassword];
                
            }
        }
        
    }
}
-(void)SelectCell:(NSInteger)CellIndex
{
    if(CellIndex==0)
    {
        
    }
}
-(void)Get_existPassword
{
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_existPassword] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"existPassword = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * result =[dictObject objectForKey:@"result"];
        if([result integerValue]==0)
        {
            NSData * data1 =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
            SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
            ModeUser.payPassword=@"";
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                       //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: ModeUser];
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            
            [self addTips_view:2];
            
        }else{
            NSData * data1 =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
            SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
            ModeUser.payPassword=@"6666";
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                       //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: ModeUser];
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            
            [self addPasswordView];
//            14.14 14.89 14.40 14.59
        }
    }failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
    }];
        
}
//  购买月卡
-(void)buyCard:(NSString*)Pay_passwordStr Cradarray:(NSArray*)arr
{
    [HudViewFZ labelExample:self.view];
    PastCardMode* mode=(PastCardMode*)arr[0];
    NSDictionary * dict=@{@"payPassword":Pay_passwordStr,
                          @"monthCardId":mode.monthCardId,
                          @"amount":self.totalAmount,};
    NSLog(@"dict=== %@",dict);
//    __block PastCradViewController *  blockSelf = self;
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_buyMonthCard] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"ObjectJY = %@",responseObject);
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * result = [dictObject objectForKey:@"result"];
        if([result intValue]==1)
        {
            [self pushView];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        
    }];
}

-(void)pushView
{
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    LaundrySuccessViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundrySuccessViewController"];
//    vc.hidesBottomBarWhenPushed = YES;
////    vc.order_c=self.order_c;
//    [self.navigationController pushViewController:vc animated:YES];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Tisp" message:@"Card purchase success" preferredStyle:UIAlertControllerStyleActionSheet];
    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了按钮1，进入按钮1的事件");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark ------- 全屏View 背景透明 --------


/**
 密码输入框、、、弹出支付框
 */
-(void)addPasswordView
{
    __block PastCradViewController *  blockSelf = self;
    Tuicang_View1=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    [Tuicang_View1 setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.9]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView222:)];
//    tapSuperGesture22.delegate = self;
    [Tuicang_View1 addGestureRecognizer:tapSuperGesture22];
    TC_CenterView = [[UIView alloc] initWithFrame:CGRectMake(38*autoSizeScaleX_6, 220*autoSizeScaleY_6, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 175)];
    [TC_CenterView setBackgroundColor:[UIColor whiteColor]];
    TC_CenterView.layer.cornerRadius=4;
    [Tuicang_View1 addSubview:TC_CenterView];
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
    [closeBtn addTarget:self action:@selector(Touch_two222) forControlEvents:UIControlEventTouchDown];
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
//            [blockSelf JYPayPassword]; ///屏蔽校验密码 后台校验
            [blockSelf buyCard:password Cradarray:blockSelf.SelectCellArray];
        }
    };
    [self.view addSubview:Tuicang_View1];
    [self show_TCview1];
}
//-(void)show_TCview
//{
//    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
//        //执行的动画
//        self->Tuicang_View.frame=self.view.bounds;
//    }];
//
//}
//-(void)hidden_TCview
//{
//    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
//        //执行的动画
//        self->Tuicang_View.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
//    }completion:^(BOOL finished){
//        //动画执行完毕后的操作
////        [self->Tuicang_View removeFromSuperview];
//        [self->Tuicang_View setHidden:YES];
//    }];
//}
-(void)Touch_two222
{
    [self hidden_TCview1];
}
- (void)tapSuperView222:(UITapGestureRecognizer *)gesture {
//    [self hidden_TCview1];
}
/**
 全屏View 背景透明
   
 */
-(void)addselect_view
{
    Tuicang_View=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    [Tuicang_View setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.3]];
    
//    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
//    tapSuperGesture22.delegate = self;
//    [Tuicang_View addGestureRecognizer:tapSuperGesture22];
    TC_CenterView = [[UIView alloc] initWithFrame:CGRectMake(38*autoSizeScaleX_6, 220*autoSizeScaleY_6, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 175)];
    [TC_CenterView setBackgroundColor:[UIColor whiteColor]];
    TC_CenterView.layer.cornerRadius=4;
    [Tuicang_View addSubview:TC_CenterView];
    tisp_lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 0)];
    [tisp_lable setText:@""];
    tisp_lable.font = [UIFont systemFontOfSize:14];
    //文字居中显示
    tisp_lable.textAlignment = NSTextAlignmentCenter;
    
    miaoshu_lable=[[UILabel alloc] initWithFrame:CGRectMake(16, 15, TC_CenterView.width-(16*2), 90)];
//    if(index==1)
//    {
//        [miaoshu_lable setText:FGGetStringWithKeyFromTable(@"Please set your payment password!", @"Language")];
//    }else if(index==2)
//    {
        [miaoshu_lable setText:FGGetStringWithKeyFromTable(@"Your current card purchases have not been exhausted, please purchase them after using them.", @"Language")];
//    }
    miaoshu_lable.font = [UIFont systemFontOfSize:16];
    //文字居中显示
    miaoshu_lable.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    miaoshu_lable.numberOfLines = 0;
    back_btn = [[UIButton alloc] initWithFrame:CGRectMake((TC_CenterView.width-100)/2, 100+15, 100, 40)];
    [back_btn setTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") forState:UIControlStateNormal];
//    [back_btn setBackgroundColor:[UIColor whiteColor]];
    [back_btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [back_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    back_btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    back_btn.layer.cornerRadius=4;
    back_btn.layer.borderColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0].CGColor;//设置边框颜色
    [back_btn addTarget:self action:@selector(Touch_OK:) forControlEvents:UIControlEventTouchDown];
//    Come_btn = [[UIButton alloc] initWithFrame:CGRectMake(29*autoSizeScaleX_6+(SCREEN_WIDTH-(38*autoSizeScaleX_6*2)-100*2-29*autoSizeScaleX_6*2)+100, 80+15, 100, 40)];
//
//    [Come_btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
//    [Come_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    Come_btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//    Come_btn.layer.cornerRadius=4;
//    Come_btn.layer.borderColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0].CGColor;//设置边框颜色
//    Come_btn.layer.borderWidth = 1.0f;//设置边框颜色
//    [Come_btn addTarget:self action:@selector(Touch_one:) forControlEvents:UIControlEventTouchDown];
    
    [TC_CenterView addSubview:tisp_lable];
    [TC_CenterView addSubview:miaoshu_lable];
//    [TC_CenterView addSubview:Come_btn];
    [TC_CenterView addSubview:back_btn];
    [self.view addSubview:Tuicang_View];
    [self show_TCview];
}

/**
 全屏View 背景透明 //没钱支付的时候提示他需要充值
 index  1是 没钱提醒充值  2是 没有设置支付密码
 */
-(void)addTips_view:(NSInteger)index
{
    Tuicang_View=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    [Tuicang_View setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.3]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
//    tapSuperGesture22.delegate = self;
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
    [back_btn addTarget:self action:@selector(back_Touch:) forControlEvents:UIControlEventTouchDown];
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
    
    [Come_btn addTarget:self action:@selector(Come_Touch:) forControlEvents:UIControlEventTouchDown];
    
    [TC_CenterView addSubview:tisp_lable];
    [TC_CenterView addSubview:miaoshu_lable];
    [TC_CenterView addSubview:Come_btn];
    [TC_CenterView addSubview:back_btn];
    [self.view addSubview:Tuicang_View];
    [self show_TCview];
}

-(void)Come_Touch:(UIButton*)sender
{
    if(sender.tag==1002)
    {
//        [self pushDetailsListViewController];
    }else if(sender.tag==1001){
        NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if([ModeUser.payPassword isEqualToString:@""] && ModeUser.payPassword != nil)
    {
    
        [self hidden_TCview];
        [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        newPhoneViewController *vc=[main instantiateViewControllerWithIdentifier:@"newPhoneViewController"];
        vc.index=1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    }
}
-(void)back_Touch:(UIButton*)sender
{
     [self hidden_TCview];
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
//        [self->Tuicang_View removeFromSuperview];
        [self->Tuicang_View setHidden:YES];
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
-(void)Touch_OK:(UIButton*)sender
{
    [self hidden_TCview];
}

-(void)addTableViewList
{

    self.TableviewS.frame=CGRectMake(16, kNavBarAndStatusBarHeight, SCREEN_WIDTH-(16*2),SCREEN_HEIGHT-(kNavBarAndStatusBarHeight)-(self.DownView.height));
//    self.tableView_top.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-0);
    self.TableviewS.delegate=self;
    self.TableviewS.dataSource=self;
    self.TableviewS.backgroundColor=rgba(243, 243, 243, 1);
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.TableviewS.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.TableviewS.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.TableviewS];
    [self.TableviewS registerNib:[UINib nibWithNibName:@"PastCradTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    [self.TableviewS registerNib:[UINib nibWithNibName:@"PastCardCenterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID1];

    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = NO;
    // 设置文字
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    self.TableviewS.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.TableviewS.mj_header=header;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
//    // 隐藏状态
//    foot.stateLabel.hidden = NO;
//    // 设置文字
//    [foot setTitle:@"Drop down to refresh more" forState:MJRefreshStateIdle];
//    [foot setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
//    [foot setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
//    // 设置字体
//    foot.stateLabel.font = [UIFont systemFontOfSize:15];
//    // 设置颜色
//    foot.stateLabel.textColor = [UIColor blackColor];
//    self.TableviewS.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//    }];
//    self.TableviewS.mj_footer =foot;
//    self.tableView_top.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    //    // 马上进入刷新状态
//        [self.tableView_top.mj_header beginRefreshing];
}
-(void)loadNewData
{
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_Getcardinfo] parameters:nil progress:^(id progress) {
           //        NSLog(@"请求成功 = %@",progress);
       } success:^(id responseObject) {
           NSLog(@"E_Getcardinfo = %@",responseObject);
           NSArray * Array = (NSArray * )responseObject;
           if(Array.count>0)
           {
               [self.CellArray removeAllObjects];
               [self.HOURCellArray removeAllObjects];
               [self.MONTHLYCellArray removeAllObjects];
               for (int i=0; i<Array.count; i++) {
                   NSDictionary * dict= Array[i];
                   PastCardMode* mode=[[PastCardMode alloc] init];
                   mode.count=[dict objectForKey:@"count"];
                   mode.creationTime=[dict objectForKey:@"creationTime"];
                   mode.currentCost=[dict objectForKey:@"currentCost"];
                   mode.dayInterval=[dict objectForKey:@"dayInterval"];
                   mode.deleteFlag=[dict objectForKey:@"deleteFlag"];
                   mode.description1=[dict objectForKey:@"description"];
                   mode.enDescription=[dict objectForKey:@"enDescription"];
                   mode.lastUpdatedTime=[dict objectForKey:@"lastUpdatedTime"];
                   mode.monthCardId=[dict objectForKey:@"monthCardId"];
                   mode.monthCardType=[dict objectForKey:@"monthCardType"];
                   mode.originalCost=[dict objectForKey:@"originalCost"];
                   mode.timeInterval=[dict objectForKey:@"timeInterval"];
                   if([mode.monthCardType isEqualToString:@"MEMBER_MONTHLY_CARD"])
                   {
                       [self.MONTHLYCellArray addObject:mode];
                   }else if([mode.monthCardType isEqualToString:@"HAPPY_HOUR_CARD"])
                   {
                       [self.HOURCellArray addObject:mode];
                   }
                   
               }
//               [self.SelectCellArray removeAllObjects];
//               [self.SelectCellArray addObject:self.MONTHLYCellArray[0]];
//               if(self.SelectCellArray.count>0)
//               {
//                   PastCardMode* Smode=self.SelectCellArray[0];
//                   self.totalAmount=Smode.currentCost;
//               }
               [self.CellArray addObject:@"Member monthly card"];
               for (int l=0; l<self.MONTHLYCellArray.count; l++) {
                   [self.CellArray addObject:self.MONTHLYCellArray[l]];
               }
//               [self.CellArray addObject:arrCard];
               [self.CellArray addObject:@"Happy Hour card"];
               for (int p=0; p<self.HOURCellArray.count; p++) {
                   [self.CellArray addObject:self.HOURCellArray[p]];
               }
//               [self.CellArray addObject:arrCard1];
               [self.CellArray addObject:@"Card purchase instructions"];
               [self.CellArray addObject:@"1.Limited to washing/drying orders;\n2.This benefit is provided by Cleanpro, please contact Cleanpro if you have any questions;"];
               [self.TableviewS reloadData];
               [self.TableviewS.mj_header endRefreshing];
           }else{
               [self.TableviewS.mj_header endRefreshing];
           }
           
       } failure:^(NSInteger statusCode, NSError *error) {
           [self.TableviewS.mj_header endRefreshing];
           if(statusCode==401)
           {
               [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
               [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"SetNSUserDefaults" object:nil userInfo:nil]];
               [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil]];
               
           }else{
            [HudViewFZ showMessageTitle:[self dictStr:error] andDelay:2.0];
            [HudViewFZ HiddenHud];
               
           }
       }];
}

-(void)loadFootData
{
    
}

-(NSString *)dictStr:(NSError *)error
{
//    NSString * receive=@"";
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//    receive= [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSString  * message = [dictFromData valueForKey:@"message"];
//
    return message;
}
-(NSNumber *)dictCodeStr:(NSError *)error
{
//    NSString * receive=@"";
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//    receive= [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSNumber * errorCode = [dictFromData valueForKey:@"errorCode"];
//
    return errorCode;
}
-(NSString *)dictMessageStr:(NSError *)error
{
//    NSString * receive=@"";
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//    receive= [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSString * message = [dictFromData valueForKey:@"message"];
    return message;
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//        NSArray * arr=self.CellArray[section];
//        return arr.count;
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return self.CellArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 || indexPath.section==(self.MONTHLYCellArray.count+1) || indexPath.section==(self.MONTHLYCellArray.count+2+self.HOURCellArray.count))
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        }
        cell.backgroundColor=rgba(243, 243, 243, 1);
                    //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        NSString * str = self.CellArray[indexPath.section];;
        [self setlabelTextBlck:str label:cell.textLabel];
        return cell;
    }else if(indexPath.section==(self.CellArray.count-1))
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
                }
                
            cell.backgroundColor=rgba(243, 243, 243, 1);
                //cell选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment=NSTextAlignmentLeft;
            NSString * str = self.CellArray[indexPath.section];;
            [self setlabelText:str label:cell.textLabel];
            return cell;
        
    }else{
//        NSLog(@"indexPath.section== %ld",(long)indexPath.section);
    PastCradTableViewCell *cell = (PastCradTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (PastCradTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PastCradTableViewCell" owner:self options:nil]  lastObject];
    }
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSArray * array= self.CellArray[indexPath.section];
    PastCardMode * mode =self.CellArray[indexPath.section];
        cell.RightTopPrice_label.text=[mode.currentCost stringValue];
//        cell.DownPrice_label.text=[mode.originalCost stringValue];
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[mode.originalCost stringValue] attributes:attribtDic];
        // 赋值
        cell.DownPrice_label.attributedText = attribtStr;
        cell.TitleMS_label.text=mode.description1;
        cell.DownMS_label.text=mode.enDescription;
        //设置边框颜色
         if(self.SelectCellArray.count>0)
         {
             PastCardMode * modeS = self.SelectCellArray[0];
             if([modeS.monthCardId isEqualToString:mode.monthCardId])
             {
                 //设置边框颜色rgba(26, 149, 229, 1)
                 cell.layer.borderColor = [[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1] CGColor];
             }else{
                  cell.layer.borderColor = [[UIColor clearColor] CGColor];
             }
         }else{
              cell.layer.borderColor = [[UIColor clearColor] CGColor];
         }
        //设置边框宽度
         cell.layer.borderWidth = 1.0f;
        cell.layer.cornerRadius=4.f;
        if([mode.monthCardType isEqualToString:@"HAPPY_HOUR_CARD"])
        {
            return cell;
        }else if([mode.monthCardType isEqualToString:@"MEMBER_MONTHLY_CARD"])
        {
            PastCardCenterTableViewCell *Macell = (PastCardCenterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID1];
            if (Macell == nil) {
                Macell= (PastCardCenterTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PastCardCenterTableViewCell" owner:self options:nil]  lastObject];
            }
            //cell选中效果
            Macell.selectionStyle = UITableViewCellSelectionStyleNone;
//            NSArray * array= self.CellArray[indexPath.section];
            PastCardMode * modeA =self.CellArray[indexPath.section];
                Macell.topPrice_label.text=[modeA.currentCost stringValue];
//                cell1.DownPrice_label.text=[mode.originalCost stringValue];
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[modeA.originalCost stringValue] attributes:attribtDic];
            // 赋值
            Macell.DownPrice_label.attributedText = attribtStr;
            Macell.title_label.text=modeA.description1;
            
            if(self.SelectCellArray.count>0)
            {
                PastCardMode * modeS = self.SelectCellArray[0];
                if([modeS.monthCardId isEqualToString:modeA.monthCardId])
                {
                    //设置边框颜色rgba(26, 149, 229, 1)
                    Macell.layer.borderColor = [[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1] CGColor];
                }else{
                     Macell.layer.borderColor = [[UIColor clearColor] CGColor];
                }
            }else{
                 Macell.layer.borderColor = [[UIColor clearColor] CGColor];
            }
            
            //设置边框宽度
             Macell.layer.borderWidth = 1.0f;
            Macell.layer.cornerRadius=4.f;
            return Macell;
        }
    return cell;
    }
    return nil;
}

-(void)setlabelText:(NSString*)str label:(UILabel*)Label_Z
{
    
//    Label_Z.lineBreakMode = NSLineBreakByCharWrapping;
    Label_Z.numberOfLines = 0;
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第一段：placeholder
//    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
//    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:str];
//    [SubStr1 appendAttributedString:substring1];
//    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
//    //设置文字颜色
//    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
//    //设置文字大小
//    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang];
//    [string appendAttributedString:SubStr1];
    // 第二段：placeholder
    NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:str];
    [SubStr2 appendAttributedString:substring2];
    NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
    //设置文字颜色
    [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] range:rang2];
    //设置文字大小
        [SubStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang2];//AppleGothic
    [string appendAttributedString:SubStr2];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [Label_Z.text length])];
    Label_Z.attributedText=string;

}

-(void)setlabelTextBlck:(NSString*)str label:(UILabel*)Label_Z
{
    
//    Label_Z.lineBreakMode = NSLineBreakByCharWrapping;
    Label_Z.numberOfLines = 0;
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第一段：placeholder
//    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
//    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:str];
//    [SubStr1 appendAttributedString:substring1];
//    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
//    //设置文字颜色
//    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
//    //设置文字大小
//    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang];
//    [string appendAttributedString:SubStr1];
    // 第二段：placeholder
    NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:str];
    [SubStr2 appendAttributedString:substring2];
    NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
    //设置文字颜色
    [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang2];
    //设置文字大小
        [SubStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.f] range:rang2];//AppleGothic
    [string appendAttributedString:SubStr2];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [Label_Z.text length])];
    Label_Z.attributedText=string;

}


//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section>0 && section<=(self.MONTHLYCellArray.count) )
    {
        return 10;;
    }
    return 0.f;
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
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 || indexPath.section==(self.MONTHLYCellArray.count+1) || indexPath.section==(self.MONTHLYCellArray.count+2+self.HOURCellArray.count))
    {
        return 40;
    }
    return 80;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    if(indexPath.section==0 || indexPath.section==(self.MONTHLYCellArray.count+1) || indexPath.section==(self.MONTHLYCellArray.count+2+self.HOURCellArray.count) || indexPath.section==(self.CellArray.count-1))
    {
        
    }else{
        [self contrastList:indexPath];
    }
}
-(void)iseqModeRowAtIndexPath:(NSIndexPath *)indexPath
{
    PastCardMode * mode =self.CellArray[indexPath.section];
    [self.SelectCellArray removeAllObjects];
    [self.SelectCellArray addObject:mode];
    if(self.SelectCellArray.count>0)
    {
        PastCardMode* Smode=self.SelectCellArray[0];
        self.totalAmount=Smode.currentCost;
    }
    self.Right_PriceBtn.userInteractionEnabled=YES;
    [self.Right_PriceBtn setBackgroundColor:rgba(26, 114, 229, 1)];
    [self.Right_PriceBtn setTitle:[NSString stringWithFormat:@"%@",self.totalAmount] forState:(UIControlStateNormal)];
    [self.Right_PriceBtn setTintColor:[UIColor whiteColor]];
    [self.TableviewS reloadData];
}
-(void)contrastList:(NSIndexPath *)indexPath
{
    [HudViewFZ labelExample:self.view];;
    PastCardMode * modeSelect =self.CellArray[indexPath.section];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_infoMonthCardLog] parameters:nil progress:^(id progress) {
               //        NSLog(@"请求成功 = %@",progress);
           } success:^(id responseObject) {
               NSLog(@"E_Getcardinfo = %@",responseObject);
               [HudViewFZ HiddenHud];
//               NSDictionary*  DictZ=(NSDictionary*)responseObject;
               NSArray * Array = (NSArray * )responseObject;
               if(Array.count>0)
               {
                   NSMutableArray * arrayMu=[NSMutableArray arrayWithCapacity:0];
                   for (int i=0; i<Array.count; i++) {
                       NSDictionary * dict= Array[i];
                       PastCardInfoMonthCardLogMode* mode=[[PastCardInfoMonthCardLogMode alloc] init];
                       mode.buyTime=[dict objectForKey:@"buyTime"];
                       mode.count=[dict objectForKey:@"count"];
                       mode.currentCost=[dict objectForKey:@"currentCost"];
                       mode.deleteFlags=[dict objectForKey:@"deleteFlags"];
                       mode.dayInterval=[dict objectForKey:@"dayInterval"];
                       mode.description1=[dict objectForKey:@"description"];
                       mode.enDescription=[dict objectForKey:@"enDescription"];
                       mode.expireTime=[dict objectForKey:@"expireTime"];
                       mode.monthCardId=[dict objectForKey:@"monthCardId"] ;
                       mode.monthCardType=[dict objectForKey:@"monthCardType"];
                       mode.originalCost=[dict objectForKey:@"originalCost"] ;
                       mode.residueCount=[dict objectForKey:@"residueCount"] ;
                       mode.timeInterval=[dict objectForKey:@"timeInterval"] ;
                       mode.useCurrentCost=[dict objectForKey:@"useCurrentCost"] ;
                       [arrayMu addObject:mode];
                       
                   }
                   
                   NSInteger flag=0;
                   for (int A=0; A<arrayMu.count; A++) {
                       PastCardInfoMonthCardLogMode* modeMu=arrayMu[A];
                       if([modeMu.deleteFlags intValue]==0)
                       {
                           if([modeMu.monthCardType isEqualToString:modeSelect.monthCardType])
                           {
                               flag=1;
                               
                           }
                       }
                   }
                   if(flag==0)
                   {
                       [self iseqModeRowAtIndexPath:indexPath];
                   }else
                   {
                       [self addselect_view];
                   }
                   
               }else{
                   [HudViewFZ HiddenHud];
                   [self iseqModeRowAtIndexPath:indexPath];
               }
               
           } failure:^(NSInteger statusCode, NSError *error) {
               [HudViewFZ HiddenHud];
               if(statusCode==401)
               {
                   [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
                   [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"SetNSUserDefaults" object:nil userInfo:nil]];
                   [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil]];
                   
               }else{
                [HudViewFZ showMessageTitle:[self dictStr:error] andDelay:2.0];
                [HudViewFZ HiddenHud];
                   
               }
           }];
}


@end
