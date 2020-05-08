//
//  MyAccountViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyWalletViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "FeedbackViewController.h"
#import "InformationViewController.h"
#import "InviteFriendsViewController.h"
#import "VIPjfViewController.h"
#import "IntroductionViewController.h"
#import "StaffViewController.h"


#import "NewMyWalletViewController.h"
#import "IMessageViewController.h"
#import "OrdersViewController.h"
#import "AppDelegate.h"
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
//#import <FBSDKShareKit/FBSDKShareMessengerURLActionButton.h>
//#import <FBSDKShareKit/FBSDKShareMessengerGenericTemplateElement.h>
//#import <FBSDKShareKit/FBSDKMessageDialog.h>
//#import <FBSDKShareKit/FBSDKSharingContent.h>
//#import <FBSDKShareKit/FBSDKShareMessengerGenericTemplateContent.h>
//#import <FBSDKShareKit/FBSDKSendButton.h>
//#import <FBSDKShareKit/FBSDKShareButton.h>
//#import <FBSDKShareKit/FBSDKShareMessengerOpenGraphMusicTemplateContent.h>


@interface MyAccountViewController ()<UITableViewDelegate,UITableViewDataSource,FBSDKSharingDelegate>
@property (nonatomic,strong)NSMutableArray * arrtitle;
@property (nonatomic,strong)UIScrollView * Down_Scroller;////全局可以滑动的ScrollView
@property (nonatomic,strong) UIImageView * imageView_down;
@property (nonatomic,strong)SaveUserIDMode * ModeUser;
@end

@implementation MyAccountViewController
@synthesize Down_Scroller,arrtitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        self.Down_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.Down_Scroller.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    arrtitle=[NSMutableArray arrayWithCapacity:0];
    [arrtitle addObject:[NSArray arrayWithObjects:FGGetStringWithKeyFromTable(@"My Wallet", @"Language"),FGGetStringWithKeyFromTable(@"History", @"Language"),FGGetStringWithKeyFromTable(@"Invite Friends", @"Language"), nil]];
    [arrtitle addObject:[NSArray arrayWithObjects:FGGetStringWithKeyFromTable(@"Introduction", @"Language"),FGGetStringWithKeyFromTable(@"Feedback", @"Language"),FGGetStringWithKeyFromTable(@"Settings", @"Language"),nil]];
    self.background_image.image=[UIImage imageNamed:@"me_head_bg1"];
    [self.jifen_btn setImage:[UIImage imageNamed:@"vip"] forState:UIControlStateNormal];
    self.touxiang_btn.layer.cornerRadius=self.touxiang_btn.width/2;
    self.touxiang_btn.layer.masksToBounds = YES;
    [self.touxiangImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageGesturerecognizer:)]];///设置点击事件
    //////设置imageview 圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.touxiangImage.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.touxiangImage.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.touxiangImage.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.touxiangImage.layer.mask = maskLayer;
    ///////
    [self.touxiangImage setUserInteractionEnabled:YES];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.subviews[0].alpha = 0.0;
        [self addDownScroller];
        
    });
    
}

-(void)addsendFeacbookMessage
{
    
    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:@"a94b13f4671d9e4aa3d936aa0849a1bb" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    [self.touxiang_btn setBackgroundImage:[UIImage imageWithData:decodedImageData] forState:(UIControlStateNormal)];
    
}


    
    
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.title=FGGetStringWithKeyFromTable(@"Me", @"Language");
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
        self.name_label.text=FGGetStringWithKeyFromTable(@"Click here to login", @"Language");
        self.jifen_label.text=@"";
        //        self.touxiang_btn.userInteractionEnabled=YES;
        [self.touxiang_btn setBackgroundImage:[UIImage imageNamed:@"icon_Avatar"] forState:UIControlStateNormal];
        [self.touxiangImage setImage:[UIImage imageNamed:@"icon_Avatar"]];
        [self.jifen_btn setHidden:YES];
    }else
    {
        [self.jifen_btn setHidden:NO];
        [self updateText];
        
    }
//    [self.Down_tableView setHidden:YES];
//    [self addRightBtn];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSLog(@"宽度：%f ，高度：%f",SCREEN_WIDTH,SCREEN_HEIGHT);
        [self addsetTableView];
        self.touxiang_btn.layer.cornerRadius=self.touxiang_btn.width/2;
        self.touxiang_btn.layer.masksToBounds = YES;
