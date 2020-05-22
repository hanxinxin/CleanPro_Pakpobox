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
#import "MyAccountViewController.h"
#import "NewRegisterViewController.h"
#import "timelineAddressViewNew.h"
#import "NewHomeViewController.h"
#import "EwashMyViewController.h"
@interface PostcodeRViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,timelineDelegate,timelineDelegateNew>
{
//    timelineAddressView * timeViewA;
    timelineAddressViewNew * timeViewA;
    NSString * ariaId;
}

@property (nonatomic,strong)SaveUserIDMode * ModeUser;
@property (nonatomic,strong)NSArray * CityArray;
@property (nonatomic,strong)NSMutableArray * SelectArray;

@property (nonatomic, assign) NSInteger inputCount;     //用户输入次数，用来控制延迟搜索请求
@end

@implementation PostcodeRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputCount=0;
    self.next_btn.layer.cornerRadius=4;
    self.Skip_btn.layer.cornerRadius=4;
    self.textfield.layer.cornerRadius=4;
    self.textfield.delegate=self;
    self.textfield.keyboardType = UIKeyboardTypePhonePad;
    self.AddressTextfield.layer.cornerRadius=4;
    self.AddressTextfield.delegate=self;
    self.AddressTextfield.keyboardType = UIKeyboardTypeDefault;
    self.AreaTextfield.tag = 1000;
    self.SelectArray = [NSMutableArray arrayWithCapacity:0];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhiViewController:) name:@"tongzhiViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.textfield];
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
        self.title=FGGetStringWithKeyFromTable(@"Postcode", @"Language");
    }else if (self.index==2)
    {
        [self.Skip_btn setHidden:YES];
        [self.next_btn setTitle:@"Save" forState:UIControlStateNormal];
        self.title=FGGetStringWithKeyFromTable(@"Address", @"Language");
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


- (void)textFieldDidChange :(NSNotification *)notif
{
     //
    [self inputBarTextViewDidChange:self.textfield hasInputText:self.textfield.text];
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
//    [HudViewFZ labelExample:self.view];
//    [self Get_AddressSelectList:nil parentIdStr:nil index:1];
    if(self.SelectArray.count>0)
    {
        [self setTimeLineArray:nil selectArr:self.SelectArray index:0];
    }else
    {
        [self setTimeLineArray:nil selectArr:nil index:0];
    }
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    timelineAddressViewController *vc=[main instantiateViewControllerWithIdentifier:@"timelineAddressViewController"];
//    timeViewA = vc.view;
    
}
-(void)setTimeLineArray:(NSMutableArray*)Cityarray1 selectArr:(NSMutableArray *)Selectarray index:(NSInteger)index
{
//    UINib *nib = [UINib nibWithNibName:@"timelineAddressView" bundle:nil];
//        NSArray *objs = [nib instantiateWithOwner:nil options:nil];
//        timeViewA=objs[0];
//        timeViewA.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
//        timeViewA.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"timelineAddressViewNew" bundle:nil];
    NSArray *objs = [nib instantiateWithOwner:nil options:nil];
    timeViewA=objs[0];
    timeViewA.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    timeViewA.delegate = self;
        [timeViewA setArrayTable:Cityarray1 selectArr:Selectarray index:index];
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

-(void)CancelDelegate:(NSInteger)time SelectArray:(nonnull NSMutableArray *)array
{
    if(time==1)
    {
        [self hidden_Timeview];
    }else if(time==2)
    {
       if(array.count==3)
       {
           
           [self UpdateSelfViewUI:array];
           self.SelectArray=array;
           if(self.textfield.text.length>0 && self.AreaTextfield.text.length>0)
           {
               [self.next_btn setUserInteractionEnabled:YES];
               self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
           }
           [self hidden_Timeview];
       }else{
           [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No specific location selected", @"Language") andDelay:2.0];
       }
    }
}
-(void)CancelDelegateNew:(NSInteger)time SelectArray:(nonnull NSMutableArray *)array
{
    if(time==1)
    {
        [self hidden_Timeview];
    }else if(time==2)
    {
       if(array.count>=3)
       {
           
           [self UpdateSelfViewUI:array];
           self.SelectArray=array;
           if(self.textfield.text.length>0 && self.AreaTextfield.text.length>0)
           {
               [self.next_btn setUserInteractionEnabled:YES];
               self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
           }
           [self hidden_Timeview];
       }else{
           [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No specific location selected", @"Language") andDelay:2.0];
       }
    }
}
//-(void)UpdateSelfViewUI:(NSMutableArray * )array
//{
//    ThreeCityMode * mode3=array[2];
//    TwoCityMode * mode2 = mode3.parentRegion;
//    OneCityMode * mode1 = mode2.parentRegion;
//    self.AreaTextfield.text = [NSString stringWithFormat:@"%@%@%@",mode1.regionName,mode2.regionName,mode3.regionName];
//    self.textfield.text = mode3.postcode;
//    if(self.textfield.text.length>0 && self.AreaTextfield.text.length>0)
//    {
//        [self.next_btn setUserInteractionEnabled:YES];
//        self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
//    }
//}
-(void)UpdateSelfViewUI:(NSMutableArray * )array
{
    if(array.count==4)
    {
        upperGradeOneMode * mode3=array[array.count-1];
        upperGradeOneMode * mode2 = [self JXGradeMode:mode3.upperGrade];
        upperGradeOneMode * mode1 = [self JXGradeMode:mode2.upperGrade];
        upperGradeOneMode * mode0 = [self JXGradeMode:mode1.upperGrade];
        self.AreaTextfield.text = [NSString stringWithFormat:@"%@%@%@%@",mode0.name,mode1.name,mode2.name,mode3.name];
        if(![mode3.postCode isEqual:[NSNull null]])
        {
            self.textfield.text = mode3.postCode;
        }else
        {
            if(![mode2.postCode isEqual:[NSNull null]])
            {
                self.textfield.text = mode2.postCode;
            }else
            {
                if(![mode1.postCode isEqual:[NSNull null]])
                {
                    self.textfield.text = mode1.postCode;
                }else
                {
                    if(![mode0.postCode isEqual:[NSNull null]])
                    {
                        self.textfield.text = mode0.postCode;
                    }else
                    {
                        self.textfield.text = @"";
                    }
                }
            }
        }
    }else if(array.count==3)
    {
        upperGradeOneMode * mode3=array[array.count-1];
        upperGradeOneMode * mode2 = [self JXGradeMode:mode3.upperGrade];
        upperGradeOneMode * mode1 = [self JXGradeMode:mode2.upperGrade];
        self.AreaTextfield.text = [NSString stringWithFormat:@"%@%@%@",mode1.name,mode2.name,mode3.name];
        if(![mode3.postCode isEqual:[NSNull null]])
        {
            self.textfield.text = mode3.postCode;
        }else
        {
            if(![mode2.postCode isEqual:[NSNull null]])
            {
                self.textfield.text = mode2.postCode;
            }else
            {
                if(![mode1.postCode isEqual:[NSNull null]])
                {
                    self.textfield.text = mode1.postCode;
                }else
                {
                        self.textfield.text = @"";
                }
            }
        }
    }
    if(self.textfield.text.length>0 && self.AreaTextfield.text.length>0)
    {
        [self.next_btn setUserInteractionEnabled:YES];
        self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    }
}
-(upperGradeOneMode*)JXGradeMode:(NSDictionary*)dict
{
    upperGradeOneMode* mode = [[upperGradeOneMode alloc] init];
    mode.districtId=[dict objectForKey:@"districtId"];
    mode.enName=[dict objectForKey:@"enName"];
    mode.endGrade=[dict objectForKey:@"endGrade"];
    mode.grade=[dict objectForKey:@"grade"];
    mode.name=[dict objectForKey:@"name"];
    mode.postCode=[dict objectForKey:@"postCode"];
    NSDictionary * dict2 =[dict objectForKey:@"upperGrade"];
    mode.upperGrade = dict2;
    mode.upperGradeId=[dict objectForKey:@"upperGradeId"];
    return mode;
}
/*
///获取用户的详细地址
-(void)getUserAddressInfo
{
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,GetUserAddress,self.ModeUser.yonghuID] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject== %@",responseObject);
        NSDictionary * region = [responseObject objectForKey:@"region"];
        NSString * detailedAddress  = [responseObject objectForKey:@"detailedAddress"];
        if(detailedAddress!=nil)
        {
            self.AddressTextfield.text = detailedAddress;
        }else{
            self.AddressTextfield.text = @"";
        }
        if(region!=nil)
        {
            NSMutableArray *Muarray3 =[NSMutableArray arrayWithCapacity:0];
            NSDictionary * dict3 = region;
            ThreeCityMode * mode3= [[ThreeCityMode alloc] init];
            mode3.idStrThree = [dict3 objectForKey:@"id"];
            NSDictionary * dict=[dict3 objectForKey:@"parentRegion"];
                TwoCityMode * modeT = [[TwoCityMode alloc] init];
                modeT.idStrTwo=[dict objectForKey:@"id"];
                NSDictionary * dictTwo=[dict objectForKey:@"parentRegion"];
                    OneCityMode* modeO = [[OneCityMode alloc] init];
                    modeO.idStr=[dictTwo objectForKey:@"id"];
                    modeO.regionLevel=[dictTwo objectForKey:@"regionLevel"];
                    modeO.regionName=[dictTwo objectForKey:@"regionName"];
                    modeO.regionShortName=[dictTwo objectForKey:@"regionShortName"];
                modeT.parentRegion = modeO;
                modeT.regionLevel=[dict objectForKey:@"regionLevel"];
                modeT.regionName=[dict objectForKey:@"regionName"];
            mode3.parentRegion=modeT;
            mode3.postcode = [dict3 objectForKey:@"postcode"];
            mode3.regionLevel=[dict3 objectForKey:@"regionLevel"];
            mode3.regionName=[dict3 objectForKey:@"regionName"];
            [Muarray3 addObject:modeO];
            [Muarray3 addObject:modeT];
            [Muarray3 addObject:mode3];
            self.SelectArray=Muarray3;
            [self UpdateSelfViewUI:self.SelectArray];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}
 */
///获取用户的详细地址
-(void)getUserAddressInfo
{
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_getaddressInfo] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject== %@",responseObject);
        NSDictionary * aria = [responseObject objectForKey:@"aria"];
        NSString * detailedAddress  = [responseObject objectForKey:@"detailedAddress"];
        if(detailedAddress!=nil  && ![detailedAddress isEqual:[NSNull null]])
        {
            self.AddressTextfield.text = detailedAddress;
        }else{
            self.AddressTextfield.text = @"";
        }
        if(aria!=nil && ![aria isEqual:[NSNull null]])
        {
            NSMutableArray *Muarray3 =[NSMutableArray arrayWithCapacity:0];
            upperGradeOneMode* mode3 = [self JXGradeMode:aria];
            if([mode3.grade intValue]==3)
            {
            upperGradeOneMode * mode2 = [self JXGradeMode:mode3.upperGrade];
            upperGradeOneMode * mode1 = [self JXGradeMode:mode2.upperGrade];
            [Muarray3 addObject:mode1];
            [Muarray3 addObject:mode2];
            [Muarray3 addObject:mode3];
            self.SelectArray=Muarray3;
            }else if([mode3.grade intValue]==4)
            {
                upperGradeOneMode * mode2 = [self JXGradeMode:mode3.upperGrade];
                upperGradeOneMode * mode1 = [self JXGradeMode:mode2.upperGrade];
                upperGradeOneMode * mode0 = [self JXGradeMode:mode1.upperGrade];
                [Muarray3 addObject:mode0];
                [Muarray3 addObject:mode1];
                [Muarray3 addObject:mode2];
                [Muarray3 addObject:mode3];
                self.SelectArray=Muarray3;
            }
            [self UpdateSelfViewUI:self.SelectArray];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        if(statusCode==401)
        {
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"SetNSUserDefaults" object:nil userInfo:nil]];
            [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil]];
            
        }else{
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            
        }
    }];
}
 


