//
//  StaffViewController.m
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "StaffViewController.h"
#import "StaffHeaderView.h"
#import "StaffTableViewCell.h"
#import "JDDetailsListViewController.h"
#import "JieDanInfoViewController.h"
#import "YYXYInfoViewController.h"
#import "VPKCUIViewExt.h"
#import "EwashMyViewController.h"

#define CellID @"StaffTableViewCell"
@interface StaffViewController ()<UITableViewDelegate,UITableViewDataSource,StaffTableViewCellDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UITapGestureRecognizer *tapSuperGesture22;
}
@property(nonatomic,strong)NSMutableArray *arrayTitle;//数据源
///
@property(nonatomic,strong)UIView *SearchView;
@property(nonatomic,strong)UIButton *SearchButton;
/// Search背景
@property(nonatomic,strong)UIView *ShelterView;
@property(nonatomic,strong)UITextField *SearchBar;
@property(nonatomic,strong)UIButton *CancelButton;

@property(nonatomic ,assign)NSInteger Page_intager; ///获取页数

@property(nonatomic,strong)NSString *UpdateStr;
@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    self.arrayTitle = [NSMutableArray arrayWithCapacity:0];
    self.Page_intager=0;///默认从 0 开始
    if(self.StatusList==1)
    {
        [self addTabbarItem];
        [self addSearchView];
//        [self getKuaiDiOrderList];
        [self addArrayT];
        [self AddSTableViewUI];
        self.title=FGGetStringWithKeyFromTable(@"Order", @"Language");
    }else if (self.StatusList==2)
    {
//        [self getPuTongOrderList];
        [self addTabbarItem];
        self.title=FGGetStringWithKeyFromTable(@"Orders", @"Language");
        [self addArrayT];
        [self AddSTableViewUI];
    }else  if (self.StatusList==3){
        self.title=FGGetStringWithKeyFromTable(@"History", @"Language");
        [self addArrayT];
        [self AddSTableViewUI];
    }else  if (self.StatusList==4)
    {
        self.title=FGGetStringWithKeyFromTable(@"History", @"Language");
        [self addArrayT];
        [self AddSTableViewUI];
    }
    
    self.UpdateStr=@"99";
     UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
            tapGesture.delegate=self;
            tapGesture.cancelsTouchesInView = NO;
            [self.view addGestureRecognizer:tapGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateListAAA:) name:@"UpdateListAAA" object:nil];
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        //    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    if(self.StatusList==1)
        {
            if(![self.UpdateStr isEqualToString:@"99"] || self.UpdateStr ==nil)
           {
               dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.STable.mj_header beginRefreshing];
                self.UpdateStr=@"99";
            });
           }
        }else if (self.StatusList==2)
        {
        }else  if (self.StatusList==3){
            if(![self.UpdateStr isEqualToString:@"99"] || self.UpdateStr ==nil)
            {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self.STable.mj_header beginRefreshing];
                    self.UpdateStr=@"99";
                });
            }
        }else if (self.StatusList==4)
        {
        }
    
    
    [super viewWillAppear:animated];
}
-(void)UpdateListAAA:(NSNotification *)noti {
    NSDictionary *dic = [noti userInfo];
    NSString * tagStr = [dic objectForKey:@"tag"];
    if(tagStr != nil)
    {
        self.UpdateStr=tagStr;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
-(void)addTabbarItem
{
    
    if(self.StatusList==1)
        {
            //两个按钮的父类view
            UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            //历史浏览按钮
            UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [rightButtonView addSubview:historyBtn];
          [historyBtn setImage:[UIImage imageNamed:@"icon_yonghu"] forState:UIControlStateNormal];
          [historyBtn addTarget:self action:@selector(historyBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];

               self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
        }else if (self.StatusList==2)
        {
//            [historyBtn setImage:[UIImage imageNamed:@"icon_yonghu"] forState:UIControlStateNormal];
            //两个按钮的父类view
            UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            //历史浏览按钮
            UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [rightButtonView addSubview:historyBtn];
            [historyBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
            [historyBtn setTitle:@"History" forState:(UIControlStateNormal)];
            [historyBtn addTarget:self action:@selector(historyBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];

               self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
        }
    
    #pragma mark >>>>>主页搜索按钮
//    //主页搜索按钮
//
//    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 50, 50)];
//
//    [rightButtonView addSubview:mainAndSearchBtn];
//
//    [mainAndSearchBtn setImage:[UIImage imageNamed:@"message_bear"] forState:UIControlStateNormal];
//    [mainAndSearchBtn addTarget:self action:@selector(mainAndSearchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    //把右侧的两个按钮添加到rightBarButtonItem

   

}
-(void)historyBtnEvent:(id)sender
{
    NSLog(@"11111111");
    if(self.StatusList==1)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            StaffViewController *vc=[main instantiateViewControllerWithIdentifier:@"StaffViewController"];
        //    vc.hidesBottomBarWhenPushed = YES;
            vc.StatusList=3;
            [self.navigationController pushViewController:vc animated:YES];
    }else if (self.StatusList==2)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            StaffViewController *vc=[main instantiateViewControllerWithIdentifier:@"StaffViewController"];
        //    vc.hidesBottomBarWhenPushed = YES;
            vc.StatusList=4;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)mainAndSearchBtnEvent:(id)sender
{
    NSLog(@"22222222");
}


-(void)getPuTongOrderList
{
//    unfinished   finished
    [HudViewFZ labelExample:self.view];
    self.Page_intager=0;
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@unfinished?page=%ld&size=%@",E_FuWuQiUrl,E_GetOrderList,(long)self.Page_intager,@"20"] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_GetOrderList = %@",responseObject);
                [HudViewFZ HiddenHud];
//                NSArray * dictArr= (NSArray*)responseObject;
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
                if(dictArr.count>0)
                {
                    [self.arrayTitle removeAllObjects];
                
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];
                        
                        
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                    }
                if(self.arrayTitle.count>0)
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                }else
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                }
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_header  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}
-(void)getPuTongOrderList_foot
{
//    unfinished   finished
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@unfinished?page=%ld&size=%@",E_FuWuQiUrl,E_GetOrderList,(long)self.Page_intager+1,@"20"] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_GetOrderList = %@",responseObject);
                [HudViewFZ HiddenHud];
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
//                NSArray * dictArr= (NSArray*)responseObject;
                if(dictArr.count>0)
                {
//                    [self.arrayTitle removeAllObjects];
                    self.Page_intager+=1;
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];;
                        
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                   if(self.arrayTitle.count>0)
                            {
                               
                                // 结束刷新状态
                                
                                [self.STable.mj_footer  endRefreshing];
                                [self.STable reloadData];
                            }else
                            {
                                // 结束刷新状态
                                
                                [self.STable.mj_footer  endRefreshing];
                                [self.STable reloadData];
                                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No more messages.", @"Language") andDelay:2.0];
                            }
                        }else
                        {
                            [self.STable.mj_footer  endRefreshing];
                            [self.STable reloadData];
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                        }
                
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_footer  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}
-(void)getPuTongHistoryList
{
//    unfinished   finished
    [HudViewFZ labelExample:self.view];
    self.Page_intager=0;
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@finished?page=%ld&size=%@",E_FuWuQiUrl,E_GetOrderList,(long)self.Page_intager,@"20"] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_GetOrderList = %@",responseObject);
                [HudViewFZ HiddenHud];
