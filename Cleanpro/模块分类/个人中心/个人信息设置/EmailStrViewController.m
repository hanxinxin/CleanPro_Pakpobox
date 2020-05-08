//
//  EmailStrViewController.m
//  Cleanpro
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "EmailStrViewController.h"
#import "InformationViewController.h"
@interface EmailStrViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    
}
@property (nonatomic,strong)SaveUserIDMode * ModeUser;
@end

@implementation EmailStrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=FGGetStringWithKeyFromTable(@"Email", @"Language");
    [self.WC_btn setTitle:FGGetStringWithKeyFromTable(@"Complete", @"Language") forState:UIControlStateNormal];
    [self.Email_textfield setPlaceholder:FGGetStringWithKeyFromTable(@"Please enter email address", @"Language")];
    self.Email_textfield.delegate=self;
    //    self.Email_textfield.clearButtonMode = UITextFieldViewModeAlways;
    self.Email_textfield.returnKeyType =UIReturnKeyDone;
    ////登录注册圆角
    self.WC_btn.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
    self.WC_btn.layer.borderColor = [UIColor clearColor].CGColor;//设置边框颜色
    self.WC_btn.layer.borderWidth = 1.0f;//设置边框颜色
    self.topView.layer.borderColor = [UIColor clearColor].CGColor;//设置边框颜色
    self.topView.layer.borderWidth = 1.0f;//设置边框颜色
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
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    ///初始化单例
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if([self.ModeUser.EmailStr isEqual:[NSNull null]])
    {
        [self.Email_textfield setPlaceholder:FGGetStringWithKeyFromTable(@"Please enter email address", @"Language")];
    }else
    {
        if([self.ModeUser.EmailStr isEqualToString:@""])
        {
        [self.Email_textfield setPlaceholder:FGGetStringWithKeyFromTable(@"Please enter email address", @"Language")];
        }else
        {
            [self.Email_textfield setPlaceholder:self.ModeUser.EmailStr];
            [self.Email_textfield setText:self.ModeUser.EmailStr];
        }
        
    }
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}
- (IBAction)WC_touch:(id)sender {
    
    if(![self.Email_textfield.text isEqualToString:@""])
    {
        if ([self isValidateEmail:self.Email_textfield.text]) {
            [self postUpdateINFO:self.Email_textfield.text];
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Email format error", @"Language") andDelay:2.4];
        }
    }else
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please enter the correct email address", @"Language") andDelay:2.5];
    }
}


//// 更新用户的Email
-(void)postUpdateINFO:(NSString *)EmailStr
//-(void)postUpdateINFO:(NSString *)gender
{
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"email":EmailStr,
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
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
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

/**
  // called when 'return' key pressed. return NO to ignore.

 @param textField textField description
 @return return value description
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [self.Email_textfield resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    NSLog(@"输入框内容 = %@",toBeString);
    if (self.Email_textfield == textField)  //判断是否时我们想要限定的那个输入框
    {
        
        if ([toBeString length] > 50) { //如果输入框内容大于20则弹出警告
            
            textField.text = [toBeString substringToIndex:50];
            
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            return NO;
            
        }else
        {
            //            if([self isValidateEmail:toBeString])
            //            {
            //                NSLog(@"是邮箱格式");
            //                self.topView.layer.borderColor = [UIColor clearColor].CGColor;//设置边框颜色
            //                self.topView.layer.borderWidth = 1.0f;//设置边框颜色
            //                self.WC_btn.userInteractionEnabled=YES;
            //                [self.WC_btn setBackgroundColor:[UIColor colorWithRed:9/255.0 green:81/255.0 blue:148/255.0 alpha:1]];
            //            }else
            //            {
            //                NSLog(@"不是不是邮箱格式");
            //                self.topView.layer.borderColor = [UIColor redColor].CGColor;//设置边框颜色
            //                self.topView.layer.borderWidth = 1.0f;//设置边框颜色
            //                self.WC_btn.userInteractionEnabled=NO;
            //                [self.WC_btn setBackgroundColor:[UIColor lightGrayColor]];
            //
            //            }
        }
        
    }
    
    return YES;
    
}

//判断邮箱格式是否合法的正则表达式：
//邮箱地址的正则表达式
- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [pre evaluateWithObject:email];//此处返回的是BOOL类型,YES or NO;
    
}


@end
