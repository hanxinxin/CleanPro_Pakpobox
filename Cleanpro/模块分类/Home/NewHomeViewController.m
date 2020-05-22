//
//  NewHomeViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NewHomeViewController.h"
#import "imageTableViewCell.h"
#import "FriendsRViewController.h"
#import "setPasswordViewController.h"
#import "nameRViewController.h"
#import "WelcomeViewController.h"
#import "MyWalletViewController.h"
#import "VIPjfViewController.h"
#import "IMessageViewController.h"
#import "BadgeButton.h"
#import "versionView.h"
#import "ConnectFeedViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ShardHViewController.h"
#import "InviteFriendsViewController.h"
#import "EWashViewController.h"
#import "StaffViewController.h"
#import "NewLoginViewController.h"
//#import <luckysdk/utils.h>
#import "CollectionHXView.h"
#import "WCQRCodeScanningVC.h"


#define tableID @"imageTableViewCell"
#define count_t 2
@interface NewHomeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,versionViewDelegate,CBCentralManagerDelegate,CollectionHXViewDelegate>
{
    NSInteger iamgeCC;
}
@property (nonatomic ,retain) UIPageControl * myPageControl;
@property (nonatomic, weak)NSTimer* rotateTimer;  //让视图自动切换

@property (nonatomic,strong) NSMutableArray *imgArr;//图片数组
@property (nonatomic,strong) NSMutableArray * imageViewArr;
@property (nonatomic,strong) NSMutableArray * ArrZongCout;//保存首页图片，检测到有更新的再更新。没有就不更新
@property (nonatomic,assign) CGFloat oldContentOffsetX;
//@property CBCentralManager *centralManager;

@property (nonatomic,strong)CollectionHXView*CenterCollectionView;

@end

@implementation NewHomeViewController
@synthesize topView,downView,ShowScrollview,globalScrollview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        ShowScrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        globalScrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    
    iamgeCC=0;
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.balanceStr=@"0";
    self.creditStr=@"0";
    self.currencyUnitStr=@"0";
    self.couponCountStr=@"0";
    self.imgArr=[NSMutableArray arrayWithCapacity:0];
    self.imageViewArr = [NSMutableArray arrayWithCapacity:0];
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SYbanner"];
    NSArray * arrayUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       ///  对比请求下来的图片和本地是否一样
//       if(arrayUser!=nil)
//       {
//           [self UpdateGuanggao:arrayUser];
//       }else
//       {
//        [self.imgArr addObject:[UIImage imageNamed:@"banner01"]];
    
        [self.imgArr addObject:[UIImage imageNamed:@"banner-EWASH.png"]];
        [self.imgArr addObject:[UIImage imageNamed:@"UPloadbanner"]];
     
        [self.imageViewArr addObject:[UIImage imageNamed:@"888paper.jpg"]];
        [self.imageViewArr addObject:[UIImage imageNamed:@"promotion2.jpeg"]];
           [self.imageViewArr addObject:[UIImage imageNamed:@"WashingTo.jpg"]];
//       }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSLog(@"宽度：%f ，高度：%f",SCREEN_WIDTH,SCREEN_HEIGHT);
        
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.subviews[0].alpha = 0.0;
        [self addglobalScrollview];
        [self topviewset];
        [self downviewset];
    });
   
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.title=@"Cleapro";
    self.navigationController.title=FGGetStringWithKeyFromTable(@"Home", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
       
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [self getGuanggao];
        [self getToken];
        [self updateMessage];
//        [self.navigationController.navigationBar setHidden:YES];
    });
//    [self addRightBtn];  ///// 修改为切换语言的按钮
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

//get_Guanggao


-(void)viewDidAppear:(BOOL)animated
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.subviews[0].alpha = 0.0;
//        NSLog(@"890890");
    });
    
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController.navigationBar setHidden:NO];
    // 设置导航栏 为不透明
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.subviews[0].alpha = 1.0;
    [self.rotateTimer fire];
    [super viewWillDisappear:animated];
    // 第二种办法：在显示导航栏的时候要添加动画
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)addRightBtn
{
    
    BadgeButton * btn1 = [[BadgeButton alloc] init];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn1 setTitle:[ChangeLanguage returnLanguageString] forState:UIControlStateNormal ];
    //    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchDown];
    
//    [btn1 setImage:[UIImage imageNamed:@"nav_bell"] forState:UIControlStateNormal];
//    NSString * Message_flage = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
//    if([Message_flage intValue]==1)
//    {
//        btn1.badgeValue=1;
//        btn1.isRedBall = YES;
//
//    }else
//    {
//        btn1.badgeValue=0;
//        btn1.isRedBall = NO;
//    }
   
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)updateMessage
{
    NSString * Message_flage = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
    if([Message_flage intValue]==1)
    {
        [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:NotificationNumber];
    }else
    {
        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:NotificationNumber];
    }
}



