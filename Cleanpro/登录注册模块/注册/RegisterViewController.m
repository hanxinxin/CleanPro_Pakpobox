//
//  RegisterViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "setPasswordViewController.h"
#import "LMJDropdownMenu.h"
@interface RegisterViewController ()<LMJDropdownMenuDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    int Time_cout;
    
}
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,strong)NSArray *DQNumber;
@property(nonatomic,strong)NSString * diquStr;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.phone_number.clearButtonMode = UITextFieldViewModeAlways;
    self.phone_number.keyboardType = UIKeyboardTypeNumberPad;
    self.phone_number.delegate=self;
    self.Verification_number.delegate=self;
//    self.Verification_number.clearButtonMode = UITextFieldViewModeAlways;
    self.Verification_number.keyboardType = UIKeyboardTypeNumberPad;
    self.NextStep.layer.cornerRadius=25;
    self.getCodebtn.layer.cornerRadius=15;
    [self.getCodebtn setUserInteractionEnabled:NO];
    [self.getCodebtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
    self.NextStep.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
    [self.NextStep setUserInteractionEnabled:NO];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self setDiqu_select];
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
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    
//     [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)setDiqu_select
{
    self.DQNumber=@[@"+60",@"+86"];
    self.diquStr=self.DQNumber[0];
    // 控件的创建
    LMJDropdownMenu * dropdownMenu = [[LMJDropdownMenu alloc] init];
    [dropdownMenu setFrame:self.phone_region.frame];
    [dropdownMenu setMenuTitles:self.DQNumber rowHeight:30];
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
    
}
//去掉+号
-(NSString*)strDiqu:(NSString *)urlString
{
    NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@"+" withString:@""];//替换字符
    return strUrl;
}

- (IBAction)back_touch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)GetCode_touch:(id)sender {
    
    if(self.phone_number.text.length>8)
    {
    [HudViewFZ labelExample:self.view];
        NSDictionary * dict=@{@"phoneNumber":self.phone_number.text,
                              @"countryCode":[self strDiqu:self.diquStr]
                              };
        NSLog(@"dict= %@",dict);
//        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
        [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            if(statusCode==200)
            {
//            NSLog(@"responseObject = %@",responseObject);
                [HudViewFZ showMessageTitle:@"SendVerifyCode Success" andDelay:2.0];
                [self countDown:60];
            }else
            {
                [HudViewFZ showMessageTitle:@"statusCode error" andDelay:2.0];
            }
        } failure:^(NSError *error) {
            NSLog(@"error = %@",error);
            [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
            [HudViewFZ HiddenHud];
        }];
         
    
    }else
    {
        
        [HudViewFZ showMessageTitle:@"Phone number error" andDelay:2.0];
    }
}

- (IBAction)nextStep_touch:(id)sender {
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"phone":self.phone_number.text,
                          @"code":self.Verification_number.text};
    //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_JYverif] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
         NSLog(@"responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * codeInt= [dictObject objectForKey:@"statusCode"];
        NSString * errorMessage= [dictObject objectForKey:@"errorMessage"];
        if([codeInt integerValue]==400603)
        {
             [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
        }else{
        if(statusCode==200)
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            setPasswordViewController *vc=[main instantiateViewControllerWithIdentifier:@"setPasswordViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.PhoneStr=self.phone_number.text;
            vc.VerificationStr= self.Verification_number.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [HudViewFZ showMessageTitle:@"statusCode error" andDelay:2.0];
        }
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self.getCodebtn setTitle:FGGetStringWithKeyFromTable(@"Get code", @"Language") forState:UIControlStateNormal];
        self.getCodebtn.userInteractionEnabled=YES;
        [self.getCodebtn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
        [self.timer setFireDate:[NSDate distantFuture]];
    }else
    {
        Time_cout--;
        //        [self.YZM_btn.titleLabel setText:[NSString stringWithFormat:@"%d",Time_cout]];
        [self.getCodebtn setTitle:[NSString stringWithFormat:@"%ds",Time_cout] forState:UIControlStateNormal];
        self.getCodebtn.userInteractionEnabled=NO;
        //        [self.YZM_btn setBackgroundColor:[UIColor grayColor]];
        [self.getCodebtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
    }
    
    
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
    
    if (textField == self.phone_number) {
//        NSLog(@"self.phone_number.text.length =  %ld",self.phone_number.text.length);
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            if(self.phone_number.text.length ==10) {
//            }else if(self.phone_number.text.length ==10) {
            }else if(self.phone_number.text.length ==11) {
            }else
            {
            [self.getCodebtn setUserInteractionEnabled:NO];
            [self.getCodebtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
            
            [self.NextStep setUserInteractionEnabled:NO];
            self.NextStep.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            }
            
            return YES;
        }else if (self.phone_number.text.length ==8) {
            self.phone_number.text = [[textField.text stringByAppendingString:string] substringToIndex:self.phone_number.text.length+1];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCodebtn.userInteractionEnabled=YES;
                [self.getCodebtn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
                
                if (self.Verification_number.text.length == 6) {
                    [self.NextStep setUserInteractionEnabled:YES];
                    self.NextStep.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
                    
                }
            }
            return NO;
        }else if (self.phone_number.text.length ==9) {
            self.phone_number.text = [[textField.text stringByAppendingString:string] substringToIndex:self.phone_number.text.length+1];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCodebtn.userInteractionEnabled=YES;
                [self.getCodebtn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
                
                if (self.Verification_number.text.length == 6) {
                    [self.NextStep setUserInteractionEnabled:YES];
                    self.NextStep.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
                    
                }
            }
            return NO;
        }else if (self.phone_number.text.length >=10) {
            self.phone_number.text = [[textField.text stringByAppendingString:string] substringToIndex:11];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCodebtn.userInteractionEnabled=YES;
                [self.getCodebtn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
                
                if (self.Verification_number.text.length == 6) {
                    [self.NextStep setUserInteractionEnabled:YES];
                    self.NextStep.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
                    
                }
            }
            return NO;
        }else
        {
            [self.getCodebtn setUserInteractionEnabled:NO];
            [self.getCodebtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
            
            [self.NextStep setUserInteractionEnabled:NO];
            self.NextStep.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
        }
    }else if (textField == self.Verification_number) {
         NSLog(@"string.Length= %@",textField.text);
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            self.NextStep.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            [self.NextStep setUserInteractionEnabled:NO];
            return YES;
        }else if (textField.text.length >= 5) {
//            NSLog(@"Length= %ld",self.Verification_number.text.length);
            self.Verification_number.text = [[textField.text stringByAppendingString:string] substringToIndex:6];
            
            if (self.phone_number.text.length >=9) {
                [self.NextStep setUserInteractionEnabled:YES];
                self.NextStep.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
            }
            
            return NO;
        }else
        {
            self.NextStep.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            [self.NextStep setUserInteractionEnabled:NO];
            
        }
    }
    return YES;
}
@end
