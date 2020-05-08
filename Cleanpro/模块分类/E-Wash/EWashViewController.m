//
//  EWashViewController.m
//  Cleanpro
//
//  Created by mac on 2020/3/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "EWashViewController.h"
#import "BagTableViewCell.h"
#import "DeliveryTableViewCell.h"
#import "EWashNextViewController.h"
#import "AddressSViewController.h"
#import "LaundrySelectTableViewCell.h"
#import "CellBagTableViewCell.h"
#import "CelladdTableViewCell.h"
#import "LocationManager.h"
#import "NewHomeViewController.h"
#import "EwashMyViewController.h"

#define tableID1 @"BagTableViewCell"
#define tableID2 @"DeliveryTableViewCell"
#define tableID3 @"CellBagTableViewCell"
#define tableID4 @"CelladdTableViewCell"
//#define tableID3 @"LaundrySelectTableViewCell"

static int iCount=0;
@interface EWashViewController ()<UITableViewDelegate,UITableViewDataSource,BagTableViewCellDelegate,CellBagTableViewCellDelegate,LocationManagerDelegate>
{
    
}
@property (nonatomic,strong)UIImageView* TopImage;
@property (nonatomic,strong)UITableView* DownTable;
@property (nonatomic,strong)NSMutableArray* ArrayTable;
@property (nonatomic,strong)NSMutableArray* BZDArray; /// 编织袋选择
@property (nonatomic,strong)UIButton* NextButton;
@property (assign, nonatomic) NSInteger CountInt1;///数量计数器
@property (assign, nonatomic) NSInteger CountInt2;///数量计数器
@property (assign, nonatomic) NSInteger SelectWay;///1.是 上门取  2.是store

@property (nonatomic,strong)NSMutableArray* PoubdArr; /// 编织袋选择大小参数选择

@property (nonatomic,strong)NSMutableArray* CommodityArr; ///已选择的购物商品数组

@property (nonatomic,strong)NSString* doorstepCostStr; /// 上门快递费
@property (nonatomic,strong)NSString* selfPickupCostStr; /// 到商店服务费

@property(nonatomic,strong)NSMutableArray *GetaddressArray;//address数据源
@property(nonatomic,strong)LocationManager * manager;;
@end

@implementation EWashViewController
@synthesize DownTable,ArrayTable,manager;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.CountInt1=2;
    self.CountInt2=2;
    self.SelectWay=1;//// 默认为上门取。
    self.title=FGGetStringWithKeyFromTable(@"E-Wash", @"Language");
    _TopImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, 170)];
    [_TopImage setImage:[UIImage imageNamed:@"banner-EWASH"]];
    [self.view addSubview:_TopImage];
    self.doorstepCostStr=@"0";
    self.selfPickupCostStr=@"0";
    self.ArrayTable=[NSMutableArray arrayWithCapacity:0];
    self.BZDArray=[NSMutableArray arrayWithCapacity:0];
    self.PoubdArr=[NSMutableArray arrayWithCapacity:0];
    self.CommodityArr=[NSMutableArray arrayWithCapacity:0];
    self.GetaddressArray=[NSMutableArray arrayWithCapacity:0];
    

    [self.BZDArray addObject:FGGetStringWithKeyFromTable(@"Bag type", @"Language")];
