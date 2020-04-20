//
//  MyWalletViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyWalletViewController.h"
#import "RechargeViewController.h"
#import "RechargeErViewController.h"
#import "DetailsListViewController.h"
#import "MyAccountViewController.h"
#import "newPhoneViewController.h"
#import "ExistingPayViewController.h"



@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * arrtitle;
@property (nonatomic,strong)UIImageView * image_b;
@end

@implementation MyWalletViewController
@synthesize arrtitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrtitle=[NSArray arrayWithObjects:FGGetStringWithKeyFromTable(@"Reload", @"Language"), nil];
    self.label_title.text = FGGetStringWithKeyFromTable(@"Account balance", @"Language");
//    [self.RMB setText:@"RM100.00"];
   [self.RMB setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
//    self.RMB.textColor = [UIColor colorWithRed:51.0026/255.0 green:51.0026/255.0 blue:51.0026/255.0 alpha:1];
    self.RMB.textColor = [UIColor whiteColor];
//    [self.topView setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    
    [self addUIBarButtonItem];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bgnav"]forBarMetrics:UIBarMetricsCompact];
//    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"bgnav"]];
    
}

-(void)addUIBarButtonItem
{
    UIButton * btn1 = [[UIButton alloc] init];
    [btn1 setTitle:FGGetStringWithKeyFromTable(@"Details", @"Language") forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:255/255.0 green:207/255.0 blue:6/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
     UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//        UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer1.width = -20; self.navigationItem.rightBarButtonItems = @[negativeSpacer1,self.navigationItem.leftBarButtonItem];
        self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)viewWillAppear:(BOOL)animated {
   
    self.title=FGGetStringWithKeyFromTable(@"My Wallet", @"Language");
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if(self.image_b==nil)
        {
            self.image_b = [[UIImageView alloc] initWithFrame:self.topView.frame];
            [self.image_b setImage:[UIImage imageNamed:@"my-wallet_bg"]];
            [self.topView addSubview:self.image_b];
            [self.topView sendSubviewToBack:self.image_b];
        }
        [self addsetTableView];
        
    });
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    SaveUserIDMode * mode  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.RMB setText:mode.balance];
    [self getToken];
    [self Get_wallet_A];
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    // 第二种办法：在隐藏导航栏的时候要添加动画
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //去除导航栏下方的横线
 self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}
-(void)selectRightAction:(id)sender
{
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailsListViewController *vc=[main instantiateViewControllerWithIdentifier:@"DetailsListViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
 
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillDisappear:animated];

    // 第二种办法：在显示导航栏的时候要添加动画
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = NO;
}

-(void)getToken
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * tokenStr = [userDefaults objectForKey:@"Token"];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?userToken=%@",FuWuQiUrl,get_tokenUser,TokenStr] parameters:nil progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"111responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
        
        
        if([statusCode intValue] ==401)
        {
            //            [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
            //            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
            //            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            //            for (UIViewController *controller in self.navigationController.viewControllers) {
            //                if ([controller isKindOfClass:[MyAccountViewController class]]) {
            //                    [self.navigationController popToViewController:controller animated:YES];
            //
            //                }
            //            }
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
//            NSDictionary * wallet = [dictObject objectForKey:@"wallet"];
//            NSNumber * ba = [wallet objectForKey:@"balance"];
//            //            self.currencyUnitStr = [cur stringValue];
//            NSNumber * credit = [dictObject objectForKey:@"credit"];
//            self.creditStr = [credit stringValue];
//            NSNumber * coupon = [dictObject objectForKey:@"couponCount"];
//            self.couponCountStr = [coupon stringValue];
            //            用来储存用户信息
            
            SaveUserIDMode * mode = [[SaveUserIDMode alloc] init];
            
            mode.phoneNumber = [dictObject objectForKey:@"phoneNumber"];//   手机号码
            mode.loginName = [dictObject objectForKey:@"loginName"];//   与手机号码相同
            mode.yonghuID = [dictObject objectForKey:@"id"]; ////用户ID
            //            mode.randomPassword = [dictObject objectForKey:@"randomPassword"];//  验证码
            //            mode.password = [dictObject objectForKey:@"password"];//  登录密码
            //            mode.payPassword = [dictObject objectForKey:@"payPassword"];//    支付密码
            mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
            mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
            NSNumber * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
            mode.birthday = [birthdayNum stringValue];
            mode.gender = [dictObject objectForKey:@"gender"];//       MALE:男，FEMALE:女
            mode.postCode = [dictObject objectForKey:@"postCode"];//   Post Code inviteCode
            mode.EmailStr = [dictObject objectForKey:@"email"];//   email
            mode.inviteCode = [dictObject objectForKey:@"inviteCode"];//       我填写的邀请码
            mode.myInviteCode = [dictObject objectForKey:@"myInviteCode"];//       我的邀请码
            mode.headImageUrl = [dictObject objectForKey:@"headImageUrl"];
            mode.payPassword = [dictObject objectForKey:@"payPassword"];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
            
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            [jiamiStr base64Data_encrypt:mode.yonghuID];
            
            
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
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:@"Token"];
            [userDefaults setObject:@"1" forKey:@"phoneNumber"];
            [userDefaults setObject:nil forKey:@"SaveUserMode"];
            [userDefaults setObject:@"1" forKey:@"logCamera"];
            //    [defaults synchronize];
            NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MyAccountViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    
                }
            }
        }else{
            self.balance = [dictObject objectForKey:@"balance"];
            self.currencyUnit = [dictObject objectForKey:@"currencyUnit"];
            [self update_label];
            
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        if(statusCode==401)
        {
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else{
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            
        }
    }];
}


-(void)update_label
{
//    [self.RMB setText:[NSString stringWithFormat:@"%@%.2f",self.currencyUnit,[self.balance floatValue]/100.0]];
    [self.RMB setText:[NSString stringWithFormat:@"%.2f",[self.balance floatValue]/100.0]];
}

-(void)addsetTableView
{
//    self.Down_tableView.frame=CGRectMake(0, self.topView.bottom+10, SCREEN_WIDTH, SCREEN_HEIGHT-self.topView.height-15);
    self.Down_tableView.frame=CGRectMake(0, self.topView.bottom+10, SCREEN_WIDTH, 51*arrtitle.count);
    
    self.Down_tableView.delegate=self;
    self.Down_tableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.Down_tableView.scrollEnabled = NO;  ////设置tableview不上下滑动
    self.Down_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.Set_tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:self.Down_tableView];
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrtitle.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [arrtitle objectAtIndex:indexPath.row];
    
    //    NSLog(@"%ld",(long)indexPath.row);
    if(indexPath.row==0)
    {
        cell.imageView.image=[UIImage imageNamed:@"wallet_recharge"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    /*else if (indexPath.row==1)
    {
        cell.imageView.image=[UIImage imageNamed:@"me_settings"];
    }
     */
    //    if(indexPath.row!=3)
    //    {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    //    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    cell.layer.cornerRadius=4;
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 51;
}

//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RechargeViewController *vc=[main instantiateViewControllerWithIdentifier:@"RechargeViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1)
    {
        /*
        NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([ModeUser.payPassword isEqualToString:@""] && ModeUser.payPassword != nil)
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            newPhoneViewController *vc=[main instantiateViewControllerWithIdentifier:@"newPhoneViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ExistingPayViewController *vc=[main instantiateViewControllerWithIdentifier:@"ExistingPayViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        */
        
    }
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
