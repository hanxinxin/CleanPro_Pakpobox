//
//  IMessageViewController.m
//  Cleanpro
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "IMessageViewController.h"
#import "ImessageTableViewCell.h"
#import "ImessageDetailsViewController.h"
#import "MGSwipeTableCell.h"
#import "TMSwipeCell.h"
#import "EwashMessageTableViewCell.h"

#define tableID @"ImessageTableViewCell"
#define tableID1 @"EwashMessageTableViewCell"

@interface IMessageViewController ()<UITableViewDelegate,UITableViewDataSource, MGSwipeTableCellDelegate, UIActionSheetDelegate,TMSwipeCellDelegate>
{
    UIButton * right_btn;
}
@property(nonatomic ,strong)NSMutableArray * ListArray;
@property(nonatomic ,strong)NSString * flag_bitStr;
@property (strong,nonatomic)AFHTTPSessionManager *manager;
@property (weak,nonatomic) MBProgressHUD* HUD;
@property(nonatomic ,assign)NSInteger Page_intager; ///获取页数
@end

@implementation IMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=FGGetStringWithKeyFromTable(@"Inbox", @"Language");
    if (@available(iOS 11.0, *)) {//解决iOS 10 版本scrollView下滑问题。
        
        self.tableViewT.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    if(self.MessageStyle==1)
    {
        self.view.backgroundColor=[UIColor whiteColor];
    }else if(self.MessageStyle==2)
    {
        self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    }
    [self.navigationController.navigationBar setTranslucent:NO];
    self.flag_bitStr=@"0";
    _ListArray = [NSMutableArray arrayWithCapacity:0];
    self.Page_intager=0;///默认从 0 开始
//    [self.Next_btn setTitle:FGGetStringWithKeyFromTable(@"Delete", @"Language") forState:UIControlStateNormal];
//    [self.Select_button setTitle:FGGetStringWithKeyFromTable(@"Select all", @"Language") forState:UIControlStateNormal];
    
//    [self addSetItem];
//    [self setDown_viewHiend];
//    [self labelExample];
//    [self Get_MessageList_arr];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        if(self.view.width==375.000000 && self.view.height>=812.000000)
//        {
//            self.tableViewT.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-84);
//        }else{
//            self.tableViewT.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64);
//        }
        [self addTableView_table];
    });
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.title=@"Cleapro";
//    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
//    [[UINavigationBar appearance] setTranslucent:NO];
//    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessage_Notification)name:kRegisterMessage object:nil];
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessage_List)name:kRegisterMessageList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessage_List1)name:@"ReturnMessage" object:nil];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:@"0" forKey:@"MessageNo"];
    //    [userDefaults setObject:@"0" forKey:@"Message"];
    [self updateMessage];
    [super viewWillDisappear:animated];
}

-(void)updateMessage_Notification
{
        [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:3];
}
-(void)updateMessage_List
{
//    [self Get_MessageList_arr];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSString * Message_flage = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
        if([Message_flage intValue]==1)
        {
            [self Get_MessageList_arr];
            self.flag_bitStr=@"1";
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"0" forKey:@"MessageNo"];
            [userDefaults setObject:@"0" forKey:@"Message"];
            NSString * Message_flage = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
            if([Message_flage intValue]==1)
            {
                [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:3];
            }else
            {
                [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:3];
            }
        
        }else{
            if([self.flag_bitStr doubleValue]==0)
            {
                [self Get_MessageList_arr];
                self.flag_bitStr=@"1";
                
            }
        }
    });
    
}
-(void)updateMessage_List1
{
    [self Get_MessageList_arr];
    self.flag_bitStr=@"1";
}


-(void)updateMessage
{
    NSString * Message_flage = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
    if([Message_flage intValue]==1)
    {
        [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:3];
    }else
    {
        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:3];
    }
}