//                NSArray * dictArr= (NSArray*)responseObject;
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
                if(dictArr.count>0)
                {
                    [self.arrayTitle removeAllObjects];
                
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];
                        
                        
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                    }
                if(self.arrayTitle.count>0)
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                }else
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                }
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_header  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}
-(void)getPuTongHistoryList_foot
{
//    unfinished   finished
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@finished?page=%ld&size=%@",E_FuWuQiUrl,E_GetOrderList,(long)self.Page_intager+1,@"20"] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_GetOrderList = %@",responseObject);
                [HudViewFZ HiddenHud];
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
//                NSArray * dictArr= (NSArray*)responseObject;
                if(dictArr.count>0)
                {
//                    [self.arrayTitle removeAllObjects];
                    self.Page_intager+=1;
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];;
                        
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                   if(self.arrayTitle.count>0)
                            {
                               
                                // 结束刷新状态
                                
                                [self.STable.mj_footer  endRefreshing];
                                [self.STable reloadData];
                            }else
                            {
                                // 结束刷新状态
                                
                                [self.STable.mj_footer  endRefreshing];
                                [self.STable reloadData];
                                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No more messages.", @"Language") andDelay:2.0];
                            }
                        }else
                        {
                            [self.STable.mj_footer  endRefreshing];
                            [self.STable reloadData];
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                        }
                
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_footer  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}

