//
//  nameRViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "nameRViewController.h"
#import "InformationViewController.h"
#import "BirthdayRViewController.h"
#import "PhoneRViewController.h"
#import "GenderRViewController.h"
#import "NewRegisterViewController.h"

@interface nameRViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@end

@implementation nameRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.next_btn.layer.cornerRadius=4;
    self.first_nameText.keyboardType = UIKeyboardTypeAlphabet;
    self.first_nameText.delegate=self;
    self.first_nameText.secureTextEntry = NO;
    self.first_nameText.layer.cornerRadius=4;
    self.last_nameText.layer.cornerRadius=4;
    self.last_nameText.delegate=self;
    self.last_nameText.secureTextEntry = NO;
    self.last_nameText.keyboardType = UIKeyboardTypeAlphabet;
    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
    [self.next_btn setUserInteractionEnabled:NO];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
    });
    if(self.Nextmode==nil)
    {
        self.Nextmode = [[userIDMode alloc] init];
    }
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
    
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    //    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
//    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
//    self.navigationItem.backBarButtonItem = backBtn;
    if(self.index==1)
    {
        [self.next_btn setTitle:@"Next" forState:UIControlStateNormal];
    }else if (self.index==2)
    {
        NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(![ModeUser.firstName isEqual:[NSNull null]] && ![ModeUser.lastName isEqual:[NSNull null]]){
        self.first_nameText.text=ModeUser.firstName;
        self.last_nameText.text=ModeUser.lastName;
        }
        
        [self.next_btn setTitle:@"Save" forState:UIControlStateNormal];
    }
    [self.navigationController.navigationBar setHidden:NO];
    [self addNoticeForKeyboard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;
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
-(void)keyboardWasShown:(NSNotification *)notif
{

    NSDictionary *info = [notif userInfo];

    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];

    CGSize keyboardSize = [value CGRectValue].size;

    NSLog(@"keyBoard:%f", keyboardSize.height);
    if (keyboardSize.height>0 && self.last_nameText.secureTextEntry == YES) {
        //不让换键盘的textField的
        self.last_nameText.secureTextEntry = NO;

    }
    if (keyboardSize.height>0 && self.first_nameText.secureTextEntry == YES) {
        //不让换键盘的textField的
        self.first_nameText.secureTextEntry = NO;

    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

 //判断一下，哪个是不让换键盘的textField

    if (textField == self.first_nameText) {

//        self.first_nameText.secureTextEntry = YES;

    }
    if (textField == self.last_nameText) {

//        self.last_nameText.secureTextEntry = YES;

    }
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
//    CGFloat offheight = SCREEN_HEIGHT-(kNavBarAndStatusBarHeight);
    CGFloat offset = (self.next_btn.top+self.next_btn.height+kbHeight+(kNavBarAndStatusBarHeight)) - SCREEN_HEIGHT;
    NSLog(@"duibi  = %f，%f",SCREEN_HEIGHT,kNavBarAndStatusBarHeight);
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
    //        self.view.frame = [UIScreen mainScreen].bounds;
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}


- (IBAction)Next_touch:(id)sender {
    if(self.index==1)
    {
        /* 12月20日 修改 只用填写姓名，屏蔽以前的生日
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BirthdayRViewController *vc=[main instantiateViewControllerWithIdentifier:@"BirthdayRViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Nextmode = self.Nextmode;
    [self.navigationController pushViewController:vc animated:YES];
         
         */
//        12月30日屏蔽 直接进入号码填写页面
//        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        PhoneRViewController *vc=[main instantiateViewControllerWithIdentifier:@"PhoneRViewController"];
//        vc.hidesBottomBarWhenPushed = YES;
//        userIDMode * Nextmode = [[userIDMode alloc] init];
//        Nextmode.firstName=self.Nextmode.firstName;
//        Nextmode.lastName=self.Nextmode.lastName;
//        Nextmode.birthday=@"";
//        Nextmode.gender=@"MALE";
//        Nextmode.postCode=@"";
//        vc.Nextmode=Nextmode;
//        [self.navigationController pushViewController:vc animated:YES];
         
        /// 4.21 日修改
        
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewRegisterViewController *vc=[main instantiateViewControllerWithIdentifier:@"NewRegisterViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        userIDMode * Nextmode = [[userIDMode alloc] init];
        Nextmode.firstName=self.Nextmode.firstName;
        Nextmode.lastName=self.Nextmode.lastName;
        Nextmode.birthday=@"";
        Nextmode.gender=@"MALE";
        Nextmode.postCode=@"";
        vc.Nextmode=Nextmode;
        [self.navigationController pushViewController:vc animated:YES];
        
        /*
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GenderRViewController *vc=[main instantiateViewControllerWithIdentifier:@"GenderRViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        userIDMode * Nextmode = [[userIDMode alloc] init];
        Nextmode.firstName=self.Nextmode.firstName;
        Nextmode.lastName=self.Nextmode.lastName;
        Nextmode.birthday=@"";
        Nextmode.gender=@"";
        Nextmode.postCode=@"";
        vc.Nextmode=Nextmode;
        [self.navigationController pushViewController:vc animated:YES];
        */
    }else if (self.index==2)
    {
        [self postUpdateINFO:self.first_nameText.text lastName:self.last_nameText.text];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//// 更新用户的性别
-(void)postUpdateINFO:(NSString *)firstName lastName:(NSString*)lastName
//-(void)postUpdateINFO:(NSString *)gender
{
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"firstName":firstName,
                          @"lastName":lastName,
                          };
    NSLog(@"dict=== %@",dict);
    
//    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,post_UpdateInfo] parameters:dict progress:^(id progress) {
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_PostUserInfo] parameters:dict progress:^(id progress) {
    
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            //            用来储存用户信息
            
            SaveUserIDMode * mode = [[SaveUserIDMode alloc] init];
            mode.phoneNumber = [dictObject objectForKey:@"mobile"];//   手机号码
            mode.loginName = [dictObject objectForKey:@"username"];//   与手机号码相同
            mode.yonghuID = [dictObject objectForKey:@"memberId"]; ////用户ID
            mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
            mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
            NSString * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
            if(![birthdayNum isEqual:[NSNull null]])
            {
                NSInteger num = [birthdayNum integerValue];
                NSNumber * nums = @(num);
                mode.birthday = [nums stringValue];;
            }
            mode.gender = [dictObject objectForKey:@"gender"];//       MALE:男，FEMALE:女
            mode.postCode = [dictObject objectForKey:@"postCode"];//   Post Code inviteCode
            mode.EmailStr = [dictObject objectForKey:@"email"];//   email
            mode.inviteCode = [dictObject objectForKey:@"inviteCode"];//       我填写的邀请码
            mode.myInviteCode = [dictObject objectForKey:@"myInviteCode"];//       我的邀请码
            mode.headImageUrl = [dictObject objectForKey:@"headImageId"];
            mode.payPassword = [dictObject objectForKey:@"payPassword"];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
            
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            [jiamiStr base64Data_encrypt:mode.yonghuID];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[InformationViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    
                }
            }
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
//        NSString * errorMessage = (NSString *)receive;
//        [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
            [HudViewFZ HiddenHud];
    }];
}



