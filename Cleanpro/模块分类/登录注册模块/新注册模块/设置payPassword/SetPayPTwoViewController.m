//
//  SetPayPTwoViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SetPayPTwoViewController.h"
#import "MyWalletViewController.h"
#import "LaundryDetailsViewController.h"
#import "SettingViewController.h"
#import "EwashMyViewController.h"
#import "AddressSViewController.h"
#import "MembershipViewController.h"
#import "PastCradViewController.h"

@interface SetPayPTwoViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@end

@implementation SetPayPTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.next_btn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1].CGColor;//设置边框颜色
    //    self.Skip_btn.layer.borderWidth = 1.0f;//设置边框颜色
    [self.title_text setText:FGGetStringWithKeyFromTable(@"Please enter again", @"Language")];
    [self.pay_textfeld setPlaceholder:FGGetStringWithKeyFromTable(@"Password", @"Language")];
    [self.next_btn setTitle:FGGetStringWithKeyFromTable(@"Next", @"Language") forState:(UIControlStateNormal)];
    
    self.pay_textfeld.keyboardType = UIKeyboardTypeNumberPad;
    self.pay_textfeld.secureTextEntry = YES;
    self.pay_textfeld.layer.cornerRadius=4;
    self.pay_textfeld.delegate=self;
    self.next_btn.layer.cornerRadius=4;
    [self.next_btn setUserInteractionEnabled:NO];
    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [self setCodetuiguang];
    });
    //    设置点击任何其他位置 键盘回收
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self addNoticeForKeyboard];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    self.navigationItem.backBarButtonItem = backBtn;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}


#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //    获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.next_btn.top+self.next_btn.height+kbHeight) - (self.view.frame.size.height);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
            self.view.frame = [UIScreen mainScreen].bounds;
//            self.view.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}



