//
//  OrdersViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrdersTableViewCell.h"
#import "OrdersUnpaidViewController.h"
#import "lineItemViewController.h"
#import "HomeViewController.h"
#import "MyAccountViewController.h"


#define tableID @"OrdersTableViewCell"

@interface OrdersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * arr_title;
@end

@implementation OrdersViewController
@synthesize arr_title;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {//解决iOS 10 版本scrollView下滑问题。
        
        self.tableViewTop.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    self.page=0;
    self.maxCount=20;
    self->arr_title=[NSMutableArray arrayWithCapacity:0];
    [self->arr_title removeAllObjects];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            
            [self addTableViewOrders];
    //        [self loadNewData];
        });
    
}

- (void)tongzhiViewController:(NSNotification *)text{
    
    NSLog(@"－－－－－接收到通知------");
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.55/*延迟执行时间*/ * NSEC_PER_SEC));
//    
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        for (UIViewController *temp in self.navigationController.viewControllers) {
//            if ([temp isKindOfClass:[HomeViewController class]]) {
//                [self.navigationController popToViewController:temp animated:YES];
//                
//            }
//        }
//        for (UIViewController *temp in self.navigationController.viewControllers) {
//            if ([temp isKindOfClass:[MyAccountViewController class]]) {
//                [self.navigationController popToViewController:temp animated:YES];
//                ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
//                
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
//            }
//        }
//    });
}