- (void)tongzhiViewController:(NSNotification *)text{
    
    NSLog(@"－－－－－接收到通知------");
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.55/*延迟执行时间*/ * NSEC_PER_SEC));

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[NewHomeViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];

                }
            }
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[EwashMyViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。

                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
                }
            }
    });
}
-(NSString *)dictStr:(NSError *)error
{
//    NSString * receive=@"";
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//    receive= [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSString  * message = [dictFromData valueForKey:@"message"];
//
    return message;
}
//
//-(void)updateUserAddress:(NSString *)postcode detailedAddress:(NSString*)detailedAddress region:(NSString*)region
//{
//    NSDictionary * idDict = @{@"id":region};
//    NSDictionary * dict = @{@"postcode":postcode,
//                            @"detailedAddress":detailedAddress,
//                            @"region":idDict
//    };
//    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_PostaddressUpdate] parameters:dict progress:^(id progress) {
//
//    } Success:^(NSInteger statusCode, id responseObject) {
//         [HudViewFZ HiddenHud];
//        NSLog(@"responseObject = %@",responseObject);
//        NSString * postcode = [responseObject objectForKey:@"postcode"];
//        NSNumber * statusCodeRE = [responseObject objectForKey:@"statusCode"];
////        NSString * errorMessage = [responseObject objectForKey:@"errorMessage"];
//        if(statusCode==200)
//        {
//            if(statusCodeRE==nil)
//            {
//                if([postcode isEqualToString:self.textfield.text])
//                {
//                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address set successfully", @"Language") andDelay:2.0];
//                }else{
//                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address setting failed", @"Language") andDelay:2.0];
//                }
//            }else if([statusCodeRE intValue]==401)
//            {
////                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
//                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults setObject:@"1" forKey:@"Token"];
//                [userDefaults setObject:@"1" forKey:@"phoneNumber"];
//                [userDefaults setObject:nil forKey:@"SaveUserMode"];
//                [userDefaults setObject:@"1" forKey:@"logCamera"];
//                //    [defaults synchronize];
//                NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
//                //通过通知中心发送通知
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
//                for (UIViewController *controller in self.navigationController.viewControllers) {
//                    if ([controller isKindOfClass:[MyAccountViewController class]]) {
//                        [self.navigationController popToViewController:controller animated:YES];
//
//                    }
//                }
//            }else
//            {
//                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
//            }
//            }
//    } failure:^(NSInteger statusCode, NSError *error) {
//        NSLog(@"error = %@",error);
//        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
//        [HudViewFZ HiddenHud];
//
//    }];
//}


