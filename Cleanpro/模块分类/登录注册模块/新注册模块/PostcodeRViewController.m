//
//  PostcodeRViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PostcodeRViewController.h"
#import "PhoneRViewController.h"
#import "InformationViewController.h"
#import "timelineAddressView.h"
@interface PostcodeRViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,timelineDelegate>
{
    timelineAddressView * timeViewA;
}

@property (nonatomic,strong)SaveUserIDMode * ModeUser;
@property (nonatomic,strong)NSArray * CityArray;
@end

@implementation PostcodeRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.next_btn.layer.cornerRadius=4;
    self.Skip_btn.layer.cornerRadius=4;
    self.textfield.layer.cornerRadius=4;
    self.textfield.delegate=self;
    self.textfield.keyboardType = UIKeyboardTypeDefault;
    self.AddressTextfield.layer.cornerRadius=4;
    self.AddressTextfield.delegate=self;
    self.AddressTextfield.keyboardType = UIKeyboardTypeDefault;
    self.AreaTextfield.tag = 1000;
    UITapGestureRecognizer * tapATextfield= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTouch:)];
    tapATextfield.delegate = self;
    [self.AreaTextfield addGestureRecognizer:tapATextfield];
    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
    [self.next_btn setUserInteractionEnabled:NO];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
    });
    //    设置点击任何其他位置 键盘回收
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
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
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.CityArray=[[NSArray alloc] init];
    if(self.index==1)
    {
        [self.next_btn setTitle:@"Next" forState:UIControlStateNormal];
        [self.Skip_btn setHidden:NO];
    }else if (self.index==2)
    {
        [self.Skip_btn setHidden:YES];
        [self.next_btn setTitle:@"Save" forState:UIControlStateNormal];
    }
    [self.navigationController.navigationBar setHidden:NO];
    [self addNoticeForKeyboard];
    [self getUserAddressInfo];/// 获取用户的详细地址
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
//    CGFloat offset = (self.Skip_btn.top+self.Skip_btn.height+kbHeight) - (self.view.frame.size.height);
    CGFloat offset = (self.textfield.top+self.textfield.height+kbHeight+(kNavBarAndStatusBarHeight)) - SCREEN_HEIGHT;
    
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
            self.view.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)tapGestureTouch:(UITapGestureRecognizer *)gesture {
    [self tapBG:nil];
    [HudViewFZ labelExample:self.view];
    [self Get_AddressSelectList:nil parentIdStr:nil index:1];
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    timelineAddressViewController *vc=[main instantiateViewControllerWithIdentifier:@"timelineAddressViewController"];
//    timeViewA = vc.view;
    
}
-(void)setTimeLineArray:(NSArray*)array
{
    UINib *nib = [UINib nibWithNibName:@"timelineAddressView" bundle:nil];
        NSArray *objs = [nib instantiateWithOwner:nil options:nil];
        timeViewA=objs[0];
        timeViewA.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        timeViewA.delegate = self;
    //    NSArray * array = @[@[@"11",@"12",@"13",@"14",@"15",@"16"],@[@"21",@"22",@"23",@"24",@"25",@"26"],@[@"31",@"32",@"33",@"34",@"35",@"36"]];
        [timeViewA setArrayTable:array];
        [self.view addSubview:timeViewA];
        [self show_Timeview];
}
-(void)show_Timeview
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
        self->timeViewA.frame=self.view.bounds;
    }];
    
}
-(void)hidden_Timeview
{
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self->timeViewA.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        [self->timeViewA removeFromSuperview];
    }];
}

////点击别的区域收起键盘
- (void)timeViewABG:(UITapGestureRecognizer *)gesture {
    
    [self hidden_Timeview];
}

-(void)CancelDelegate:(NSInteger)time
{
    if(time==1)
    {
        [self hidden_Timeview];
    }else if(time==1)
    {
       
    }
}


