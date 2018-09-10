//
//  mimaViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "mimaViewController.h"
#import "againMimaViewController.h"
#import "HomeViewController.h"
#import "MyAccountViewController.h"

@interface mimaViewController ()

@end

@implementation mimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
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
    __block mimaViewController *  blockSelf = self;
    self.password_text.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        
        if(password.length==6)
        {

                self->_Pay_passwordStr=password;
                [blockSelf Post_payPassword];
        }
    };
    
    [self.view addSubview:self.password_text];
}

-(void)Post_payPassword
{
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"payPassword":self.Pay_passwordStr};
    NSLog(@"dict=== %@",dict);
    __block mimaViewController *  blockSelf = self;
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
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else if (codeInt==nil)
        {
            if([code intValue]==0)
            {
                [HudViewFZ showMessageTitle:@"statusCode error" andDelay:2.0];
                [blockSelf tisp];
                [blockSelf.password_text clearPassword];
            
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
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else{
            [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
            
        }
        }];
}

-(void)push_againMimaViewController
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    againMimaViewController *vc=[main instantiateViewControllerWithIdentifier:@"againMimaViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.PayOrLog=1;
    vc.oldPayPassword=self.Pay_passwordStr;
    vc.TokenString=@"1";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tisp
{
    [HudViewFZ showMessageTitle:@"Wrong password" andDelay:2.0];
    
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
