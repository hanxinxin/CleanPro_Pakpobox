//
//  FriendsRViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "FriendsRViewController.h"

@interface FriendsRViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@end

@implementation FriendsRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.title_Label setText:FGGetStringWithKeyFromTable(@"Enter code from your friends!", @"Language")];
//    FGGetStringWithKeyFromTable(@"Choose a Password", @"Language")
    [self.Code_tuiguang setPlaceholder:FGGetStringWithKeyFromTable(@"Code", @"Language")];
    [self.complete setTitle:FGGetStringWithKeyFromTable(@"Complete", @"Language") forState:UIControlStateNormal];
    [self.Skip_btn setTitle:FGGetStringWithKeyFromTable(@"Skip", @"Language") forState:UIControlStateNormal];
    self.Skip_btn.layer.cornerRadius=4;
    self.Code_tuiguang.layer.cornerRadius=4;
    self.complete.layer.cornerRadius=4;
    self.Skip_btn.layer.borderColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0].CGColor;//设置边框颜色
    self.Skip_btn.layer.borderWidth = 1.0f;//设置边框颜色
    self.inviteCode=@"";
    self.Code_tuiguang.delegate=self;
    //    self.Verification_textfield.clearButtonMode = UITextFieldViewModeAlways;
    self.Code_tuiguang.keyboardType = UIKeyboardTypeASCIICapable;
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
    CGFloat offset = (self.Skip_btn.top+self.Skip_btn.height+kbHeight) - (self.view.frame.size.height);
    
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

- (IBAction)complete_touch:(id)sender {
//    [self postRegister];
    [self InciteCodeYZ:self.Code_tuiguang.text];
}
- (IBAction)Skip_touch:(id)sender {
    [self SkipInviteCode];
}


-(void)setCodetuiguang
{
    __block FriendsRViewController *  weakSelf = self;
//    self.Code_tuiguang1=[[TPPasswordTextView alloc] initWithFrame:self.Code_tuiguang.frame];
//    self.Code_tuiguang1.elementCount = 6;
//    self.Code_tuiguang1.backgroundColor=[UIColor whiteColor];
//    self.Code_tuiguang1.elementBorderColor=[UIColor blackColor];
//    self.Code_tuiguang1.passwordDidChangeBlock = ^(NSString *password) {
//        NSLog(@"%@",password);
////        self->_pay_passwordOne=password;
////        if(self->_pay_passwordOne.length==6)
////        {
////            [weakSelf GB_backgroundColor];
////        }else
////        {
////            [weakSelf GB_backgroundColor];
////        }
//    };
//    [self.view addSubview:self.Code_tuiguang1];
//    [self.Code_tuiguang1 hideKeyboard];
    
    HWTFCodeView *code1View = [[HWTFCodeView alloc] initWithCount:6 margin:10];
    code1View.frame = CGRectMake(self.Code_tuiguang.left, self.Code_tuiguang.top, self.Code_tuiguang.width/4*3, self.Code_tuiguang.height);
    [self.view addSubview:code1View];
    self.Code_tuiguang1 = code1View;
    self.Code_tuiguang1.passwordBlock = ^(NSString *password) {
                NSLog(@"password = %@",password);
        
                weakSelf.inviteCode=password;
                if(weakSelf.inviteCode.length==6)
                {
                    self.Nextmode.inviteCode=weakSelf.inviteCode;
//                    [weakSelf postRegister];
                    [weakSelf InciteCodeYZ:weakSelf.inviteCode];
                }else
                {
//                    [weakSelf GB_backgroundColor];
                }
            };
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)InciteCodeYZ:(NSString *)strInviteCode
{
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@inviteCode=%@",FuWuQiUrl,GetInciteYZ,strInviteCode] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
//         [HudViewFZ HiddenHud];
        NSDictionary * dictList=(NSDictionary *)responseObject;
        NSNumber * statusCodeStr=[dictList objectForKey:@"statusCode"];
        if([statusCodeStr integerValue]==401 || [statusCodeStr integerValue]==404 || statusCodeStr!=nil)
        {
             [HudViewFZ HiddenHud];
            
           NSString * errorMessage = [dictList objectForKey:@"errorMessage"];
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.5];
        }else if(statusCodeStr==nil){
            self.Nextmode.inviteCode=strInviteCode;
            [self postRegister];
        }
        
    } failure:^(NSError *error) {
         [HudViewFZ HiddenHud];
        NSLog(@"error ORder=  %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Network error", @"Language") andDelay:2.0];
    }];
}


-(void)postRegister
{
    NSDictionary * dict=@{@"phoneNumber":self.Nextmode.phoneNumber,
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
                          @"inviteCode":self.Nextmode.inviteCode,//
                          };
    NSLog(@"dict=== %@",dict);
    
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_Register] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
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


#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.Code_tuiguang) {
        NSLog(@"string.Length= %@",textField.text);
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
//            self.next_btn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
//            [self.next_btn setUserInteractionEnabled:NO];
            return YES;
        }else if (textField.text.length >= 5) {
            //            NSLog(@"Length= %ld",self.Verification_number.text.length);
            self.Code_tuiguang.text = [[textField.text stringByAppendingString:string] substringToIndex:6];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
            });
            return NO;
        }else
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                self.next_btn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
//                [self.next_btn setUserInteractionEnabled:NO];
            });
            
        }
    }
    return YES;
}


@end