-(void)addnilView
{
    self.nilView.hidden=NO;
    [self.view addSubview:self.nilView];
}
-(void)removeNilView
{
    self.nilView.hidden=YES;
//    [self.nilView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏导航栏
    self.title=FGGetStringWithKeyFromTable(@"History", @"Language");
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [[UINavigationBa、r appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bgnav"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
//    self.navigationController.navigationBar.translucent = YES;
    
    
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    //    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}




-(void)addTableViewOrders
{
    if(self.view.width==375.000000 && self.view.height>=812.000000)
    {
        self.tableViewTop.frame=CGRectMake(15, 84+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-84-10);
    }else{
        self.tableViewTop.frame=CGRectMake(15, 64+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-64-10);
    }
//    self.tableViewTop.frame=self.view.frame;
    self.tableViewTop.delegate=self;
    self.tableViewTop.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.tableViewTop.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableViewTop.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
//    self.tableViewTop.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableViewTop];
    [self.tableViewTop registerNib:[UINib nibWithNibName:@"OrdersTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];

    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = NO;
    // 设置文字
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    // 隐藏状态
    foot.stateLabel.hidden = NO;
    // 设置文字
    [foot setTitle:@"Drop down to refresh more" forState:MJRefreshStateIdle];
    [foot setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [foot setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    // 设置字体
    foot.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    foot.stateLabel.textColor = [UIColor blackColor];
//    foot.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    self.tableViewTop.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.tableViewTop.mj_header=header;
//     self.tableViewTop.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableViewTop.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    }];
    self.tableViewTop.mj_footer = foot;
    // 马上进入刷新状态
    [self.tableViewTop.mj_header beginRefreshing];
    
}

-(void)loadNewData
{
    [self getOrderList];
}

-(void)loadFootData
{
    [self getOrderListFoot];
}


-(void)getOrderList
{
    self.page=0;
    
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?page=%ld&size=%ld",E_FuWuQiUrl,E_WasherDryerquery,(long)self.page,(long)self.maxCount] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
        NSDictionary * dictList=(NSDictionary *)responseObject;
        if(dictList)
        {
//        if([self.totalCount integerValue]>20)
//        {
//            [self.tableViewTop.mj_footer setHidden:NO];
//        }else
//        {
//            [self.tableViewTop.mj_footer setHidden:YES];
//        }
            [arr_title removeAllObjects];
            NSArray * Array= [dictList objectForKey:@"content"];;
            if(Array.count>0)
            {
                [self.arr_title removeAllObjects];
            
            for (int i=0; i<Array.count; i++) {
                NSDictionary * dictArr=Array[i];
                NewOrderList * mode = [[NewOrderList alloc] init];
                mode.merchantId=[dictArr objectForKey:@"merchantId"];;//
                mode.cleanProItemName=[dictArr objectForKey:@"cleanProItemName"];
                mode.merchantName=[dictArr objectForKey:@"merchantName"];//
                mode.orderNumber=[dictArr objectForKey:@"orderNumber"];//
                mode.ordersId=[dictArr objectForKey:@"ordersId"];//
                mode.ordersItems=[dictArr objectForKey:@"ordersItems"];//
                mode.paidCharge=[dictArr objectForKey:@"paidCharge"];//
                mode.siteAddress=[dictArr objectForKey:@"siteAddress"];//
                mode.siteNumber=[dictArr objectForKey:@"siteNumber"];//
                mode.siteSerialNumber=[dictArr objectForKey:@"siteSerialNumber"];//
                mode.siteType=[dictArr objectForKey:@"siteType"];
                mode.timeCreated=[dictArr objectForKey:@"timeCreated"];//
                [self->arr_title addObject:mode];
            }
                if(self->arr_title.count>0)
                {
                    [self removeNilView];
                }else
                {
                    [self addnilView];
                }
            }else{
                
                    [self.tableViewTop.mj_header  endRefreshing];
                    [self addnilView];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
            }
        }
        [self.tableViewTop reloadData];
        [self.tableViewTop.mj_header endRefreshing];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error ORder=  %@",error);
        [self.tableViewTop.mj_header endRefreshing];
    }];
}
-(void)getOrderListFoot
{
    if((self.page+1)<[self.totalPage integerValue])
    {
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@??page=%ld&size=%ld",E_FuWuQiUrl,E_WasherDryerquery,(long)self.page,(long)self.maxCount] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
        NSDictionary * dictList=(NSDictionary *)responseObject;
        if(dictList)
        {
            self.page+=1;
        NSArray * Array= [dictList objectForKey:@"content"];;
        if(Array.count>0)
        {
        
        for (int i=0; i<Array.count; i++) {
            NSDictionary * dictArr=Array[i];
            NewOrderList * mode = [[NewOrderList alloc] init];
            mode.merchantId=[dictArr objectForKey:@"merchantId"];;//
            mode.cleanProItemName=[dictArr objectForKey:@"cleanProItemName"];
            mode.merchantName=[dictArr objectForKey:@"merchantName"];//
            mode.orderNumber=[dictArr objectForKey:@"orderNumber"];//
            mode.ordersId=[dictArr objectForKey:@"ordersId"];//
            mode.ordersItems=[dictArr objectForKey:@"ordersItems"];//
            mode.paidCharge=[dictArr objectForKey:@"paidCharge"];//
            mode.siteAddress=[dictArr objectForKey:@"siteAddress"];//
            mode.siteNumber=[dictArr objectForKey:@"siteNumber"];//
            mode.siteSerialNumber=[dictArr objectForKey:@"siteSerialNumber"];//
            mode.siteType=[dictArr objectForKey:@"siteType"];
            mode.timeCreated=[dictArr objectForKey:@"timeCreated"];//
            [self->arr_title addObject:mode];
        }
            if(self->arr_title.count>0)
            {
                [self removeNilView];
            }else
            {
                [self addnilView];
            }
        }
        }
        [self.tableViewTop reloadData];
        [self.tableViewTop.mj_footer endRefreshing];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error ORder=  %@",error);
        [self.tableViewTop.mj_footer endRefreshing];
        [self removeNilView];
    }];
    }else{
        [self.tableViewTop.mj_footer endRefreshing];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"There's no more data", @"Language") andDelay:2.0];
    }
}

/*
-(void)getOrderList
{
    self.page=0;
    [arr_title removeAllObjects];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?page=%ld&maxCount=%ld",FuWuQiUrl,Post_userOrder,(long)self.page,(long)self.maxCount] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
        NSDictionary * dictList=(NSDictionary *)responseObject;
        NSNumber * statusCodeStr=[dictList objectForKey:@"statusCode"];
        if([statusCodeStr integerValue]==401)
        {
//            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
//             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
//                NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxin1" object: nil];
//                //通过通知中心发送通知
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self addnilView];
        }else if(statusCodeStr==nil){
        NSArray * Array=[dictList objectForKey:@"resultList"];
        
        self.totalCount=[dictList objectForKey:@"totalCount"];
        self.totalPage=[dictList objectForKey:@"totalPage"];
        if([self.totalCount integerValue]>20)
        {
            [self.tableViewTop.mj_footer setHidden:NO];
        }else
        {
            [self.tableViewTop.mj_footer setHidden:YES];
        }
        for (int i=0; i<Array.count; i++) {
            NSDictionary * dict=Array[i];
        OrderListClass * mode=[[OrderListClass alloc] init];
        mode.goods_info=[dict objectForKey:@"goods_info"];
        mode.client_type=[dict objectForKey:@"client_type"];
        mode.create_time=[dict objectForKey:@"create_time"];
        mode.OrderId=[dict objectForKey:@"id"];
        mode.machine_no=[dict objectForKey:@"machine_no"];
        mode.order_type=[dict objectForKey:@"order_type"];
        mode.order_no=[dict objectForKey:@"order_no"];
        mode.pay_status = [dict objectForKey:@"pay_status"];
        mode.total_amount=[dict objectForKey:@"total_amount"];
//        NSLog(@"locationName = %@",[[dict objectForKey:@"box"] objectForKey:@"name"]);
        mode.LocationName = [[dict objectForKey:@"box"] objectForKey:@"name"];
            [self->arr_title addObject:mode];
        }
            if(self->arr_title.count>0)
            {
                [self removeNilView];
            }else
            {
                [self addnilView];
            }
        }
        
        [self.tableViewTop reloadData];
        [self.tableViewTop.mj_header endRefreshing];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error ORder=  %@",error);
        [self.tableViewTop.mj_header endRefreshing];
    }];
}
*/
/*
-(void)getOrderListFoot
{
    if((self.page+1)<[self.totalPage integerValue])
    {
        self.page+=1;

    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?page=%ld&maxCount=%ld",FuWuQiUrl,Post_userOrder,(long)self.page,(long)self.maxCount] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
        NSDictionary * dictList=(NSDictionary *)responseObject;
        
        NSArray * Array=[dictList objectForKey:@"resultList"];
        self.totalCount=[dictList objectForKey:@"totalCount"];
        self.totalPage=[dictList objectForKey:@"totalPage"];
        for (int i=0; i<Array.count; i++) {
            NSDictionary * dict=Array[i];
            OrderListClass * mode=[[OrderListClass alloc] init];
            mode.goods_info=[dict objectForKey:@"goods_info"];
            mode.client_type=[dict objectForKey:@"client_type"];
            mode.create_time=[dict objectForKey:@"create_time"];
            mode.OrderId=[dict objectForKey:@"id"];
            mode.machine_no=[dict objectForKey:@"machine_no"];
            mode.order_type=[dict objectForKey:@"order_type"];
            mode.total_amount=[dict objectForKey:@"total_amount"];
            mode.LocationName = [[dict objectForKey:@"box"] objectForKey:@"name"];
            [self->arr_title addObject:mode];
        }
        
        [self.tableViewTop reloadData];
        [self.tableViewTop.mj_footer endRefreshing];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error ORder=  %@",error);
        [self.tableViewTop.mj_footer endRefreshing];
        [self removeNilView];
    }];
    }else{
        [self.tableViewTop.mj_footer endRefreshing];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"There's no more data", @"Language") andDelay:2.0];
    }
}

*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return arr_title.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersTableViewCell *cell = (OrdersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (OrdersTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"OrdersTableViewCell" owner:self options:nil]  lastObject];
    }
//    NSLog(@"%ld",indexPath.section);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor clearColor];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    OrderListClass * mode =arr_title[indexPath.section];
//
//    if([mode.order_type isEqualToString:@"DRYER"])
//    {
//
//        [cell.typeButton setImage:[UIImage imageNamed:@"icon_dryer2"] forState:(UIControlStateNormal)];
//        cell.Order_type.text=[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Dryer", @"Language")];
//    }else if([mode.order_type isEqualToString:@"LAUNDRY"])
//    {
//        [cell.typeButton setImage:[UIImage imageNamed:@"icon_laundry2"] forState:(UIControlStateNormal)];
//        cell.Order_type.text=[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Washer", @"Language")];
//    }
////    cell.OrderNo.text=[NSString stringWithFormat:@"Order NO. %@",mode.order_no];
//    cell.OrderNo.text=[NSString stringWithFormat:@"%@%@",FGGetStringWithKeyFromTable(@"Transaction NO. ", @"Language"),mode.order_no];
////    cell.OrderNo.text=[NSString stringWithFormat:@"%@",[OrdersViewController nsdateToString:[OrdersViewController changeSpToTime:[mode.createTime stringValue]]]];
//    cell.Paid.text=[NSString stringWithFormat:@"%@",mode.pay_status];
//    cell.totalAmount.text=[NSString stringWithFormat:@"%.2f",[mode.total_amount floatValue]];
    
    NewOrderList * mode=arr_title[indexPath.section];
        if([mode.siteType isEqualToString:@"DRYER"])
        {
    
            [cell.typeButton setImage:[UIImage imageNamed:@"icon_dryer2"] forState:(UIControlStateNormal)];
            cell.Order_type.text=[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Dryer", @"Language")];
        }else if([mode.siteType isEqualToString:@"WASHER"])
        {
            [cell.typeButton setImage:[UIImage imageNamed:@"icon_laundry2"] forState:(UIControlStateNormal)];
            cell.Order_type.text=[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Washer", @"Language")];
        }
        cell.OrderNo.text=[NSString stringWithFormat:@"%@%@",FGGetStringWithKeyFromTable(@"Transaction NO. ", @"Language"),mode.orderNumber];
//        cell.Paid.text=[NSString stringWithFormat:@"%@",mode.pay_status];
        cell.totalAmount.text=[NSString stringWithFormat:@"%.2f",[mode.paidCharge floatValue]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.f;
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
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section==0)
//    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        lineItemViewController *vc=[main instantiateViewControllerWithIdentifier:@"lineItemViewController"];
        vc.hidesBottomBarWhenPushed = YES;
//        vc.mode=arr_title[indexPath.section];
        vc.Newmode=arr_title[indexPath.section];
    NSLog(@"indexPath.section= %ld",(long)indexPath.section);
        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.section==1)
//    {
//        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        OrdersUnpaidViewController *vc=[main instantiateViewControllerWithIdentifier:@"OrdersUnpaidViewController"];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//将时间戳转换成NSDate
+(NSDate *)changeSpToTime:(NSString*)spString{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    return confromTimesp;
}
//将NSDate按yyyy-MM-dd HH:mm:ss格式时间输出
+(NSString*)nsdateToString:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}


@end
