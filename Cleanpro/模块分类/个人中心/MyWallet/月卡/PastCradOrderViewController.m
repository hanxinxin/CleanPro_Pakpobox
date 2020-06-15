//
//  PastCradOrderViewController.m
//  Cleanpro
//
//  Created by mac on 2020/6/11.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PastCradOrderViewController.h"
#import "PastCardOrderTableViewCell.h"
#define tableID @"PastCardOrderTableViewCell"
@interface PastCradOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSMutableArray * CellArray;
@property(strong,nonatomic)NSMutableArray * SelectCellArray;
@property(strong,nonatomic)NSMutableArray * MONTHLYCellArray;
@property(strong,nonatomic)NSMutableArray * HOURCellArray;
@end

@implementation PastCradOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {//解决iOS 10 版本scrollView下滑问题。
        
        self.TableviewS.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    self.title = FGGetStringWithKeyFromTable(@"Past Card", @"Language");
    self.view.backgroundColor=rgba(243, 243, 243, 1);
    self.CellArray = [NSMutableArray arrayWithCapacity:0];
    self.SelectCellArray= [NSMutableArray arrayWithCapacity:0];
    self.MONTHLYCellArray= [NSMutableArray arrayWithCapacity:0];
    self.HOURCellArray= [NSMutableArray arrayWithCapacity:0];
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
-(void)addTableViewOrders
{

    self.TableviewS.frame=CGRectMake(16, kNavBarAndStatusBarHeight, SCREEN_WIDTH-(16*2),SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
//    self.tableView_top.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-0);
    self.TableviewS.delegate=self;
    self.TableviewS.dataSource=self;
    self.TableviewS.backgroundColor=rgba(243, 243, 243, 1);
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.TableviewS.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.TableviewS.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.TableviewS];
    [self.TableviewS registerNib:[UINib nibWithNibName:@"PastCardOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];

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
    self.TableviewS.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.TableviewS.mj_header=header;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
//    // 隐藏状态
//    foot.stateLabel.hidden = NO;
//    // 设置文字
//    [foot setTitle:@"Drop down to refresh more" forState:MJRefreshStateIdle];
//    [foot setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
//    [foot setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
//    // 设置字体
//    foot.stateLabel.font = [UIFont systemFontOfSize:15];
//    // 设置颜色
//    foot.stateLabel.textColor = [UIColor blackColor];
//    self.TableviewS.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//    }];
//    self.TableviewS.mj_footer =foot;
//    self.tableView_top.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    //    // 马上进入刷新状态
//        [self.tableView_top.mj_header beginRefreshing];
}
-(void)loadNewData
{
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_getAllCard] parameters:nil progress:^(id progress) {
           //        NSLog(@"请求成功 = %@",progress);
       } success:^(id responseObject) {
           NSLog(@"E_getAllCard = %@",responseObject);
           NSDictionary*  DictZ=(NSDictionary*)responseObject;
           NSArray * Array = (NSArray * )[DictZ objectForKey:@"content"];
           if(Array.count>0)
           {
               [self.CellArray removeAllObjects];
               [self.HOURCellArray removeAllObjects];
               [self.MONTHLYCellArray removeAllObjects];
               for (int i=0; i<Array.count; i++) {
                   NSDictionary * dict= Array[i];
                   PastCardListMode* mode=[[PastCardListMode alloc] init];
                   mode.buyTime =[dict objectForKey:@"buyTime"];
                   mode.count =[dict objectForKey:@"count"];
                   mode.currentCost=[dict objectForKey:@"currentCost"];
                   mode.dayInterval=[dict objectForKey:@"dayInterval"];
                   mode.description1=[dict objectForKey:@"description"];
                   mode.enDescription=[dict objectForKey:@"enDescription"];
                   mode.expireTime =[dict objectForKey:@"expireTime"];
                   mode.monthCardId =[dict objectForKey:@"monthCardId"];
                   mode.monthCardType =[dict objectForKey:@"monthCardType"];
                   mode.originalCost =[dict objectForKey:@"originalCost"];
                   mode.residueCount =[dict objectForKey:@"residueCount"];
                   mode.timeInterval =[dict objectForKey:@"timeInterval"];
                   mode.useCurrentCost =[dict objectForKey:@"useCurrentCost"];
                   if([mode.monthCardType isEqualToString:@"MEMBER_MONTHLY_CARD"])
                   {
                       [self.MONTHLYCellArray addObject:mode];
                   }else if([mode.monthCardType isEqualToString:@"HAPPY_HOUR_CARD"])
                   {
                       [self.HOURCellArray addObject:mode];
                   }
                   
               }
               [self.CellArray addObject:@"Member monthly card"];
               for (int l=0; l<self.MONTHLYCellArray.count; l++) {
                   [self.CellArray addObject:self.MONTHLYCellArray[l]];
               }
               for (int p=0; p<self.HOURCellArray.count; p++) {
                   [self.CellArray addObject:self.HOURCellArray[p]];
               }
               [self.TableviewS reloadData];
               [self.TableviewS.mj_header endRefreshing];
           }else{
               [self.TableviewS.mj_header endRefreshing];
           }
           
       } failure:^(NSInteger statusCode, NSError *error) {
           [self.TableviewS.mj_header endRefreshing];
           if(statusCode==401)
           {
               [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
               [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"SetNSUserDefaults" object:nil userInfo:nil]];
               [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil]];
               
           }else{
            [HudViewFZ showMessageTitle:[self dictStr:error] andDelay:2.0];
            [HudViewFZ HiddenHud];
               
           }
       }];
}