-(void)selectRightAction:(id)sender
{
   /*
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
        [self.navigationController pushViewController:vc animated:YES];
    }
 //   */
    
//    [self sendDeviceData:@"01017880-0000-0000-83ce-c017048500c0" taskCommand:@"031119190001110e0066"];
    //        @"031119190001110e0066";
    /*
    if([[ChangeLanguage returnLanguageString]isEqualToString:EN])
    {
        ChangeLanguage * Change = [ChangeLanguage sharedInstance];
        [Change setNewLanguage:CNS];

    }else if([[ChangeLanguage returnLanguageString]isEqualToString:CNS])
    {
        ChangeLanguage * Change = [ChangeLanguage sharedInstance];
        [Change setNewLanguage:EN];
    }
     */
//    [self addVersionView];
    NSNotification *notification =[NSNotification notificationWithName:@"addVersionView" object: nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
-(void)getGuanggao
{
    //     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString * tokenStr = [userDefaults objectForKey:@"Token"];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,get_Guanggao] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
//        NSLog(@"get_Guanggao = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSArray * array=(NSArray *)responseObject;
//        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
        if(array.count>0)
        {
            
//            SYbanner
            NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SYbanner"];
            NSArray * arrayUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            ///  对比请求下来的图片和本地是否一样
            if(arrayUser!=nil)
            {
                int counterImage = 0;
                for (int i=0; i<array.count; i++) {
                    NSDictionary * dictObject =array[i];
//                    NSLog(@"dictObject111 = %@",dictObject);
                    NSString * advertType = [dictObject objectForKey:@"advertType"];
                    NSDictionary * dicMainPage = [dictObject objectForKey:@"mainPage"];
                    bannerMode * mode = [[bannerMode alloc] init];
                    mode.advertType = advertType;
                    mode.mainPage = dicMainPage;
                    mode.pageName = [dictObject objectForKey:@"pageName"];
                    mode.sequence = [dictObject objectForKey:@"sequence"];
                    mode.subPageType = [dictObject objectForKey:@"subPageType"];
                    mode.picture = [dictObject objectForKey:@"picture"];
                    NSDictionary * dict = mode.mainPage;
                    NSString * ImageIDA = [dict objectForKey:@"id"];
                    for (int j=0; j<arrayUser.count; j++) {
                        NSDictionary * dictObject2 =arrayUser[
                        j];
//                        NSLog(@"dictObject111 = %@",dictObject);
                        NSString * advertType2 = [dictObject2 objectForKey:@"advertType"];
                        NSDictionary * dicMainPage2 = [dictObject2 objectForKey:@"mainPage"];
                        bannerMode * mode2 = [[bannerMode alloc] init];
                        mode2.advertType = advertType2;
                        mode2.mainPage = dicMainPage2;
                        mode2.pageName = [dictObject2 objectForKey:@"pageName"];
                        mode2.sequence = [dictObject2 objectForKey:@"sequence"];
                        mode2.subPageType = [dictObject2 objectForKey:@"subPageType"];
                        mode2.picture = [dictObject objectForKey:@"picture"];
                        NSDictionary * dict2 = mode2.mainPage;
                        NSString * ImageIDB = [dict2 objectForKey:@"id"];
                        if([ImageIDA isEqualToString:ImageIDB])
                        {
                            counterImage++;
//                            NSLog(@"counterImage == %d",counterImage);
                        }
                    }
                }
                if(counterImage != array.count)
                {
                    [self.imgArr removeAllObjects];
                    [self.imageViewArr removeAllObjects];
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    //存储到NSUserDefaults（转NSData存）
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: array];
                    [defaults setObject:data forKey:@"SYbanner"];
                    [defaults synchronize];
                    [self UpdateGuanggao:array];
                }
            }else
            {
                [self.imgArr removeAllObjects];
                [self.imageViewArr removeAllObjects];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                 //存储到NSUserDefaults（转NSData存）
                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject: array];
                 [defaults setObject:data forKey:@"SYbanner"];
                 [defaults synchronize];
                [self UpdateGuanggao:array];
            }
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
//        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
}

-(void)UpdateGuanggao:(NSArray *)array
{

            for (int i=0; i<array.count; i++) {
             
            NSDictionary * dictObject =array[i];
            NSLog(@"dictObject111 = %@",dictObject);
            NSString * advertType = [dictObject objectForKey:@"advertType"];
            NSDictionary * dicMainPage = [dictObject objectForKey:@"mainPage"];
    //        NSString * base64Str = [dicMainPage objectForKey:@"base64"];
    //        self->iamgeCC = imageD;
                bannerMode * mode = [[bannerMode alloc] init];
                mode.advertType = advertType;
                mode.mainPage = dicMainPage;
                mode.pageName = [dictObject objectForKey:@"pageName"];
                mode.sequence = [dictObject objectForKey:@"sequence"];
                mode.subPageType = [dictObject objectForKey:@"subPageType"];
                mode.picture = [dictObject objectForKey:@"picture"];
                if([advertType isEqualToString:@"BANNER"])
                {
                    [self.imgArr addObject:mode];
                }else if([advertType isEqualToString:@"PROMOTION"])
                {
                    [self.imageViewArr addObject:mode];
                }
            }
            for (int j=0; j<self.imgArr.count; j++) {
                for (int m=0; m<self.imgArr.count; m++) {
                    bannerMode * modePX = self.imgArr[j];
                    NSString* seq = modePX.sequence;
                    bannerMode * modePX1 = self.imgArr[m];
                    NSString* seq1 = modePX1.sequence;
                    if ([seq intValue] < [seq1 intValue]) {
                        [self.imgArr exchangeObjectAtIndex:j withObjectAtIndex:m];
                    }
                }
                
            }
            for (int j=0; j<self.imageViewArr.count; j++) {
                for (int m=0; m<self.imageViewArr.count; m++) {
                    bannerMode * modePX = self.imageViewArr[j];
                    NSString* seq = modePX.sequence;
                    bannerMode * modePX1 = self.imageViewArr[m];
                    NSString* seq1 = modePX1.sequence;
                    if ([seq intValue] < [seq1 intValue]) {
                        [self.imageViewArr exchangeObjectAtIndex:j withObjectAtIndex:m];
                    }
                }
                
            }
            self->iamgeCC=1;
            [self addScrollerView];
    //        [self downviewset];
            self.downView.frame = CGRectMake(0, self->topView.bottom+8, SCREEN_WIDTH, 160*self.imageViewArr.count+8*self.imageViewArr.count+60);
    NSLog(@"self->globalScrollview.contentSize === %lf",(self->topView.height+160*self.imageViewArr.count+8*self.imageViewArr.count+60+64));
            self->globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self->topView.height+160*self.imageViewArr.count+8*self.imageViewArr.count+60+64);
            self.tableViewD.frame = CGRectMake(15, self.title_View.height, SCREEN_WIDTH-30,160*self.imageViewArr.count+8*self.imageViewArr.count);
            [self.tableViewD reloadData];
}



