//
//  setPasswordViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "setPasswordViewController.h"
#import "LoginViewController.h"
@interface setPasswordViewController ()<UITextFieldDelegate>

@end

@implementation setPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sing_up.layer.cornerRadius=4;
//    self.log_one_textfiled.clearButtonMode = UITextFieldViewModeAlways;
    self.log_one_textfiled.keyboardType = UIKeyboardTypeASCIICapable;
    self.log_one_textfiled.delegate=self;
    self.log_one_textfiled.secureTextEntry=YES;
//    self.log_two_textfiled.clearButtonMode = UITextFieldViewModeAlways;
    self.log_two_textfiled.keyboardType = UIKeyboardTypeASCIICapable;
    self.log_two_textfiled.delegate=self;
    self.log_two_textfiled.secureTextEntry=YES;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
       [self setPassword];
    });
    
}
- (void)viewWillAppear:(BOOL)animated {
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}
-(void)setPassword
{
    __block setPasswordViewController *  weakSelf = self;
    self.one_payPassword1=[[TPPasswordTextView alloc] initWithFrame:self.one_payPassword.frame];
    self.one_payPassword1.elementCount = 6;
    //  背景色 方便  看
    self.one_payPassword1.backgroundColor = [UIColor whiteColor];
    //  距离
    self.one_payPassword1.elementMargin = 0;
    // 边框宽度
    self.one_payPassword1.elementBorderWidth = 1;
//    self.one_payPassword1.backgroundColor=[UIColor whiteColor];
    self.one_payPassword1.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        self->_pay_passwordOne=password;
        if(self->_pay_passwordOne.length==6)
        {
           [weakSelf GB_backgroundColor];
        }else
        {
            [weakSelf GB_backgroundColor];
        }
    };
    self.two_payPassword2=[[TPPasswordTextView alloc] initWithFrame:self.two_payPassword.frame];
    self.two_payPassword2.elementCount = 6;
//    self.two_payPassword2.backgroundColor=[UIColor blueColor];
    //  背景色 方便  看
    self.two_payPassword2.backgroundColor = [UIColor whiteColor];
    //  距离
    self.two_payPassword2.elementMargin = 0;
    // 边框宽度
    self.two_payPassword2.elementBorderWidth = 1;
    self.two_payPassword2.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        
         self->_pay_passwordTwo=password;
        if(self->_pay_passwordTwo.length==6)
        {
           
            [weakSelf GB_backgroundColor];
        }else
        {
            [weakSelf GB_backgroundColor];
        }
    };
    [self.down_paypassword addSubview:self.one_payPassword1];
    [self.down_paypassword addSubview:self.two_payPassword2];
    [self.one_payPassword1 hideKeyboard];
    [self.two_payPassword2 hideKeyboard];
}


/**
 判断输入的文字是否符合要求

 @return YES符合，NO 不符合
 */
-(BOOL)isequal_textfiled
{
    if(self.log_one_textfiled.text.length>=6 && self.log_one_textfiled.text.length <= 16)
    {
        if(self.log_two_textfiled.text.length>=6 && self.log_two_textfiled.text.length <= 16)
        {
            if([self.log_one_textfiled.text isEqualToString:self.log_two_textfiled.text])
            {
                if(self.pay_passwordOne.length==6 && self.pay_passwordTwo.length==6)
                {
                    if([self.pay_passwordOne isEqualToString:self.pay_passwordTwo])
                    {
                        return YES;
                    }else
                    {
                        return NO;
                    }
                }else
                {
                    return NO;
                }
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }else
    {
        return NO;
    }
    return NO;
}

-(void)GB_backgroundColor
{
    if([self isequal_textfiled])
    {
        [self.sing_up setUserInteractionEnabled:YES];
        self.sing_up.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
    }else
    {
        self.sing_up.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
        [self.sing_up setUserInteractionEnabled:NO];
    }
}

- (IBAction)SingUp_touch:(id)sender {
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"phoneNumber":self.PhoneStr,
                          @"loginName":self.PhoneStr,
                          @"randomPassword":self.VerificationStr,
                          @"password":self.log_two_textfiled.text,
                          @"payPassword":self.pay_passwordTwo,
                          @"countryCode":@"86",////先默认为中国
                          };
            NSLog(@"dict=== %@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_Register] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
                    NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
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
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
    
}

- (IBAction)back_touch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (textField == self.log_one_textfiled) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self GB_backgroundColor];
            });
            return YES;
        }
        //so easy
        else if (self.log_one_textfiled.text.length >= 15) {
            self.log_one_textfiled.text =[[textField.text stringByAppendingString:string] substringToIndex:16];
            [self GB_backgroundColor];
            return NO;
        }else{
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self GB_backgroundColor];
            });
        }
    }else if (textField == self.log_two_textfiled) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self GB_backgroundColor];
            });
            return YES;
        }else if (self.log_two_textfiled.text.length >= 15) {
            self.log_two_textfiled.text = [[textField.text stringByAppendingString:string] substringToIndex:16];
            
            return NO;
        }else{
//            self.log_two_textfiled.text = [textField.text stringByAppendingString:string];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self GB_backgroundColor];
            });
            
        }
    }
    return YES;
}

@end
