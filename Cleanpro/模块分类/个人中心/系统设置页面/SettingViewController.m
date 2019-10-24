//
//  SettingViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SettingViewController.h"
#import "ForgetPayPasswordViewController.h"
#import "mimaViewController.h"
#import "MyAccountViewController.h"
#import "ContactViewController.h"
#import "newPhoneViewController.h"
#import "ExistingPayViewController.h"
#import "ZGQActionSheetView.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,ZGQActionSheetViewDelegate>
@property (nonatomic,strong)NSArray * arrtitle;
@property (nullable,strong)ChangeLanguage * Change;
@end

@implementation SettingViewController
@synthesize arrtitle,Change;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    arrtitle=[NSArray arrayWithObjects:@"Modify payment password",@"Forget payment password", nil];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    
    arrtitle=@[FGGetStringWithKeyFromTable(@"Payment Setting", @"Language"),FGGetStringWithKeyFromTable(@"Language", @"Language"),FGGetStringWithKeyFromTable(@"Version", @"Language"),FGGetStringWithKeyFromTable(@"Contact us", @"Language")];
//    [self addsetTableView];
    [self.NextSetp setTitle:FGGetStringWithKeyFromTable(@"Log out", @"Language") forState:(UIControlStateNormal)];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.NextSetp.layer.cornerRadius=4;
    [self.view addSubview:self.NextSetp];
    [self.view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1]];
    self.tableView.hidden=YES;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addsetTableView];
    });
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    //    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:2.0 sinceDate:[NSDate date]]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=FGGetStringWithKeyFromTable(@"Settings", @"Language");
    if([TokenStr isEqualToString:@"1"])
    {
        self.NextSetp.hidden=YES;
    }else
    {
        self.NextSetp.hidden=NO;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
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

-(void)addsetTableView
{
    self.tableView.hidden = NO;
    self.tableView.frame=CGRectMake(0, 64+8, SCREEN_WIDTH, 51*arrtitle.count+8*arrtitle.count);
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.Set_tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
}


- (IBAction)Logout_touch:(id)sender {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"1" forKey:@"Token"];
    [jiamiStr base64Data_encrypt:@"1"];
    [userDefaults setObject:@"1" forKey:@"YHToken"];
    [userDefaults setObject:@"1" forKey:@"phoneNumber"];
    [userDefaults setObject:nil forKey:@"SaveUserMode"];
    [userDefaults setObject:@"1" forKey:@"logCamera"];
//    [defaults synchronize];
    NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxinLog" object: nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MyAccountViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
     self.NextSetp.hidden=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return arrtitle.count;
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
    return arrtitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0)
    {
        
        UITableViewCell* cell1 = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
            
            //            cell.contentView.backgroundColor = [UIColor blueColor];
            
        }
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [cell1.contentView addSubview:lbl];
        //cell选中效果
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.textLabel.text = [arrtitle objectAtIndex:indexPath.section];
//        cell1.imageView.image=[UIImage imageNamed:@"me_settings"];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell1.textLabel.textColor = [UIColor darkGrayColor];
        return cell1;
    }else if(indexPath.section==1)
    {
        cell.textLabel.text = [arrtitle objectAtIndex:indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }else if(indexPath.section==2)
    {
    cell.textLabel.text = [arrtitle objectAtIndex:indexPath.section];
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [cell.detailTextLabel setText:app_Version];
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0]];
    }else if(indexPath.section==3)
    {
        cell.textLabel.text = [arrtitle objectAtIndex:indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }
        NSLog(@"%ld",(long)indexPath.row);

//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 51;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section==0)
//    {
//        return 0;
//    }
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
        if([strPhoen isEqualToString:@"1"])
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
        NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([ModeUser.payPassword isEqualToString:@""] && ModeUser.payPassword != nil)
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            newPhoneViewController *vc=[main instantiateViewControllerWithIdentifier:@"newPhoneViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ExistingPayViewController *vc=[main instantiateViewControllerWithIdentifier:@"ExistingPayViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        }
    }else if(indexPath.section==1)
    {
        NSArray *optionArray = @[FGGetStringWithKeyFromTable(@"English", @"Language"),FGGetStringWithKeyFromTable(@"Malay", @"Language"),FGGetStringWithKeyFromTable(@"Thai", @"Language")];
        ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray];
        sheetView.tag=202;
        sheetView.delegate = self;
        [sheetView show];
    }else if(indexPath.section==2)
    {
//        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ContactViewController *vc=[main instantiateViewControllerWithIdentifier:@"ContactViewController"];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section==3)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactViewController *vc=[main instantiateViewControllerWithIdentifier:@"ContactViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



- (void)ZGQActionSheetView:(ZGQActionSheetView *)sheetView didSelectRowAtIndex:(NSInteger)index text:(NSString *)text {
    NSLog(@"%zd,%@",index,text);
    if(sheetView.tag==202)
    {
        Change = [ChangeLanguage sharedInstance];;
        
        if(index==0)
        {
            NSLog(@"英");
            [Change setNewLanguage:EN];
        }else if(index==1)
        {
            NSLog(@"马来文");
            [Change setNewLanguage:malai];
            
        }else if(index==2)
        {
             NSLog(@"泰文");
            [Change setNewLanguage:TaiWen];
        }
    }
}

@end