//-(void)getToken
//{
////     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
////    NSString * tokenStr = [userDefaults objectForKey:@"Token"];
////    NSLog(@"Login url===%@",[NSString stringWithFormat:@"%@%@?userToken=%@",FuWuQiUrl,get_tokenUser,TokenStr]);
//    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?userToken=%@",FuWuQiUrl,get_tokenUser,TokenStr] parameters:nil progress:^(id progress) {
////        NSLog(@"请求成功 = %@",progress);
//    } success:^(id responseObject) {
//        NSLog(@"111responseObject = %@",responseObject);
//        [HudViewFZ HiddenHud];
//        NSDictionary * dictObject=(NSDictionary *)responseObject;
//        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
//
//
//        if([statusCode intValue] ==401)
//        {
//            //            [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
////            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
////            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
////            for (UIViewController *controller in self.navigationController.viewControllers) {
////                if ([controller isKindOfClass:[MyAccountViewController class]]) {
////                    [self.navigationController popToViewController:controller animated:YES];
////
////                }
////            }
//            [self setTopViewStrNIL];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setObject:@"1" forKey:@"Token"];
//            [userDefaults setObject:@"1" forKey:@"phoneNumber"];
//            [userDefaults setObject:nil forKey:@"SaveUserMode"];
//            [userDefaults setObject:@"1" forKey:@"logCamera"];
//            //    [defaults synchronize];
//
//        }else if([statusCode intValue] ==500)
//        {
//            NSString * errorMessage =[dictObject objectForKey:@"errorMessage"];;
//            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
//        }else{
//            self.IDStr = [dictObject objectForKey:@"id"];
//            NSDictionary * wallet = [dictObject objectForKey:@"wallet"];
//            NSNumber * ba = [wallet objectForKey:@"balance"];
//            self.balanceStr =[ba stringValue];
//            self.currencyUnitStr = [wallet objectForKey:@"currencyUnit"];
////            self.currencyUnitStr = [cur stringValue];
//            NSNumber * credit = [wallet objectForKey:@"credit"];
//            self.creditStr = [credit stringValue];
//            NSNumber * coupon = [dictObject objectForKey:@"couponCount"];
//            self.couponCountStr = [coupon stringValue];
////            用来储存用户信息
//
//            SaveUserIDMode * mode = [[SaveUserIDMode alloc] init];
//
//            mode.phoneNumber = [dictObject objectForKey:@"phoneNumber"];//   手机号码
//            mode.loginName = [dictObject objectForKey:@"loginName"];//   与手机号码相同
//            mode.yonghuID = [dictObject objectForKey:@"id"]; ////用户ID
////            mode.randomPassword = [dictObject objectForKey:@"randomPassword"];//  验证码
////            mode.password = [dictObject objectForKey:@"password"];//  登录密码
////            mode.payPassword = [dictObject objectForKey:@"payPassword"];//    支付密码
//            mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
//            mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
//            NSNumber * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
//            mode.birthday = [birthdayNum stringValue];
//            mode.gender = [dictObject objectForKey:@"gender"];//       MALE:男，FEMALE:女
//            mode.postCode = [dictObject objectForKey:@"postCode"];//   Post Code inviteCode
//            mode.EmailStr = [dictObject objectForKey:@"email"];//   email
//            mode.inviteCode = [dictObject objectForKey:@"inviteCode"];//       我填写的邀请码
//            mode.myInviteCode = [dictObject objectForKey:@"myInviteCode"];//       我的邀请码
//            mode.headImageUrl = [dictObject objectForKey:@"headImageUrl"];
//            mode.payPassword = [dictObject objectForKey:@"payPassword"];
//             ////个人中心需要用到积分
//            mode.credit = self.creditStr;
//            mode.balance = self.balanceStr;
//            mode.couponCount = self.couponCountStr;
//            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//            //存储到NSUserDefaults（转NSData存）
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
//
//            [defaults setObject:data forKey:@"SaveUserMode"];
//            [defaults synchronize];
//            [jiamiStr base64Data_encrypt:mode.yonghuID];
//            [self setTopViewStr];
//
//
//        }
//    } failure:^(NSInteger statusCode, NSError *error) {
//        NSLog(@"error = %@",error);
//        [HudViewFZ HiddenHud];
//        if(statusCode==401)
//        {
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
//            //创建一个消息对象
//            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
//            //发送消息
//            [[NSNotificationCenter defaultCenter]postNotification:notice];
//
//        }else{
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
//
//        }
//    }];
//}
-(void)getToken
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * tokenStr = [userDefaults objectForKey:@"Token"];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_GetToken] parameters:nil progress:^(id progress) {
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
//            [self addDownScroller];
            
        }else if([statusCode intValue] ==500)
        {
            NSString * errorMessage =[dictObject objectForKey:@"errorMessage"];;
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
        }else{
                        NSString*tokenStr = [dictObject objectForKey:@"token"];
                        NSString*phoneNumberStr = [dictObject objectForKey:@"mobile"];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:tokenStr forKey:@"Token"];
                        [userDefaults setObject:phoneNumberStr forKey:@"phoneNumber"];
                        [userDefaults setObject:@"2" forKey:@"logCamera"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
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
                        
                        mode.phoneNumber = [dictObject objectForKey:@"mobile"];//   手机号码
                        mode.loginName = [dictObject objectForKey:@"username"];//   与手机号码相同
                        mode.yonghuID = [dictObject objectForKey:@"memberId"]; ////用户ID
                        //            mode.randomPassword = [dictObject objectForKey:@"randomPassword"];//  验证码
                        //            mode.password = [dictObject objectForKey:@"password"];//  登录密码
                        //            mode.payPassword = [dictObject objectForKey:@"payPassword"];//    支付密码
                        mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
                        mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
                        NSString * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
                        if(![birthdayNum isEqual:[NSNull null]])
                        {
            //                mode.birthday = [birthdayNum ];;
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
             
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        if(statusCode==401)
        {
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:1.0];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"SetNSUserDefaults" object:nil userInfo:nil]];
            });
        }else{
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:1.0];
            
        }
    }];
}
-(void)addglobalScrollview
{
    globalScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    globalScrollview.tag=1001;
    globalScrollview.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //设置分页效果
    globalScrollview.pagingEnabled = NO;
    //水平滚动条隐藏
    globalScrollview.showsHorizontalScrollIndicator = YES;
    globalScrollview.delegate=self;
    [self.view addSubview:globalScrollview];
    UIImageView *backView = self.navigationController.navigationBar.subviews[0];
    backView.alpha = 0;
}