-(void)addTableView_table
{
    if(self.MessageStyle==1)
    {
    self.tableViewT.frame=CGRectMake(0, kNavBarAndStatusBarHeight+8, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    self.tableViewT.delegate=self;
    self.tableViewT.dataSource=self;
    self.tableViewT.showsVerticalScrollIndicator=NO;
    self.tableViewT.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    //    self.tableViewT.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.Set_tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:self.tableViewT];
    self.tableViewT.tableFooterView = [[UIView alloc]init];
        // 注册某个重用标识 对应的 Cell类型
        [self.tableViewT registerNib:[UINib nibWithNibName:@"ImessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    }else if(self.MessageStyle==2)
    {
        self.tableViewT.frame=CGRectMake(15, kNavBarAndStatusBarHeight+8, SCREEN_WIDTH-(15*2),SCREEN_HEIGHT-(kNavBarAndStatusBarHeight-8-kTabBarHeight));
        self.tableViewT.delegate=self;
        self.tableViewT.dataSource=self;
        self.tableViewT.showsVerticalScrollIndicator=NO;
        self.tableViewT.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
        //    self.tableViewT.separatorStyle=UITableViewCellSeparatorStyleNone;
        //    self.Set_tableView.separatorColor = [UIColor blackColor];
        [self.view addSubview:self.tableViewT];
        self.tableViewT.tableFooterView = [[UIView alloc]init];
        // 注册某个重用标识 对应的 Cell类型
        [self.tableViewT registerNib:[UINib nibWithNibName:@"EwashMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID1];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.tableViewT.mj_header beginRefreshing];
            });
            
    }
    //    [self.tableViewT setEditing:YES animated:NO];
    
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
    self.tableViewT.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.tableViewT.mj_header=header;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData_foot)];
    // 设置文字
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    // 设置回调（一旦进入刷新状态，就调用 target 的 action，也就是调用 self 的 loadNewData 方法）
//    self.tableViewT.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableViewT.mj_footer =footer;
    // 马上进入刷新状态
    
    
}
-(void)loadNewData
{
    if(self.MessageStyle==1)
    {

        [self Get_MessageList_arr];
        //    // 结束刷新状态
        //    [self.tableViewT.mj_header  endRefreshing];
        //    [self.tableViewT reloadData];
    }else if(self.MessageStyle==2)
    {
        [self NewGet_MessageList_arr];
    }
            
        
}
-(void)loadNewData_foot
{
        if(self.MessageStyle==1)
        {
            [self Get_MessageList_arr_foot];
  
        }else if(self.MessageStyle==2)
       {
           [self NewGet_MessageList_arr_foot];
       }
}
-(void)Get_MessageList_arr
{
    if(self.MessageStyle==1)
    {
    self.Page_intager = 0;
    NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@Page=%ld&PageSize=%@",FuWuQiUrl,get_queryMessage,(long)self.Page_intager,@"10"]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@Page=%ld&PageSize=%@",FuWuQiUrl,get_queryMessage,(long)self.Page_intager,@"10"] parameters:nil progress:^(id progress) {
        
//    [NSString stringWithFormat:@"%@%@CustomerID=%@&Page=%ld&PageSize=%@",XJP_China(DIQU_Number),Get_MessageList,YonghuID,(long)self.Page_intager,@"20"] parameters:nil progress:^(id progress) {
    
    } success:^(id responseObject) {
        NSLog(@"成功kkk =%@",responseObject);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        [self->_ListArray removeAllObjects];
        NSArray * dictARR=[responseObject objectForKey:@"resultList"];
        NSLog(@"cout=== %ld",(unsigned long)dictARR.count);
        if(dictARR.count>0)
        {
            
            
            for (int i=0; i<dictARR.count;i++) {
                NSDictionary * dict1 = (NSDictionary *)dictARR[i];
                NSLog(@"dict1 = %@",dict1);
                messageMode * mode = [[messageMode alloc] init];
                mode.sendTime = [dict1 objectForKey:@"sendTime"];
                mode.message = [dict1 objectForKey:@"message"];;
                mode.ID = [dict1 objectForKey:@"id"];;
                mode.messageType = [dict1 objectForKey:@"messageType"];;
                mode.sendTo = [dict1 objectForKey:@"sendTo"];
                mode.pushStatus = [dict1 objectForKey:@"pushStatus"];
                mode.header = [dict1 objectForKey:@"header"];
                mode.memberId = [dict1 objectForKey:@"memberId"];
                mode.createTime = [dict1 objectForKey:@"createTime"];
                mode.deleted = [dict1 objectForKey:@"deleted"];
                mode.status = [dict1 objectForKey:@"status"];
                mode.generatedDateTime = [dict1 objectForKey:@"generatedDateTime"];
                [self->_ListArray addObject:mode];
            }
            
        }
        if(self->_ListArray.count>0)
        {
            if(self.HUD!=nil){
                [self.HUD hideAnimated:YES];
            }
            // 结束刷新状态
            
            [self.tableViewT.mj_header  endRefreshing];
            [self.tableViewT reloadData];
        }else
        {
            if(self.HUD!=nil){
                [self.HUD hideAnimated:YES];
            }
            // 结束刷新状态
            
            [self.tableViewT.mj_header  endRefreshing];
            [self.tableViewT reloadData];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"You have no message", @"Language") andDelay:2.0];
        }
    }  failure:^(NSInteger statusCode, NSError *error) {
        //        [self textExample:@"请求失败!"];
        NSLog(@"error =  %@",error);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        // 结束刷新状态
        [self.tableViewT.mj_header  endRefreshing];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Request timed out!", @"Language") andDelay:2.0];
    }];
    }else if(self.MessageStyle==2)
    {
    
    }
    
}
-(void)Get_MessageList_arr_foot
{
    if(self.MessageStyle==1)
    {
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@Page=%ld&PageSize=%@",FuWuQiUrl,get_queryMessage,(long)self.Page_intager+1,@"10"] parameters:nil progress:^(id progress) {
        
        //    [NSString stringWithFormat:@"%@%@CustomerID=%@&Page=%ld&PageSize=%@",XJP_China(DIQU_Number),Get_MessageList,YonghuID,(long)self.Page_intager,@"20"] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"成功kkk1 =%@",responseObject);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
//        [self->_ListArray removeAllObjects];
        NSArray * dictARR=[responseObject objectForKey:@"resultList"];
        NSLog(@"cout=== %ld",(unsigned long)dictARR.count);
        if(dictARR.count>0)
        {
            self.Page_intager+=1;
            
            for (int i=0; i<dictARR.count;i++) {
                NSDictionary * dict1 = (NSDictionary *)dictARR[i];
                NSLog(@"dict1 = %@",dict1);
                messageMode * mode = [[messageMode alloc] init];
                mode.sendTime = [dict1 objectForKey:@"sendTime"];
                mode.message = [dict1 objectForKey:@"message"];;
                mode.ID = [dict1 objectForKey:@"id"];;
                mode.messageType = [dict1 objectForKey:@"messageType"];;
                mode.sendTo = [dict1 objectForKey:@"sendTo"];
                mode.pushStatus = [dict1 objectForKey:@"pushStatus"];
                mode.header = [dict1 objectForKey:@"header"];
                mode.memberId = [dict1 objectForKey:@"memberId"];
                mode.createTime = [dict1 objectForKey:@"createTime"];
                mode.deleted = [dict1 objectForKey:@"deleted"];
                mode.status = [dict1 objectForKey:@"status"];
                mode.generatedDateTime = [dict1 objectForKey:@"generatedDateTime"];
                [self->_ListArray addObject:mode];
            }
  
        if(self->_ListArray.count>0)
        {
           
            // 结束刷新状态
            
            [self.tableViewT.mj_footer  endRefreshing];
            [self.tableViewT reloadData];
        }else
        {
            // 结束刷新状态
            
            [self.tableViewT.mj_footer  endRefreshing];
            [self.tableViewT reloadData];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No more messages.", @"Language") andDelay:2.0];
        }
            
        }else
        {
            [self.tableViewT.mj_footer  endRefreshing];
            [self.tableViewT reloadData];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No more messages.", @"Language") andDelay:2.0];
        }
    }  failure:^(NSInteger statusCode, NSError *error) {
        //        [self textExample:@"请求失败!"];
        NSLog(@"error =  %@",error);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        // 结束刷新状态
        [self.tableViewT.mj_header  endRefreshing];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Request timed out!", @"Language") andDelay:1.5];
    }];
    }else if(self.MessageStyle==2)
    {
    
    }
    
}