-(void)getKuaiDiOrderList
{
//    unfinished   finished
    [HudViewFZ labelExample:self.view];
    self.Page_intager=0;
//    [NSString stringWithFormat:@"%@%@?page=%ld&size=%@",E_FuWuQiUrl,E_articlesE_wash,(long)self.Page_intager,@"20"]
    NSLog(@"KD URL = %@",[NSString stringWithFormat:@"%@%@?eWashStatus=%@&page=%ld&size=%@",E_FuWuQiUrl,E_articlesE_wash,@"finished",(long)self.Page_intager,@"20"]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@?eWashStatus=%@&page=%ld&size=%@",E_FuWuQiUrl,E_articlesE_wash,@"unfinished",(long)self.Page_intager,@"20"] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_articlesE_wash = %@",responseObject);
                
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
                if(dictArr.count>0)
                {
                    [self.arrayTitle removeAllObjects];
                
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];;
                        mode.cleaningTime=[dictM objectForKey:@"cleaningTime"];
                        mode.cleaningUserId=[dictM objectForKey:@"cleaningUserId"];
                        mode.cleaningUserName=[dictM objectForKey:@"cleaningUserName"];
                        mode.courierCollectTime=[dictM objectForKey:@"courierCollectTime"];
                        mode.courierCollectUserId=[dictM objectForKey:@"courierCollectUserId"];
                        mode.courierCollectUserName=[dictM objectForKey:@"courierCollectUserName"];
                        mode.finishTime=[dictM objectForKey:@"finishTime"];
                        mode.finishUserId=[dictM objectForKey:@"finishUserId"];
                        mode.finishUserName=[dictM objectForKey:@"finishUserName"];
                        mode.inDeliveryTime=[dictM objectForKey:@"inDeliveryTime"];
                        mode.inDeliveryUserId=[dictM objectForKey:@"inDeliveryUserId"];
                        mode.inDeliveryUserName=[dictM objectForKey:@"inDeliveryUserName"];
                        mode.packedTime=[dictM objectForKey:@"packedTime"];
                        mode.packedUserId=[dictM objectForKey:@"packedUserId"];
                        mode.packedUserName=[dictM objectForKey:@"packedUserName"];
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                    }
                if(self.arrayTitle.count>0)
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                }else
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                }
                
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_header  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}
-(void)getKuaiDiOrderList_foot
{
//page=0&size=10
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@?eWashStatus=%@&page=%ld&size=%@",E_FuWuQiUrl,E_articlesE_wash,@"unfinished",(long)self.Page_intager+1,@"20"] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_articlesE_wash = %@",responseObject);
                [HudViewFZ HiddenHud];
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
                if(dictArr.count>0)
                {
                    
//                    [self.arrayTitle removeAllObjects];
                self.Page_intager+=1;
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];
                        mode.cleaningTime=[dictM objectForKey:@"cleaningTime"];
                        mode.cleaningUserId=[dictM objectForKey:@"cleaningUserId"];
                        mode.cleaningUserName=[dictM objectForKey:@"cleaningUserName"];
                        mode.courierCollectTime=[dictM objectForKey:@"courierCollectTime"];
                        mode.courierCollectUserId=[dictM objectForKey:@"courierCollectUserId"];
                        mode.courierCollectUserName=[dictM objectForKey:@"courierCollectUserName"];
                        mode.finishTime=[dictM objectForKey:@"finishTime"];
                        mode.finishUserId=[dictM objectForKey:@"finishUserId"];
                        mode.finishUserName=[dictM objectForKey:@"finishUserName"];
                        mode.inDeliveryTime=[dictM objectForKey:@"inDeliveryTime"];
                        mode.inDeliveryUserId=[dictM objectForKey:@"inDeliveryUserId"];
                        mode.inDeliveryUserName=[dictM objectForKey:@"inDeliveryUserName"];
                        mode.packedTime=[dictM objectForKey:@"packedTime"];
                        mode.packedUserId=[dictM objectForKey:@"packedUserId"];
                        mode.packedUserName=[dictM objectForKey:@"packedUserName"];
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                    if(self.arrayTitle.count>0)
                    {
                       
                        // 结束刷新状态
                        
                        [self.STable.mj_footer  endRefreshing];
                        [self.STable reloadData];
                    }else
                    {
                        // 结束刷新状态
                        
                        [self.STable.mj_footer  endRefreshing];
                        [self.STable reloadData];
                        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No more messages.", @"Language") andDelay:2.0];
                    }
                }else
                {
                    [self.STable.mj_footer  endRefreshing];
                    [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                }
                
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_footer  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
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
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tongzhi_UpdateTabbar" object: nil]];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[EwashMyViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
}
-(void)addArrayT
{
//    [self.arrayTitle addObject:@"0"];
//    [self.arrayTitle addObject:@"1"];
//    [self.arrayTitle addObject:@"2"];
//    [self.arrayTitle addObject:@"3"];
//    [self.arrayTitle addObject:@"4"];
}
-(void)addSearchView
{
    self.SearchView=[[UIView alloc] initWithFrame:CGRectMake(15, kNavBarAndStatusBarHeight+8, SCREEN_WIDTH-(15*2), 35)];
    self.SearchView.alpha = 0.8;
    self.SearchView.layer.borderColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0].CGColor;
    self.SearchView.layer.borderWidth = 1;
    self.SearchView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GestureTouch:)];
    [self.SearchView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.SearchView];
    self.SearchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.SearchView.width-35, 0, 35, 35)];
    [self.SearchButton setImage:[UIImage imageNamed:@"icon_chazhao"] forState:UIControlStateNormal];
    [self.SearchButton addTarget:self action:@selector(SearchTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.SearchView addSubview:self.SearchButton];
}
-(void)GestureTouch:(UITapGestureRecognizer *)gesture
{
    [self addShelterView];
}
-(void)SearchTouch:(id)sender
{
    [self addShelterView];
}