-(void)setTopViewStr
{
//    self.buttonOne.Number_lable.text=[NSString stringWithFormat:@"%.2f",[self.balanceStr doubleValue]/100.0];
    self.buttonOne.down_label.attributedText =[self set_button_view_Label:self.buttonOne.tag str:[NSString stringWithFormat:@"%.2f",[self.balanceStr doubleValue]/100.0]];
//    self.buttonTwo.Number_lable.text=self.couponCountStr;
    self.buttonTwo.down_label.attributedText =[self set_button_view_Label:self.buttonTwo.tag str:self.couponCountStr];
//    self.buttonThree.Number_lable.text=self.creditStr;
    self.buttonThree.down_label.attributedText =[self set_button_view_Label:self.buttonThree.tag str:self.creditStr];
}
-(void)setTopViewStrNIL
{
//    self.buttonOne.Number_lable.text=[NSString stringWithFormat:@"0"];
//    self.buttonTwo.Number_lable.text=@"0";
//    self.buttonThree.Number_lable.text=@"0";
    self.buttonOne.down_label.attributedText =[self set_button_view_Label:self.buttonOne.tag str:@"-"];
    self.buttonTwo.down_label.attributedText =[self set_button_view_Label:self.buttonTwo.tag str:@"-"];
    self.buttonThree.down_label.attributedText =[self set_button_view_Label:self.buttonThree.tag str:@"-"];
}

-(void)topviewset
{
//    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 214*autoSizeScaleX+68*autoSizeScaleX)];
//    topView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:topView];
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 214*autoSizeScaleX+200*autoSizeScaleX+20)];
    
    [self addScrollerView];