-(void)updateUserAddress:(NSString *)postcode detailedAddress:(NSString*)detailedAddress region:(NSString*)ariaId
{
//    NSDictionary * idDict = @{@"id":region};
    NSDictionary * dict = @{@"postCode":postcode,
                            @"detailedAddress":detailedAddress,
                            @"ariaId":ariaId
    };
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_PostaddressUpdate] parameters:dict progress:^(id progress) {
        
    } Success:^(NSInteger statusCode, id responseObject) {
         [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
//        NSString * postcode = [responseObject objectForKey:@"postcode"];
        NSString * ariaId = [responseObject objectForKey:@"ariaId"];
//        NSString * errorMessage = [responseObject objectForKey:@"errorMessage"];
//        if(statusCode==200)
//        {
            if(ariaId!=nil)
            {
                NSDictionary * aria = [responseObject objectForKey:@"aria"];
                if(aria!=nil)
                {
                    upperGradeOneMode* mode3 = [self JXGradeMode:aria];
                   
                    if([mode3.grade intValue]==3)
                    {
//                        upperGradeOneMode * mode2 = [self JXGradeMode:mode3.upperGrade];
//                        upperGradeOneMode * mode1 = [self JXGradeMode:mode2.upperGrade];
                                           
                        if([mode3.postCode isEqualToString:self.textfield.text])
                        {
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address set successfully", @"Language") andDelay:2.0];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address setting failed", @"Language") andDelay:2.0];
                        }
                    }else if([mode3.grade intValue]==4)
                    {
                        upperGradeOneMode * mode2 = [self JXGradeMode:mode3.upperGrade];
//                        upperGradeOneMode * mode1 = [self JXGradeMode:mode2.upperGrade];
//                        upperGradeOneMode * mode0 = [self JXGradeMode:mode1.upperGrade];
                        if([mode2.postCode isEqualToString:self.textfield.text])
                        {
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address set successfully", @"Language") andDelay:2.0];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address setting failed", @"Language") andDelay:2.0];
                        }
                    }
                    
                }
                