-(void)addShelterView
{
    self.ShelterView=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(kNavBarAndStatusBarHeight))];
        [self.ShelterView setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.3]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [self.ShelterView addGestureRecognizer:tapSuperGesture22];
    [self.view addSubview:self.ShelterView];
    self.SearchBar=[[UITextField alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-15*2-55-8, 35)];
    [self.ShelterView addSubview:self.SearchBar];
    self.SearchBar.returnKeyType = UIReturnKeySearch;//Search按钮
    self.SearchBar.delegate = self;
    //设置文本颜色
    self.SearchBar.textColor = [UIColor redColor];
    //设置文本对齐方式
    self.SearchBar.textAlignment = NSTextAlignmentLeft;
    //设置字体
    self.SearchBar.font = [UIFont systemFontOfSize:16.0];
    self.SearchBar.borderStyle = UITextBorderStyleLine;
    self.SearchBar.backgroundColor=[UIColor whiteColor];
    self.SearchBar.layer.borderColor= [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0].CGColor;
    self.SearchBar.layer.borderWidth= 1.0f;
    [self.SearchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.CancelButton=[[UIButton alloc] initWithFrame:CGRectMake(self.SearchBar.right+8, self.SearchBar.top, 55, 35)];
    [self.CancelButton setTintColor:[UIColor whiteColor]];
    [self.CancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.CancelButton setTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language") forState:(UIControlStateNormal)];
    [self.CancelButton addTarget:self action:@selector(CancelTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.ShelterView addSubview:self.CancelButton];
    [self show_TCview];
}
-(void)show_TCview
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
//        self.ShelterView.frame=self.view.bounds;
        self.ShelterView.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    }];
    self.SearchView.hidden=YES;
}
-(void)hidden_TCview
{
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self.ShelterView.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        [self.ShelterView removeFromSuperview];
    }];
    self.SearchView.hidden=NO;
}
- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    [self hidden_TCview];
}
-(void)CancelTouch:(id)sender
{
    [self hidden_TCview];
}

