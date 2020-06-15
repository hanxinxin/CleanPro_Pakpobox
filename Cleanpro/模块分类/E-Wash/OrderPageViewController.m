//
//  OrderPageViewController.m
//  Cleanpro
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import "OrderPageViewController.h"
#import "PriceWashTableViewCell.h"
#import "NewHomeViewController.h"
#define CellID @"PriceWashTableViewCell"

@interface OrderPageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    UIButton * button;
}
@property(nonatomic,strong)NSMutableArray *LeftarrayTitle;//数据源
@property(nonatomic,strong)NSMutableArray *Rightarray;//数据源
@property (nonatomic,strong)UIButton* CancelBtn;
@end

@implementation OrderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    self.LeftarrayTitle = [NSMutableArray arrayWithCapacity:0];
    self.Rightarray = [NSMutableArray arrayWithCapacity:0];
    [self addArrayT];
    [self AddSTableViewUI];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
-(void)ParsingMode
{
//    PostOrderMode
    if(self.OrderMode!=nil)
    {
//        [self.Rightarray addObject:@""];
//        [self.Rightarray addObject:@"payment succeeded"];
        
    }
}

-(void)addArrayT
{
    [self.LeftarrayTitle addObject:@"0"];
    [self.LeftarrayTitle addObject:@"Current status"];
    [self.LeftarrayTitle addObject:@"Bag type"];
    [self.LeftarrayTitle addObject:@"Payment time"];
    [self.LeftarrayTitle addObject:@"Payment method"];
    [self.LeftarrayTitle addObject:@"Store name"];
    [self.LeftarrayTitle addObject:@"6"];
    
}

-(void)AddSTableViewUI
{
//    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    _STable.frame=CGRectMake(15, kNavBarAndStatusBarHeight+8, SCREEN_WIDTH-15*2,(5*50+296+70));
    _STable.delegate=self;
    _STable.dataSource=self;
    _STable.showsVerticalScrollIndicator=NO;
    _STable.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
//    //UITableViewCell 左分割线顶格
//    self.STable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.STable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.STable.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉全部cell的分割线
    [_STable registerNib:[UINib nibWithNibName:@"PriceWashTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
}

-(void)AddButtonNext
{
    if(self.CancelBtn == nil)
    {
        self.CancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, self.STable.width, 50)];
        [self.CancelBtn setTitle:FGGetStringWithKeyFromTable(@"Completed", @"Language") forState:(UIControlStateNormal)];
        [self.CancelBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [self.CancelBtn addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchDown];
        self.CancelBtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
        self.CancelBtn.tag=200;
        self.CancelBtn.layer.cornerRadius = 4;
    }
    
}
-(void)pushNext:(id)sender
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[NewHomeViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                
            }
        }
}
// 点击back按钮后调用 引用的他人写的一个extension
- (BOOL)navigationShouldPopOnBackButton {
    NSLog(@"重置密码返回啦");
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[NewHomeViewController class]]) {

            [self.navigationController popToViewController:temp animated:YES];
            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
            
        }
    }

    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.LeftarrayTitle.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.LeftarrayTitle[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:157/255.0 green:175/255.0 blue:178/255.0 alpha:1];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0]];

    if(indexPath.row==0)
    {
        PriceWashTableViewCell * cellOne = (PriceWashTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
        if (cellOne == nil) {
            cellOne= (PriceWashTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PriceWashTableViewCell" owner:self options:nil]  lastObject];
        }
            //cell选中效果
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            cellOne.tag= 500+indexPath.row;
        cellOne.PriceTitle.text=[NSString stringWithFormat:@"RMB %@",self.TotalStr];
        cellOne.MSTitle.text=self.OrderMode.orderNumber;
        return cellOne;
        
    }else if(indexPath.row==1)
    {
        for (int i=0; i<self.OrderMode.paymentItems.count; i++) {
            paymentItemsMode * mode =self.OrderMode.paymentItems[i];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",mode.payStatus];
        }
        
        
    }else if(indexPath.row==2)
    {
        NSString *str=@"";
        for (int  i =0; i<self.CommodityArr.count; i++) {
            CommodityMode *mode = self.CommodityArr[i];
            productsMode * modeP=mode.Mode;
            if(i==0)
            {
                 str=[NSString stringWithFormat:@"%@",modeP.productName];
            }else
            {
                 str=[NSString stringWithFormat:@"%@/%@",str,modeP.productName];
            }
            /* //屏蔽自己做的适配
            if(i==0)
            {
                if([modeP.productName isEqualToString:@"5 Pound"])
                {
                    str=[NSString stringWithFormat:@"%@",@"L"];
                }else if([modeP.productName isEqualToString:@"10 Pound"])
                {
                    str=[NSString stringWithFormat:@"%@",@"XL"];
                }
                
            }else
            {
                if([modeP.productName isEqualToString:@"5 Pound"])
                {
                    str=[NSString stringWithFormat:@"%@/%@",str,@"L"];
                }else if([modeP.productName isEqualToString:@"10 Pound"])
                {
                    str=[NSString stringWithFormat:@"%@/%@",str,@"XL"];
                }
                
            }
            */
            
        }
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",str];
    }
    else if(indexPath.row==3)
    {
                for (int i=0; i<self.OrderMode.paymentItems.count; i++) {
                    paymentItemsMode * mode =self.OrderMode.paymentItems[i];
                    if(![mode isEqual:[NSNull null]]){
                        if(![mode.payTime isEqual:[NSNull null]])
                        {
                        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",[self timeStampConversionNSString:mode.payTime]];
                        }else{
                            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",[self getDateTime]];
                        }
                    }
                }
    }
    else if(indexPath.row==4)
    {
//        if(![self.OrderMode.paymentMethod isEqual:[NSNull null]])
//        {
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.OrderMode.paymentMethod];
//        }else{
//            cell.detailTextLabel.text=[NSString stringWithFormat:@""];
//        }
        if(self.PaymentMethodStr==1)
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"Cash"];
        }else if(self.PaymentMethodStr==2)
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"Online Pay"];
        }else if(self.PaymentMethodStr==3)
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"WALLET"];
        }
        
    }
    else if(indexPath.row==5)
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.OrderMode.siteName];
    }else if(indexPath.row==6)
    {
        cell.textLabel.text=@"";
        cell.detailTextLabel.text=@"";
        [self AddButtonNext];
         [cell addSubview:self.CancelBtn];
        cell.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);//去掉cell的分割线
    }

    
    return cell;
}
-(NSString *)timeStampConversionNSString:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
-(NSString *)getDateTime
{
    NSDate *date = [NSDate date];
    //使用formatter格式化后的时间

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *time_now = [formatter stringFromDate:date];
    return time_now;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        if(indexPath.row==0)
        {
            return 296;
        }else if (indexPath.row==6)
        {
            return 70;
        }
    return 40;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中数据
    
    
}
@end