//    [self addHButtonViewA];  //屏蔽一起显示金额的view
    [self addCollectionViewA];
    [globalScrollview addSubview:topView];
    
}
-(void)addCollectionViewA
{
    
    NSArray * array= @[@[@"Laundry",@"E-wash",@"Lroning",@"Power Bank",@"Vending Machine",@"Gife",@"Locker",@"Coming Soon"]];
    NSArray * arrS=array[0];
    NSArray * imagearr= @[@[@"icon_laundry1",@"icon_ewash",@"icon_ironing",@"icon_powerbank",@"icon_vending",@"icon_gifts",@"icon_locker",@"icon_coming"]];
       NSArray * arrImage=imagearr[0];
    int count = (int)((arrS.count%4)==0?(arrS.count/4):((arrS.count/4)+1));
    self.CenterCollectionView=[[CollectionHXView alloc] initFrame:CGRectMake(0, ShowScrollview.bottom, SCREEN_WIDTH,(100*autoSizeScaleX)*count+20) Array:(NSMutableArray *)array imageArr:(NSMutableArray *)arrImage];
    self.CenterCollectionView.delegate=self;
    self.CenterCollectionView.backgroundColor=[UIColor whiteColor];
    [topView addSubview:self.CenterCollectionView];
    
}
- (void)CellTouch:(UITableViewCell*)Cell
{
    NSLog(@"Cell.tag=== %ld",(long)Cell.tag);
    if(Cell.tag==0)
    {
        NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
        if([strPhoen isEqualToString:@"1"])
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NewLoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"NewLoginViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            WCQRCodeScanningVC *WCVC = [[WCQRCodeScanningVC alloc] init];
            WCVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:WCVC animated:YES];
        }
    }else if(Cell.tag==1)
    {
        NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
        if([strPhoen isEqualToString:@"1"])
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NewLoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"NewLoginViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EWashViewController *vc=[main instantiateViewControllerWithIdentifier:@"EWashViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The function is under development, so stay tuned!", @"Language") andDelay:2.0];
    }
}
-(void)addHButtonViewA
{
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 214*autoSizeScaleX)];
     NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        SaveUserIDMode * mode  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.button_view = [[UIView alloc] initWithFrame:CGRectMake(0, ShowScrollview.bottom, SCREEN_WIDTH, 68*autoSizeScaleX)];
        
        for (int i =0 ; i<2; i++) {
    //        HButtonView *
            UINib *nib = [UINib nibWithNibName:@"HButtonView" bundle:nil];
            NSArray *objs = [nib instantiateWithOwner:nil options:nil];
            HButtonView * hb=objs[0];
            hb.frame=CGRectMake(i*self.button_view.width/2, 0, self.button_view.width/2, self.button_view.height);
            UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Puhs_MyWallet:)];
            
            [hb addGestureRecognizer:labelTapGestureRecognizer];
            hb.tag=i;
            if(i==0)
            {
                if(mode!=nil)
                {
                    hb.Number_lable.text=mode.balance;
                }else
                {
                    hb.Number_lable.text=@"-";
                }
                hb.title_lable.text=FGGetStringWithKeyFromTable(@"Balance", @"Language");
                [hb.left_btn setImage:[UIImage imageNamed:@"balance1"] forState:UIControlStateNormal];
                hb.down_label.textAlignment=NSTextAlignmentCenter;
                hb.down_label.attributedText =[self set_button_view_Label:i str:@"0"];
                self.buttonOne=hb;
            }
            /*else if(i==1)
            {
                hb.Number_lable.text=@"0";
                hb.title_lable.text=@"Coupons";
                [hb.left_btn setImage:[UIImage imageNamed:@"home_Coupons"] forState:UIControlStateNormal];
                hb.down_label.textAlignment=NSTextAlignmentCenter;
                hb.down_label.attributedText =[self set_button_view_Label:i str:@"0"];
                self.buttonTwo=hb;
            }
             */
            else if(i==1)
            {
                if(mode!=nil)
                {
                    hb.Number_lable.text=mode.credit;
                }else
                {
                    hb.Number_lable.text=@"-";
                }
                hb.title_lable.text=FGGetStringWithKeyFromTable(@"Reward Points", @"Language");
                [hb.left_btn setImage:[UIImage imageNamed:@"credit"] forState:UIControlStateNormal];
     hb.down_label.textAlignment=NSTextAlignmentCenter;
                hb.down_label.attributedText =[self set_button_view_Label:i str:@"0"];
                self.buttonThree=hb;
            }
    //        [self.button_view addSubview:hb];
            
        }
        [self.button_view addSubview:self.buttonOne];
        [self.button_view addSubview:self.buttonTwo];
        [self.button_view addSubview:self.buttonThree];
    //    [topView addSubview:self.button_view];
}
-(NSMutableAttributedString*)set_button_view_Label:(NSInteger)index str:(NSString*)strlabel
{
//    NSLog(@"tag = %ld", (long)index);
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第二段：图片
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    if(index == 0){
        attachment.image = [UIImage imageNamed:@"balance1"];
    }else if(index == 1)
    {
        attachment.image = [UIImage imageNamed:@"home_Coupons"];
    }else if(index == 2)
    {
        attachment.image = [UIImage imageNamed:@"credit"];
    }
    attachment.bounds = CGRectMake(0, 0, 15, 15);
    //这里bounds的x值并不会产生影响
//    attachment.bounds = CGRectMake(-600, 0, 20, 10);
    NSAttributedString *subtring2 = [NSAttributedString attributedStringWithAttachment:attachment];
    [string appendAttributedString:subtring2];
    // 第一段：placeholder
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",strlabel]];
    [SubStr1 appendAttributedString:substring1];
    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
    //设置文字颜色
    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    //设置文字大小
    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang];
    [string appendAttributedString:SubStr1];
    return string;
}


-(void)Puhs_MyWallet:(UITapGestureRecognizer *)recognizer{
    
    HButtonView *HB=(HButtonView*)recognizer.view;
    
//    NSLog(@"点击了 %ld",HB.tag);
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
    if(HB.tag==0)
    {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyWalletViewController *vc=[main instantiateViewControllerWithIdentifier:@"MyWalletViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        
    
    }else if (HB.tag==1)
    {
        
    }else if (HB.tag==2)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VIPjfViewController *vc=[main instantiateViewControllerWithIdentifier:@"VIPjfViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
    
}
-(void)downviewset
{
    downView=[[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom+8, SCREEN_WIDTH, 160*self.imageViewArr.count+8*self.imageViewArr.count+60)];
//    downView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    downView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:downView];
    [globalScrollview addSubview:downView];
    self.title_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.title_View.backgroundColor=[UIColor whiteColor];
    UIButton * promos = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-93, 40)];
//    [promos.titleLabel setTextAlignment:NSTextAlignmentLeft];
    promos.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [promos setTitle:FGGetStringWithKeyFromTable(@"Collections for you！", @"Language") forState:UIControlStateNormal];
    [promos setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //粗体
    [promos.titleLabel setFont:[UIFont fontWithName : @"Helvetica-Bold" size : 16 ]];
    UIButton * ViewAll = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-7, 0, 80, 40)];
    [ViewAll setTitle:FGGetStringWithKeyFromTable(@"View all", @"Language") forState:UIControlStateNormal];