-(void)AddSTableViewUI
{
//    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    NSLog(@"height = %f",(self.SearchView.bottom+8+kNavBarAndStatusBarHeight));
    if(self.StatusList==1)
        {
            _STable.frame=CGRectMake(0, self.SearchView.bottom+8, SCREEN_WIDTH,SCREEN_HEIGHT-(self.SearchView.bottom+8+kNavBarAndStatusBarHeight));
        }else if (self.StatusList==2)
        {
            _STable.frame=CGRectMake(0, self.SearchView.bottom+8, SCREEN_WIDTH,SCREEN_HEIGHT-(self.SearchView.bottom+8));
        }else  if (self.StatusList==3){
            _STable.frame=CGRectMake(0, self.SearchView.bottom+8, SCREEN_WIDTH,SCREEN_HEIGHT-(self.SearchView.bottom+8));
        }else  if (self.StatusList==4){
            _STable.frame=CGRectMake(0, self.SearchView.bottom+8, SCREEN_WIDTH,SCREEN_HEIGHT-(self.SearchView.bottom+8));
        }
    _STable.delegate=self;
    _STable.dataSource=self;
    _STable.showsVerticalScrollIndicator=NO;
    _STable.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    //UITableViewCell 左分割线顶格
    self.STable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.STable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_STable registerNib:[UINib nibWithNibName:@"StaffTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
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
        self.STable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
        }];
        self.STable.mj_header=header;
    // 设置回调（一旦进入刷新状态，就调用 target 的 action，也就是调用 self 的 loadNewData 方法）
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData_foot)];
        // 设置文字
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStatePulling];
        [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    self.STable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
        self.STable.mj_footer =footer;
        // 马上进入刷新状态
            [self.STable.mj_header beginRefreshing];
        
    }
-(void)loadNewData
{
        if(self.StatusList==1)
        {
            
            [self getKuaiDiOrderList];
        }else if (self.StatusList==2)
        {
            [self getPuTongOrderList];
        }else if (self.StatusList==3)
        {
            [self getOnleMeOrder];
        }else  if (self.StatusList==4)
        {
            [self getPuTongHistoryList];
        }
    
        
}
-(void)loadNewData_foot
{
          if(self.StatusList==1)
          {
              
              [self getKuaiDiOrderList_foot];
          }else if (self.StatusList==2)
          {
              [self getPuTongOrderList_foot];
          }else if (self.StatusList==3)
          {
              [self getOnleMeOrder_foot];
          }else  if (self.StatusList==4)
          {
              [self getPuTongHistoryList_foot];
          }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayTitle.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StaffTableViewCell * cell = (StaffTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell= (StaffTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"StaffTableViewCell" owner:self options:nil]  lastObject];
    }
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = self.arrayTitle[indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//显示最右边的箭头
    cell.tag=indexPath.row;
    if(self.StatusList==1)
    {
        cell.StausLabel.userInteractionEnabled=YES;
    }else if (self.StatusList==2)
    {
        cell.StausLabel.userInteractionEnabled=NO;
    }else if (self.StatusList==3)
    {
       cell.StausLabel.userInteractionEnabled=YES;
    }else  if (self.StatusList==4)
    {
        cell.StausLabel.userInteractionEnabled=NO;
    }
    
    
//    [];
    cell.tag=indexPath.row;
    OrderListMode*mode=self.arrayTitle[indexPath.row];
    cell.NoLabel.text=mode.orderNumber;
    if(![mode.logisticsType isEqual:[NSNull null]])
    {
       

    if([mode.logisticsType isEqualToString:@"DOORSTEP_DELIVERY"])
    {
        cell.PickLabel.text=@"R";
    }else if([mode.logisticsType isEqualToString:@"SELF_PICKUP"])
    {
        cell.PickLabel.text=@"S";
    }
        
    }
    if(![mode.status isEqual:[NSNull null]])
    {
       

    if([mode.status isEqualToString:@"Created"])
    {
        [cell.StausLabel setImage:[UIImage imageNamed:@"icon_zt01"] forState:(UIControlStateNormal)];
    }else if([mode.status isEqualToString:@"Courier collect"])
    {
        [cell.StausLabel setImage:[UIImage imageNamed:@"icon_zt02"] forState:(UIControlStateNormal)];
    }else if([mode.status isEqualToString:@"Cleaning"])
    {
        [cell.StausLabel setImage:[UIImage imageNamed:@"icon_zt03"] forState:(UIControlStateNormal)];
    }else if([mode.status isEqualToString:@"Packed"])
    {
        [cell.StausLabel setImage:[UIImage imageNamed:@"icon_zt04"] forState:(UIControlStateNormal)];
    }else if([mode.status isEqualToString:@"In delivery"])
    {
        [cell.StausLabel setImage:[UIImage imageNamed:@"icon_zt05"] forState:(UIControlStateNormal)];
    }else if([mode.status isEqualToString:@"Customer collected"])
        {
            [cell.StausLabel setImage:[UIImage imageNamed:@"icon_zt10"] forState:(UIControlStateNormal)];
        }
        
    }
    
    
    
    cell.delegate=self;

    
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       
    return 50;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
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
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"StaffHeaderView" owner:nil options:nil];
    StaffHeaderView *bookView = views.firstObject;
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(0, bookView.height-1, self.view.width, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [bookView addSubview:lbl];
    return bookView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    YYXYInfoViewController *vc=[main instantiateViewControllerWithIdentifier:@"YYXYInfoViewController"];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.ModeZ=self.arrayTitle[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}



-(void)StatusTouch:(UITableViewCell *)Cell
{
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JDDetailsListViewController *vc=[main instantiateViewControllerWithIdentifier:@"JDDetailsListViewController"];
    OrderListMode*mode=self.arrayTitle[Cell.tag];
    vc.mode=mode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)DetailTouch:(UITableViewCell *)Cell
{
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YYXYInfoViewController *vc=[main instantiateViewControllerWithIdentifier:@"YYXYInfoViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.ModeZ=self.arrayTitle[Cell.tag];
    [self.navigationController pushViewController:vc animated:YES];
}







#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.SearchBar) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.03/*延迟执行时间*/ * NSEC_PER_SEC));
//
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//
//                [self searchOrder:textField.text];
//            });
            // 一次取消所有的延迟执行
//            [NSObject cancelPreviousPerformRequestsWithTarget:self];
//            NSString *subString = textField.text;
//            subString = [subString stringByReplacingCharactersInRange:range withString:string];
//
//            // 如果1秒内没有没和变化进行延时操作
//            [self performSelector:@selector(searchOrder:) withObject:subString afterDelay:1.5f];
            return YES;
        }else if (self.SearchBar.text.length >= 200) {
            self.SearchBar.text = [[textField.text stringByAppendingString:string] substringToIndex:(self.SearchBar.text.length+1)];
            //            NSLog(@"self.phone_textfiled.text =  %@",self.phone_textfiled.text );
            
                
//            [self searchOrder:textField.text];
//            [NSObject cancelPreviousPerformRequestsWithTarget:self];
//            NSString *subString = textField.text;
//            subString = [subString stringByReplacingCharactersInRange:range withString:string];
//
//            // 如果1秒内没有没和变化进行延时操作
//            [self performSelector:@selector(searchOrder:) withObject:subString afterDelay:1.5f];
            return NO;
        }else
        {
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
//
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//
//            });
//            [self searchOrder:textField.text];
            
        }
        
    }
    return YES;
}