//            }else if([statusCodeRE intValue]==401)
//            {
////                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
//                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults setObject:@"1" forKey:@"Token"];
//                [userDefaults setObject:@"1" forKey:@"phoneNumber"];
//                [userDefaults setObject:nil forKey:@"SaveUserMode"];
//                [userDefaults setObject:@"1" forKey:@"logCamera"];
//                //    [defaults synchronize];
//                NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
//                //通过通知中心发送通知
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
//                for (UIViewController *controller in self.navigationController.viewControllers) {
//                    if ([controller isKindOfClass:[MyAccountViewController class]]) {
//                        [self.navigationController popToViewController:controller animated:YES];
//                        
//                    }
//                }
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
            }
//            }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:[self dictStr:error] andDelay:2.0];
        [HudViewFZ HiddenHud];
        
    }];
}

- (IBAction)Next_touch:(id)sender {
    if(self.index==1)
    {
        if(self.textfield.text.length > 0)
        {
            //4.21 先屏蔽以前的代码
//            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            PhoneRViewController *vc=[main instantiateViewControllerWithIdentifier:@"PhoneRViewController"];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.Nextmode=self.Nextmode;
//            [self.navigationController pushViewController:vc animated:YES];
            
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NewRegisterViewController *vc=[main instantiateViewControllerWithIdentifier:@"NewRegisterViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.Nextmode=self.Nextmode;
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (self.index==2)
    {
//        [self postUpdateINFO:self.textfield.text ];
        if(self.textfield.text!=nil)
        {
            if(self.SelectArray != nil)
            {
                if(self.AddressTextfield.text!=nil)
                {
//                 ThreeCityMode * mode3 = self.SelectArray[2];
                    upperGradeOneMode * mode = self.SelectArray[self.SelectArray.count-1];
                    [HudViewFZ labelExample:self.view];
                [self updateUserAddress:self.textfield.text detailedAddress:self.AddressTextfield.text region:mode.districtId];
                }else
                {
                    self.AddressTextfield.text=@"";
//                    ThreeCityMode * mode3 = self.SelectArray[2];
                    upperGradeOneMode * mode = self.SelectArray[self.SelectArray.count-1];
                    [HudViewFZ labelExample:self.view];
                    [self updateUserAddress:self.textfield.text detailedAddress:self.AddressTextfield.text region:mode.districtId];
                }
            }else{
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Area Can't be empty", @"Language") andDelay:2.0];
            }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please enter the Postcode", @"Language") andDelay:2.0];
        }
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

/// 根据区号获取地址
-(void)Get_AddressSelectList:(NSString *)postcode parentIdStr:(NSString *)parentId index:(NSInteger)Index
{
    NSString * GetURLStr;
    if(postcode!=nil)
    {
        if(parentId!=nil)
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@?postCode=%@&upperGradeId=%@",E_FuWuQiUrl,E_getDistrict,postcode,parentId] ;
        }else
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@?postCode=%@",E_FuWuQiUrl,E_getDistrict,postcode];
        }
    }else
    {
        if(parentId!=nil)
        {
            
            if(Index!=0)
            {
                
                GetURLStr=[NSString stringWithFormat:@"%@%@?upperGradeId=%@&grade=%ld",E_FuWuQiUrl,E_getDistrict,parentId,(long)Index] ;
            }else
            {
                GetURLStr=[NSString stringWithFormat:@"%@%@?upperGradeId=%@",E_FuWuQiUrl,E_getDistrict,parentId] ;
            }
        }else
        {
            if(Index!=0)
            {
                
                GetURLStr=[NSString stringWithFormat:@"%@%@?grade=%ld",E_FuWuQiUrl,E_getDistrict,(long)Index] ;
            }else
            {
                GetURLStr=[NSString stringWithFormat:@"%@%@?grade=3",E_FuWuQiUrl,E_getDistrict];
            }
        }
    }
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:GetURLStr parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject== %@",responseObject);
        [HudViewFZ HiddenHud];
        
        NSArray * arrayZong = (NSArray *)responseObject;
        if(arrayZong.count>0)
        {
        if(postcode==nil && parentId==nil && Index==1)
        {
            if(responseObject!=nil)
            {
            NSMutableArray * KBArray = [NSMutableArray arrayWithCapacity:0];
            for (int i =0; i<arrayZong.count; i++) {
                NSDictionary * dict =arrayZong[i];
                upperGradeOneMode*mode = [self JXGradeMode:dict];
                [KBArray addObject:mode];
            }
//            NSArray * array = @[KBArray];
//            self.CityArray= KBArray;
//            [self->timeViewA setArrayTable:self.CityArray];
            [self setTimeLineArray:KBArray selectArr:nil index:0];
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No data was found", @"Language") andDelay:1.5];
        }
        }else if(postcode!=nil && parentId==nil && Index==0)
        {
            if(responseObject!=nil)
            {
            NSMutableArray * Muarray3 = [NSMutableArray arrayWithCapacity:0];
            NSArray * array = (NSArray *)responseObject;
            for (int i =0 ; i<array.count; i++) {
                NSDictionary * dict3 = array[i];
                upperGradeOneMode*mode3 = [self JXGradeMode:dict3];
                [Muarray3 addObject:mode3];
            }
//            self.CityArray = Muarray3;
                [self tapBG:nil];
                [self setTimeLineArray:nil selectArr:Muarray3 index:1];
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No query found", @"Language") andDelay:1.5];
            }
        }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Postcode is wrong, please re-enter!", @"Language") andDelay:1.5];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
//        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
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
        }else if (self.textfield.text.length>=6) {
            self.textfield.text = [[textField.text stringByAppendingString:string] substringToIndex:7];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.Nextmode.postCode=self.textfield.text;
//                [self Get_AddressSelectList:self.textfield.text parentIdStr:nil index:0];
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
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.Nextmode.postCode=self.textfield.text;
                if (self.textfield.text.length>=4) {
//                    [self Get_AddressSelectList:self.textfield.text parentIdStr:nil index:0];
                }
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
        [self setSelfTextData];
    }else if (textField == self.AddressTextfield)
    {
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
            });
            return YES;
        }else if (self.AddressTextfield.text.length>=50) {
            self.AddressTextfield.text = [[textField.text stringByAppendingString:string] substringToIndex:(50)];
        }
    }
    return YES;
}


-(void)setSelfTextData
{
    self.AreaTextfield.text = [NSString stringWithFormat:@""];
    [self.SelectArray removeAllObjects];
}



- (void)inputBarTextViewDidChange:(UITextField *)textView hasInputText:(NSString *)text {
    // 用户停止输入1秒后进行提示内容匹配搜索
    self.inputCount ++;
    [self performSelector:@selector(requestKeyWorld:) withObject:@(self.inputCount) afterDelay:1.0f];
}

- (void)requestKeyWorld:(NSNumber *)count {
    if (self.inputCount == [count integerValue]) {
        //说明用户停止输入超过了一秒，发起网络请求
        [[AFNetWrokingAssistant shareAssistant] cancelTask];
        //执行网络请求
        [self Get_AddressSelectList:self.textfield.text parentIdStr:nil index:0];
    }
}
- (void)searchKeyword:(NSNumber *)inputCount{

    // 判断不等于0是为了防止用户输入完直接点击搜索，延时结束之后又搜索一次
    if (inputCount.integerValue == self.inputCount && self.inputCount != 0) {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
}

@end
