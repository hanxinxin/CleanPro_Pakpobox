//
//  NewMyWalletViewController.m
//  Cleanpro
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NewMyWalletViewController.h"
#import "LLSegmentBarVC.h"
#import "DCNavTabBarController.h"
#import "DetailsListViewController.h"
#import "MembershipViewController.h"
@interface NewMyWalletViewController ()<DCNavTabBarControllerDelegate>


@property (nonatomic,strong)SaveUserIDMode * ModeUser;
@end

@implementation NewMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.backgroundImage setImage:[UIImage imageNamed:@"my-wallet_bg"]];
//    [self.topView addSubview:self.backgroundImage];
//    [self.topView sendSubviewToBack:self.backgroundImage];
    
    self.backgroundImage.hidden=YES;
    self.topView.backgroundColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    //////设置imageview 圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.TouxiangImage.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.TouxiangImage.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.TouxiangImage.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.TouxiangImage.layer.mask = maskLayer;
    ///////
    [self.TouxiangImage setUserInteractionEnabled:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
       [self addCollection];
        
    });
}
- (void)viewWillAppear:(BOOL)animated {

 self.title=FGGetStringWithKeyFromTable(@"My Wallet", @"Language");
 [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
 [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
// [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
// [self.navigationController.navigationBar setShadowImage:nil];
 [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
 self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
       self.UserName.text=FGGetStringWithKeyFromTable(@"Click here to login", @"Language");
//        [self.TouxiangImage setImage:[UIImage imageNamed:@"icon_Avatar"]];
        
        
        
    }else
    {
        [self updateText];
        
    }
    
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.translucent = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillDisappear:animated];

}

-(void)updateText
{
//    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //        self.name_label.text=strPhoen;
    
    if(self.ModeUser!=nil)
    {
        self.UserName.text=[NSString stringWithFormat:@"%@%@",self.ModeUser.firstName,self.ModeUser.lastName];
        if(self.ModeUser.headImageUrl!=nil)
        {
            [self.TouxiangImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",E_FuWuQiUrl,E_DownliadHeaderImage,self.ModeUser.headImageUrl]] placeholderImage:[UIImage imageNamed:@"icon_Avatar"]];
        }else
        {
            [self.TouxiangImage setImage:[UIImage imageNamed:@"icon_Avatar"]];
        }
    }else
    {
        [self.TouxiangImage setImage:[UIImage imageNamed:@"icon_Avatar"]];
        self.UserName.text=FGGetStringWithKeyFromTable(@"Click here to login", @"Language");
    }
    //    [self.touxiang_btn setBackgroundImage:[self getImage_touxiang] forState:UIControlStateNormal];
    //    [self.touxiang_btn setBackgroundImage:[self getImage_touxiang] forState:UIControlStateNormal];
    
}
-(void)addCollection
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MembershipViewController *parcel=[main instantiateViewControllerWithIdentifier:@"MembershipViewController"];
        parcel.title = @"Membership";
        DetailsListViewController *Packets=[main instantiateViewControllerWithIdentifier:@"DetailsListViewController"];
        Packets.title = @"Historical bill";
        Packets.topHeight =(SCREEN_HEIGHT-self.topView.bottom-(kNavBarAndStatusBarHeight)+10);
        NSArray *subViewControllers = @[parcel,Packets];
        DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    //    tabBarVC.view.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-(self.navigationController.navigationBar.bottom));
        tabBarVC.delegate=self;
    //    tabBarVC.view.frame = CGRectMake(0, -5, SCREEN_WIDTH, SCREEN_HEIGHT-(self.navigationController.navigationBar.bottom));
        tabBarVC.view.frame = CGRectMake(0, self.topView.bottom, SCREEN_WIDTH, (SCREEN_HEIGHT-self.topView.height));
        
        
        [self.view addSubview:tabBarVC.view];
        [self addChildViewController:tabBarVC];
}
-(void)SelectInt:(NSInteger)intager
{
//    NSLog(@"tag1111==== %ld",intager);
}
@end
