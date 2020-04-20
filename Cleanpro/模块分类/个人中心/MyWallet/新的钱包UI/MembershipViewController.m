//
//  MembershipViewController.m
//  Cleanpro
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MembershipViewController.h"
#import "RechargeViewController.h"
#import "ReloadTableViewCell.h"
#import "BalanceTableViewCell.h"
#import "MyAccountViewController.h"

#define tableID @"ReloadTableViewCell"
#define tableID1 @"BalanceTableViewCell"
@interface MembershipViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ReloadTableViewCell *cellReload;
    BalanceTableViewCell *cellBalance;
}
@property (nonatomic , strong)UITableView * tableView;
@end

@implementation MembershipViewController
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    tableView = [[UITableView alloc] init];
    tableView.frame=CGRectMake(16, 0, (SCREEN_WIDTH-16*2), 6*60+8);
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"ReloadTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    [tableView registerNib:[UINib nibWithNibName:@"BalanceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID1];
}
- (void)viewWillAppear:(BOOL)animated {
   
    [self getToken];
    [self Get_wallet_A];
    
    [super viewWillAppear:animated];
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
            self.credit = [dictObject objectForKey:@"credit"];
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
    [cellBalance.left_Money setText:[NSString stringWithFormat:@"%.2f",[self.balance floatValue]/100.0]];
    [cellBalance.Right_Points setText:[NSString stringWithFormat:@"%@",self.credit]];
}



#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section==0)
   {
       cellReload = (ReloadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
       if (cellReload == nil) {
           cellReload= (ReloadTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ReloadTableViewCell" owner:self options:nil]  lastObject];
       }
       
       //cell选中效果
       cellReload.selectionStyle = UITableViewCellSelectionStyleNone;
       dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
       
       dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//           self->cellReload.layer.cornerRadius=10;
           self->cellReload.ReloadBtn.layer.cornerRadius= 15;
           self->cellReload.ReloadBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
           self->cellReload.ReloadBtn.layer.borderWidth = 1;
           UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self->cellReload.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = self->cellReload.bounds;
           maskLayer.path = maskPath.CGPath;
           self->cellReload.layer.mask = maskLayer;
           
       });
       cellReload.layer.cornerRadius=10;
       return cellReload;
   }else if(indexPath.section==1)
   {
       cellBalance = (BalanceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID1];
       if (cellBalance == nil) {
           cellBalance= (BalanceTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"BalanceTableViewCell" owner:self options:nil]  lastObject];
       }
//       UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
//       lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
//       lbl.backgroundColor =  [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
//       [cell.contentView addSubview:lbl];
       //cell选中效果
       cellBalance.selectionStyle = UITableViewCellSelectionStyleNone;
       if(self.balance!=nil)
       {
           [cellBalance.left_Money setText:[NSString stringWithFormat:@"%.2f",[self.balance floatValue]/100.0]];
           [cellBalance.Right_Points setText:[NSString stringWithFormat:@"%@",self.credit]];
       }
       dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
       
       dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//           self->cellBalance.layer.cornerRadius=4;
           
       });
       self->cellBalance.layer.cornerRadius=4;
       return cellBalance;
   }
    return nil;
}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24.f;
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
    
    return 100;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RechargeViewController *vc=[main instantiateViewControllerWithIdentifier:@"RechargeViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