-(void)loadFootData
{
    
}



-(NSString *)dictStr:(NSError *)error
{
//    NSString * receive=@"";
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//    receive= [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSString  * message = [dictFromData valueForKey:@"message"];
//
    return message;
}
-(NSNumber *)dictCodeStr:(NSError *)error
{
//    NSString * receive=@"";
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//    receive= [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSNumber * errorCode = [dictFromData valueForKey:@"errorCode"];
//
    return errorCode;
}
-(NSString *)dictMessageStr:(NSError *)error
{
//    NSString * receive=@"";
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//    receive= [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSString * message = [dictFromData valueForKey:@"message"];
    return message;
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//        NSArray * arr=self.CellArray[section];
//        return arr.count;
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return self.CellArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        }
        cell.backgroundColor=rgba(243, 243, 243, 1);
                    //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        NSString * str = self.CellArray[indexPath.section];;
        [self setlabelTextBlck:str label:cell.textLabel];
        return cell;
    }else{
        NSLog(@"indexPath.section== %ld",(long)indexPath.section);
    PastCardOrderTableViewCell *cell = (PastCardOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (PastCardOrderTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PastCardOrderTableViewCell" owner:self options:nil]  lastObject];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PastCardListMode* mode=self.CellArray[indexPath.section];
        cell.topTitle.text=mode.description1;
        cell.State_btn.layer.cornerRadius=10;
        cell.TopPrice.text=[mode.currentCost stringValue];
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[mode.originalCost stringValue] attributes:attribtDic];
        // 赋值
        cell.CenterPrice.attributedText = attribtStr;
        cell.centerTitle.text=[NSString stringWithFormat:@"Remaining times:%@",[mode.residueCount stringValue]];
        if([mode.monthCardType isEqualToString:@"MEMBER_MONTHLY_CARD"])
        {
//            cell.downTitle.hidden=NO;
            cell.downTitle.text=[NSString stringWithFormat:@"Time end:%@",[PublicLibrary timeString:[mode.expireTime stringValue]]];
            [cell.left_btn setImage:[UIImage imageNamed:@"icon_card_lv"] forState:(UIControlStateNormal)];
        }else if([mode.monthCardType isEqualToString:@"HAPPY_HOUR_CARD"])
        {
//            cell.downTitle.hidden=YES;
            cell.downTitle.text=[NSString stringWithFormat:@""];
            [cell.left_btn setImage:[UIImage imageNamed:@"icon_card_zi"] forState:(UIControlStateNormal)];
        }
//        Time end：2020-07-09
        cell.layer.cornerRadius=4;
    return cell;
    }
    return nil;
}

-(void)setlabelTextBlck:(NSString*)str label:(UILabel*)Label_Z
{
    
//    Label_Z.lineBreakMode = NSLineBreakByCharWrapping;
    Label_Z.numberOfLines = 0;
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第一段：placeholder
//    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
//    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:str];
//    [SubStr1 appendAttributedString:substring1];
//    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
//    //设置文字颜色
//    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
//    //设置文字大小
//    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang];
//    [string appendAttributedString:SubStr1];
    // 第二段：placeholder
    NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:str];
    [SubStr2 appendAttributedString:substring2];
    NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
    //设置文字颜色
    [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang2];
    //设置文字大小
        [SubStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.f] range:rang2];//AppleGothic
    [string appendAttributedString:SubStr2];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [Label_Z.text length])];
    Label_Z.attributedText=string;

}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section>0 && section<=(self.MONTHLYCellArray.count) )
    {
        return 10;;
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
//        return CGFLOAT_MIN;//最小数，相当于0
        return 8;
    }else{
        return 8;
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
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //自定义间隔view，可以不写默认用系统的
    UIView * view_c= [[UIView alloc] init];
    view_c.frame=CGRectMake(0, 0, 0, 0);
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
    {
        return 40;
    }
    return 110;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