- (void)textFieldDidChange:(UITextField *)textField
{
    UITextRange * selectedRange = textField.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
      //这里取到textfielf.text最后的值 进行检索
      NSLog(@"selectedRange textField.text [%@]", textField.text);
       NSString *text = textField.text;
       if ([@"" isEqualToString:text]) {
    // text is empty
       }else {// do search or other
           [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    NSString *subString = text;
          //          subString = [subString stringByReplacingCharactersInRange:range withString:text];
                    // 如果1秒内没有没和变化进行延时操作
           [self performSelector:@selector(searchOrder:) withObject:subString afterDelay:0.3f];}
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.SearchBar)
    {
        [self.SearchBar becomeFirstResponder];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        NSString *subString = textField.text;
                 //          subString = [subString stringByReplacingCharactersInRange:range withString:text];
                           // 如果1秒内没有没和变化进行延时操作
        [self performSelector:@selector(searchOrder:) withObject:subString afterDelay:1.0f];

    }
    return YES;
}


-(void)searchOrder:(NSString * ) searchStr
{
//    unfinished   finished
    [HudViewFZ labelExample:self.view];
    self.Page_intager=0;
    NSLog(@"url == %@", [NSString stringWithFormat:@"%@%@?eWashQuery=%@",E_FuWuQiUrl,E_articlesE_wash,searchStr]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@?eWashQuery=%@",E_FuWuQiUrl,E_articlesE_wash,searchStr] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_articlesE_wash = %@",responseObject);
                
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
                if(dictArr.count>0)
                {
                    [self.arrayTitle removeAllObjects];
                
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];;
                        mode.cleaningTime=[dictM objectForKey:@"cleaningTime"];
                        mode.cleaningUserId=[dictM objectForKey:@"cleaningUserId"];
                        mode.cleaningUserName=[dictM objectForKey:@"cleaningUserName"];
                        mode.courierCollectTime=[dictM objectForKey:@"courierCollectTime"];
                        mode.courierCollectUserId=[dictM objectForKey:@"courierCollectUserId"];
                        mode.courierCollectUserName=[dictM objectForKey:@"courierCollectUserName"];
                        mode.finishTime=[dictM objectForKey:@"finishTime"];
                        mode.finishUserId=[dictM objectForKey:@"finishUserId"];
                        mode.finishUserName=[dictM objectForKey:@"finishUserName"];
                        mode.inDeliveryTime=[dictM objectForKey:@"inDeliveryTime"];
                        mode.inDeliveryUserId=[dictM objectForKey:@"inDeliveryUserId"];
                        mode.inDeliveryUserName=[dictM objectForKey:@"inDeliveryUserName"];
                        mode.packedTime=[dictM objectForKey:@"packedTime"];
                        mode.packedUserId=[dictM objectForKey:@"packedUserId"];
                        mode.packedUserName=[dictM objectForKey:@"packedUserName"];
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                    }
                if(self.arrayTitle.count>0)
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                }else
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                }
                
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_header  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}