#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.first_nameText) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.Nextmode.lastName=self.last_nameText.text;
                if (self.first_nameText.text.length >0 && self.last_nameText.text.length >0) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                }else
                {
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                    [self.next_btn setUserInteractionEnabled:NO];
                }
            });
            return YES;
        }else if (self.first_nameText.text.length >= 200) {
            self.first_nameText.text = [[textField.text stringByAppendingString:string] substringToIndex:(self.first_nameText.text.length+1)];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
                if (self.last_nameText.text.length >0) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    
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
                self.Nextmode.firstName=self.first_nameText.text;
                if (self.last_nameText.text.length >0 && self.first_nameText.text.length >0) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    
                }else
                {
                    [self.next_btn setUserInteractionEnabled:NO];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                }
            });
            
        }
        
    }else if (textField == self.last_nameText) {
        NSLog(@"string.Length= %@",textField.text);
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.Nextmode.lastName=self.last_nameText.text;
                if (self.first_nameText.text.length >0 && self.last_nameText.text.length >0) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                }else
                {
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                    [self.next_btn setUserInteractionEnabled:NO];
                }
            });
                
            return YES;
        }else if (self.last_nameText.text.length >=200) {
            //            NSLog(@"Length= %ld",self.Verification_number.text.length);
            self.last_nameText.text = [[textField.text stringByAppendingString:string] substringToIndex:(self.last_nameText.text.length+1)];
            
            if (self.first_nameText.text.length >0 && self.last_nameText.text.length >0) {
                [self.next_btn setUserInteractionEnabled:YES];
                self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
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
                self.Nextmode.lastName=self.last_nameText.text;
                if (self.first_nameText.text.length >0 && self.last_nameText.text.length >0) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
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