//    [self.BZDArray addObject:@"1"];
//    [self.BZDArray addObject:@"0"];
    [ArrayTable addObject:self.BZDArray];
    [ArrayTable addObject:@[FGGetStringWithKeyFromTable(@"Delivery", @"Language"),FGGetStringWithKeyFromTable(@"Residence", @"Language"),FGGetStringWithKeyFromTable(@"Store", @"Language")]];
    [ArrayTable addObject:@[FGGetStringWithKeyFromTable(@"Total", @"Language"),FGGetStringWithKeyFromTable(@"Delivery Fee", @"Language"),FGGetStringWithKeyFromTable(@"Service Fee", @"Language"),FGGetStringWithKeyFromTable(@"", @"Language")]];
    [ArrayTable addObject:@[FGGetStringWithKeyFromTable(@"Next", @"Language")]];
    [self addDowntableUI];
    
    [self Get_E_MenuList];  ////要获取商品数据
}
- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    if(manager==nil)
    {
        manager=[LocationManager sharedInstance];
        manager.delegate=self;
    }
    [manager setStartUpdatingLocation];
    iCount=0;
    
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
-(void)returnLoction:(CLLocationCoordinate2D)CLLocation
{
    
    
    if(iCount ==0)
    {
        NSLog(@"longitude = %f    latitude= %f",CLLocation.longitude,CLLocation.latitude);
        [self GetQueryLocation:CLLocation.longitude lat:CLLocation.latitude];
        iCount+=1;
    }
    
}
-(void)GetQueryLocation:(CLLocationDegrees)longitude lat:(CLLocationDegrees)latitude
{
    
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?longitude=%f&latitude=%f",E_FuWuQiUrl,E_QueryLocation,longitude,latitude] parameters:nil progress:^(id progress) {
            //        NSLog(@"请求成功 = %@",progress);
        } success:^(id responseObject) {
            NSLog(@"E_MenuList = %@",responseObject);
            
//            NSArray * array=(NSArray *)responseObject;
            NSDictionary * dictObject= (NSDictionary *)responseObject;
            NSArray * contentarr =[dictObject objectForKey:@"content"];
            if(contentarr.count>0)
            {
                [self.GetaddressArray removeAllObjects];
                for (int i =0; i<contentarr.count; i++) {
                    NSDictionary * dictCon= contentarr[i];
                    AddressListMode* mode = [[AddressListMode alloc] init];
                    
                    mode.siteId =[dictCon objectForKey:@"siteId"];;
                    mode.siteName=[dictCon objectForKey:@"siteName"] ;
                    mode.siteSerialNumber=[dictCon objectForKey:@"siteSerialNumber"];
                    mode.siteType=[dictCon objectForKey:@"siteType"];
                    mode.streetAddress=[dictCon objectForKey:@"streetAddress"];
                    mode.latitude=[dictCon objectForKey:@"latitude"];
                    mode.longitude=[dictCon objectForKey:@"longitude"];
                    mode.distance=[dictCon objectForKey:@"distance"];
                    [self.GetaddressArray addObject:mode];
                    [self.DownTable reloadData];
                }
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No stores available nearby", @"Language") andDelay:2.0];
            }
            
                    
            
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
            if(statusCode==401)
            {
                [self setDefaults];
            }
            [HudViewFZ HiddenHud];
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
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[NewHomeViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
}


-(void)addDowntableUI
{
    DownTable = [[UITableView alloc] init];
    DownTable.frame=CGRectMake(0, _TopImage.bottom, SCREEN_WIDTH,SCREEN_HEIGHT-(_TopImage.bottom));
    DownTable.delegate=self;
    DownTable.dataSource=self;
    DownTable.showsVerticalScrollIndicator=NO;
    DownTable.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    //    self.tableViewT.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.Set_tableView.separatorColor = [UIColor blackColor];
    //UITableViewCell 左分割线顶格
    self.DownTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.DownTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [DownTable registerNib:[UINib nibWithNibName:@"BagTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID1];
    [DownTable registerNib:[UINib nibWithNibName:@"DeliveryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID2];
//    [DownTable registerNib:[UINib nibWithNibName:@"CellBagTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID3];
    [DownTable registerNib:[UINib nibWithNibName:@"CelladdTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID4];
    
    [self.view addSubview:DownTable];
}
-(void)AddButtonNext
{
    if(self.NextButton == nil)
    {
        self.NextButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-(15*2), 50)];
//        [self.NextButton setTitle:FGGetStringWithKeyFromTable(@"Next", @"Language") forState:(UIControlStateNormal)];
        [self.NextButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.NextButton addTarget:self action:@selector(pushNext) forControlEvents:UIControlEventTouchDown];
        self.NextButton.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
        self.NextButton.layer.cornerRadius = 4;
    }
}

-(void)pushNext
{
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    EWashNextViewController *vc=[main instantiateViewControllerWithIdentifier:@"EWashNextViewController"];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
////    [self.DownTable reloadData];
    if(self.GetaddressArray.count>0)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddressSViewController *vc=[main instantiateViewControllerWithIdentifier:@"AddressSViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.SelectWay=self.SelectWay;
        vc.CommodityArr= self.CommodityArr;
        float total =0;
        for (int i=0; i<self.CommodityArr.count; i++) {
            CommodityMode*mode=self.CommodityArr[i];
            NSString* priceStr=[self ReturnPriceStr:mode];
            total+=[priceStr floatValue];
        }
        if(self.SelectWay==1)
        {
            total+=[self.doorstepCostStr floatValue];
        }else if(self.SelectWay==2){
        //              total+=[self.doorstepCostStr floatValue];
            total+=[self.selfPickupCostStr floatValue];
        }
        vc.TotalStr=[NSString stringWithFormat:@"%.2f",total];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No shops nearby", @"Language") andDelay:2.0];
    }
}


-(void)Get_E_MenuList
{
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_MenuList] parameters:nil progress:^(id progress) {
            //        NSLog(@"请求成功 = %@",progress);
        } success:^(id responseObject) {
            NSLog(@"E_MenuList = %@",responseObject);
            NSArray * array=(NSArray *)responseObject;
    //        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
            if(array.count>0)
            {
                NSDictionary * dict = array[0];
                NSString * productMenuIdStr= [dict objectForKey:@"productMenuId"];
                [self getCaiDanInfo:productMenuIdStr];
            }else
            {
                [HudViewFZ HiddenHud];
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Quantity is 0", @"Language") andDelay:2.0];
            }
            
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
            if(statusCode==401)
            {
                [self setDefaults];
            }
            [HudViewFZ HiddenHud];
            
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        }];
}

-(void)getCaiDanInfo:(NSString*)IdStr
{
    
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?productMenuId=%@",E_FuWuQiUrl,E_MenuListMember,IdStr] parameters:nil progress:^(id progress) {
            //        NSLog(@"请求成功 = %@",progress);
        } success:^(id responseObject) {
            NSLog(@"E_MenuListMember = %@",responseObject);
            
            NSArray * dictArr= (NSArray*)responseObject;
            NSDictionary * dictz= (NSDictionary*)dictArr[0];
            NSDictionary * products = [dictz objectForKey:@"products"];
            self.doorstepCostStr = [dictz objectForKey:@"doorstepCost"];
            self.selfPickupCostStr = [dictz objectForKey:@"selfPickupCost"];;
            NSArray * array=[products objectForKey:@"content"];
    //        NSNumber * statusCode =[dictObject objectForKey:@"statusCode"];
            [self.PoubdArr removeAllObjects];
            [self.CommodityArr  removeAllObjects];
            if(array.count>0)
            {
                
//                productsMode * ModeProducts = [productsMode mj_objectWithKeyValues:products];
                
                for(int i=0;i<array.count;i++)
                {
                    productsMode * ModeProducts = [[productsMode alloc] init];
                    NSDictionary * dictA=array[i];
                    NSArray * attributeList = [dictA objectForKey:@"attributeList"];
                    NSArray * productVariantList = [dictA objectForKey:@"productVariantList"];
                    ModeProducts.productId = [dictA objectForKey:@"productId"];
                    ModeProducts.productName = [dictA objectForKey:@"productName"];
                    ModeProducts.productNameEn = [dictA objectForKey:@"productNameEn"];
                    ModeProducts.serviceId = [dictA objectForKey:@"serviceId"];
                    for(int j=0;j<attributeList.count;j++)
                    {
                        NSDictionary * dictJ=attributeList[j];
                        attributeListsMode * mode = [[attributeListsMode alloc] init];
                        mode.attributeType = [dictJ objectForKey:@"attributeType"];
                        mode.name = [dictJ objectForKey:@"name"];
                        mode.productAttributeId = [dictJ objectForKey:@"productAttributeId"];
                        NSArray * valueList = [dictJ objectForKey:@"valueList"];
                        NSMutableArray * ArrayMu= [NSMutableArray arrayWithCapacity:0];
                        NSMutableArray * ArrayvalueListMode= [NSMutableArray arrayWithCapacity:0];
                        for(int B=0;B<valueList.count;B++)
                        {
                            NSDictionary * dictObject=valueList[B];
                            
                            valueListMode * modeValue = [[valueListMode alloc] init];
                            modeValue.productAttributeValue=[dictObject objectForKey:@"productAttributeValue"];
                            modeValue.productAttributeValueId=[dictObject objectForKey:@"productAttributeValueId"];
                            [ArrayvalueListMode addObject:modeValue];
                            
                        }
                        mode.valueList = ArrayvalueListMode;
                        [ArrayMu addObject:mode];
                        ModeProducts.attributeList=ArrayMu;
                    }
                    NSMutableArray * productArrayMu= [NSMutableArray arrayWithCapacity:0];
                    for(int k=0;k<productVariantList.count;k++)
                    {
                        NSDictionary * dictJ=productVariantList[k];
                        NSArray * productAttributeValueIds = [dictJ objectForKey:@"productAttributeValueIds"];
                        
                        productVariantListMode * modeP = [[productVariantListMode alloc] init];
                        modeP.priceValue = [dictJ objectForKey:@"priceValue"];
                        modeP.productAttributeValueName = [dictJ objectForKey:@"productAttributeValueName"];
                        modeP.productVariantId = [dictJ objectForKey:@"productVariantId"];
                        NSMutableArray * ValueIds= [NSMutableArray arrayWithCapacity:0];
                        for(int B=0;B<productAttributeValueIds.count;B++)
                        {
                            NSString * productAttributeValueId=productAttributeValueIds[B];
                            [ValueIds addObject:productAttributeValueId];
                        }
                        modeP.productAttributeValueIds = ValueIds;
                        [productArrayMu addObject:modeP];
                    }
                    ModeProducts.productVariantList=productArrayMu;
                    
//                        if([ModeProducts.productName isEqualToString:@"5 Pound"])
//                        {
//                            [self.PoubdArr addObject:ModeProducts];
//                        }else if([ModeProducts.productName isEqualToString:@"10 Pound"])
//                        {
//                            [self.PoubdArr addObject:ModeProducts];
//                        }
                    [self.PoubdArr addObject:ModeProducts];
//                    [self.BZDArray addObject:ModeProducts];
                }
                CommodityMode * modeCCC= [[CommodityMode alloc] init];
                productsMode*modePC=self.PoubdArr[0];
                modeCCC.Ctype=modePC.productName;
                modeCCC.Ctemperature=@"Cold";
                modeCCC.Mode =modePC;
                modeCCC.SelectTemperature=1;
                modeCCC.SelectMenuPound=0;
                [self.CommodityArr addObject:modeCCC];
                [self.BZDArray addObject:@"1"];/// 刷新商品时，默认选择一个商品
                [self.DownTable reloadData];
//                NSLog(@"ModeProducts=== %@",ModeProducts);
                [HudViewFZ HiddenHud];
            }else{
                [HudViewFZ HiddenHud];
            }
            
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
            if(statusCode==401)
            {
                [self setDefaults];
            }
            [HudViewFZ HiddenHud];
            
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        }];
}

#pragma mark -------- Tableview -------
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return ArrayTable.count; /////设置多少个组
}
/////cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = ArrayTable[section];
    if(section==0)
    {
        if(self.BZDArray.count!=4)
        {
            return self.BZDArray.count+1;
        }
    }
    return arr.count;
