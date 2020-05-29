//
//  YYXYInfoViewController.m
//  Cleanpro
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import "YYXYInfoViewController.h"
//#define CellID @"CellID"
@interface YYXYInfoViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *arrayTitle;//数据源
@property(nonatomic,strong)NSMutableArray *RightarrayTitle;//数据源
@property (nonatomic,strong)UIButton* CallButton;
@property (nonatomic,strong)UIButton* GoogleButton;
@property (nonatomic,strong)UIButton* MessageButton;
@end

@implementation YYXYInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    self.arrayTitle = [NSMutableArray arrayWithCapacity:0];
    self.RightarrayTitle=[NSMutableArray arrayWithCapacity:0];
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
-(void)addArrayT
{
    [self.arrayTitle addObject:@"Label"];
    [self.arrayTitle addObject:@"Type"];
    [self.arrayTitle addObject:@"Qty"];
    [self.arrayTitle addObject:@"Price"];
    [self.arrayTitle addObject:@"Payment"];
    [self.arrayTitle addObject:@"Status"];
    [self.arrayTitle addObject:@"Name"];
    [self.arrayTitle addObject:@"Address"];
    [self.arrayTitle addObject:@"Phone"];
//    [self.arrayTitle addObject:@"0"];
    if(![self.ModeZ.logisticsType isEqual:[NSNull null]])
    {
    if([self.ModeZ.logisticsType isEqualToString:@"DOORSTEP_DELIVERY"])
    {
        
    }else if([self.ModeZ.logisticsType isEqualToString:@"SELF_PICKUP"])
    {
        if(![self.ModeZ.paymentPlatform isEqual:[NSNull null]])
        {
            if([self.ModeZ.paymentPlatform isEqualToString:@"CASH_PAY"])
            {
                [self.arrayTitle addObject:@"image"];
            }
        }else
        {
            
        }
    }else if([self.ModeZ.logisticsType isEqualToString:@"LAUNDRY_OUTLET"])
    {
        
    }
    }
    if([userIdStr isEqualToString:@"1"])
    {
        
    }else
    {
       [self.arrayTitle addObject:@"button"];
    }
    
    if(_ModeZ!=nil)
    {
        
        [self.RightarrayTitle addObject:self.ModeZ.orderNumber];
//        if([self.ModeZ.itemsName isEqualToString:@"5P"])
//        {
//            [self.RightarrayTitle addObject:@"L"];
//        }else if([self.ModeZ.itemsName isEqualToString:@"10P"])
//        {
//           [self.RightarrayTitle addObject:@"XL"];
//        }else if([self.ModeZ.itemsName isEqualToString:@"10P/5P"])
//        {
//            [self.RightarrayTitle addObject:[NSString stringWithFormat:@"L/%@",@"XL"]];
//        }else if([self.ModeZ.itemsName isEqualToString:@"5P/10P"])
//        {
//            [self.RightarrayTitle addObject:[NSString stringWithFormat:@"L/%@",@"XL"]];
//        }
        [self.RightarrayTitle addObject:self.ModeZ.itemsName];
        NSString * Qtystr=@"0";
        for (int i =0; i<self.ModeZ.ordersItems.count; i++) {
            OrderSItemsMode * modeO=self.ModeZ.ordersItems[i];
            
            Qtystr=[NSString stringWithFormat:@"%d",[Qtystr intValue]+[modeO.quantity intValue]];
        }
        [self.RightarrayTitle addObject:Qtystr];
        [self.RightarrayTitle addObject:self.ModeZ.paidCharge];
        if(![self.ModeZ.paymentMethod isEqual:[NSNull null]])
        {
            [self.RightarrayTitle addObject:self.ModeZ.paymentMethod];
        }else
        {
           [self.RightarrayTitle addObject:@"Online Pay"];
        }
        
        [self.RightarrayTitle addObject:self.ModeZ.status];
        [self.RightarrayTitle addObject:self.ModeZ.recipientName];
//        [self.RightarrayTitle addObject:self.ModeZ.recipientAddress];
        if(![self.ModeZ.logisticsType isEqual:[NSNull null]])
        {
                if([self.ModeZ.logisticsType isEqualToString:@"DOORSTEP_DELIVERY"])
                {
                    [self.RightarrayTitle addObject:self.ModeZ.recipientAddress];
                }else if([self.ModeZ.logisticsType isEqualToString:@"SELF_PICKUP"])
                {
                    if(![self.ModeZ.recipientAddress isEqual:[NSNull null]])
                    {
                        [self.RightarrayTitle addObject:self.ModeZ.recipientAddress];
                    }else
                    {
                        [self.RightarrayTitle addObject:self.ModeZ.siteName];
                    }
                }else if([self.ModeZ.logisticsType isEqualToString:@"LAUNDRY_OUTLET"])
                {
                    if(![self.ModeZ.recipientAddress isEqual:[NSNull null]])
                    {
                        [self.RightarrayTitle addObject:self.ModeZ.recipientAddress];
                    }else
                    {
                        [self.RightarrayTitle addObject:self.ModeZ.siteName];
                    }
                }
        }
        [self.RightarrayTitle addObject:self.ModeZ.recipientPhoneNumber];
        if(![self.ModeZ.logisticsType isEqual:[NSNull null]])
        {
                if([self.ModeZ.logisticsType isEqualToString:@"DOORSTEP_DELIVERY"])
                {
                    [self.RightarrayTitle addObject:self.ModeZ.recipientAddress];
                }else if([self.ModeZ.logisticsType isEqualToString:@"SELF_PICKUP"])
                {
        //         @"S";
                    if(![self.ModeZ.recipientAddress isEqual:[NSNull null]])
                    {
                        [self.RightarrayTitle addObject:self.ModeZ.recipientAddress];
                    }else
                    {
                        [self.RightarrayTitle addObject:self.ModeZ.siteName];
                    }
                }
       
            if([self.ModeZ.logisticsType isEqualToString:@"SELF_PICKUP"])
            {
                if(![self.ModeZ.paymentPlatform isEqual:[NSNull null]])
                {
                    if([self.ModeZ.paymentPlatform isEqualToString:@"CASH_PAY"])
                    {
                        [self.RightarrayTitle addObject:self.ModeZ.fileId];
                    }
                }
            }
        }
        
    }
    
    [self.STable reloadData];
}
-(void)AddSTableViewUI
{
//    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    _STable.frame=CGRectMake(15, kNavBarAndStatusBarHeight+8, SCREEN_WIDTH-(15*2),SCREEN_HEIGHT-(kNavBarAndStatusBarHeight+10));
    _STable.delegate=self;
    _STable.dataSource=self;
    _STable.showsVerticalScrollIndicator=NO;
    _STable.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    //UITableViewCell 左分割线顶格
//    self.STable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.STable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.STable.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉全部cell的分割线
    self.STable.layer.cornerRadius = 4;
//    [_STable registerNib:[UINib nibWithNibName:@"JieDanTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
}
-(void)AddButtonNext
{
    if(self.GoogleButton == nil)
    {
        self.GoogleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 17, 100, 36)];
        [self.GoogleButton setTitle:FGGetStringWithKeyFromTable(@"Copy address", @"Language") forState:(UIControlStateNormal)];
        [self.GoogleButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.GoogleButton addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchDown];
        [self.GoogleButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        self.GoogleButton.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
        self.GoogleButton.tag=200;
        self.GoogleButton.layer.cornerRadius = 4;
    }
    if(self.CallButton == nil)
    {
        self.CallButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-(15*2))/2-(100/2), 17, 100, 36)];
        [self.CallButton setTitle:FGGetStringWithKeyFromTable(@"Call", @"Language") forState:(UIControlStateNormal)];
        [self.CallButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.CallButton addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchDown];
        [self.CallButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        self.CallButton.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
        self.CallButton.tag=201;
        self.CallButton.layer.cornerRadius = 4;
    }
    
    if(self.MessageButton == nil)
        {
            self.MessageButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-(15*2)-100), 17, 100, 36)];
            [self.MessageButton setTitle:FGGetStringWithKeyFromTable(@"Message", @"Language") forState:(UIControlStateNormal)];
            [self.MessageButton.titleLabel setTextColor:[UIColor whiteColor]];
            [self.MessageButton addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchDown];
            [self.MessageButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
            self.MessageButton.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            self.MessageButton.tag=202;
            self.MessageButton.layer.cornerRadius = 4;
        }
}
-(void)pushNext:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    NSLog(@"tag == %ld",btn.tag);
    if(btn.tag==200)
    {
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address Copy successful!", @"Language") andDelay:1.5];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if(![self.ModeZ.recipientAddress isEqual:[NSNull null]])
        {
            pasteboard.string = self.ModeZ.recipientAddress;
        }else
        {
            pasteboard.string = self.ModeZ.siteName;
        }

    }else if(btn.tag==201)
    {
        
        //        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"186xxxx6979"];
        //
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
        //
        //        }];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",self.ModeZ.recipientPhoneNumber]]]];
//
//        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.ModeZ.recipientPhoneNumber];
        // NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    }else if(btn.tag==202)
    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://10086&&body=123"]];
//        iOS10之后苹果官方建议使用下面的方法：

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"sms://%@",self.ModeZ.recipientPhoneNumber]] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"调用成功");
            }else{
                NSLog(@"调用失败");
            }
        }];
        
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
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];        
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row==9)
    {
        NSString * str = self.arrayTitle[indexPath.row];
        if([str isEqualToString:@"image"])
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, self.STable.width-(16*2), 140)];
            if(self.ModeZ.fileId!=nil)
            {
    //            [imageView setImage:[UIImage imageNamed:self.RightarrayTitle[indexPath.row]]];
//                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",E_FuWuQiUrl,E_DownFile,self.ModeZ.fileId]] placeholderImage:[UIImage imageNamed:@"tianjiantupian"]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",E_FuWuQiUrl,E_DownFile,self.ModeZ.fileId]]];
            }
            [cell addSubview:imageView];
        }else if([str isEqualToString:@"button"])
        {
            if([userIdStr isEqualToString:@"1"])
            {
            }else
            {
                    [self AddButtonNext];
                    [cell addSubview:self.CallButton];
                    [cell addSubview:self.GoogleButton];
                    [cell addSubview:self.MessageButton];
                    cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
            }
        }
    }else if(indexPath.row==10)
    {
        if([userIdStr isEqualToString:@"1"])
        {
        }else
        {
                [self AddButtonNext];
                [cell addSubview:self.CallButton];
                [cell addSubview:self.GoogleButton];
                [cell addSubview:self.MessageButton];
                cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
        }
            
    }else
    {
            cell.textLabel.text = self.arrayTitle[indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithRed:157/255.0 green:175/255.0 blue:178/255.0 alpha:1];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
            if(indexPath.row<9)
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.RightarrayTitle[indexPath.row]];;
            }else
            {
                
            }
            
            
        }
        
//    cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);//去掉某个cell的分割线
    
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       if(indexPath.row==9)
       {
           if(self.ModeZ.fileId!=nil)
           {
               return 160;
           }
           return 0;
       }else if(indexPath.row==10)
       {
           return 60;
       }
    return 30;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
}

@end