-(void)NewGet_MessageList_arr
{
//    if(self.MessageStyle==1)
//    {
    self.Page_intager = 0;
    NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@?page=%ld&size=%@",E_FuWuQiUrl,E_MessageList,(long)self.Page_intager,@"10"]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?page=%ld&size=%@",E_FuWuQiUrl,E_MessageList,(long)self.Page_intager,@"10"] parameters:nil progress:^(id progress) {
        
//    [NSString stringWithFormat:@"%@%@CustomerID=%@&Page=%ld&PageSize=%@",XJP_China(DIQU_Number),Get_MessageList,YonghuID,(long)self.Page_intager,@"20"] parameters:nil progress:^(id progress) {
    
    } success:^(id responseObject) {
        NSLog(@"get_queryMessage  =%@",responseObject);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        [self->_ListArray removeAllObjects];
        NSDictionary * messageDict=(NSDictionary *)responseObject;
        NSArray * dictARR=[messageDict objectForKey:@"content"];
        NSLog(@"cout=== %ld",(unsigned long)dictARR.count);
        if(dictARR.count>0)
        {
            
            
            for (int i=0; i<dictARR.count;i++) {
                NSDictionary * dict1 = (NSDictionary *)dictARR[i];
                NSLog(@"dict1 = %@",dict1);
                E_NessageMode * mode = [[E_NessageMode alloc] init];
                mode.content = [dict1 objectForKey:@"content"];
                mode.messageId = [dict1 objectForKey:@"messageId"];
                mode.title = [dict1 objectForKey:@"title"];
                [self->_ListArray addObject:mode];
            }
            
        }
        if(self->_ListArray.count>0)
        {
            if(self.HUD!=nil){
                [self.HUD hideAnimated:YES];
            }
            // 结束刷新状态
            
            [self.tableViewT.mj_header  endRefreshing];
            [self.tableViewT.mj_footer  endRefreshing];
            [self.tableViewT reloadData];
        }else
        {
            if(self.HUD!=nil){
                [self.HUD hideAnimated:YES];
            }
            // 结束刷新状态
            
            [self.tableViewT.mj_header  endRefreshing];
            [self.tableViewT.mj_footer  endRefreshing];
            [self.tableViewT reloadData];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"You have no message", @"Language") andDelay:2.0];
        }
    }  failure:^(NSInteger statusCode, NSError *error) {
        //        [self textExample:@"请求失败!"];
        NSLog(@"error =  %@",error);
        
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        
        // 结束刷新状态
        [self.tableViewT.mj_header  endRefreshing];
        [self.tableViewT.mj_footer  endRefreshing];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Request timed out!", @"Language") andDelay:2.0];
        if(statusCode==401)
        {
            [self setDefaults];
        }
    }];
