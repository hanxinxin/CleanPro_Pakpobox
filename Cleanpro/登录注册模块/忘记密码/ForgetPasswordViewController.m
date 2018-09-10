//
//  ForgetPasswordViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LMJDropdownMenu.h"
#import "ForgetSetPasswordViewController.h"

@interface ForgetPasswordViewController ()<LMJDropdownMenuDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
     int Time_cout;
}
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,strong)NSArray * DQNumber;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NextStep.layer.cornerRadius=25;
    self.getCode_btn.layer.cornerRadius=15;
//    self.phone_textfield.clearButtonMode = UITextFieldViewModeAlways;
    self.phone_textfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phone_textfield.delegate=self;
    self.Verification_textfield.delegate=self;
//    self.Verification_textfield.clearButtonMode = UITextFieldViewModeAlways;
    self.Verification_textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.getCode_btn setUserInteractionEnabled:NO];
    [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
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
}

-(void)setDiqu_select
{
    self.DQNumber=@[@"+60",@"+86"];
    // 控件的创建
    LMJDropdownMenu * dropdownMenu = [[LMJDropdownMenu alloc] init];
    [dropdownMenu setFrame:self.diqu_btn.frame];
    [dropdownMenu setMenuTitles:self.DQNumber rowHeight:40];
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
  
}
- (IBAction)back_touch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getVode_touch:(id)sender {
    
    if(self.phone_textfield.text.length==11)
    {
        [HudViewFZ labelExample:self.view];
        NSDictionary * dict=@{@"phone":self.phone_textfield.text};
        //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
        [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_zhaohuiPassword] parameters:dict progress:^(id progress) {
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
- (IBAction)NextStep_touch:(id)sender {
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"phone":self.phone_textfield.text,
                          @"code":self.Verification_textfield.text};
    //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_zhaohuiPasswordYZ] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        if(statusCode==200)
        {
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            NSString*tokenStr = [dictObject objectForKey:@"token"];
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ForgetSetPasswordViewController *vc=[main instantiateViewControllerWithIdentifier:@"ForgetSetPasswordViewController"];
            vc.TokenString=tokenStr;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
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
        self.getCode_btn.userInteractionEnabled=YES;
        [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
        [self.timer setFireDate:[NSDate distantFuture]];
    }else
    {
        Time_cout--;
        //        [self.YZM_btn.titleLabel setText:[NSString stringWithFormat:@"%d",Time_cout]];
        [self.getCode_btn setTitle:[NSString stringWithFormat:@"%ds",Time_cout] forState:UIControlStateNormal];
        self.getCode_btn.userInteractionEnabled=NO;
        //        [self.YZM_btn setBackgroundColor:[UIColor grayColor]];
        [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
    }
    
    
}




#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",number);
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


#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phone_textfield) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            [self.getCode_btn setUserInteractionEnabled:NO];
            [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
            
            [self.NextStep setUserInteractionEnabled:NO];
            self.NextStep.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            return YES;
        }else if (self.phone_textfield.text.length >= 10) {
            self.phone_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:11];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCode_btn.userInteractionEnabled=YES;
                [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
                
                if (self.Verification_textfield.text.length == 6) {
                    [self.NextStep setUserInteractionEnabled:YES];
                    self.NextStep.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
                    
                }
            }
            return NO;
        }else
        {
            [self.getCode_btn setUserInteractionEnabled:NO];
            [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
            
            [self.NextStep setUserInteractionEnabled:NO];
            self.NextStep.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
        }
    }else if (textField == self.Verification_textfield) {
        NSLog(@"string.Length= %@",textField.text);
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            self.NextStep.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
            [self.NextStep setUserInteractionEnabled:NO];
            return YES;
        }else if (textField.text.length >= 5) {
            //            NSLog(@"Length= %ld",self.Verification_number.text.length);
            self.Verification_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:6];
            
            if (self.phone_textfield.text.length == 11) {
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
