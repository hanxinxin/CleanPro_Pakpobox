//
//  LoginViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "MyAccountViewController.h"
#import "HomeViewController.h"
#import "WelcomeViewController.h"
#import "BarViewController.h"
#import "WCQRCodeScanningVC.h"
#import "LMJDropdownMenu.h"
#import "UIBezierPathView.h"
@interface LoginViewController ()<LMJDropdownMenuDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSArray *DQNumber;
@property(nonatomic,strong)NSString * diquStr;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.phone_textfiled.borderStyle=;
//    self.phone_textfiled.clearButtonMode = UITextFieldViewModeAlways;
    
    [self.Forget_btn setTitle:FGGetStringWithKeyFromTable(@"Forget password?", @"Language") forState:(UIControlStateNormal)];
    [self.Register_btn setTitle:FGGetStringWithKeyFromTable(@"Register", @"Language") forState:(UIControlStateNormal)];
    self.phone_textfiled.placeholder=FGGetStringWithKeyFromTable(@"Mobile No.", @"Language");
    self.verification_textfiled.placeholder=FGGetStringWithKeyFromTable(@"Password", @"Language");
    [self.SignIn_btn setTitle:FGGetStringWithKeyFromTable(@"Sign in", @"Language") forState:(UIControlStateNormal)];
    self.phone_textfiled.keyboardType = UIKeyboardTypeNumberPad;
    self.phone_textfiled.delegate=self;
    self.topview.layer.cornerRadius=4;
    [UIBezierPathView setCornerOnRight:4 view_b:self.phone_textfiled];
//    self.verification_textfiled.clearButtonMode = UITextFieldViewModeAlways;
    self.verification_textfiled.keyboardType = UIKeyboardTypeASCIICapable;
    self.verification_textfiled.delegate=self;
    self.verification_textfiled.layer.cornerRadius=4;
    self.verification_textfiled.secureTextEntry=YES;
    self.SignIn_btn.layer.cornerRadius=4;
    self.SignIn_btn.userInteractionEnabled=NO;
//    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
    //    设置点击任何其他位置 键盘回收
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。//点击空白处取消TextField的第一响应
    [self.view addGestureRecognizer:tapGesture];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self setDiqu_select];
    });
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //    self.navigationController.navigationBar.translucent = YES;
//    self.title=@"login";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:NO];
    [self addNoticeForKeyboard];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
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
    CGFloat offset = (self.SignIn_btn.top+self.SignIn_btn.height+kbHeight) - (SCREEN_HEIGHT);
    
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
    }];
}


- (IBAction)back_touch:(id)sender {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[BarViewController class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"phoneNumber"];
//                [self.navigationController popToViewController:controller animated:NO];
                [self.navigationController popViewControllerAnimated:NO];
                
            }else
            {

                    [self.navigationController popViewControllerAnimated:NO];
            }
        }
}
// 点击back按钮后调用 引用的他人写的一个extension
- (BOOL)navigationShouldPopOnBackButton {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BarViewController class]]) {
//            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"phoneNumber"];
            //                [self.navigationController popToViewController:controller animated:NO];
            [self.navigationController popViewControllerAnimated:NO];
            return NO;
        }else if ([controller isKindOfClass:[WCQRCodeScanningVC class]]) {
//            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"phoneNumber"];
            //                [self.navigationController popToViewController:controller animated:NO];
            [self.navigationController popViewControllerAnimated:NO];
            return NO;
        }
    }
    return YES;
}

-(void)setDiqu_select
{
    self.DQNumber=@[@"+60",@"+86",@"+65",@"+66"];;
    //    self.DQNumber=@[@"+60"];
    self.diquStr=self.DQNumber[0];
    // 控件的创建
    LMJDropdownMenu * dropdownMenu = [[LMJDropdownMenu alloc] init];
    dropdownMenu.Style=1;
    [dropdownMenu setFrame:self.quhao_btn.frame];
    [UIBezierPathView setCornerOnLeft:4 view_b:dropdownMenu.mainBtn];
    [dropdownMenu setMenuTitles:self.DQNumber rowHeight:40];
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
    
}
//去掉+号
-(NSString*)strDiqu:(NSString *)urlString
{
    NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@"+" withString:@""];//替换字符
    return strUrl;
}
#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",number);
    self.diquStr=self.DQNumber[number];
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    //    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    //    NSLog(@"--已经显示--");
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    //    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    //    NSLog(@"--已经隐藏--");
}


