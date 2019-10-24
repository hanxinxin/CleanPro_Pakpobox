//
//  ExistingPayViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ExistingPayViewController.h"

@interface ExistingPayViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@end

@implementation ExistingPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.next_btn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1].CGColor;//设置边框颜色
//    self.Skip_btn.layer.borderWidth = 1.0f;//设置边框颜色
    self.title_text.text = FGGetStringWithKeyFromTable(@"Please enter original password", @"Language");
    self.pay_textfeld.placeholder = FGGetStringWithKeyFromTable(@"Password", @"Language");
    [self.forget_pay_btn setTitle:FGGetStringWithKeyFromTable(@"Forget password?", @"Language") forState:UIControlStateNormal];
    [self.next_btn setTitle:FGGetStringWithKeyFromTable(@"Next", @"Language") forState:(UIControlStateNormal)];
    self.pay_textfeld.keyboardType = UIKeyboardTypeNumberPad;
    self.pay_textfeld.layer.cornerRadius=4;
    self.pay_textfeld.secureTextEntry = YES;
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
    __block ExistingPayViewController *  weakSelf = self;
    
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


- (IBAction)forgetPay_touch:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newPhoneViewController *vc=[main instantiateViewControllerWithIdentifier:@"newPhoneViewController"];
    vc.hidesBottomBarWhenPushed = YES;
//    vc.validateCode=self.pay_textfeld.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)next_touch:(id)sender {
    if(self.pay_textfeld.text.length>0)
    {
        self.PayPassWordStr=self.pay_textfeld.text;
        [self Post_payPassword];
    }
    
   
}

-(void)Post_payPassword
{
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"payPassword":self.PayPassWordStr};
    NSLog(@"dict=== %@",dict);
    __block ExistingPayViewController *  blockSelf = self;
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_jiaoyanPayPassword] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * code= [dictObject objectForKey:@"result"];
        //        NSNumber * statusCode1 =[dictObject objectForKey:@"statusCode"];
        NSNumber * codeInt= [dictObject objectForKey:@"statusCode"];
        if([codeInt intValue]==401)
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else if (codeInt==nil)
        {
            if([code intValue]==0)
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Password mistake", @"Language") andDelay:2.0];
                
                
            }else
            {
                [blockSelf push_againMimaViewController];
                
            }
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


-(void)push_againMimaViewController
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SetPayPViewController *vc=[main instantiateViewControllerWithIdentifier:@"SetPayPViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.PayOldPassWordStr=self.PayPassWordStr;
    vc.index=2;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    if (textField == self.pay_textfeld) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [self.next_btn setUserInteractionEnabled:NO];
                self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                self.PayPassWordStr=self.pay_textfeld.text;
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
            });
        }
    }
    return YES;
}

@end
