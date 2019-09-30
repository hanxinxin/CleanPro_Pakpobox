//
//  VIPjfViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "VIPjfViewController.h"
#import "JF1TableViewCell.h"
#import "JF2TableViewCell.h"
#import "MyAccountViewController.h"


#define tableID1 @"JF1TableViewCell"
#define tableID2 @"JF2TableViewCell"
@interface VIPjfViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * arrtitle;
@property (nonatomic,strong) NSNumber * balance;
@property (nonatomic,strong) NSNumber * credit;
@property (nonatomic,strong) NSString * currencyUnit;
@end

@implementation VIPjfViewController
@synthesize arrtitle,Donw_tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrtitle = [NSArray arrayWithObjects:@[FGGetStringWithKeyFromTable(@"VIP", @"Language")],@[FGGetStringWithKeyFromTable(@"How to get credits?", @"Language"),FGGetStringWithKeyFromTable(@"1. After you register, you are a member of Cleanpro.You can get Cleanpro benefits.\n2. Reload of each RM10 to get 1 point", @"Language")],@[FGGetStringWithKeyFromTable(@"How to use credits?", @"Language"),FGGetStringWithKeyFromTable(@"One point is equivalent to RM0.10, you can use the credits when you pay.", @"Language")], nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]];
    [self addsetTableView];
    [self Get_wallet_A];
}
- (void)viewWillAppear:(BOOL)animated {
    
   
    self.title=FGGetStringWithKeyFromTable(@"VIP", @"Language");
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self Get_wallet_A];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = NO;
}
/**
 获取用户钱包
 */
-(void)Get_wallet_A
{
//    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_wallet] parameters:nil progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
        
        
        if([statusCode intValue] ==401)
        {
            //            [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"TokenError"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MyAccountViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    
                }
            }
        }else{
            self.balance = [dictObject objectForKey:@"balance"];
            self.currencyUnit = [dictObject objectForKey:@"currencyUnit"];
            self.credit = [dictObject objectForKey:@"credit"];
//            [self update_label];
            [self.Donw_tableview reloadData];
            
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



-(void)addsetTableView
{
    //    self.Down_tableView.frame=CGRectMake(0, self.topView.bottom+10, SCREEN_WIDTH, SCREEN_HEIGHT-self.topView.height-15);
    
    self.Donw_tableview.frame=CGRectMake(15, 0, SCREEN_WIDTH-30, 99+24+330);
    
    self.Donw_tableview.delegate=self;
    self.Donw_tableview.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
//    [self.Donw_tableview setBackgroundColor:[UIColor whiteColor]];
    [self.Donw_tableview setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]];
    self.Donw_tableview.scrollEnabled = NO;  ////设置tableview不上下滑动
    self.Donw_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.Set_tableView.separatorColor = [UIColor blackColor];
    [self.Donw_tableview registerNib:[UINib nibWithNibName:@"JF1TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID1];
    [self.Donw_tableview registerNib:[UINib nibWithNibName:@"JF2TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID2];
    [self.view addSubview:self.Donw_tableview];
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return arrtitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        JF1TableViewCell *cell = (JF1TableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID1];
        if (cell == nil) {
            cell= (JF1TableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"JF1TableViewCell" owner:self options:nil]  lastObject];
        }
//    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
//    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
//    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
//    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius=4;
    [cell setBackgroundColor:[UIColor whiteColor]];
        if([self.credit doubleValue]>999)
        {
            cell.Jifen_label.text = [NSString stringWithFormat:@"%.f",[self.credit floatValue]];
        }else
        {
            cell.Jifen_label.text = [self.credit stringValue];
        }
        
    return cell;
    }else
    {
        JF2TableViewCell *cell = (JF2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID2];
        if (cell == nil) {
            cell= (JF2TableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"JF2TableViewCell" owner:self options:nil]  lastObject];
        }
//        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
//        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
//        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
//        [cell.contentView addSubview:lbl];
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius=4;
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSArray * arr = arrtitle[indexPath.section];
        for (int i =0; i<arr.count; i++) {
            if(i==0)
            {
            cell.topLabel.text = [arr objectAtIndex:i];
            }else if (i==1)
            {
            cell.DownLabel.text = [arr objectAtIndex:i];
            }
        }
        
        return cell;
    }
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
    {
    return 99;
    }else if(indexPath.section==1)
    {
        NSArray * arr = arrtitle[indexPath.section];
        for (int i =0; i<arr.count; i++) {
            if(i==1)
            {
                CGFloat height = [self getHeightLineWithString:[arr objectAtIndex:i] withWidth:SCREEN_WIDTH-32 withFont:[UIFont systemFontOfSize:19]];
                return 45.0+height;
            }
        }
    }else if(indexPath.section==2)
    {
            NSArray * arr = arrtitle[indexPath.section];
            for (int i =0; i<arr.count; i++) {
                if(i==1)
                {
                    CGFloat height = [self getHeightLineWithString:[arr objectAtIndex:i] withWidth:SCREEN_WIDTH-32 withFont:[UIFont systemFontOfSize:14]];
                    CGFloat returnHeight =60+height+20;
                    return returnHeight;
                }
            }
        
        
    }
    return 0;
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
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}

//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        
    }
}



#pragma mark - 根据字符串计算label高度
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}

@end
