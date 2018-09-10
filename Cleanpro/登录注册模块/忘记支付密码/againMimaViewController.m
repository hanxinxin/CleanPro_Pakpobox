//
//  againMimaViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "againMimaViewController.h"
#import "AffirmViewController.h"
@interface againMimaViewController ()

@end

@implementation againMimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self setPassword];
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
    __block againMimaViewController *  blockSelf = self;
    self.password_text.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        if(password.length==6)
        {
                self->_payNewPassword=password;
                [blockSelf push_AffirmViewController];
        }
    };
    
    [self.view addSubview:self.password_text];
}

-(void)push_AffirmViewController
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AffirmViewController *vc=[main instantiateViewControllerWithIdentifier:@"AffirmViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.oldPayPassword=self.oldPayPassword;
    vc.payNewPassword=self.payNewPassword;
    if(self.PayOrLog==1)
    {
        vc.TokenString=self.TokenString;
        vc.PayOrLog=self.PayOrLog;
    }else if (self.PayOrLog==2)
    {
        vc.TokenString=self.TokenString;
        vc.PayOrLog=self.PayOrLog;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
