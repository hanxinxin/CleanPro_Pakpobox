//
//  PasswordRViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PasswordRViewController.h"
#import "FriendsRViewController.h"
@interface PasswordRViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@end

@implementation PasswordRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passwordStr=@"";
    self.Nextmode.inviteCode=@"";
    self.next_btn.layer.cornerRadius=4;
    [self.next_btn setTitle:FGGetStringWithKeyFromTable(@"Complete", @"Language") forState:UIControlStateNormal];
    [self.title_label setText:FGGetStringWithKeyFromTable(@"Choose a Password", @"Language")];

    self.onePassword_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    self.onePassword_textfield.delegate=self;
    self.onePassword_textfield.clearsOnBeginEditing = YES;
    self.onePassword_textfield.secureTextEntry = YES;
    self.onePassword_textfield.layer.cornerRadius=4;
    self.onePassword_textfield.placeholder = FGGetStringWithKeyFromTable(@"At least 6 digit numbers", @"Language");
    self.twoPassword_textfield.layer.cornerRadius=4;
    self.twoPassword_textfield.secureTextEntry = YES;
    self.twoPassword_textfield.clearsOnBeginEditing = YES;
    self.twoPassword_textfield.delegate=self;
    self.twoPassword_textfield.placeholder = FGGetStringWithKeyFromTable(@"At least 6 digit numbers", @"Language");
    self.twoPassword_textfield.keyboardType = UIKeyboardTypeASCIICapable;
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
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    
    [self.navigationController.navigationBar setHidden:NO];
    [self addNoticeForKeyboard];
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