//    [ViewAll setTitle:FGGetStringWithKeyFromTable(@"", @"Language") forState:UIControlStateNormal];
    [ViewAll setTitleColor:[UIColor colorWithRed:25/255.0 green:181/255.0 blue:239/255.0 alpha:1.0] forState:UIControlStateNormal];
    [ViewAll.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
//    [ViewAll addTarget:self action:@selector(btnViewAll:) forControlEvents:UIControlEventTouchDown];
    UILabel * labelX = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    labelX.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    [self.title_View addSubview:promos];
    [self.title_View addSubview:ViewAll];
    [self.title_View addSubview:labelX];
    [downView addSubview:self.title_View];
    [self tableviewDSet];
}
-(void)btnViewAll:(id)sender
{
    
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
    if([strPhoen isEqualToString:@"1"])
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewLoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"NewLoginViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EWashViewController *vc=[main instantiateViewControllerWithIdentifier:@"EWashViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        StaffViewController *vc=[main instantiateViewControllerWithIdentifier:@"StaffViewController"];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.StatusList=1;
//        [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)tableviewDSet
{
    self.tableViewD = [[UITableView alloc] initWithFrame:CGRectMake(15, self.title_View.height, SCREEN_WIDTH-30,160*self.imageViewArr.count+8*self.imageViewArr.count) style:UITableViewStylePlain];
    if(self.view.width==375.000000 && self.view.height==812.000000)
    {
        self.tableViewD.frame=CGRectMake(15, self.title_View.height, SCREEN_WIDTH-30,downView.height-self.title_View.height);
    }else{
        self.tableViewD.frame=CGRectMake(15, self.title_View.height, SCREEN_WIDTH-30,downView.height-self.title_View.height);
    }
    
    self.tableViewD.delegate=self;
    self.tableViewD.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.tableViewD.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.tableViewD.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    self.tableViewD.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableViewD];
    [self.tableViewD registerNib:[UINib nibWithNibName:@"imageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
//    self.tableViewD.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
//    }];
    // 或
    // 设置回调（一旦进入刷新状态，就调用 target 的 action，也就是调用 self 的 loadNewData 方法）
//    self.tableViewD.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableViewD.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    // 马上进入刷新状态
    //    [self.tableViewTop.mj_header beginRefreshing];
    [self.downView addSubview:self.tableViewD];
    NSLog(@"contentSize===== %f",(topView.height+160*self.imageViewArr.count+8*self.imageViewArr.count+60+64));
    globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), topView.height+160*self.imageViewArr.count+8*self.imageViewArr.count+60+64);
    
}

-(void)loadNewData
{
//    [self getOrderList];
}

-(void)loadFootData
{
//    [self getOrderListFoot];

}
/**
 创建滚动轮播图
 */
-(void)addScrollerView
{
    //设置滚动范围
    if(self.view.width==375 && self.view.height==812)
    {
        ShowScrollview.frame=CGRectMake(0, 0, SCREEN_WIDTH, 214*autoSizeScaleX);
    }else if(self.view.width==320.f && self.view.height==568.f)
    {
        ShowScrollview.frame=CGRectMake(0, 0, SCREEN_WIDTH, 214*autoSizeScaleX);
    }else if(self.view.width==375.f && self.view.height==667.f)
    {
        ShowScrollview.frame=CGRectMake(0, 0, SCREEN_WIDTH, 214*autoSizeScaleX);
    }else{
        ShowScrollview.frame=CGRectMake(0, 0, SCREEN_WIDTH, 214*autoSizeScaleX);
    }
    
    
    //    GG_Scroller.frame=CGRectMake(0, 0, SCREEN_WIDTH, 180*autoSizeScaleX);
    
    //设置分页效果
    ShowScrollview.pagingEnabled = YES;
    //    GG_Scroller.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
    //    GG_Scroller.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);//设置边框颜色
    //    GG_Scroller.layer.borderWidth = 1.0f;//设置边框颜色
    //水平滚动条隐藏
    ShowScrollview.showsHorizontalScrollIndicator = NO;
    //// 给Scroller加一个点击手势
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    tap.numberOfTapsRequired = 1;
    [ShowScrollview addGestureRecognizer:tap];
    
    
    ShowScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*(self.imgArr.count+2), CGRectGetHeight(self.ShowScrollview.frame));
    //添加三个子视图  UILabel类型
