//
//  ForgetPayPasswordViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ForgetPayPasswordViewController.h"
#import "LMJDropdownMenu.h"
#import "AffirmViewController.h"
#import "againMimaViewController.h"
@interface ForgetPayPasswordViewController ()<LMJDropdownMenuDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    int Time_cout;
}
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,strong)NSArray * DQNumber;
@property(nonatomic,strong)NSString * diquStr;
@end

@implementation ForgetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NextSetp.layer.cornerRadius=4;
    self.getCodeBtn.layer.cornerRadius=15;
//    self.phone_textfield.clearButtonMode = UITextFieldViewModeAlways;
    self.phone_textfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phone_textfield.delegate=self;
    self.Verification_Textfield.delegate=self;
//    self.Verification_Textfield.clearButtonMode = UITextFieldViewModeAlways;
    self.Verification_Textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.getCodeBtn setUserInteractionEnabled:NO];
    [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
    self.NextSetp.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
    [self.NextSetp setUserInteractionEnabled:NO];
    self.diquStr=@"60";
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
}


- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}

-(void)setDiqu_select
{
//    self.DQNumber=@[@"+60",@"+86"];
    self.DQNumber=@[@"+60",@"+86",@"+65",@"+66"];
//    self.diquStr=self.DQNumber[0];
    // 控件的创建
    LMJDropdownMenu * dropdownMenu = [[LMJDropdownMenu alloc] init];
    [dropdownMenu setFrame:self.phone_btn.frame];
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

- (IBAction)back_touch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)GetCode_touch:(id)sender {
    
    if(self.phone_textfield.text.length==11)
    {
        [HudViewFZ labelExample:self.view];
        NSDictionary * dict=@{@"phone":self.phone_textfield.text,
                              @"countryCode":self.diquStr
        };
//        NSDictionary * dict=@{@"phoneNumber":self.phone_number.text,
//                              @"countryCode":[self strDiqu:self.diquStr]
//                              };
        //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
        [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_zhaohuiPassword] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            
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
        
        
    }else
    {
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Phone number error", @"Language") andDelay:2.0];
    }
    
}

- (IBAction)NextSetp_touch:(id)sender {
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"phone":self.phone_textfield.text,
                          @"code":self.Verification_Textfield.text};
    //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_zhaohuiPasswordYZ] parameters:dict progress:^(id progress) {
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
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            NSString*tokenStr = [dictObject objectForKey:@"token"];
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            againMimaViewController *vc=[main instantiateViewControllerWithIdentifier:@"againMimaViewController"];
            vc.PayOrLog=2;
            vc.TokenString=tokenStr;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
    
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
        [self.getCodeBtn setTitle:FGGetStringWithKeyFromTable(@"Get code", @"Language") forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled=YES;
        [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
        [self.timer setFireDate:[NSDate distantFuture]];
    }else
    {
        Time_cout--;
        //        [self.YZM_btn.titleLabel setText:[NSString stringWithFormat:@"%d",Time_cout]];
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds",Time_cout] forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled=NO;
        //        [self.YZM_btn setBackgroundColor:[UIColor grayColor]];
        [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",number);
//    self.diquStr=self.DQNumber[number];
    self.diquStr=[self ReplacingStr:self.DQNumber[number] ];
//    self.countryCodeStr
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    //    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    //    NSLog(@"--已经显示--");
    [self.Verification_Textfield setUserInteractionEnabled:NO];
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    //    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    //    NSLog(@"--已经隐藏--");
    [self.Verification_Textfield setUserInteractionEnabled:YES];
}
-(NSString*)ReplacingStr:(NSString *)str
{
   return [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
}

#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phone_textfield) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            if(self.phone_textfield.text.length ==10) {
                //            }else if(self.phone_number.text.length ==10) {
            }else if(self.phone_textfield.text.length ==11) {
            }else
            {
            [self.getCodeBtn setUserInteractionEnabled:NO];
            [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
            
            [self.NextSetp setUserInteractionEnabled:NO];
            self.NextSetp.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            }
            return YES;
        }else if (self.phone_textfield.text.length ==8) {
            self.phone_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:self.phone_textfield.text.length+1];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCodeBtn.userInteractionEnabled=YES;
                [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
                
                if (self.Verification_Textfield.text.length == 6) {
                    [self.NextSetp setUserInteractionEnabled:YES];
                    self.NextSetp.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
                    
                }
            }
            return NO;
        }else if (self.phone_textfield.text.length == 9 ) {
            self.phone_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:self.phone_textfield.text.length+1];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCodeBtn.userInteractionEnabled=YES;
                [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
                
                if (self.Verification_Textfield.text.length == 6) {
                    [self.NextSetp setUserInteractionEnabled:YES];
                    self.NextSetp.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
                    
                }
            }
            return NO;
        }else if (self.phone_textfield.text.length >= 10) {
            self.phone_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:11];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCodeBtn.userInteractionEnabled=YES;
                [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
                
                if (self.Verification_Textfield.text.length == 6) {
                    [self.NextSetp setUserInteractionEnabled:YES];
                    self.NextSetp.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
                    
                }
            }
            return NO;
        }else
        {
            [self.getCodeBtn setUserInteractionEnabled:NO];
            [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
            
            [self.NextSetp setUserInteractionEnabled:NO];
            self.NextSetp.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
        }
    }else if (textField == self.Verification_Textfield) {
        NSLog(@"string.Length= %@",textField.text);
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            self.NextSetp.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            [self.NextSetp setUserInteractionEnabled:NO];
            return YES;
        }else if (textField.text.length >= 5) {
            //            NSLog(@"Length= %ld",self.Verification_number.text.length);
            self.Verification_Textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:6];
            
            if (self.phone_textfield.text.length == 11) {
                [self.NextSetp setUserInteractionEnabled:YES];
                self.NextSetp.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
            }
            
            return NO;
        }else
        {
            self.NextSetp.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            [self.NextSetp setUserInteractionEnabled:NO];
            
        }
    }
    return YES;
}

@end