//    }else if(self.MessageStyle==2)
//    {
//
//    }
    
}
-(void)setDefaults
{
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Token"];
        [userDefaults setObject:@"1" forKey:@"memberId"];
        [userDefaults setObject:@"1" forKey:@"mobile"];
        [jiamiStr base64Data_encrypt:@"1"];
//        [userDefaults setObject:@"1" forKey:@"YHToken"];
        [userDefaults setObject:@"1" forKey:@"phoneNumber"];
        [userDefaults setObject:nil forKey:@"SaveUserMode"];
        [userDefaults setObject:@"1" forKey:@"logCamera"];
        [userDefaults setObject:@"1" forKey:@"userId"];
    //    [defaults synchronize];
    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tongzhi_UpdateTabbar" object: nil]];
    
    
}

-(void)NewGet_MessageList_arr_foot
{
    if(self.MessageStyle==1)
    {
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?page=%ld&size=%@",E_FuWuQiUrl,E_MessageList,(long)self.Page_intager,@"10"] parameters:nil progress:^(id progress) {
        
        //    [NSString stringWithFormat:@"%@%@CustomerID=%@&Page=%ld&PageSize=%@",XJP_China(DIQU_Number),Get_MessageList,YonghuID,(long)self.Page_intager,@"20"] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"get_queryMessageFoot =%@",responseObject);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
//        [self->_ListArray removeAllObjects];
        NSDictionary * messageDict=(NSDictionary *)responseObject;
        NSArray * dictARR=[messageDict objectForKey:@"content"];
        NSLog(@"cout=== %ld",(unsigned long)dictARR.count);
        if(dictARR.count>0)
        {
            self.Page_intager+=1;
            
            for (int i=0; i<dictARR.count;i++) {
                NSDictionary * dict1 = (NSDictionary *)dictARR[i];
                NSLog(@"dict1 = %@",dict1);
                E_NessageMode * mode = [[E_NessageMode alloc] init];
                mode.content = [dict1 objectForKey:@"content"];
                mode.messageId = [dict1 objectForKey:@"messageId"];
                mode.title = [dict1 objectForKey:@"title"];
                [self->_ListArray addObject:mode];
            }
  
        if(self->_ListArray.count>0)
        {
           
            // 结束刷新状态
            
            [self.tableViewT.mj_footer  endRefreshing];
            [self.tableViewT reloadData];
        }else
        {
            // 结束刷新状态
            
            [self.tableViewT.mj_footer  endRefreshing];
            [self.tableViewT reloadData];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No more messages.", @"Language") andDelay:2.0];
        }
            
        }else
        {
            [self.tableViewT.mj_footer  endRefreshing];
            [self.tableViewT reloadData];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No more messages.", @"Language") andDelay:2.0];
        }
    }  failure:^(NSInteger statusCode, NSError *error) {
        //        [self textExample:@"请求失败!"];
        NSLog(@"error =  %@",error);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        
        // 结束刷新状态
        [self.tableViewT.mj_header  endRefreshing];
        [self.tableViewT.mj_footer  endRefreshing];
        if(statusCode==401)
        {
            [self setDefaults];
        }
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Request timed out!", @"Language") andDelay:1.5];
    }];
    }else if(self.MessageStyle==2)
    {
    
    }
    
}