//    for (int i = 0; i< count_t; i++) {
    for (int i = 0; i< self.imgArr.count+2; i++) {
        UIImageView *imagView = [[UIImageView alloc]init];  imagView.frame=CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.ShowScrollview.frame.size.height);
        if(i==0)
        {
//            imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner02"]];
           if(iamgeCC==0)
           {
               imagView.image = self.imgArr[self.imgArr.count-1];
           }else{
            bannerMode *mode=self.imgArr[self.imgArr.count-1];
            NSDictionary * dict = mode.mainPage;
            NSString * ImageID = [dict objectForKey:@"id"];
//            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:base options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            imagView.image = [UIImage imageWithData:decodedImageData];
               NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]);
               [imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]]
                            placeholderImage:imagView.image];
           }
        }else if(i==(self.imgArr.count+1)){
//            imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner"]];
            if(iamgeCC==0)
            {
                imagView.image = self.imgArr[0];
            }else{
            bannerMode *mode=self.imgArr[0];
            NSDictionary * dict = mode.mainPage;
//            NSString * base = [dict objectForKey:@"base64"];
//            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:base options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            imagView.image = [UIImage imageWithData:decodedImageData];
                NSString * ImageID = [dict objectForKey:@"id"];
                NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]);
                [imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]]
                            placeholderImage:imagView.image];
            }
        }else
        {
//            imagView.image = self.imgArr[i-1];
            if(iamgeCC==0)
            {
                imagView.image = self.imgArr[i-1];
            }else{
            bannerMode *mode=self.imgArr[i-1];
            NSDictionary * dict = mode.mainPage;
//            NSString * base = [dict objectForKey:@"base64"];
//            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:base options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            imagView.image = [UIImage imageWithData:decodedImageData];
                NSString * ImageID = [dict objectForKey:@"id"];
                NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]);
                [imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]]
                            placeholderImage:imagView.image];
            }
        }
        //        [imagView setContentMode:UIViewContentModeCenter];
        //        imagView.clipsToBounds = YES;
        [imagView setClipsToBounds:NO];
        
        [imagView setContentMode:UIViewContentModeRedraw];
        
        [ShowScrollview addSubview:imagView];
    }
    [ShowScrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
//        [self.view addSubview:ShowScrollview];
    //启动定时器
    if(self.rotateTimer==nil)
    {
        self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    }else
    {
        [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]]];
    }
        ShowScrollview.tag = 1000;
        //    X= 375.000000,812.000000
        //    NSLog(@"X= %f,%f",self.view.frame.size.width,self.view.frame.size.height);
        if((self.view.frame.size.width==375) && (self.view.frame.size.height>=812))
        {
            self.myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.ShowScrollview.frame)-40, CGRectGetWidth(self.view.frame), 50)];
        }else
        {
            self.myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ShowScrollview.height-40, CGRectGetWidth(self.view.frame), 50)];
        }
        self.myPageControl.numberOfPages = self.imgArr.count;
        self.myPageControl.currentPage = 0;
        self.myPageControl.userInteractionEnabled=NO;
        //            self.myPageControl.pageIndicatorTintColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];        //设置未激活的指示点颜色
        self.myPageControl.pageIndicatorTintColor = [UIColor colorWithRed:198/255.0 green:228/255.0 blue:248/255.0 alpha:1.0];
//        RGBA(198, 228, 248, 1)
        self.myPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];     //设置当前页指示点颜色
        //    self.myPageControl.g
        [self.view addSubview:self.myPageControl];
        //    [GG_Scroller addSubview:self.myPageControl];
        
        //为滚动视图指定代理
        ShowScrollview.delegate = self;
        self.myPageControl.hidden=NO;
//    }
    
    
    [topView addSubview:ShowScrollview];
    [topView addSubview:self.myPageControl];
    
//    [globalScrollview addSubview:ShowScrollview];
//    [globalScrollview addSubview:self.myPageControl];
}
#pragma mark -- 滚动视图的代理方法
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //        NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    
    
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
//            NSLog(@"Begin   X= %f,Y= %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if(scrollView.tag==1000)
    {
        [self.rotateTimer setFireDate:[NSDate distantFuture]];
       
        
        
    }else if (scrollView.tag==1001)
    {
//        CGFloat offsetY = scrollView.contentOffset.y;
        self.navigationController.navigationBar.translucent = YES;
    }
    //    else  if(scrollView.tag==12000)
    //    {
    //        collectionView_L.alpha=0.8;
    //    }
    
}
//监听scrollView滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 1001 ) {
        CGFloat offsetY = scrollView.contentOffset.y;
//        NSLog(@"offsetY === %f",offsetY);
        [self setNavigationBarColorWithOffsetY:offsetY];
    }else if(scrollView.tag==1000)
    {

//        NSLog(@"offsetX === %f",offsetX);

        

    }
}
// 界面滑动时导航栏随偏移量 实时变化
- (void)setNavigationBarColorWithOffsetY:(CGFloat)offsetY {
    UIImageView *backView = self.navigationController.navigationBar.subviews[0];
    
    if (offsetY <= 0) {
        backView.alpha = 0;
        if(offsetY <= 0)
        {
            self.globalScrollview.contentOffset=CGPointMake(0, 0);
            backView.alpha = 0;
//            NSLog(@"少时诵诗书 === %f",offsetY);
        }
    } else if (offsetY > 0 && offsetY < 64) {
//        backView.alpha = offsetY / 64;
//        self.navigationController.navigationBar.translucent = YES;
        
    }else if(offsetY == 64 ){
//        backView.alpha = 0;
//        NSLog(@"fdsafdsfds ");
    } else if (offsetY > 64 ) {//&& offsetY <= NavBar_HEIGHT + 30
//        backView.alpha = 1;///不显示导航栏
//        self.navigationController.navigationBar.translucent = NO;
    }
}
//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //        NSLog(@"8888888");
//            NSLog(@"End    X= %f,Y= %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//        NSLog(@"几倍？= %f",(scrollView.contentOffset.x)/(self.view.frame.size.width));
    if(scrollView.tag==1000)
    {
        
        CGFloat offsetX = scrollView.contentOffset.x;
        if(offsetX>=(SCREEN_WIDTH*(self.imgArr.count+1)))
        {
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
//            self.myPageControl.currentPage =(int)(scrollView.contentOffset.x)/(self.view.frame.size.width)-1;
            self.myPageControl.currentPage =0;
        }else if (offsetX<SCREEN_WIDTH)
        {
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.imgArr.count, 0) animated:NO];
//            self.myPageControl.currentPage =(int)(scrollView.contentOffset.x)/(self.view.frame.size.width)-1;
            self.myPageControl.currentPage = self.imgArr.count-1;
        }else{
        self.myPageControl.currentPage =(int)offsetX/(self.view.frame.size.width)-1;
        }
        //视图静止之后，过1.5秒在开启定时器
        //    [NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]  返回值为从现在时刻开始 再过1.5秒的时刻。
        //        NSLog(@"开启定时器");
        [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]]];
        
    }else if(scrollView.tag==1001)
    {
        NSLog(@"MMMMMMMMKKKKKKKKK");
//        self.navigationController.navigationBar.translucent = NO;
//        UIImageView *backView = self.navigationController.navigationBar.subviews[0];
//        self.globalScrollview.contentOffset=CGPointMake(0, 0);
//        backView.alpha = 0;
    }
    
}
// 在开发中如果需要监听scrollView滚动是否停止可以这样写

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    
    if (!decelerate) {//手指控制 直接停止 也就是拖动一段距离直接停止
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if(dragToDragStop) {// 停止后要执行的代码
            [self scrollViewEndScroll:scrollView];
        }
    }
      
}
- (void)scrollViewEndScroll:(UIScrollView *)scrollView { //完全停止滚动要做的处理
    
}