- (IBAction)Next_touch:(id)sender {
    
    if(self.passwordStr !=nil && ![self.passwordStr isEqualToString:@""])
    {
    self.Nextmode.password=self.passwordStr;
        /*
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FriendsRViewController *vc=[main instantiateViewControllerWithIdentifier:@"FriendsRViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Nextmode= self.Nextmode;
    [self.navigationController pushViewController:vc animated:YES];
         */
        [self SkipInviteCode];
    }
}
-(void)SkipInviteCode
{
    NSDictionary * dict = [[NSDictionary alloc] init];
    if(self.Nextmode.birthday!=nil && ![self.Nextmode.birthday isEqualToString:@""])
    {
        if (self.Nextmode.postCode!=nil && ![self.Nextmode.postCode isEqualToString:@""]) {
            dict=@{@"phoneNumber":self.Nextmode.phoneNumber,
                   @"loginName":self.Nextmode.loginName,
                   @"randomPassword":self.Nextmode.randomPassword,
                   @"password":self.Nextmode.password,
                   //                          @"payPassword":self.pay_passwordTwo,
                   @"countryCode":self.Nextmode.countryCode,////先默认为中国
                   @"registerType":@"IOS",//写死 IOS
                   @"firstName":self.Nextmode.firstName,//
                   @"lastName":self.Nextmode.lastName,//
                   @"birthday":self.Nextmode.birthday,//
                   @"gender":self.Nextmode.gender,//
                   @"postCode":self.Nextmode.postCode,//
                   };
        }else
        {
            dict=@{@"phoneNumber":self.Nextmode.phoneNumber,
                   @"loginName":self.Nextmode.loginName,
                   @"randomPassword":self.Nextmode.randomPassword,
                   @"password":self.Nextmode.password,
                   //                          @"payPassword":self.pay_passwordTwo,
                   @"countryCode":self.Nextmode.countryCode,////先默认为中国
                   @"registerType":@"IOS",//写死 IOS
                   @"firstName":self.Nextmode.firstName,//
                   @"lastName":self.Nextmode.lastName,//
                   @"birthday":self.Nextmode.birthday,//
                   @"gender":self.Nextmode.gender,//
                   //                                  @"postCode":self.Nextmode.postCode,//
                   };
        }
        
        
    }else
    {
        if (self.Nextmode.postCode!=nil && ![self.Nextmode.postCode isEqualToString:@""]) {
            dict=@{@"phoneNumber":self.Nextmode.phoneNumber,
                   @"loginName":self.Nextmode.loginName,
                   @"randomPassword":self.Nextmode.randomPassword,
                   @"password":self.Nextmode.password,
                   //                          @"payPassword":self.pay_passwordTwo,
                   @"countryCode":self.Nextmode.countryCode,////先默认为中国
                   @"registerType":@"IOS",//写死 IOS
                   @"firstName":self.Nextmode.firstName,//
                   @"lastName":self.Nextmode.lastName,//
                   //                   @"birthday":self.Nextmode.birthday,//
                   @"gender":self.Nextmode.gender,//
                   @"postCode":self.Nextmode.postCode,//
                   };
        }else
        {
            dict=@{@"phoneNumber":self.Nextmode.phoneNumber,
                   @"loginName":self.Nextmode.loginName,
                   @"randomPassword":self.Nextmode.randomPassword,
                   @"password":self.Nextmode.password,
                   //                          @"payPassword":self.pay_passwordTwo,
                   @"countryCode":self.Nextmode.countryCode,////先默认为中国
                   @"registerType":@"IOS",//写死 IOS
                   @"firstName":self.Nextmode.firstName,//
                   @"lastName":self.Nextmode.lastName,//
                   //                   @"birthday":self.Nextmode.birthday,//
                   @"gender":self.Nextmode.gender,//
                   //                                  @"postCode":self.Nextmode.postCode,//
                   };
        }
    }
    NSLog(@"dict=== %@",dict);
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_Register] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        //        NSDictionary * dict = [responseObject objectForKey:@"Message"];
        NSNumber * codeStr = [responseObject objectForKey:@"statusCode"];
        
        if(codeStr==nil)
        {
            
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Registered successfully", @"Language") andDelay:2.0];
            //            [self.navigationController popToViewController:LoginViewController animated:YES];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LoginViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
            
        }else
        {
            NSString * errorMessage = [responseObject objectForKey:@"errorMessage"];
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
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
    
    if (textField == self.onePassword_textfield) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                if ([self.onePassword_textfield.text isEqualToString:self.twoPassword_textfield.text]) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    self.passwordStr = self.twoPassword_textfield.text;
                }else
                {
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                    [self.next_btn setUserInteractionEnabled:NO];
                }
            });
            return YES;
        }else if (self.onePassword_textfield.text.length >= 15) {
            self.onePassword_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:16];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if ([self.onePassword_textfield.text isEqualToString:self.twoPassword_textfield.text]) {
                [self.next_btn setUserInteractionEnabled:YES];
                self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                self.passwordStr = self.twoPassword_textfield.text;
            }else
            {
                [self.next_btn setUserInteractionEnabled:NO];
                self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
            }
            
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                if ([self.onePassword_textfield.text isEqualToString:self.twoPassword_textfield.text]) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    self.passwordStr = self.twoPassword_textfield.text;
                }else
                {
                    [self.next_btn setUserInteractionEnabled:NO];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                }
            });
            
        }
        
    }else if (textField == self.twoPassword_textfield) {
        NSLog(@"string.Length= %@",textField.text);
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                if ([self.onePassword_textfield.text isEqualToString:self.twoPassword_textfield.text]) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    self.passwordStr = self.twoPassword_textfield.text;
                }else
                {
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                    [self.next_btn setUserInteractionEnabled:NO];
                }
            });
            
            return YES;
        }else if (self.twoPassword_textfield.text.length >=15) {
            //            NSLog(@"Length= %ld",self.Verification_number.text.length);
            self.twoPassword_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:16];
            
            if ([self.onePassword_textfield.text isEqualToString:self.twoPassword_textfield.text]) {
                [self.next_btn setUserInteractionEnabled:YES];
                self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                self.passwordStr = self.twoPassword_textfield.text;
            }else
            {
                self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                [self.next_btn setUserInteractionEnabled:NO];
            }
            
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                if ([self.onePassword_textfield.text isEqualToString:self.twoPassword_textfield.text]) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    self.passwordStr = self.twoPassword_textfield.text;
                }else
                {
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                    [self.next_btn setUserInteractionEnabled:NO];
                }
            });
            
            
        }
        
    }
    return YES;
}

@end