-(void)get_read_message:(NSString *)messageID
{
    
}

-(void)Get_Message_delete:(NSString *)MessageID indexPath:(NSIndexPath*)indexPath
{
    if(self.MessageStyle==1)
    {
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    SaveUserIDMode *ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDictionary * dict =
    @{@"memberId":ModeUser.yonghuID,
      @"id":MessageID
      };
    NSLog(@"上传 dict = %@",dict);
    
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manager.requestSerializer setTimeoutInterval:50];
    // 加上这行代码，https ssl 验证。
//    [_manager setSecurityPolicy:[jiamiStr customSecurityPolicy]];
    [_manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    self.manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    NSLog(@"posr URL = %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,post_deleteMessage]);
    [self.manager POST:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,post_deleteMessage] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除消息请求成功: %@",responseObject);
        NSDictionary * dict = (NSDictionary*)responseObject;
        NSString * statusCode = [dict objectForKey:@"statusCode"];
        NSString * errorMessage = [dict objectForKey:@"errorMessage"];
        if(statusCode!=nil && [statusCode intValue]==400)
        {
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
            if(self.HUD!=nil){
                [self.HUD hideAnimated:YES];
            }
        }else
        {
            if(self.HUD!=nil){
                [self.HUD hideAnimated:YES];
            }
            [self->_ListArray removeObjectAtIndex:indexPath.row];
            [self.tableViewT reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Request timed out!", @"Language") andDelay:1.5];
    }];
    }else if(self.MessageStyle==2)
    {
    
    }
}


-(void)addSetItem
{
    right_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    right_btn.frame=CGRectMake(0, 0, 50, 30);
    [right_btn setTitle:FGGetStringWithKeyFromTable(@"Edit", @"Language") forState:UIControlStateNormal];
    [right_btn setTitle:FGGetStringWithKeyFromTable(@"Read", @"Language") forState:UIControlStateSelected];
    right_btn.selected=NO;
    [right_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [right_btn setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
    [right_btn addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [right_btn.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:right_btn];
    //    self.navigationItem.rightBarButtonItem = rightBtn;
}
-(void)setDown_viewHiend
{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.Down_View.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);;
//    } completion:^(BOOL finished) {
//        [self.Down_View setHidden:YES];
//    }];
}
-(void)setDown_viewShow
{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.Down_View.frame=CGRectMake(0, SCREEN_HEIGHT-54, SCREEN_WIDTH, 54);;
//    } completion:^(BOOL finished) {
//        [self.Down_View setHidden:NO];
//    }];
}

-(void)selectLeftAction:(id)sender
{
    if (right_btn.selected==YES) {
        
        //        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:right_btn];
        //        self.navigationItem.rightBarButtonItem = rightBtn;
        //        right_btn.selected=NO;
        //        [self.tableViewT setEditing:NO animated:YES];
        //        [self setDown_viewHiend];
    }else
    {
        
        //        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:right_btn];
        //        self.navigationItem.rightBarButtonItem = rightBtn;
        //        right_btn.selected=YES;
        //        [self.tableViewT setEditing:YES animated:YES];
        //         [self setDown_viewShow];
    }
    
}

#pragma mark -------- Tableview -------
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.MessageStyle==1)
    {
        return 1; /////设置多少个组
    }else if(self.MessageStyle==2)
    {
        return _ListArray.count;; /////设置多少个组
    }
    return 1; /////设置多少个组
}
/////cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.MessageStyle==1)
    {
        return _ListArray.count;
    }else if(self.MessageStyle==2)
    {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.MessageStyle==1)
    {
     
    //    __weak MyMessageViewController *weakSelf = self;
    ImessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell = [[ImessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableID];
        
    }
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor clearColor];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.tag = indexPath.row;
    cell.delegate = self;
    messageMode * mode_message = self.ListArray[indexPath.row];
    
    cell.imageBtn.isRedBall = YES;
    if([mode_message.messageType intValue]==1)
    {
    [cell.imageBtn setImage:[UIImage imageNamed:@"washing"] forState:UIControlStateNormal];
    }else if([mode_message.messageType intValue]==2)
    {
        [cell.imageBtn setImage:[UIImage imageNamed:@"drying"] forState:UIControlStateNormal];
    }else if([mode_message.messageType intValue]==3)
    {
        [cell.imageBtn setImage:[UIImage imageNamed:@"reward"] forState:UIControlStateNormal];
    }
    
    [cell.topLabel setText:mode_message.header];
    [cell.downLabel setText:mode_message.generatedDateTime];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if([mode_message.status intValue]==0)
        {
            cell.imageBtn.badgeValue=1;
        }else if([mode_message.status intValue]==1)
        {
            cell.imageBtn.badgeValue=0;
        }
    });
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    cell.select_btn.layer.cornerRadius=5;
    return cell;
    
     }else if(self.MessageStyle==2)
     {
         //    __weak MyMessageViewController *weakSelf = self;
         EwashMessageTableViewCell* cell1 = [tableView dequeueReusableCellWithIdentifier:tableID1];
         if (cell1 == nil) {
             cell1 = [[EwashMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableID1];
             
         }
         UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
         lbl.frame = CGRectMake(cell1.frame.origin.x + 10, 0, self.view.width-1, 1);
         lbl.backgroundColor =  [UIColor clearColor];
         [cell1.contentView addSubview:lbl];
         //cell选中效果
         cell1.selectionStyle = UITableViewCellSelectionStyleNone;
         cell1.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
         cell1.tag = indexPath.section;
         E_NessageMode * mode  =self.ListArray[indexPath.section];
         cell1.TopTitle.text=[NSString stringWithFormat:@"%@",mode.title];
         cell1.ContentTitle.text=[NSString stringWithFormat:@"%@",mode.content];
         return cell1;
     }
    return nil;
}