- (IBAction)Register_touch:(id)sender {
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    RegisterViewController *vc=[main instantiateViewControllerWithIdentifier:@"RegisterViewController"];
//    vc.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    [self.navigationController pushViewController:vc animated:YES];
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *vc=[main instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)SignIn_touch:(id)sender {
    ///密码长度 大于6小于16
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"account":self.phone_textfiled.text,
                          @"password":self.verification_textfiled.text,};
    NSLog(@"dict=== %@    url === %@",dict,[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_login]);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_login] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            NSString*tokenStr = [dictObject objectForKey:@"token"];
            NSString*phoneNumberStr = [dictObject objectForKey:@"phoneNumber"];
            NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if([statusCode intValue] ==400001)
            {
                NSString*errorMessage = [dictObject objectForKey:@"errorMessage"];
                [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
            }if([statusCode intValue] ==400002)
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Password error", @"Language") andDelay:2.0];
            }else if(statusCode==nil){
                [userDefaults setObject:tokenStr forKey:@"Token"];
                [userDefaults setObject:phoneNumberStr forKey:@"phoneNumber"];
                [userDefaults setObject:@"2" forKey:@"logCamera"];
                
            [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
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
                NSDictionary * wallet = [dictObject objectForKey:@"wallet"];
                NSNumber * ba = [wallet objectForKey:@"balance"];
                NSString * balanceStr =[ba stringValue];
                NSNumber * credit = [wallet objectForKey:@"credit"];
                NSString * creditStr = [credit stringValue];
//                NSNumber * coupon = [dictObject objectForKey:@"couponCount"];
//                NSString * couponCountStr = [coupon stringValue];
                mode.credit = creditStr;
                mode.balance = balanceStr;
//                mode.couponCount = couponCountStr;
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                //存储到NSUserDefaults（转NSData存）
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
                
                [defaults setObject:data forKey:@"SaveUserMode"];
                [defaults synchronize];
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Login successful", @"Language") andDelay:2.0];
                NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[HomeViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                        
                    }
                }
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[MyAccountViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[WCQRCodeScanningVC class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[BarViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
                
            }
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
    
}
- (IBAction)Forget_touch:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgetPasswordViewController *vc=[main instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    vc.hidesBottomBarWhenPushed = YES;
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
#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phone_textfiled) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                //                NSLog(@"CCCC =  %d",self.phone_textfiled.text.length );
                if (self.phone_textfiled.text.length == 9 || self.phone_textfiled.text.length ==10 || self.phone_textfiled.text.length ==11) {
                    [self.SignIn_btn setUserInteractionEnabled:YES];
                    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                }else{
                    [self.SignIn_btn setUserInteractionEnabled:NO];
                    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                }
            });
            return YES;
        }
        //so easy
        else if (self.phone_textfiled.text.length >= 10) {
            self.phone_textfiled.text = [[textField.text stringByAppendingString:string] substringToIndex:11];
//            NSLog(@"self.phone_textfiled.text =  %ld",self.phone_textfiled.text.length );
            if (self.verification_textfiled.text.length >=6) {
                
            [self.SignIn_btn setUserInteractionEnabled:YES];
           self.SignIn_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            }else{
                [self.SignIn_btn setUserInteractionEnabled:NO];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
            }
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                NSLog(@"self.phone_textfiled =  %ld",self.phone_textfiled.text.length );
            if(self.phone_textfiled.text.length > 8)
            {
            if (self.verification_textfiled.text.length >=6) {
                
                [self.SignIn_btn setUserInteractionEnabled:YES];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            }else{
                [self.SignIn_btn setUserInteractionEnabled:NO];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
            }
            }
            });
        }
    }else if (textField == self.verification_textfiled) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                //                NSLog(@"CCCC =  %d",self.phone_textfiled.text.length );
                if (self.phone_textfiled.text.length == 9 || self.phone_textfiled.text.length ==10 || self.phone_textfiled.text.length ==11) {
                    [self.SignIn_btn setUserInteractionEnabled:YES];
                    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                }else{
                    [self.SignIn_btn setUserInteractionEnabled:NO];
                    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                }
            });
            return YES;
        }else if (self.verification_textfiled.text.length >= 15) {
            self.verification_textfiled.text = [[textField.text stringByAppendingString:string] substringToIndex:16];
            if (self.phone_textfiled.text.length ==9 || self.phone_textfiled.text.length ==10 || self.phone_textfiled.text.length ==11) {
                [self.SignIn_btn setUserInteractionEnabled:YES];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            }else{
                [self.SignIn_btn setUserInteractionEnabled:NO];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
            }
            
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                NSLog(@"CCCC =  %d",self.phone_textfiled.text.length );
                if (self.phone_textfiled.text.length == 9 || self.phone_textfiled.text.length ==10 || self.phone_textfiled.text.length ==11) {
                    [self.SignIn_btn setUserInteractionEnabled:YES];
                    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                }else{
                    [self.SignIn_btn setUserInteractionEnabled:NO];
                    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                }
            });
            
        }
    }
    return YES;
}

@end