-(void)getOnleMeOrder
{
//    unfinished   finished
    [HudViewFZ labelExample:self.view];
    self.Page_intager=0;
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@?onlyMe=%d&page=%ld&size=%@",E_FuWuQiUrl,E_articlesE_wash,YES,(long)self.Page_intager,@"20"] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_articlesE_wash = %@",responseObject);
                
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
                if(dictArr.count>0)
                {
                    [self.arrayTitle removeAllObjects];
                
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];;
                        mode.cleaningTime=[dictM objectForKey:@"cleaningTime"];
                        mode.cleaningUserId=[dictM objectForKey:@"cleaningUserId"];
                        mode.cleaningUserName=[dictM objectForKey:@"cleaningUserName"];
                        mode.courierCollectTime=[dictM objectForKey:@"courierCollectTime"];
                        mode.courierCollectUserId=[dictM objectForKey:@"courierCollectUserId"];
                        mode.courierCollectUserName=[dictM objectForKey:@"courierCollectUserName"];
                        mode.finishTime=[dictM objectForKey:@"finishTime"];
                        mode.finishUserId=[dictM objectForKey:@"finishUserId"];
                        mode.finishUserName=[dictM objectForKey:@"finishUserName"];
                        mode.inDeliveryTime=[dictM objectForKey:@"inDeliveryTime"];
                        mode.inDeliveryUserId=[dictM objectForKey:@"inDeliveryUserId"];
                        mode.inDeliveryUserName=[dictM objectForKey:@"inDeliveryUserName"];
                        mode.packedTime=[dictM objectForKey:@"packedTime"];
                        mode.packedUserId=[dictM objectForKey:@"packedUserId"];
                        mode.packedUserName=[dictM objectForKey:@"packedUserName"];
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                    }
                if(self.arrayTitle.count>0)
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                }else
                {
                    [HudViewFZ HiddenHud];
                    // 结束刷新状态
                    
                    [self.STable.mj_header  endRefreshing];
                    [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                }
                
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_header  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}