//    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strCellID= [NSString stringWithFormat:@"cellID%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strCellID];
        //            cell.contentView.backgroundColor = [UIColor blueColor];
    }
//    NSLog(@"indexPath.section= %ld  indexPath.row==%ld",(long)indexPath.section,(long)indexPath.row);
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * arr = ArrayTable[indexPath.section];
    if(indexPath.row==0)
    {
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    }
    if(indexPath.section!=0)
    {
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    }
    if(indexPath.section==0)
    {
        
//        if(indexPath.row>0)
//        {
//        BagTableViewCell * cellOne = (BagTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID1];
//        if (cellOne == nil) {
//            cellOne= (BagTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"BagTableViewCell" owner:self options:nil]  lastObject];
//        }
//
//            //cell选中效果
//            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
//            cellOne.LeftTitle.text= [arr objectAtIndex:indexPath.row];
//            cellOne.delegate=self;
//            cellOne.tag= 500+indexPath.row;
//        return cellOne;
//        }
        if(indexPath.row>0)
        {
             if(indexPath.row== (self.BZDArray.count))
             {
                 CelladdTableViewCell * cellOne1 = (CelladdTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID4];
                 if (cellOne1 == nil) {
                     cellOne1= (CelladdTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"CelladdTableViewCell" owner:self options:nil]  lastObject];
                 }
                 //cell选中效果
                 cellOne1.selectionStyle = UITableViewCellSelectionStyleNone;
                 cellOne1.tag= 500+indexPath.row;
                 
                 return cellOne1;
             }else{
                CellBagTableViewCell * cellOne = (CellBagTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID3];
                if (cellOne == nil) {
                    cellOne= (CellBagTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"CellBagTableViewCell" owner:self options:nil]  lastObject];
                }
                 //cell选中效果
                 cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
                 cellOne.delegate=self;
                 if(self.PoubdArr.count>0)
                 {
                     cellOne.DQNumber = self.PoubdArr;
                     cellOne.ModeS=(CommodityMode*)self.CommodityArr[(indexPath.row-1)];
                     cellOne.SelectMenuPound=cellOne.ModeS.SelectMenuPound;
                     cellOne.SelectTemperature=cellOne.ModeS.SelectTemperature;
                     NSLog(@"SelectMenuPound= %ld,SelectTemperature= %ld",(long)cellOne.SelectMenuPound,(long)cellOne.SelectTemperature);
//                     [cellOne set_select];
                     [cellOne setUI:cellOne.ModeS.Mode];
//                     [cellOne updateMenu:cellOne.ModeS.SelectMenuPound];
                 }
                 cellOne.tag= 500+indexPath.row;
                 if(self.BZDArray.count>2)
                 {
                     if(indexPath.row>1)
                     {
                     cellOne.styleLeft=1;
                     }
                 }
                return cellOne;
             }
           
        }else{
            cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        }
        
    }else if(indexPath.section==1)
    {
        if(indexPath.row>0)
        {
        DeliveryTableViewCell * cellOne = (DeliveryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID2];
        if (cellOne == nil) {
            cellOne= (DeliveryTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"DeliveryTableViewCell" owner:self options:nil]  lastObject];
        }
            if(self.SelectWay==1)
            {
                if(indexPath.row==1)
                {
                    [cellOne.RightSelect setImage:[UIImage imageNamed:@"check-circle-fill"] forState:(UIControlStateNormal)];
                    [cellOne.LeftImage setImage:[UIImage imageNamed:@"icon_shangmen"] forState:(UIControlStateNormal)];
                }else if(indexPath.row==2)
                {
                    [cellOne.RightSelect setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
                    [cellOne.LeftImage setImage:[UIImage imageNamed:@"icon_mendian"] forState:(UIControlStateNormal)];
                }
            }else if(self.SelectWay==2){
                if(indexPath.row==1)
                {
                    [cellOne.RightSelect setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
                    [cellOne.LeftImage setImage:[UIImage imageNamed:@"icon_shangmen"] forState:(UIControlStateNormal)];
                }else if(indexPath.row==2)
                {
                    [cellOne.RightSelect setImage:[UIImage imageNamed:@"check-circle-fill"] forState:(UIControlStateNormal)];
                    [cellOne.LeftImage setImage:[UIImage imageNamed:@"icon_mendian"] forState:(UIControlStateNormal)];
                }
            }
            //cell选中效果
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            cellOne.LeftTitle.text= [arr objectAtIndex:indexPath.row];
        return cellOne;
        }else
        {
            UITableViewCell* cellCC = [tableView dequeueReusableCellWithIdentifier:@"cellID1"];
            if (cellCC == nil) {
                cellCC = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID1"];
                //            cell.contentView.backgroundColor = [UIColor blueColor];
            }
            
            //cell选中效果
            cellCC.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray * arr2 = ArrayTable[indexPath.section];
            [cellCC.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            cellCC.textLabel.text = [arr2 objectAtIndex:indexPath.row];
            return cellCC;
        }
    }else if(indexPath.section==2)
    {
        if(indexPath.row>=1 && indexPath.row<3)
        {
            NSString * strCellID= [NSString stringWithFormat:@"cellID%ld%ld",(long)indexPath.section,(long)indexPath.row];
            UITableViewCell* cell2 = [tableView dequeueReusableCellWithIdentifier:strCellID];
            if (cell2 == nil) {
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strCellID];
                //            cell.contentView.backgroundColor = [UIColor blueColor];
            }
            //cell选中效果
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray * arr = ArrayTable[indexPath.section];
//            [UIFont fontWithName:@"Helvetica-Bold" size:18]
            [cell2.textLabel setFont:[UIFont systemFontOfSize:16.f]];
            [cell2.detailTextLabel setFont:[UIFont systemFontOfSize:16.f]];
            cell2.textLabel.text = [arr objectAtIndex:indexPath.row];
            cell2.textLabel.textColor=[UIColor colorWithRed:158/255.0 green:174/255.0 blue:183/255.0 alpha:1.0];
            cell2.detailTextLabel.textColor=[UIColor colorWithRed:158/255.0 green:174/255.0 blue:183/255.0 alpha:1.0];
            
            if(self.SelectWay==1)
            {
                if(indexPath.row==1){
                    cell2.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",[self.doorstepCostStr floatValue]];
                }else if(indexPath.row==2){
                    float total =0;
                    for (int i=0; i<self.CommodityArr.count; i++) {
                        CommodityMode*mode=self.CommodityArr[i];
                        NSString* priceStr=[self ReturnPriceStr:mode];
                        total+=[priceStr floatValue];
                    }
                    cell2.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",total];;
                }
            }else if(self.SelectWay==2){
                
                if(indexPath.row==1){
//                    cell2.detailTextLabel.text = [NSString stringWithFormat:@"0"];
                    cell2.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",[self.selfPickupCostStr floatValue]];
                    
                }else if(indexPath.row==2){
                    float total =0;
                    for (int i=0; i<self.CommodityArr.count; i++) {
                        CommodityMode*mode=self.CommodityArr[i];
                        NSString* priceStr=[self ReturnPriceStr:mode];
                        total+=[priceStr floatValue];
                    }
                    cell2.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",total];;
                }
            }
            return cell2;
        }else if (indexPath.row==3)
        {
            
            UITableViewCell* cell3 = [tableView dequeueReusableCellWithIdentifier:@"cellID3"];
            if (cell3 == nil) {
                cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID3"];
            }
            //cell选中效果
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell3.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
             cell3.detailTextLabel.textColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            float total =0;
            for (int i=0; i<self.CommodityArr.count; i++) {
                CommodityMode*mode=self.CommodityArr[i];
                NSString* priceStr=[self ReturnPriceStr:mode];
                total+=[priceStr floatValue];
            }
            if(self.SelectWay==1)
            {

                total+=[self.doorstepCostStr floatValue];
            }else if(self.SelectWay==2){
//              total+=[self.doorstepCostStr floatValue];
                total+=[self.selfPickupCostStr floatValue];
            }
            cell3.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",total];
            return cell3;
        }
        
        
        
        
    }else if(indexPath.section==3)
    {
        
        cell.textLabel.text=@"";
        cell.detailTextLabel.text=@"";
        [self AddButtonNext];
        [self.NextButton setTitle:[arr objectAtIndex:indexPath.row] forState:(UIControlStateNormal)];
        [cell addSubview:self.NextButton];
        cell.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);//去掉cell的分割线
        if(self.GetaddressArray.count>0)
        {
            self.NextButton.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            self.NextButton.userInteractionEnabled=YES;
        }else
        {
            self.NextButton.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
            self.NextButton.userInteractionEnabled=NO;
        }
    }
    return cell;
}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
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
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:0.5];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            return 51;
        }else if(self.BZDArray.count!=4 && indexPath.row==self.BZDArray.count)
        {
            return 51;
        }else
        {
        return 120;
        }
    }
    return 51;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row====== %ld",(long)indexPath.row);
    if(indexPath.section==(ArrayTable.count-1))
    {
        if(self.GetaddressArray.count>0)
        {
           [self pushNext];
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No shops nearby", @"Language") andDelay:2.0];
        }
        
    }if (indexPath.section==0)
    {
        if(self.BZDArray.count>1)
        {
        if(self.BZDArray.count!=4 && indexPath.row==self.BZDArray.count)
        {
            [self.BZDArray addObject:@"1"];
            CommodityMode * modeCCC= [[CommodityMode alloc] init];
            productsMode*modePC=self.PoubdArr[0];
            modeCCC.Ctype=modePC.productName;
            modeCCC.Ctemperature=@"Cold";
            modeCCC.SelectTemperature=1;
            modeCCC.SelectMenuPound=0;
            modeCCC.Mode =modePC;
            [self.CommodityArr addObject:modeCCC];
            [self.DownTable reloadData];
        }
        }else{
           [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"No products to choose from", @"Language") andDelay:2.0];
        }
