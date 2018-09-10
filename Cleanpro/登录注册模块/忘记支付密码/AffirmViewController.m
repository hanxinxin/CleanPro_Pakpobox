//
//  AffirmViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AffirmViewController.h"
#import "HomeViewController.h"
#import "MyAccountViewController.h"

@interface AffirmViewController ()

@end

@implementation AffirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ConfirmBtn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
    [self.ConfirmBtn setUserInteractionEnabled:NO];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self setPassword];
    });
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(tongzhiViewController:) name:@"tongzhiViewController" object:nil];
}



- (void)tongzhiViewController:(NSNotification *)text{
    
    NSLog(@"－－－－－接收到通知------");
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.55/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[HomeViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                
            }
        }
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[MyAccountViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
                //创建通知
                
                NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxin1" object: nil];
                
                //通过通知中心发送通知
                
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }
    });
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    //    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:2.0 sinceDate:[NSDate date]]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=@"Settings";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}

-(void)setPassword
{
    self.password_text=[[TPPasswordTextView alloc] initWithFrame:self.password_btn.frame];
    self.password_text.elementCount = 6;
    //    self.one_payPassword1.backgroundColor=[UIColor blueColor];
    __block AffirmViewController *  blockSelf = self;
    self.password_text.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        if(password.length==6)
        {
            if([password isEqualToString:blockSelf->_payNewPassword])
            {
                NSLog(@"YESYES");
                blockSelf->_SelfPayPassword=password;
                [blockSelf.ConfirmBtn setUserInteractionEnabled:YES];
                blockSelf.ConfirmBtn.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
            }else
            {
//                NSLog(@"NONONO");
                
                [blockSelf.password_text clearPassword];
                blockSelf.ConfirmBtn.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
                [blockSelf.ConfirmBtn setUserInteractionEnabled:NO];
                [HudViewFZ showMessageTitle:@"Two password inconsistencies" andDelay:2.0];
            }
        }
    };
    
    [self.view addSubview:self.password_text];
}




- (IBAction)Confirm_touch:(id)sender {
    
    if(self.PayOrLog==1)
    {
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"payPassword":self.SelfPayPassword,
                          @"oldPayPassword":self.oldPayPassword,
                          };
    NSLog(@"dict=== %@",dict);
    __block AffirmViewController *  blockSelf = self;
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_XiugaiPayPassword] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            [HudViewFZ showMessageTitle:@"Modify successfully" andDelay:2.0];
            [blockSelf return_viewcontroller];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:@"Token"];
            [userDefaults setObject:@"1" forKey:@"phoneNumber"];
        }else
        {
            [HudViewFZ showMessageTitle:@"StatusCode error" andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        if(statusCode==401)
        {
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
           //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];

        }else{
            [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
            
        }
    }];
    }else if (self.PayOrLog==2)
    {
        
        
        [HudViewFZ labelExample:self.view];
        NSDictionary * dict=@{@"token":self.TokenString,
                              @"payPassword":self.SelfPayPassword};
        //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
        [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_ChongzhiPayPassword] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            if(statusCode==200)
            {
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[HomeViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                        
                    }
                }
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[MyAccountViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                        ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
                    }
                }
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
    
}


-(void)return_viewcontroller
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
   
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[HomeViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            
        }
    }
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MyAccountViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
        }
    }
    
    });
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

@end
