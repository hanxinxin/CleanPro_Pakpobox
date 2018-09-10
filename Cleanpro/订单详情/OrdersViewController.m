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
    arr_title=[NSMutableArray arrayWithCapacity:0];
    [arr_title removeAllObjects];
    [self loadNewData];
    
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
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏导航栏
    self.title=@"Orders";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSString* TokenError=[[NSUserDefaults standardUserDefaults] objectForKey:@"TokenError"];
    if([TokenError isEqualToString:@"1"])
    {
        NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxin1" object: nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    [self addTableViewOrders];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}



-(void)getOrderList
{
    
    [arr_title removeAllObjects];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?page=%ld&maxCount=%ld",FuWuQiUrl,Post_userOrder,(long)self.page,(long)self.maxCount] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
        NSDictionary * dictList=(NSDictionary *)responseObject;
        NSNumber * statusCodeStr=[dictList objectForKey:@"statusCode"];
        if([statusCodeStr integerValue]==401)
        {
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
                NSNotification *notification =[NSNotification notificationWithName:@"UIshuaxin1" object: nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
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
        mode.total_amount=[dict objectForKey:@"total_amount"];
            [self->arr_title addObject:mode];
        }
        }
        [self.tableViewTop reloadData];
        [self.tableViewTop.mj_header endRefreshing];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error ORder=  %@",error);
        [self.tableViewTop.mj_header endRefreshing];
    }];
}


-(void)addTableViewOrders
{
    if(self.view.width==375.000000 && self.view.height==812.000000)
    {
        self.tableViewTop.frame=CGRectMake(0, 84, SCREEN_WIDTH,SCREEN_HEIGHT-84-64);
    }else{
        self.tableViewTop.frame=CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT-64-64);
    }
    
    self.tableViewTop.delegate=self;
    self.tableViewTop.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.tableViewTop.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableViewTop.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.tableViewTop];
    [self.tableViewTop registerNib:[UINib nibWithNibName:@"OrdersTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    self.tableViewTop.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 或
    // 设置回调（一旦进入刷新状态，就调用 target 的 action，也就是调用 self 的 loadNewData 方法）
    self.tableViewTop.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
     self.tableViewTop.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    // 马上进入刷新状态
//    [self.tableViewTop.mj_header beginRefreshing];
    
}

-(void)loadNewData
{
    [self getOrderList];
}

-(void)loadFootData
{
    [self getOrderListFoot];
}

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
            [self->arr_title addObject:mode];
        }
        
        [self.tableViewTop reloadData];
        [self.tableViewTop.mj_footer endRefreshing];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error ORder=  %@",error);
        [self.tableViewTop.mj_footer endRefreshing];
    }];
    }else{
        [self.tableViewTop.mj_footer endRefreshing];
        [HudViewFZ showMessageTitle:@"There's no more data" andDelay:2.0];
    }
}


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
    OrderListClass * mode =arr_title[indexPath.section];
    cell.Order_type.text=[NSString stringWithFormat:@"%@",mode.order_type];
    cell.OrderNo.text=[NSString stringWithFormat:@"Order NO. %@",mode.OrderId];
    cell.Paid.text=[NSString stringWithFormat:@"PAID"];
    cell.totalAmount.text=[NSString stringWithFormat:@"RM %.2f",[mode.total_amount floatValue]];
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
    vc.mode=arr_title[indexPath.section];
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

@end
