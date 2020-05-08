//
//  newPhoneViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import "newPhoneViewController.h"

@interface newPhoneViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    int Time_cout;
}
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,strong)NSArray * DQNumber;
@end

@implementation newPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.next_btn.layer.cornerRadius=4;
    self.getCode_btn.layer.cornerRadius=0;
    self.pay_textfeld.keyboardType = UIKeyboardTypeNumberPad;
    self.pay_textfeld.layer.cornerRadius=4;
    self.pay_textfeld.delegate=self;
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    [self.title_text setText:[NSString stringWithFormat:@"Verify Phone Number:%@",ModeUser.phoneNumber]];
    [self.title_text setText:FGGetStringWithKeyFromTable(@"Verify Phone Number:", @"Language")];
    [self.phoneTitle setText:[NSString stringWithFormat:@"%@",ModeUser.phoneNumber]];
    self.pay_textfeld.placeholder=FGGetStringWithKeyFromTable(@"Verification", @"Language");
    [self.getCode_btn setTitle:FGGetStringWithKeyFromTable(@"Get code", @"Language") forState:UIControlStateNormal];
    [self.next_btn setTitle:FGGetStringWithKeyFromTable(@"Next Setp", @"Language") forState:(UIControlStateNormal)];
    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
    [self.next_btn setUserInteractionEnabled:NO];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
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
    NSLog(@"距上对比 = %f，%f",self.view.frame.origin.y,[UIScreen mainScreen].bounds.origin.y);
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
            self.view.frame = [UIScreen mainScreen].bounds;
//            self.view.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}


- (IBAction)getCode_touch:(id)sender {
    [self send_getcode];
}



- (IBAction)next_touch:(id)sender {
    
    [self jiaoyan];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
-(void)send_getcode
{
    
//    NSDictionary * dict=@{@"validateCode":self.validateCode,
//                          @"payPassword":self.payStringTwo,
//                          };
//    NSLog(@"dict=== %@",dict);
    [HudViewFZ labelExample:self.view];
    //    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,setPay_password] parameters:dict progress:^(id progress) {
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,setpay_Getcode] parameters:nil progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
//            NSNumber * result = [responseObject objectForKey:@"result"];
//            if(![[result stringValue] isEqualToString:@"1"])
//            {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Send a success", @"Language") andDelay:2.0];
            //            [self.navigationController popToViewController:LoginViewController animated:YES];
            [self countDown:60];
//            }else
//            {
//                NSString * errorMessage = [responseObject objectForKey:@"errorMessage"];
//                [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
//            }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get Code error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get Code error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
        
    
}

-(void)jiaoyan
{
    NSDictionary * dict = @{@"code":self.pay_textfeld.text,
                            };
    NSLog(@"dict=== %@",dict);
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,setpay_YZGetcode] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
                NSNumber * codeStr = [responseObject objectForKey:@"statusCode"];
        if(statusCode==200)
        {
            if(![[codeStr stringValue] isEqualToString:@"400602"] && ![[codeStr stringValue] isEqualToString:@"400603"])
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Check success", @"Language") andDelay:1.0];
                [self push_viewcontroller];
            }else
            {
                NSString * errorMessage = [responseObject objectForKey:@"errorMessage"];
                [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
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
*/


-(void)send_getcode
{
    [HudViewFZ labelExample:self.view];
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDictionary * dict=@{@"mobile":ModeUser.phoneNumber
    };
    //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_sendSmsCode] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"E_sendSmsCode = %@",responseObject);
        if(statusCode==200)
        {
            //            NSLog(@"responseObject = %@",responseObject);
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"SendVerifyCode Success", @"Language") andDelay:2.0];
            [self countDown:60];
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
-(void)jiaoyan
{
    [HudViewFZ labelExample:self.view];
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDictionary * dict=@{@"mobile":ModeUser.phoneNumber,
    @"validateCode":self.pay_textfeld.text,};
    //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_verifySmsCode] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Check success", @"Language") andDelay:1.0];
        [self push_viewcontroller];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        
        if (error) {
            [HudViewFZ showMessageTitle:[self dictStr:error] andDelay:2.0];
        }
        
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
-(void)push_viewcontroller
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SetPayPViewController *vc=[main instantiateViewControllerWithIdentifier:@"SetPayPViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.validateCode=self.pay_textfeld.text;
    vc.index=self.index;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)countDown:(int)count{
    
    Time_cout=count;
    
    
    //启动定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerSelector) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate dateWithTimeInterval:1.0 sinceDate:[NSDate date]]];
    
}
-(void)timerSelector
{
    if(Time_cout==0)
    {
        //倒计时已到，作需要作的事吧。
        //    [self.YZM_btn.titleLabel setText:[NSString stringWithFormat:@"点击获取"]];
        //        [self.YZM_btn setTitle:[NSString stringWithFormat:@"点击获取"] forState:UIControlStateNormal];
        [self.getCode_btn setTitle:FGGetStringWithKeyFromTable(@"Get code", @"Language") forState:UIControlStateNormal];
        [self.getCode_btn setTitleColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.getCode_btn.userInteractionEnabled=YES;
//        [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
        [self.timer setFireDate:[NSDate distantFuture]];
    }else
    {
        Time_cout--;
        //        [self.YZM_btn.titleLabel setText:[NSString stringWithFormat:@"%d",Time_cout]];
        [self.getCode_btn setTitle:[NSString stringWithFormat:@"%ds",Time_cout] forState:UIControlStateNormal];
        [self.getCode_btn setTitleColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.getCode_btn.userInteractionEnabled=NO;
        //        [self.YZM_btn setBackgroundColor:[UIColor grayColor]];
//        [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
    }
    
    
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
            });
            return YES;
        }else if (self.pay_textfeld.text.length == 3) {
            self.pay_textfeld.text = [[textField.text stringByAppendingString:string] substringToIndex:4];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCode_btn.userInteractionEnabled=YES;
//                [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
                [self.getCode_btn setTitleColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
                
            }
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                if (self.pay_textfeld.text.length == 4) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    
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
            });
        }
    }
    return YES;
}

@end