-(void)getOnleMeOrder_foot
{
//page=0&size=10
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URLString:[NSString stringWithFormat:@"%@%@?onlyMe=%d&page=%ld&size=%@",E_FuWuQiUrl,E_articlesE_wash,YES,(long)self.Page_intager+1,@"20"] parameters:nil progress:^(id progress) {
                //        NSLog(@"请求成功 = %@",progress);
            } success:^(id responseObject) {
                NSLog(@"E_articlesE_wash = %@",responseObject);
                [HudViewFZ HiddenHud];
                NSDictionary * Dict = (NSDictionary *)responseObject;
                NSArray * dictArr= [Dict objectForKey:@"content"];;
                if(dictArr.count>0)
                {
                    
//                    [self.arrayTitle removeAllObjects];
                self.Page_intager+=1;
                    for (int i=0; i<dictArr.count; i++) {
                        NSDictionary * dictM= dictArr[i];
                        OrderListMode* mode=[[OrderListMode alloc] init];
                        mode.articleId=[dictM objectForKey:@"articleId"];
                        mode.cleaningTime=[dictM objectForKey:@"cleaningTime"];
                        mode.cleaningUserId=[dictM objectForKey:@"cleaningUserId"];
                        mode.cleaningUserName=[dictM objectForKey:@"cleaningUserName"];
                        mode.courierCollectTime=[dictM objectForKey:@"courierCollectTime"];
                        mode.courierCollectUserId=[dictM objectForKey:@"courierCollectUserId"];
                        mode.courierCollectUserName=[dictM objectForKey:@"courierCollectUserName"];
                        mode.finishTime=[dictM objectForKey:@"finishTime"];
                        mode.finishUserId=[dictM objectForKey:@"finishUserId"];
                        mode.finishUserName=[dictM objectForKey:@"finishUserName"];
                        mode.inDeliveryTime=[dictM objectForKey:@"inDeliveryTime"];
                        mode.inDeliveryUserId=[dictM objectForKey:@"inDeliveryUserId"];
                        mode.inDeliveryUserName=[dictM objectForKey:@"inDeliveryUserName"];
                        mode.packedTime=[dictM objectForKey:@"packedTime"];
                        mode.packedUserId=[dictM objectForKey:@"packedUserId"];
                        mode.packedUserName=[dictM objectForKey:@"packedUserName"];
                        mode.lastUpdatedStaffName=[dictM objectForKey:@"lastUpdatedStaffName"];
                        
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"] ;
                        mode.lastUpdatedTime=[dictM objectForKey:@"lastUpdatedTime"];
                        mode.creationTime=[dictM objectForKey:@"creationTime"];
                        mode.itemsName=[dictM objectForKey:@"itemsName"];
                        mode.iconFileId=[dictM objectForKey:@"iconFileId"];
                        mode.logisticsType=[dictM objectForKey:@"logisticsType"];
                        mode.paidCharge=[dictM objectForKey:@"paidCharge"];
                        mode.fileId=[dictM objectForKey:@"fileId"];;
                        mode.paymentMethod=[dictM objectForKey:@"paymentMethod"];;
                        mode.paymentPlatform=[dictM objectForKey:@"paymentPlatform"];
                        NSMutableArray * arrMU=[[NSMutableArray alloc] init];
                        NSArray * ordersItemsArr= [dictM objectForKey:@"ordersItems"];
                        for (int m=0; m<ordersItemsArr.count; m++) {
                            NSDictionary *dictPR=ordersItemsArr[m];
                            OrderSItemsMode * modeO=[[OrderSItemsMode alloc] init];
                            modeO.priceValue=[dictPR objectForKey:@"priceValue"];
                            modeO.productVariantId=[dictPR objectForKey:@"productVariantId"];
                            modeO.productVariantName=[dictPR objectForKey:@"productVariantName"];
                            modeO.quantity=[dictPR objectForKey:@"quantity"];
                            [arrMU addObject:modeO];
                        }
                        mode.ordersItems=arrMU;
                        mode.recipientAddress=[dictM objectForKey:@"recipientAddress"];
                        mode.recipientMail=[dictM objectForKey:@"recipientMail"];
                        mode.recipientName=[dictM objectForKey:@"recipientName"];
                        mode.recipientPhoneNumber=[dictM objectForKey:@"recipientPhoneNumber"];
                        mode.orderNumber=[dictM objectForKey:@"orderNumber"];
                        mode.overdueTime=[dictM objectForKey:@"overdueTime"];
                        mode.qrcodeUnitType=[dictM objectForKey:@"qrcodeUnitType"];
                        mode.serverFunctionType=[dictM objectForKey:@"serverFunctionType"];
                        mode.serviceName=[dictM objectForKey:@"serviceName"];
                        mode.status=[dictM objectForKey:@"status"];
                        mode.trakingNumber=[dictM objectForKey:@"trakingNumber"];
                        
                        mode.siteId=[dictM objectForKey:@"siteId"];
                        mode.siteName=[dictM objectForKey:@"siteName"];
                        mode.siteNameEn=[dictM objectForKey:@"siteNameEn"];
                        mode.siteType=[dictM objectForKey:@"siteType"];
                        [self.arrayTitle addObject:mode];
                    }
                    [self.STable reloadData];
                    if(self.arrayTitle.count>0)
                    {
                       
                        // 结束刷新状态
                        
                        [self.STable.mj_footer  endRefreshing];
                        [self.STable reloadData];
                    }else
                    {
                        // 结束刷新状态
                        
                        [self.STable.mj_footer  endRefreshing];
                        [self.STable reloadData];
                        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No more messages.", @"Language") andDelay:2.0];
                    }
                }else
                {
                    [self.STable.mj_footer  endRefreshing];
                    [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No order at present", @"Language") andDelay:2.0];
                }
                
                
            } failure:^(NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                [HudViewFZ HiddenHud];
                [self.STable.mj_footer  endRefreshing];
                [self.STable reloadData];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}
@end