-(NSString *)Str_With_JQ:(NSString*)string
{
    NSString *str_y= [string substringWithRange:NSMakeRange(0,4)];//str2 = "is"
    NSString *str_m= [string substringWithRange:NSMakeRange(4,2)];//str2 = "is"
    NSString *str_d= [string substringWithRange:NSMakeRange(6,2)];//str2 = "is"
    //    NSString * str_y = [string substringToIndex:4];
    //    NSString * subString1 = [string substringFromIndex:4];
    //    NSString * str_m = [subString1 substringToIndex:2];
    //    NSString * str_d = [subString1 substringFromIndex:2];
    NSString * date=[NSString stringWithFormat:@"%@/%@/%@",str_d,str_m,str_y];
    return date;
}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(self.MessageStyle==1)
    {
        return 0.f;
    }else if(self.MessageStyle==2)
    {
        return 10.f;
    }
    return 0.f;
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
    
    
    if(self.MessageStyle==1)
    {
        return 80;
    }else if(self.MessageStyle==2)
    {
        return 115;
    }
    return 0;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //    self.tableViewT.editing=NO;
    if(self.MessageStyle==1)
    {
        NSLog(@"row====== %ld",(long)indexPath.row);
    if(self.tableViewT.editing==NO)
    {
//        MessageMode *mode=_ListArray[indexPath.row];
//        [self get_read_message:mode.Message_ID];
//        MessageViewController * vc = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:[NSBundle mainBundle]];
//        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//        vc.mode_message=mode;
//        [self.navigationController pushViewController:vc animated:YES];

    //    MyMessageTableViewCell *cell = [self.tableViewT cellForRowAtIndexPath:indexPath];
    //    cell.select_btn.hidden=YES;
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImessageDetailsViewController *vc=[main instantiateViewControllerWithIdentifier:@"ImessageDetailsViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.mode_Message = self.ListArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    }
    }else if(self.MessageStyle==2)
    {
        NSLog(@"row====== %ld",(long)indexPath.section);
        
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    NSLog(@"选中 = %ld",(long)indexPath.row);
    
}

#pragma mark - 侧滑删除
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //我们让能被3整除的cell顺序不显示勾选框，其他的都显示,当然也可以在model中定义别的属性，根据他的数据来判断哪一行不需要显示勾选框
    //    int i =(int)indexPath.row+1;
    //    if (i%3==0) {
    //        return UITableViewCellEditingStyleNone;
    //    }else{
    //    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleDelete;
    //    }
}

/**
 选中了侧滑按钮
 
 @param swipeCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @param index 选中的是第几个action
 */
- (void)swipeCell:(TMSwipeCell *)swipeCell atIndexPath:(NSIndexPath *)indexPath didSelectedAtIndex:(NSInteger)index
{
    
}

/**
 告知当前位置的cell是否需要侧滑按钮
 
 @param swipeCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @return YES 表示当前cell可以侧滑, NO 不可以
 */
- (BOOL)swipeCell:(TMSwipeCell *)swipeCell canSwipeRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/**
 返回侧滑事件
 
 @param swipeCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @return 数组为空, 则没有侧滑事件
 */
- (nullable NSArray<TMSwipeCellAction *> *)swipeCell:(TMSwipeCell *)swipeCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    TestModel *model = [_datas objectAtIndex:indexPath.row];
//    __weak __typeof(&*self)weakSelf = self;
    //    if ([model.message_id isEqualToString:TMSWIPE_FRIEND]) {
    //
//    messageMode * mode =_ListArray[indexPath.row];
    
        TMSwipeCellAction *action2 = [TMSwipeCellAction rowActionWithStyle:TMSwipeCellActionStyleDefault title:@"Delete" handler:^(TMSwipeCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"Delete");
            //            [weakSelf.datas removeObject:model];
            //            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            messageMode * mode =self.ListArray[indexPath.row];
            [self labelExample];
            [self Get_Message_delete:mode.ID indexPath:indexPath];
            //            [_ListArray removeObjectAtIndex:indexPath.row];
            //            [self.tableViewT reloadData];
        }];
//        action2.confirmTitle = @"Delete";
//        [action2 setImage:[UIImage imageNamed:@"icon_delete"]];
        return @[action2];
    
    
    
    //    }else{
//    return @[];
    //    }
}

#pragma mark – 分割线没有顶格解决方法
-(void)viewDidLayoutSubviews {
    if ([self.tableViewT respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableViewT setSeparatorInset:UIEdgeInsetsZero];
        
        
    }
    if ([self.tableViewT respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableViewT setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


///// 登录HUD提示
- (void)labelExample {
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    self.HUD.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
}



@end
