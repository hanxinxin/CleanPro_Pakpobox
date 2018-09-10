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
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * arrtitle;

@end

@implementation SettingViewController
@synthesize arrtitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrtitle=[NSArray arrayWithObjects:@"Modify payment password",@"Forget payment password", nil];
    
//    [self addsetTableView];
    self.NextSetp.layer.cornerRadius=25;
    [self.view addSubview:self.NextSetp];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    //    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:2.0 sinceDate:[NSDate date]]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=@"Settings";
    if([TokenStr isEqualToString:@"1"])
    {
        self.NextSetp.hidden=YES;
    }else
    {
        self.NextSetp.hidden=NO;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self addsetTableView];
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

-(void)addsetTableView
{
    self.tableView.frame=CGRectMake(0, 5, SCREEN_WIDTH, (self.NextSetp.top));
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
    [userDefaults setObject:@"1" forKey:@"phoneNumber"];
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
//    if(indexPath.row==0)
//    {
//        cell.imageView.image=[UIImage imageNamed:@"wallet"];
//    }else if (indexPath.row==1)
//    {
//        cell.imageView.image=[UIImage imageNamed:@"icon_settings"];
//    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.textLabel.textColor = [UIColor darkGrayColor];
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
        mimaViewController *vc=[main instantiateViewControllerWithIdentifier:@"mimaViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row==1)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ForgetPayPasswordViewController *vc=[main instantiateViewControllerWithIdentifier:@"ForgetPayPasswordViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
