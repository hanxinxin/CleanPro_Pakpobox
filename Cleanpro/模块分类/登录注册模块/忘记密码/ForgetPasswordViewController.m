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
    
    self.title_label.text = FGGetStringWithKeyFromTable(@"Enter Your Mobile Number", @"Language");
    [self.NextStep setTitle:FGGetStringWithKeyFromTable(@"Next", @"Language") forState:UIControlStateNormal];
    [self.getCode_btn setTitle:FGGetStringWithKeyFromTable(@"Get code", @"Language") forState:(UIControlStateNormal)];
    self.phone_textfield.placeholder=FGGetStringWithKeyFromTable(@"Mobile No.", @"Language");
    self.Verification_textfield.placeholder=FGGetStringWithKeyFromTable(@"Verification", @"Language");
    self.NextStep.layer.cornerRadius=4;
    self.getCode_btn.layer.cornerRadius=15;
    [UIBezierPathView setCornerOnRight:4 view_b:self.phone_textfield];
    self.Verification_textfield.layer.cornerRadius=4;
//    self.phone_textfield.clearButtonMode = UITextFieldViewModeAlways;
    self.phone_textfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phone_textfield.delegate=self;
    self.Verification_textfield.delegate=self;
//    self.Verification_textfield.clearButtonMode = UITextFieldViewModeAlways;
    self.Verification_textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.getCode_btn setUserInteractionEnabled:NO];
    [self.getCode_btn setTitleColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
    self.NextStep.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
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
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
    //    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
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
    CGFloat offset = (self.NextStep.top+self.NextStep.height+kbHeight) - (self.view.frame.size.height);
    
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
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}


-(void)setDiqu_select
{
    self.DQNumber=@[@"+60",@"+86",@"+65",@"+66"];;
//    self.DQNumber=@[@"+60"];
    // 控件的创建
    LMJDropdownMenu * dropdownMenu = [[LMJDropdownMenu alloc] init];
    [dropdownMenu setFrame:self.diqu_btn.frame];
    [dropdownMenu setMenuTitles:self.DQNumber rowHeight:40];
    [UIBezierPathView setCornerOnLeft:4 view_b:dropdownMenu.mainBtn];
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
  
}
- (IBAction)back_touch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getVode_touch:(id)sender {
    
    if(self.phone_textfield.text.length > 8)
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
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
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
        [self.getCode_btn setTitleColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
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
//            [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
            [self.getCode_btn setTitleColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.NextStep setUserInteractionEnabled:NO];
            self.NextStep.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
            return YES;
        }else if (self.phone_textfield.text.length >= 10) {
            self.phone_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:11];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
            if(Time_cout==0){
                self.getCode_btn.userInteractionEnabled=YES;
//                [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1]];
                [self.getCode_btn setTitleColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                if (self.Verification_textfield.text.length == 6) {
                    [self.NextStep setUserInteractionEnabled:YES];
                    self.NextStep.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    
                }
                });
            }
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                if(self.phone_textfield.text.length > 8)
                {
                    [self.getCode_btn setUserInteractionEnabled:YES];
                    [self.getCode_btn setTitleColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
                    if (self.Verification_textfield.text.length >=6) {
                        
                        [self.NextStep setUserInteractionEnabled:YES];
                        self.NextStep.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    }else{
                        
                        self.NextStep.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
//                        self.getCode_btn.userInteractionEnabled=YES;
//                        [self.getCode_btn setTitleColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
                    }
                }else
                {
                    [self.NextStep setUserInteractionEnabled:NO];
                    self.NextStep.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                    [self.getCode_btn setUserInteractionEnabled:NO];
                    [self.getCode_btn setTitleColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] forState:UIControlStateNormal];
                }
                
                
            });
//            [self.getCode_btn setUserInteractionEnabled:NO];
//            //            [self.getCode_btn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:222/255.0 blue:223/255.0 alpha:1]];
//            [self.getCode_btn setTitleColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] forState:UIControlStateNormal];
//            [self.NextStep setUserInteractionEnabled:NO];
//            self.NextStep.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
        }
    }else if (textField == self.Verification_textfield) {
        NSLog(@"string.Length= %@",textField.text);
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            self.NextStep.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
            [self.NextStep setUserInteractionEnabled:NO];
            return YES;
        }else if (textField.text.length >= 5) {
            //            NSLog(@"Length= %ld",self.Verification_number.text.length);
            self.Verification_textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:6];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                if (self.phone_textfield.text.length == 9 || self.phone_textfield.text.length ==10 || self.phone_textfield.text.length ==11) {
                    [self.NextStep setUserInteractionEnabled:YES];
                    self.NextStep.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                }
            });
//            if (self.phone_textfield.text.length == 11) {
//
//            }
            
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.NextStep.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                [self.NextStep setUserInteractionEnabled:NO];
            });
            
            
        }
    }
    return YES;
}
@end