//         [self.navigationController setNavigationBarHidden:YES animated:NO];//隐藏导航栏
        [self getToken];
        [self updateMessage];
    });
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.subviews[0].alpha = 0.0;
        NSLog(@"123123");
    });
    
    [super viewDidAppear:animated];
    
}
//- (void)viewWillDisappear:(BOOL)animated {
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    //    [backBtn setTintColor:[UIColor blackColor]];
//    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
//    self.navigationItem.backBarButtonItem = backBtn;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [super viewWillDisappear:animated];
//    // 第二种办法：在显示导航栏的时候要添加动画
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController.navigationBar setHidden:NO];
    // 设置导航栏 为不透明
    //    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.subviews[0].alpha = 1.0;
    [super viewWillDisappear:animated];
    // 第二种办法：在显示导航栏的时候要添加动画
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)updateMessage
{
    NSString * Message_flage = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
    if([Message_flage intValue]==1)
    {
        [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:3];
    }else
    {
        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:3];
    }
}
-(void)addRightBtn
{
    BadgeButton * btn1 = [[BadgeButton alloc] init];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    //    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"nav_bell"] forState:UIControlStateNormal];
    NSString * Message_flage = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
    if([Message_flage intValue]==1)
    {
        self.Message_Btn.badgeValue=1;
        self.Message_Btn.isRedBall = YES;
        btn1.badgeValue=1;
        btn1.isRedBall = YES;
    }else
    {
        self.Message_Btn.badgeValue=0;
        self.Message_Btn.isRedBall = NO;
        btn1.badgeValue=0;
        btn1.isRedBall = NO;
    }
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightItem;
//    self.Message_Btn = btn1;
//    [self.topView addSubview:self.Message_Btn];
}
- (IBAction)push_message:(id)sender {
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IMessageViewController *vc=[main instantiateViewControllerWithIdentifier:@"IMessageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.MessageStyle=2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)selectRightAction:(id)sender
{
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IMessageViewController *vc=[main instantiateViewControllerWithIdentifier:@"IMessageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.MessageStyle=2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)imageGesturerecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
//    [self addsendFeacbookMessage];
    
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InformationViewController *vc=[main instantiateViewControllerWithIdentifier:@"InformationViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


-(void)updateText
{
//    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //        self.name_label.text=strPhoen;
    if(self.ModeUser!=nil)
    {
        self.name_label.text=[NSString stringWithFormat:@"%@%@",self.ModeUser.firstName,self.ModeUser.lastName];
        if(self.ModeUser.credit!=nil)
        {
            self.jifen_label.text=[NSString stringWithFormat:@"%@ %@",FGGetStringWithKeyFromTable(@"Reward Points", @"Language"),self.ModeUser.credit];
        }
    }else{
//        self.name_label.text=strPhoen;
        self.name_label.text=FGGetStringWithKeyFromTable(@"Click here to login", @"Language");
        self.jifen_label.text=@"";
    }
    NSLog(@"测试断点");
    if(self.ModeUser!=nil)
    {
        if(self.ModeUser.headImageUrl!=nil)
        {
            [self.touxiangImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_downImage,self.ModeUser.headImageUrl]] placeholderImage:[UIImage imageNamed:@"icon_Avatar"]];
            NSLog(@"测试断点22");
        }else
        {
            [self.touxiangImage setImage:[UIImage imageNamed:@"icon_Avatar"]];
        }
    }else
    {
        [self.touxiangImage setImage:[UIImage imageNamed:@"icon_Avatar"]];
    }
    //    [self.touxiang_btn setBackgroundImage:[self getImage_touxiang] forState:UIControlStateNormal];
    //    [self.touxiang_btn setBackgroundImage:[self getImage_touxiang] forState:UIControlStateNormal];
    
}

-(void)getToken
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * tokenStr = [userDefaults objectForKey:@"Token"];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?userToken=%@",FuWuQiUrl,get_tokenUser,TokenStr] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"111responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];


        if([statusCode intValue] ==401)
        {
            //            [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
            //            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
            //            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            //            for (UIViewController *controller in self.navigationController.viewControllers) {
            //                if ([controller isKindOfClass:[MyAccountViewController class]]) {
            //                    [self.navigationController popToViewController:controller animated:YES];
            //
            //                }
            //            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:@"Token"];
            [userDefaults setObject:@"1" forKey:@"phoneNumber"];
            [userDefaults setObject:nil forKey:@"SaveUserMode"];
            [userDefaults setObject:@"1" forKey:@"logCamera"];
            //    [defaults synchronize];

            [self updateText];;

            [self.Down_tableView reloadData];
//            [self addDownScroller];

        }else if([statusCode intValue] ==500)
        {
            NSString * errorMessage =[dictObject objectForKey:@"errorMessage"];;
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
        }else{
            //            NSString * IDStr = [dictObject objectForKey:@"id"];
            NSDictionary * wallet = [dictObject objectForKey:@"wallet"];

            NSNumber * ba = [wallet objectForKey:@"balance"];
            NSString * balanceStr =[ba stringValue];
            //            NSString * currencyUnitStr = [wallet objectForKey:@"currencyUnit"];
            //            self.currencyUnitStr = [cur stringValue];
            NSNumber * credit = [wallet objectForKey:@"credit"];
            NSString * creditStr = [credit stringValue];
            NSNumber * coupon = [dictObject objectForKey:@"couponCount"];
            NSString *couponCountStr = [coupon stringValue];
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
            ////个人中心需要用到积分
            mode.credit = creditStr;
            mode.balance = balanceStr;
            mode.couponCount = couponCountStr;
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
             NSLog(@"测试断点5555");
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            [jiamiStr base64Data_encrypt:mode.yonghuID];
            [self updateText];;
            [self.Down_tableView reloadData];
//            [self addDownScroller];
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


- (IBAction)Login_touch:(id)sender {
    

    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InformationViewController *vc=[main instantiateViewControllerWithIdentifier:@"InformationViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)jifen_touch:(id)sender {
    
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VIPjfViewController *vc=[main instantiateViewControllerWithIdentifier:@"VIPjfViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



/////  加载下方ScrollerView
-(void)addDownScroller
{
    NSLog(@"iphoenX= %f,%f",self.view.width,self.view.height);
    //    375.000000,812.000000
    if(SCREEN_WIDTH==375 && SCREEN_HEIGHT==812)
    {
        //设置滚动范围
        Down_Scroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        Down_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.topView.height+6*60);
        Down_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.topView.height+5*60+8+95+10);
    }else if(SCREEN_WIDTH==320.f && SCREEN_HEIGHT==568.f)
    {
        //设置滚动范围
        Down_Scroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        Down_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.topView.bottom+5*60+10);
    }else if(SCREEN_WIDTH==375.f && SCREEN_HEIGHT==667.f)
    {
        //设置滚动范围
        Down_Scroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        Down_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.topView.height+5*60+8+95+10);
    }else{
        //设置滚动范围
        Down_Scroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        Down_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.topView.height+5*60+8+95+10);
    }
    NSLog(@"Down_Scroller.top= %f",self.Down_Scroller.top);
    //设置分页效果
    //    Down_Scroller.pagingEnabled = YES;
//    Down_Scroller.backgroundColor = [UIColor redColor];
    Down_Scroller.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //水平滚动条隐藏
    Down_Scroller.scrollEnabled = YES;
    Down_Scroller.showsHorizontalScrollIndicator = NO;
    Down_Scroller.showsVerticalScrollIndicator = NO;
    [self.view addSubview:Down_Scroller];
    [self.Down_Scroller addSubview:self.topView];
    
}
-(void)addsetTableView
{
    [self.Down_tableView setHidden:NO];
    //    self.Down_tableView.frame=CGRectMake(0, self.topView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.topView.height-15);5*60+15
//    NSLog(@"self.topView.bottom = %f , self.topView.height = %f",self.topView.bottom,self.topView.height);
    self.Down_tableView.frame=CGRectMake(0, self.topView.bottom+8, SCREEN_WIDTH, 6*60+8);
    self.Down_tableView.delegate=self;
    self.Down_tableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    if((self.topView.height+self.Down_tableView.height+30) > SCREEN_HEIGHT)
    {
        NSLog(@"ANober");
        self.Down_tableView.scrollEnabled = YES;  ////设置tableview可以上下滑动
        self.Down_tableView.frame=CGRectMake(0, self.topView.bottom, SCREEN_WIDTH, 6*60+40);
    }else{
        self.Down_tableView.scrollEnabled = NO;  ////设置tableview不上下滑动
        NSLog(@"BNober");
    }
    
    self.Down_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.Down_Scroller addSubview:self.Down_tableView];

    NSLog(@"zongheight= %f",self.topView.height+self.Down_tableView.height+30);
    //    self.imageView_down = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.Down_tableView.bottom+8, SCREEN_WIDTH-15*2, 95)];
    //    [self.imageView_down setImage:[UIImage imageNamed:@"promos_1"]];
    //    [self.Down_Scroller addSubview:self.imageView_down];
    NSLog(@"Down_tableView.top =  %f",self.Down_tableView.top);
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = arrtitle[section];
    return arr.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrtitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
//    NSLog(@"self.topView.bottom = %f , self.topView.height = %f",self.topView.bottom,self.topView.height);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray  * titleT=arrtitle[indexPath.section];
    cell.textLabel.text = [titleT objectAtIndex:indexPath.row];
    
        NSLog(@"%ld",(long)indexPath.row);
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            if(self.ModeUser!=nil)
            {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2f",[self.ModeUser.balance doubleValue]/100]];
            }else
            {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@""]];
            }
            cell.imageView.image=[UIImage imageNamed:@"me_balance"];
        }else if (indexPath.row==1)
        {
            
            cell.imageView.image=[UIImage imageNamed:@"orders11"];
        }
         else if (indexPath.row==2)
        {
            cell.imageView.image=[UIImage imageNamed:@"invite-friends"];
        }
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            cell.imageView.image=[UIImage imageNamed:@"me_introduction"];
        }else if (indexPath.row==1)
        {
            cell.imageView.image=[UIImage imageNamed:@"nav_feedback"];
        }else if (indexPath.row==2)
        {
            cell.imageView.image=[UIImage imageNamed:@"me_settings"];
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    //    if(!(indexPath.section == 1 && indexPath.row==0))
    //    {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    //    }
    //    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    cell.layer.cornerRadius=4;
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
    {
        return 0;
    }
    return 8.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
        return CGFLOAT_MIN;//最小数，相当于0
    }
    return 0;//机器不可识别，然后自动返回默认高度
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //自定义间隔view，可以不写默认用系统的
    UIView * view_c= [[UIView alloc] init];
    view_c.frame=CGRectMake(0, 0, 0, 0);
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            NSLog(@"11111111");
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate.appdelegate1 setImportMeshNetWorkWithDataJson:[[NSData alloc]init]];
            if([strPhoen isEqualToString:@"1"])
            {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
//                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                MyWalletViewController *vc=[main instantiateViewControllerWithIdentifier:@"MyWalletViewController"];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                NewMyWalletViewController *vc=[main instantiateViewControllerWithIdentifier:@"NewMyWalletViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.row==1)
        {
            NSLog(@"222222");
//            [[AppDelegate shareAppDelegate].appdelegate1 AddConnected];
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate.appdelegate1 AddConnected];
            if([strPhoen isEqualToString:@"1"])
            {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                OrdersViewController *vc=[main instantiateViewControllerWithIdentifier:@"OrdersViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.row==2)
        {
            NSLog(@"333333");
//            [[AppDelegate shareAppDelegate].appdelegate1 closeConnected];
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate.appdelegate1 closeConnected];
            if([strPhoen isEqualToString:@"1"])
            {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                InviteFriendsViewController *vc=[main instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            NSLog(@"444444");
//            [[AppDelegate shareAppDelegate].appdelegate1 dataSend];
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate.appdelegate1 dataSend];
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            IntroductionViewController *vc=[main instantiateViewControllerWithIdentifier:@"IntroductionViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1)
        {
            if([strPhoen isEqualToString:@"1"])
            {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                FeedbackViewController *vc=[main instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if (indexPath.row==2)
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SettingViewController *vc=[main instantiateViewControllerWithIdentifier:@"SettingViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
    }
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

//////  没有获取到返回默认头像
-(UIImage *)getImage_touxiang
{
    //    NSLog(@"URL = %@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_downImage,self.ModeUser.headImageUrl]);
    if(self.ModeUser!=nil)
    {
        if(self.ModeUser.headImageUrl!=nil)
        {
            NSString * fileURL =[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_downImage,self.ModeUser.headImageUrl];
            UIImage * result;
            
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
            
            result = [UIImage imageWithData:data];
            //
            //            [self.touxiang_btn.imageView sd_setImageWithURL:[NSURL URLWithString:fileURL] placeholderImage:[UIImage imageNamed:@"user_default"]];
            //            sd_setImageWithURL
            return result;
        }else
        {
            return [UIImage imageNamed:@"icon_Avatar"];
        }
    }else
    {
        return [UIImage imageNamed:@"icon_Avatar"];
    }
    
    return [UIImage imageNamed:@"icon_Avatar"];
}


@end