//        replaceObjectAtIndex
//         [ArrayTable replaceObjectAtIndex:0 withObject:self.BZDArray];
//        [ArrayTable insertObject:self.BZDArray atIndex:0];
        
    }else if (indexPath.section==1)
    {
        if(indexPath.row==1)
        {
            self.SelectWay=1;
            [self.DownTable reloadData];
        }else if(indexPath.row==2)
        {
            self.SelectWay=2;
            [self.DownTable reloadData];
        }
        
    }
}
- (void)SelectPoubd:(UITableViewCell*)cell index:(NSInteger)CellIndex SelectTemperature:(NSInteger)SelectTemperature
{
    CellBagTableViewCell * cellOne = (CellBagTableViewCell *)cell;
    if(cellOne.tag==501)
    {
        
        CommodityMode * mode =self.CommodityArr[0];
        productsMode*modepro=self.PoubdArr[CellIndex];
        mode.Ctype = modepro.productName;
        mode.Mode = modepro;
        mode.SelectTemperature=SelectTemperature;
        mode.SelectMenuPound=CellIndex;

        cellOne.ModeS = mode;
        [cellOne setUI:modepro];
        [self.CommodityArr replaceObjectAtIndex:0 withObject:mode];
    }else if(cellOne.tag==502)
    {
        CommodityMode * mode =self.CommodityArr[1];
        productsMode*modepro=self.PoubdArr[CellIndex];
        mode.Ctype = modepro.productName;
        mode.Mode = modepro;
        mode.SelectTemperature=SelectTemperature;
        mode.SelectMenuPound=CellIndex;
        cellOne.ModeS = mode;
        [cellOne setUI:modepro];
        [self.CommodityArr replaceObjectAtIndex:1 withObject:mode];
    }else if(cellOne.tag==503)
    {
        CommodityMode * mode =self.CommodityArr[2];
        productsMode*modepro=self.PoubdArr[CellIndex];
        mode.Ctype = modepro.productName;
        mode.Mode = modepro;
        mode.SelectTemperature=SelectTemperature;
        mode.SelectMenuPound=CellIndex;
        cellOne.ModeS = mode;
        [cellOne setUI:modepro];
        [self.CommodityArr replaceObjectAtIndex:2 withObject:mode];
    }
}
- (void)SelectTouch:(UITableViewCell*)cell index:(NSInteger)CellIndex
{
    CellBagTableViewCell * cellOne = (CellBagTableViewCell *)cell;
    if(cellOne.tag==501)
    {
        CommodityMode * mode =cellOne.ModeS;
        mode.SelectTemperature=CellIndex;
        if(CellIndex==1)
        {
            
            mode.Ctemperature = @"Cold";
            
//            [cellOne setUI:modepro];
        }else if(CellIndex==2)
        {
            mode.Ctemperature = @"Warm";
        }else if(CellIndex==3)
        {
            mode.Ctemperature = @"Hot";
        }
        cellOne.ModeS = mode;
        [self.CommodityArr replaceObjectAtIndex:0 withObject:mode];
    }else if(cellOne.tag==502)
    {
        CommodityMode * mode =cellOne.ModeS;
        mode.SelectTemperature=CellIndex;
        if(CellIndex==1)
        {
            mode.Ctemperature = @"Cold";
        }else if(CellIndex==2)
        {
            mode.Ctemperature = @"Warm";
        }else if(CellIndex==3)
        {
            mode.Ctemperature = @"Hot";
        }
        cellOne.ModeS = mode;
        [self.CommodityArr replaceObjectAtIndex:1 withObject:mode];
    }else if(cellOne.tag==503)
    {
        CommodityMode * mode =cellOne.ModeS;
        mode.SelectTemperature=CellIndex;
        if(CellIndex==1)
        {
            mode.Ctemperature = @"Cold";
        }else if(CellIndex==2)
        {
            mode.Ctemperature = @"Warm";
        }else if(CellIndex==3)
        {
            mode.Ctemperature = @"Hot";
        }
        cellOne.ModeS = mode;
        [self.CommodityArr replaceObjectAtIndex:2 withObject:mode];
    }
//    [self.DownTable reloadData];
}
- (void)DeleteTouch:(UITableViewCell*)cell index:(NSInteger)CellIndex
{
//    CellBagTableViewCell*cellBag=(CellBagTableViewCell*)cell;
    if(CellIndex==502)
    {
        [self.BZDArray removeObjectAtIndex:2];
        [self.CommodityArr removeObjectAtIndex:1];
        [self.DownTable reloadData];
    }else if(CellIndex==503)
    {
        [self.BZDArray removeObjectAtIndex:3];
        [self.CommodityArr removeObjectAtIndex:2];
        [self.DownTable reloadData];
    }
    
}

