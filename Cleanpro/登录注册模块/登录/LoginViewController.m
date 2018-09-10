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

@interface LoginViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.phone_textfiled.borderStyle=;
//    self.phone_textfiled.clearButtonMode = UITextFieldViewModeAlways;
    self.phone_textfiled.keyboardType = UIKeyboardTypeNumberPad;
    self.phone_textfiled.delegate=self;
//    self.verification_textfiled.clearButtonMode = UITextFieldViewModeAlways;
    self.verification_textfiled.keyboardType = UIKeyboardTypeASCIICapable;
    self.verification_textfiled.delegate=self;
    self.verification_textfiled.secureTextEntry=YES;
    self.SignIn_btn.layer.cornerRadius=25;
    self.SignIn_btn.userInteractionEnabled=NO;
//    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
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
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}

- (IBAction)back_touch:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)Register_touch:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController *vc=[main instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)SignIn_touch:(id)sender {
    ///密码长度 大于6小于16
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"account":self.phone_textfiled.text,
                          @"password":self.verification_textfiled.text,};
    NSLog(@"dict=== %@",dict);
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
                [HudViewFZ showMessageTitle:@"Password error" andDelay:2.0];
            }else if(statusCode==nil){
                [userDefaults setObject:tokenStr forKey:@"Token"];
                [userDefaults setObject:phoneNumberStr forKey:@"phoneNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
            [HudViewFZ showMessageTitle:@"Login successful" andDelay:2.0];
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
                
            }
            
        }else
        {
            [HudViewFZ showMessageTitle:@"statusCode error" andDelay:2.0];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
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
            [self.SignIn_btn setUserInteractionEnabled:NO];
            self.SignIn_btn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            return YES;
        }
        //so easy
        else if (self.phone_textfiled.text.length >= 10) {
            self.phone_textfiled.text = [[textField.text stringByAppendingString:string] substringToIndex:11];
//            NSLog(@"self.phone_textfiled.text =  %ld",self.phone_textfiled.text.length );
            if (self.verification_textfiled.text.length >=6) {
                
            [self.SignIn_btn setUserInteractionEnabled:YES];
           self.SignIn_btn.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
            }else{
                [self.SignIn_btn setUserInteractionEnabled:NO];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
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
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
            }else{
                [self.SignIn_btn setUserInteractionEnabled:NO];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            }
            }
            });
        }
    }else if (textField == self.verification_textfiled) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            [self.SignIn_btn setUserInteractionEnabled:NO];
            self.SignIn_btn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            return YES;
        }else if (self.verification_textfiled.text.length >= 15) {
            self.verification_textfiled.text = [[textField.text stringByAppendingString:string] substringToIndex:16];
            if (self.phone_textfiled.text.length ==9 || self.phone_textfiled.text.length ==10 || self.phone_textfiled.text.length ==11) {
                [self.SignIn_btn setUserInteractionEnabled:YES];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
            }else{
                [self.SignIn_btn setUserInteractionEnabled:NO];
                self.SignIn_btn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            }
            
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                NSLog(@"CCCC =  %d",self.phone_textfiled.text.length );
                if (self.phone_textfiled.text.length == 9 || self.phone_textfiled.text.length ==10 || self.phone_textfiled.text.length ==11) {
                    [self.SignIn_btn setUserInteractionEnabled:YES];
                    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
                }else{
                    [self.SignIn_btn setUserInteractionEnabled:NO];
                    self.SignIn_btn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
                }
            });
            
        }
    }
    return YES;
}

@end