- (IBAction)Next_touch:(id)sender {
    if(self.index==1)
    {
        if(self.textfield.text.length > 0)
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PhoneRViewController *vc=[main instantiateViewControllerWithIdentifier:@"PhoneRViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.Nextmode=self.Nextmode;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (self.index==2)
    {
        [self postUpdateINFO:self.textfield.text ];
    }
    
}
- (IBAction)Skip_touch:(id)sender {
    if(self.index==1)
    {
            self.Nextmode.postCode=@"";
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PhoneRViewController *vc=[main instantiateViewControllerWithIdentifier:@"PhoneRViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.Nextmode=self.Nextmode;
            [self.navigationController pushViewController:vc animated:YES];
        
    }
}


//// 更新用户的性别
//-(void)postUpdateINFO:(NSString *)firstName lastName:(NSString*)lastName
-(void)postUpdateINFO:(NSString *)postCode
{
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"postCode":postCode,
                          };
    NSLog(@"dict=== %@",dict);
    
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,post_UpdateInfo] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            //            用来储存用户信息
            
            SaveUserIDMode * mode = [[SaveUserIDMode alloc] init];
            
            mode.phoneNumber = [dictObject objectForKey:@"phoneNumber"];//   手机号码
            mode.loginName = [dictObject objectForKey:@"loginName"];//   与手机号码相同
            mode.yonghuID = [dictObject objectForKey:@"id"]; ////用户ID
            //            mode.randomPassword = [dictObject objectForKey:@"randomPassword"];//  验证码
            //            mode.password = [dictObject objectForKey:@"password"];//  登录密码
            //            mode.payPassword = [dictObject objectForKey:@"payPassword"];//    支付密码
            mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
            mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
            NSNumber * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
            mode.birthday = [birthdayNum stringValue];
            mode.gender = [dictObject objectForKey:@"gender"];//       MALE:男，FEMALE:女
            mode.postCode = [dictObject objectForKey:@"postCode"];//   Post Code inviteCode
            mode.EmailStr = [dictObject objectForKey:@"email"];//   email
            mode.inviteCode = [dictObject objectForKey:@"inviteCode"];//       我填写的邀请码
            mode.myInviteCode = [dictObject objectForKey:@"myInviteCode"];//       我的邀请码
            mode.headImageUrl = [dictObject objectForKey:@"headImageUrl"];
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

///获取用户的详细地址
-(void)getUserAddressInfo
{
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,GetUserAddress,self.ModeUser.yonghuID] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject== %@",responseObject);
        
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}

/// 根据区号获取地址
-(void)Get_AddressSelectList:(NSString *)postcode parentIdStr:(NSString *)parentId index:(NSInteger)Index
{
    NSString * GetURLStr;
    if(postcode!=nil)
    {
        if(parentId!=nil)
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@?postcode=%@&parentId=%@",FuWuQiUrl,Get_AddressSelect,postcode,parentId] ;
        }else
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@?postcode=%@&parentId=%@",FuWuQiUrl,Get_AddressSelect,postcode,parentId];
        }
    }else
    {
        if(parentId!=nil)
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@?parentId=%@",FuWuQiUrl,Get_AddressSelect,parentId] ;
        }else
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_AddressSelect];
        }
    }
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:GetURLStr parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject== %@",responseObject);
        [HudViewFZ HiddenHud];
        NSArray * arrayZong = (NSArray *)responseObject;
        if(postcode==nil && parentId==nil && Index==1)
        {
            NSMutableArray * KBArray = [NSMutableArray arrayWithCapacity:0];
            for (int i =0; i<arrayZong.count; i++) {
                NSDictionary * dict =arrayZong[i];
                OneCityMode* mode = [[OneCityMode alloc] init];
                mode.idStr=[dict objectForKey:@"id"];
                mode.regionLevel=[dict objectForKey:@"regionLevel"];
                mode.regionName=[dict objectForKey:@"regionName"];
                mode.regionShortName=[dict objectForKey:@"regionShortName"];
                [KBArray addObject:mode];
            }
//            NSArray * array = @[KBArray];
            self.CityArray= KBArray;
//            [self->timeViewA setArrayTable:self.CityArray];
            [self setTimeLineArray:self.CityArray];
        }
        
    } failure:^(NSError *error) {
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
#define UITextFieldDelete  -------- - -------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField.tag==1000)
    {
        return NO;
    }else
    {
        return YES;
    }
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.textfield) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.Nextmode.postCode=self.textfield.text;
                if (self.textfield.text.length >0 && self.AreaTextfield.text.length>0) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                }else
                {
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                    [self.next_btn setUserInteractionEnabled:NO];
                }
            });
            return YES;
        }else if (self.textfield.text.length>=5) {
            self.textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:(self.textfield.text.length+1)];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.Nextmode.postCode=self.textfield.text;
            if (self.textfield.text.length >0 && self.AreaTextfield.text.length>0) {
                [self.next_btn setUserInteractionEnabled:YES];
                self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                
            }else
            {
                [self.next_btn setUserInteractionEnabled:NO];
                self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
            }
            });
            return NO;
        }else
        {
            if (self.textfield.text.length>=4) {
                [self Get_AddressSelectList:self.AreaTextfield.text parentIdStr:nil index:0];
            }else
            {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.Nextmode.postCode=self.textfield.text;
                if (self.textfield.text.length >0 && self.AreaTextfield.text.length>0) {
                    [self.next_btn setUserInteractionEnabled:YES];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                    
                }else
                {
                    [self.next_btn setUserInteractionEnabled:NO];
                    self.next_btn.backgroundColor=[UIColor colorWithRed:172/255.0 green:220/255.0 blue:251/255.0 alpha:1.0];
                }
            });
            }
            
        }
        
    }
    return YES;
}

@end
