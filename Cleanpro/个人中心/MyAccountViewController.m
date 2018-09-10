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

@interface MyAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * arrtitle;

@end

@implementation MyAccountViewController
@synthesize arrtitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrtitle=[NSArray arrayWithObjects:@"My Wallet",@"Settings", nil];
    
    self.background_image.image=[UIImage imageNamed:@"myaccount_bg"];
//    self.background_image.clipsToBounds = NO;
//    //自适应图片宽高比例
//    self.background_image.contentMode = UIViewContentModeScaleToFill;
//    [self.background_image setMultipleTouchEnabled:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];//隐藏导航栏
    //    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:2.0 sinceDate:[NSDate date]]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.title=@"Cleapro";
    self.navigationController.title=FGGetStringWithKeyFromTable(@"My Account", @"Language");
    NSString * strPhoen=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if([strPhoen isEqualToString:@"1"])
    {
        self.name_label.text=@"not log in";
        self.touxiang_btn.userInteractionEnabled=YES;
    }else
    {
        self.name_label.text=strPhoen;
        self.touxiang_btn.userInteractionEnabled=NO;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self addsetTableView];
    
    
    NSString* TokenError=[[NSUserDefaults standardUserDefaults] objectForKey:@"TokenError"];
    if([TokenError isEqualToString:@"1"])
    {
    NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxin1" object: nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}
- (IBAction)Login_touch:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


-(void)addsetTableView
{
    self.Down_tableView.frame=CGRectMake(0, self.topView.bottom+15, SCREEN_WIDTH, SCREEN_HEIGHT-self.topView.height-15);
    self.Down_tableView.delegate=self;
    self.Down_tableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.Down_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.Set_tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:self.Down_tableView];
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrtitle.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [arrtitle objectAtIndex:indexPath.row];
    
    //    NSLog(@"%ld",(long)indexPath.row);
    if(indexPath.row==0)
    {
        cell.imageView.image=[UIImage imageNamed:@"wallet"];
    }else if (indexPath.row==1)
    {
        cell.imageView.image=[UIImage imageNamed:@"icon_settings"];
    }
//    if(indexPath.row!=3)
//    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
//    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    cell.layer.cornerRadius=4;
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyWalletViewController *vc=[main instantiateViewControllerWithIdentifier:@"MyWalletViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SettingViewController *vc=[main instantiateViewControllerWithIdentifier:@"SettingViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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

@end