/// BagTableViewCellDelegate
- (void)jiaTouch:(UITableViewCell*)Cell
{
    BagTableViewCell* cellA= (BagTableViewCell*)Cell;
    if(cellA.tag-500 == 1)
    {
        if(self.CountInt1==10)
        {
            [self setbtn_jia_NO:cellA];
        }else{
            self.CountInt1++;
            [self setbtn_jia_yes:cellA];
            if(self.CountInt1>1)
            {
                [self setbtn_jian_yes:cellA];
            }
            if(self.CountInt1==10)
            {
               [self setbtn_jia_NO:cellA];
            }
        }
        [cellA.RightTitle setText:[NSString stringWithFormat:@"%ld",(long)self.CountInt1]];
    }else if(cellA.tag-500 == 2)
    {
        
        if(self.CountInt2==10)
        {
            [self setbtn_jia_NO:cellA];
        }else{
            self.CountInt2++;
            [self setbtn_jia_yes:cellA];
            if(self.CountInt2>1)
            {
                [self setbtn_jian_yes:cellA];
            }
            if(self.CountInt2==10)
            {
               [self setbtn_jia_NO:cellA];
            }
        }
        [cellA.RightTitle setText:[NSString stringWithFormat:@"%ld",(long)self.CountInt2]];
    }

}
- (void)jianTouch:(UITableViewCell*)Cell
{
    BagTableViewCell* cellA= (BagTableViewCell*)Cell;
    if(cellA.tag-500 == 1)
    {
        if(self.CountInt1==1)
        {
            [self setbtn_jian_NO:cellA];
        }else{
            self.CountInt1--;
            [self setbtn_jian_yes:cellA];
            if(self.CountInt1<10)
            {
                [self setbtn_jia_yes:cellA];
            }
            if(self.CountInt1==1)
            {
               [self setbtn_jian_NO:cellA];
            }
        }
        [cellA.RightTitle setText:[NSString stringWithFormat:@"%ld",(long)self.CountInt1]];
    }else if(cellA.tag-500 == 2)
    {
        if(self.CountInt2==1)
        {
            [self setbtn_jian_NO:cellA];
        }else{
            self.CountInt2--;
            [self setbtn_jian_yes:cellA];
            if(self.CountInt2<10)
            {
                [self setbtn_jia_yes:cellA];
            }
            if(self.CountInt2==1)
            {
               [self setbtn_jian_NO:cellA];
            }
        }
        [cellA.RightTitle setText:[NSString stringWithFormat:@"%ld",(long)self.CountInt2]];
    }
}
-(void)setbtn_jian_yes:(BagTableViewCell*)cell
{
    [cell.RightJian setImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
    
}
-(void)setbtn_jian_NO:(BagTableViewCell*)cell
{

    [cell.RightJian  setImage:[UIImage imageNamed:@"minus_unavailable"] forState:UIControlStateNormal];
}

-(void)setbtn_jia_yes:(BagTableViewCell*)cell
{

    [cell.rightJia  setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
}
-(void)setbtn_jia_NO:(BagTableViewCell*)cell
{
    [cell.rightJia setImage:[UIImage imageNamed:@"plus_unavailable"] forState:UIControlStateNormal];
    
}




-(NSString * )ReturnPriceStr:(CommodityMode*)DomeZ
{
    productsMode* mode=DomeZ.Mode;
     for (int i = 0; i<mode.attributeList.count; i++) {
            attributeListsMode * attmode= mode.attributeList[i];
            for (int j=0; j<attmode.valueList.count; j++) {
                valueListMode * modeValue =attmode.valueList[j];
                NSString * productAttributeValueIdStr = modeValue.productAttributeValueId;
                if([modeValue.productAttributeValue isEqualToString:@"Cold"])
                {
//                    [_ColdBtn setTitle:modeValue.productAttributeValue forState:(UIControlStateNormal)];
                    for (int k=0; k<mode.productVariantList.count; k++) {
                        productVariantListMode * modePro = mode.productVariantList[k];
                        for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                            NSString * ValueId= modePro.productAttributeValueIds[M];
                            if([ValueId isEqualToString:productAttributeValueIdStr])
                            {
                                if(DomeZ.SelectTemperature==1)
                                {
                                    
                                    return modePro.priceValue;
                                }
                            }
                        }
                        
                    }
                }else if([modeValue.productAttributeValue isEqualToString:@"Warm"])
                {
                    for (int k=0; k<mode.productVariantList.count; k++) {
                        productVariantListMode * modePro = mode.productVariantList[k];
                        for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                            NSString * ValueId= modePro.productAttributeValueIds[M];
                            if([ValueId isEqualToString:productAttributeValueIdStr])
                            {
                                
                                    if(DomeZ.SelectTemperature==2)
                                    {
                                        return modePro.priceValue;
                                    }
                            }
                        }
                        
                    }
                }else if([modeValue.productAttributeValue isEqualToString:@"Hot"])
                {
                    for (int k=0; k<mode.productVariantList.count; k++) {
                        productVariantListMode * modePro = mode.productVariantList[k];
                        for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                            NSString * ValueId= modePro.productAttributeValueIds[M];
                            if([ValueId isEqualToString:productAttributeValueIdStr])
                            {
                                if(DomeZ.SelectTemperature==3)
                                {
                                    return modePro.priceValue;
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }

    return nil;
}

@end
