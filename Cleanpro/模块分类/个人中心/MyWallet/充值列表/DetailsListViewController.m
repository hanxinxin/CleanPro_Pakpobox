//
//  DetailsListViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DetailsListViewController.h"
#import "DetailsListTableViewCell.h"
#define tableID @"DetailsListTableViewCell"

@interface DetailsListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * arr_title;
@end

@implementation DetailsListViewController
@synthesize arr_title;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {//解决iOS 10 版本scrollView下滑问题。
        
        self.tableView_top.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    arr_title=[NSMutableArray arrayWithCapacity:0];
//    self.view.backgroundColor = [UIColor redColor];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addTableViewOrders];
        [self loadNewData];
    });
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
//    self.title=FGGetStringWithKeyFromTable(@"Details", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.page=0;
     self.maxCount=20;
     
    
    
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

    self.page = 0;
    [arr_title removeAllObjects];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?page=%ld&maxCount=%ld",FuWuQiUrl,Get_UserQuery,(long)self.page,(long)self.maxCount] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
        NSDictionary * dictList=(NSDictionary *)responseObject;
        NSArray * Array=[dictList objectForKey:@"resultList"];
        self.totalCount=[dictList objectForKey:@"totalCount"];
        self.totalPage=[dictList objectForKey:@"totalPage"];
        if([self.totalCount integerValue]>20)
        {
            [self.tableView_top.mj_footer setHidden:NO];
        }else
        {
            [self.tableView_top.mj_footer setHidden:YES];
        }
        for (int i=0; i<Array.count; i++) {
            NSDictionary * dict=Array[i];
            WalletListClass * mode=[[WalletListClass alloc] init];;
            mode.amount=[dict objectForKey:@"amount"];
            mode.balance=[dict objectForKey:@"balance"];
            mode.createTime=[dict objectForKey:@"createTime"];
            mode.WalletId=[dict objectForKey:@"id"];
            mode.incomeType=[dict objectForKey:@"incomeType"];
            mode.paymentType=[dict objectForKey:@"paymentType"];
            mode.tradeType=[dict objectForKey:@"tradeType"];
            mode.transactionType=[dict objectForKey:@"transactionType"];
            [self->arr_title addObject:mode];
        }
        [self.tableView_top reloadData];
        [self.tableView_top.mj_header endRefreshing];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error ORder=  %@",error);
        [self.tableView_top.mj_header endRefreshing];
    }];
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
                WalletListClass * mode=[[WalletListClass alloc] init];;
                mode.amount=[dict objectForKey:@"amount"];
                mode.balance=[dict objectForKey:@"balance"];
                mode.createTime=[dict objectForKey:@"createTime"];
                mode.WalletId=[dict objectForKey:@"id"];
                mode.incomeType=[dict objectForKey:@"incomeType"];
                mode.paymentType=[dict objectForKey:@"paymentType"];
                mode.tradeType=[dict objectForKey:@"tradeType"];
                mode.transactionType=[dict objectForKey:@"transactionType"];
//                if([mode.incomeType isEqualToString:@"OUT"])
//                {
//
//                }else if ([mode.incomeType isEqualToString:@"IN"])
//                {
//                    [self->arr_title addObject:mode];
//                }
                [self->arr_title addObject:mode];
            }
            [self.tableView_top reloadData];
            [self.tableView_top.mj_footer endRefreshing];
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error ORder=  %@",error);
            [self.tableView_top.mj_footer endRefreshing];
        }];
    }else{
        [self.tableView_top.mj_footer endRefreshing];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"There's no more data", @"Language") andDelay:2.0];
    }
}
-(void)addTableViewOrders
{
//    if(self.view.width==375.000000 && self.view.height==812.000000)
//    {
//        self.tableView_top.frame=CGRectMake(0, self.navigationController.navigationBar.height, SCREEN_WIDTH,SCREEN_HEIGHT-self.navigationController.navigationBar.height);
//    }else{
//        self.tableView_top.frame=CGRectMake(0, self.navigationController.navigationBar.height, SCREEN_WIDTH,SCREEN_HEIGHT-self.navigationController.navigationBar.height);
//    }
//    if(self.view.width==375.000000 && self.view.height>=812.000000)
//    {
//        self.tableView_top.frame=CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-84-64);
//    }else{
//        self.tableView_top.frame=CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-64-self.tabBarController.tabBar.height);
//    }
//    self.tableView_top.frame=CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-64-self.tabBarController.tabBar.height);
    self.tableView_top.frame=CGRectMake(0, 0, SCREEN_WIDTH,self.topHeight);
//    self.tableView_top.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-0);
    self.tableView_top.delegate=self;
    self.tableView_top.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.tableView_top.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView_top.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView_top];
    [self.tableView_top registerNib:[UINib nibWithNibName:@"DetailsListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    
    // 或
//    // 设置回调（一旦进入刷新状态，就调用 target 的 action，也就是调用 self 的 loadNewData 方法）
//    self.tableView_top.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView_top.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
//    // 马上进入刷新状态
//    [self.tableView_top.mj_header beginRefreshing];
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
    self.tableView_top.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.tableView_top.mj_header=header;
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
    self.tableView_top.mj_footer =foot;
//    self.tableView_top.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    //    // 马上进入刷新状态
//        [self.tableView_top.mj_header beginRefreshing];
}

-(void)loadNewData
{
    [self getOrderList];
}

-(void)loadFootData
{
    [self getOrderListFoot];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return arr_title.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsListTableViewCell *cell = (DetailsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (DetailsListTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"DetailsListTableViewCell" owner:self options:nil]  lastObject];
    }
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WalletListClass * mode =arr_title[indexPath.row];
    if([mode.transactionType isEqualToString:@"LAUNDRY"])
    {
//        self.title =@"Washer";
        cell.top_Label.text=[NSString stringWithFormat:@"%@",FGGetStringWithKeyFromTable(@"Washer", @"Language")];
    }else if([mode.transactionType isEqualToString:@"DRYER"])
    {
//        self.title =@"Dryer";
        cell.top_Label.text=[NSString stringWithFormat:@"%@",mode.transactionType];
    }
    
    
//    cell.down_label.text=[NSString stringWithFormat:@"%@",mode.createTime];
    cell.down_label.text=[NSString stringWithFormat:@"%@",[DetailsListViewController nsdateToString:[DetailsListViewController changeSpToTime:[mode.createTime stringValue]]]];
    if([mode.incomeType isEqualToString:@"OUT"])
    {
        cell.right_label.text=[NSString stringWithFormat:@"-%.f",[mode.amount floatValue]/100];
        cell.right_label.textColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
    }else if ([mode.incomeType isEqualToString:@"IN"])
    {
        cell.right_label.text=[NSString stringWithFormat:@"+%.f",[mode.amount floatValue]/100];
        cell.right_label.textColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    }
    cell.backgroundColor = [UIColor whiteColor];
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
    
    return 62;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



//将时间戳转换成NSDate  13位是毫秒，10位是秒
+(NSDate *)changeSpToTime:(NSString*)spString{
    if(spString.length!=10)
    {
        if(spString.length>10)
        {
//            NSLog(@"spString == %f   %f ",[spString doubleValue],[spString doubleValue]/1000.0 );
            NSTimeInterval timeInt = [spString doubleValue]/1000.0;
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInt];
            return confromTimesp;
        }else
        {
//            NSTimeInterval timeInt = [spString intValue]/1000;
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
            return confromTimesp;
        }
    }else
    {
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
        return confromTimesp;
    }
}
//将NSDate按yyyy-MM-dd HH:mm:ss格式时间输出
+(NSString*)nsdateToString:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

@end