-(void)setCodetuiguang
{
    __block SetPayPTwoViewController *  weakSelf = self;
    
    HWTFCodeView *code1View = [[HWTFCodeView alloc] initWithCount:6 margin:10 payanskip:1];
    code1View.frame = CGRectMake(self.pay_textfeld.left, self.pay_textfeld.top, self.pay_textfeld.width/4*3, self.pay_textfeld.height);
    [self.view addSubview:code1View];
    self.Code_tuiguang1 = code1View;
    self.Code_tuiguang1.passwordBlock = ^(NSString *password) {
        NSLog(@"password = %@",password);
        
        weakSelf.PayPassWordStr=password;
        if(weakSelf.PayPassWordStr.length==6)
        {
            //            self.Nextmode.inviteCode=weakSelf.inviteCode;
            //            [weakSelf postRegister];
            weakSelf.payStringTwo=password;
            [self.next_btn setUserInteractionEnabled:YES];
            self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
        }else
        {
            //                    [weakSelf GB_backgroundColor];
            [self.next_btn setUserInteractionEnabled:NO];
            self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
        }
        
    };
    
}
- (IBAction)next_touch:(id)sender {
    if([self.payStringOne isEqualToString:self.payStringTwo])
    {
        if(self.index==1){
            [self postRegister];
        }else if (self.index==2)
        {
            
//                [self setPostPasswrod];
            [self ResetPostPasswrod];
        }else if (self.index==3)
        {
            [self setPostPasswrod];
        }
    }else{
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The passwords do not match", @"Language") andDelay:2.0];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//-(void)postRegister
//{
//    NSDictionary * dict=@{@"validateCode":self.validateCode,
//                          @"payPassword":self.payStringTwo,
//                          };
//
//    NSLog(@"dict=== %@",dict);
//    [HudViewFZ labelExample:self.view];
////    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,setPay_password] parameters:dict progress:^(id progress) {
//    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,setPay_password] parameters:dict progress:^(id progress) {
//        NSLog(@"请求成功 = %@",progress);
//    }Success:^(NSInteger statusCode,id responseObject) {
//        [HudViewFZ HiddenHud];
//        NSLog(@"responseObject = %@",responseObject);
//        if(statusCode==200)
//        {
//            [self getToken];
//
//            //            [self.navigationController popToViewController:LoginViewController animated:YES];
//
//
//        }else
//        {
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
//        }
//    } failure:^(NSInteger statusCode, NSError *error) {
//        NSLog(@"error = %@",error);
//        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
//        [HudViewFZ HiddenHud];
//    }];
//}


-(void)postRegister
{
    NSDictionary * dict=@{@"validateCode":self.validateCode,
                          @"newPayPassword":self.payStringTwo,
                          };
     
    NSLog(@"dict=== %@",dict);
    [HudViewFZ labelExample:self.view];
//    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,setPay_password] parameters:dict progress:^(id progress) {
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_setPayPassword] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject1 = %@",responseObject);
        if(statusCode==200)
        {
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            NSNumber * result =[dictObject objectForKey:@"result"];
            if([result integerValue]==1)
            {
                [self Get_existPassword];
            }
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        NSString * strMessage = [self dictStr:error];
        [HudViewFZ showMessageTitle:strMessage andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}

-(void)Get_existPassword
{
    
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
        }else{
            NSData * data1 =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
            SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
            ModeUser.payPassword=@"6666";
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                       //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: ModeUser];
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            
        }
        [self PopViewcontroller];
    }failure:^(NSInteger statusCode, NSError *error) {
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
/*
-(void)getToken
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * tokenStr = [userDefaults objectForKey:@"Token"];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?userToken=%@",FuWuQiUrl,get_tokenUser,TokenStr] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
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
            
        }else if([statusCode intValue] ==500)
        {
            NSString * errorMessage =[dictObject objectForKey:@"errorMessage"];;
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
        }else{
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
            ////个人中心需要用到积分
            mode.credit = creditStr;
            mode.balance = balanceStr;
            mode.couponCount = couponCountStr;
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
            
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            [jiamiStr base64Data_encrypt:mode.yonghuID];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Set up the success", @"Language") andDelay:2.0];
            [self PopViewcontroller];
            
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
 */
-(void)PopViewcontroller
{
    if(self.index==1)
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LaundryDetailsViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }else if ([controller isKindOfClass:[AddressSViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }else if ([controller isKindOfClass:[PastCradViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MembershipViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }else if ([controller isKindOfClass:[AddressSViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }else if ([controller isKindOfClass:[SettingViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }else if ([controller isKindOfClass:[LaundryDetailsViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
   
    
}
/*
-(void)setPostPasswrod
{
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"payPassword":self.payStringTwo,
                          @"oldPayPassword":self.PayOldPassWordStr,
                          };
    NSLog(@"dict=== %@",dict);
    __block SetPayPTwoViewController *  blockSelf = self;
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_XiugaiPayPassword] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            NSDictionary *dict = (NSDictionary*)responseObject;
            NSString * payPassword = [dict objectForKey:@"payPassword"];
            if(payPassword!=nil)
                {
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Set up the success", @"Language") andDelay:2.0];
                    //            [self.navigationController popToViewController:LoginViewController animated:YES];
                    [self PopViewcontroller];
                }else
                {
                    NSString*errorMessage = [dict objectForKey:@"errorMessage"];
                    [HudViewFZ showMessageTitle:errorMessage andDelay:2.5];
                }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"StatusCode error", @"Language") andDelay:2.0];
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
 */



-(void)setPostPasswrod
{
    NSDictionary * dict=@{@"oldPayPassword":self.PayOldPassWordStr,
                          @"newPayPassword":self.payStringTwo,
                          };
     
    NSLog(@"dict=== %@",dict);
    [HudViewFZ labelExample:self.view];
//    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,setPay_password] parameters:dict progress:^(id progress) {
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_updatePassword] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject2 = %@",responseObject);
        if(statusCode==200)
        {
            
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            NSNumber * result =[dictObject objectForKey:@"result"];
            if([result integerValue]==1)
            {
            //            [self.navigationController popToViewController:LoginViewController animated:YES];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Set up the success", @"Language") andDelay:2.0];
            [self Get_existPassword];
            
            }
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        
        NSString * strMessage = [self dictStr:error];
        [HudViewFZ showMessageTitle:strMessage andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}



-(void)ResetPostPasswrod
{
    NSDictionary * dict=@{@"validateCode":self.validateCode,
                          @"newPayPassword":self.payStringTwo,
    };
     
    NSLog(@"dict=== %@",dict);
    [HudViewFZ labelExample:self.view];
//    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,setPay_password] parameters:dict progress:^(id progress) {
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_resetPassword] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject2 = %@",responseObject);
        if(statusCode==200)
        {
            
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            NSNumber * result =[dictObject objectForKey:@"result"];
            if([result integerValue]==1)
            {
            //            [self.navigationController popToViewController:LoginViewController animated:YES];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Set up the success", @"Language") andDelay:2.0];
            [self Get_existPassword];
            
            }
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        NSString * strMessage = [self dictStr:error];
        [HudViewFZ showMessageTitle:strMessage andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
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
#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.pay_textfeld) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [self.next_btn setUserInteractionEnabled:NO];
                self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                self.PayPassWordStr=self.pay_textfeld.text;
                self.payStringTwo=self.pay_textfeld.text;
            });
            return YES;
        }else if (self.pay_textfeld.text.length >= 5) {
            self.pay_textfeld.text = [[textField.text stringByAppendingString:string] substringToIndex:6];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                if (self.pay_textfeld.text.length == 6) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    self.PayPassWordStr=self.pay_textfeld.text;
                    self.payStringTwo=self.pay_textfeld.text;
                }
            });
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                //                [self.getCode_btn setUserInteractionEnabled:NO];
                //                [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
                //
                [self.next_btn setUserInteractionEnabled:NO];
                self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                self.PayPassWordStr=self.pay_textfeld.text;
                self.payStringTwo=self.pay_textfeld.text;
            });
        }
    }
    return YES;
}

@end