//定时器的回调方法   切换界面
- (void)changeView{
//    NSLog(@"onetwo12 ");
    //得到scrollView
    UIScrollView *scrollView = [self.view viewWithTag:1000];
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_X = scrollView.contentOffset.x;
    //每次切换一个屏幕
    offset_X += CGRectGetWidth(self.view.frame);
    
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X == CGRectGetWidth(self.view.frame)*(self.imgArr.count+1)) {
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        offset_X = SCREEN_WIDTH;
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_X == CGRectGetWidth(self.view.frame)*(self.imgArr.count+1)) {
        self.myPageControl.currentPage = 1;
    }else{
        self.myPageControl.currentPage = offset_X/CGRectGetWidth(self.view.frame)-1;
    }
    
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >CGRectGetWidth(self.view.frame)*(self.imgArr.count+1)) {
        self.myPageControl.currentPage = self.imgArr.count;
//        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*self.imgArr.count, 0) animated:YES];
    }else{
        [scrollView setContentOffset:resultPoint animated:YES];
    }
    
    
}
//点击
-(void)doTapChange:(UITapGestureRecognizer *)sender{
        NSLog(@"点击了第%ld个",(long)self.myPageControl.currentPage);
    /*
         bannerMode *mode=self.imgArr[self.myPageControl.currentPage];
    //    NSArray * arrTitle = @[@"Invite friend",@"My Wallet"];
        if([mode.subPageType isEqualToString:@"NATIVE_PAGE"])
        {
            if([mode.pageName isEqualToString:@"Invite friend"])
            {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                InviteFriendsViewController *vc=[main instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if([mode.pageName isEqualToString:@"My Wallet"]){
                    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                       MyWalletViewController *vc=[main instantiateViewControllerWithIdentifier:@"MyWalletViewController"];
                       vc.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if([mode.subPageType isEqualToString:@"PICTURE"]){
            ShardHViewController * avc = [[ShardHViewController alloc] init];
            avc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:avc animated:YES];
        }
    */
    if(self.myPageControl.currentPage==0)
    {
        [self btnViewAll:nil];
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


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.imageViewArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    imageTableViewCell *cell = (imageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (imageTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"imageTableViewCell" owner:self options:nil]  lastObject];
    }
//        NSLog(@"LLLLLLL ==  %ld",indexPath.section);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor clearColor];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if(iamgeCC==0)
        {
            [cell.ImageViewG setImage:self.imageViewArr[indexPath.section]];
        }else
        {
            bannerMode *mode=self.imageViewArr[indexPath.section];
            NSDictionary * dict = mode.mainPage;
//            NSString * base = [dict objectForKey:@"base64"];
//            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:base options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            [cell.imageView setImage:[UIImage imageWithData:decodedImageData]];
            NSString * ImageID = [dict objectForKey:@"id"];
//            NSLog(@"%@,%ld",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID],indexPath.section);
//            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]] placeholderImage:nil];
//            NSLog(@"url == %@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]);
            [cell.ImageViewG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]]];
        }
    return cell;
}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
//    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    view_c.backgroundColor=[UIColor whiteColor];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FriendsRViewController *vc=[main instantiateViewControllerWithIdentifier:@"FriendsRViewController"];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WelcomeViewController *vc=[main instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
//    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    
    
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//       ConnectFeedViewController *vc=[main instantiateViewControllerWithIdentifier:@"ConnectFeedViewController"];
//       vc.hidesBottomBarWhenPushed = YES;
//       [self.navigationController pushViewController:vc animated:YES];
    
    
    
    /*
     bannerMode *mode=self.imageViewArr[indexPath.section];
//    NSArray * arrTitle = @[@"Invite friend",@"My Wallet"];
    if([mode.subPageType isEqualToString:@"NATIVE_PAGE"])
    {
        if([mode.pageName isEqualToString:@"Invite friend"])
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
            InviteFriendsViewController *vc=[main instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            }
        }else if([mode.pageName isEqualToString:@"My Wallet"]){
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
                   MyWalletViewController *vc=[main instantiateViewControllerWithIdentifier:@"MyWalletViewController"];
                   vc.hidesBottomBarWhenPushed = YES;
                   [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }else if([mode.subPageType isEqualToString:@"PICTURE"]){
        ShardHViewController * avc = [[ShardHViewController alloc] init];
        avc.hidesBottomBarWhenPushed = YES;
        avc.modeA = mode;
        [self.navigationController pushViewController:avc animated:YES];
    }
    */
//    if(indexPath.section==0)
//    {
//        [self btnViewAll:nil];
//    }
}






@end
