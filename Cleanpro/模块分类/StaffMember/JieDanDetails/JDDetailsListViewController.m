//
//  JDDetailsListViewController.m
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "JDDetailsListViewController.h"
#import "JieDanTableViewCell.h"
#import "JieDanHeaderView.h"
#import "YYXYInfoViewController.h"
#define CellID @"JieDanTableViewCell"
@interface JDDetailsListViewController ()<UITableViewDelegate,UITableViewDataSource ,JieDanTableViewCellDelegate>

@property(nonatomic,strong)NSMutableArray *arrayTitle;//数据源
@property(nonatomic,assign)NSInteger statusInt;//数据源
@end

@implementation JDDetailsListViewController
@synthesize statusInt;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    self.arrayTitle = [NSMutableArray arrayWithCapacity:0];
    if([self.mode.logisticsType isEqualToString:@"DOORSTEP_DELIVERY"])
    {
        statusInt=5;
    }else if([self.mode.logisticsType isEqualToString:@"SELF_PICKUP"])
    {
        statusInt=5;
    }else if([self.mode.logisticsType isEqualToString:@"LAUNDRY_OUTLET"])
    {
        statusInt=3;
    }
    
//    [self addArrayT];
    NSLog(@"self.mode.status=  %@  ， logisticsType = %@",self.mode.status,self.mode.logisticsType);
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
    if(![self.mode.status isEqual:[NSNull null]])
    {
//        [self.arrayTitle addObject:@"Created"];
//
//        [self.arrayTitle addObject:@"Courier collect"];
//        [self.arrayTitle addObject:@"Cleaning"];
//        [self.arrayTitle addObject:@"Packed"];
//        [self.arrayTitle addObject:@"In delivery"];
//        [self.arrayTitle addObject:@"Finish"];
//        if([self.mode.status isEqualToString:@"Created"])
//        {
//            statusInt=1;
//        }else if([self.mode.status isEqualToString:@"Courier collect"])
//        {
//            statusInt=2;
//        }
//        else if([self.mode.status isEqualToString:@"Cleaning"])
//        {
//            statusInt=3;
//        }
//        else if([self.mode.status isEqualToString:@"Packed"])
//        {
//            statusInt=4;
//        }
//        else if([self.mode.status isEqualToString:@"In delivery"])
//        {
//            statusInt=5;
//        }else if([self.mode.status isEqualToString:@"Finish"])
//        {
//            statusInt=5;
//        }
        
    }
}
-(void)AddSTableViewUI
{
//    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT);
    _STable.delegate=self;
    _STable.dataSource=self;
    _STable.showsVerticalScrollIndicator=NO;
    _STable.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    //UITableViewCell 左分割线顶格
    self.STable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.STable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_STable registerNib:[UINib nibWithNibName:@"JieDanTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return statusInt;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JieDanTableViewCell * cell = (JieDanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell= (JieDanTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"JieDanTableViewCell" owner:self options:nil]  lastObject];
    }
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = self.arrayTitle[indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//显示最右边的箭头
    
    cell.delegate=self;
    cell.tag=indexPath.row;
    if(statusInt==5){
        [self SetCellView5:cell index:indexPath];
    }else if(statusInt==3)
    {
        [self SetCellView3:cell index:indexPath];
    }
     
//            if([self.mode.status isEqualToString:@"Finish"])
//            {
//                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
//                cell.Cfmbtn.userInteractionEnabled=NO;
//            }else
//            {
//                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
//                cell.Cfmbtn.userInteractionEnabled=NO;
//            }
    
    return cell;
}

-(void)SetCellView5:(JieDanTableViewCell *)cell index:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
       
        if(![self.mode.courierCollectUserName isEqual:[NSNull null]])
        {
            cell.CenterLabel.text = [NSString stringWithFormat:@"%@",self.mode.courierCollectUserName];
            cell.Cfmbtn.hidden=YES;
            
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt06"] forState:(UIControlStateNormal)];
        }else{
            cell.Cfmbtn.hidden=NO;
            cell.CenterLabel.text=@"Waiting";
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt01"] forState:(UIControlStateNormal)];
            if([self.mode.status isEqualToString:@"Created"])
            {
                
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=YES;
            }else{
                
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=NO;
            }
        }
        cell.leftTitle.text=@"Courier collect";
        
        
    }else if(indexPath.row==1)
    {
       
        if(![self.mode.cleaningUserName isEqual:[NSNull null]])
        {
            cell.CenterLabel.text = [NSString stringWithFormat:@"%@",self.mode.cleaningUserName];
            cell.Cfmbtn.hidden=YES;
            
            
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt07"] forState:(UIControlStateNormal)];
        }else{
            cell.Cfmbtn.hidden=NO;
            cell.CenterLabel.text=@"Waiting";
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt02"] forState:(UIControlStateNormal)];
            if([self.mode.status isEqualToString:@"Courier collect"])
            {
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=YES;
            }else{
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=NO;
            }
        }
        cell.leftTitle.text=@"Cleaning";
    }else if(indexPath.row==2)
    {
       
        if(![self.mode.packedUserName isEqual:[NSNull null]])
        {
            cell.CenterLabel.text = [NSString stringWithFormat:@"%@",self.mode.packedUserName];
            cell.Cfmbtn.hidden=YES;
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt08"] forState:(UIControlStateNormal)];
        }else{
            cell.Cfmbtn.hidden=NO;
            cell.CenterLabel.text=@"Waiting";
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt03"] forState:(UIControlStateNormal)];
            if([self.mode.status isEqualToString:@"Cleaning"])
            {
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=YES;
            }else{
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=NO;
            }
        }
        cell.leftTitle.text=@"Packed";
    }else if(indexPath.row==3)
    {
       
        if(![self.mode.inDeliveryUserName isEqual:[NSNull null]])
        {
            cell.CenterLabel.text = [NSString stringWithFormat:@"%@",self.mode.inDeliveryUserName];
            cell.Cfmbtn.hidden=YES;
            
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt09"] forState:(UIControlStateNormal)];
        }else{
            cell.Cfmbtn.hidden=NO;
            cell.CenterLabel.text=@"Waiting";
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt04"] forState:(UIControlStateNormal)];
            if([self.mode.status isEqualToString:@"Packed"])
            {
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=YES;
            }
            else{
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=NO;
            }
        }
        
        cell.leftTitle.text=@"In delivery";
    }else if(indexPath.row==4)
    {
       
        if(![self.mode.finishUserName isEqual:[NSNull null]])
        {
            cell.CenterLabel.text = [NSString stringWithFormat:@"%@",self.mode.finishUserName];
            cell.Cfmbtn.hidden=YES;
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt10"] forState:(UIControlStateNormal)];
        }else{
            cell.Cfmbtn.hidden=NO;
            cell.CenterLabel.text=@"Waiting";
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt05"] forState:(UIControlStateNormal)];
            if([self.mode.status isEqualToString:@"In delivery"])
            {
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=YES;
            }else{
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=NO;
            }
        }
        cell.leftTitle.text=@"Finish";
    }
}

-(void)SetCellView3:(JieDanTableViewCell *)cell index:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
       
        if(![self.mode.courierCollectUserName isEqual:[NSNull null]])
        {
            cell.CenterLabel.text = [NSString stringWithFormat:@"%@",self.mode.courierCollectUserName];
            cell.Cfmbtn.hidden=YES;
            
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt06"] forState:(UIControlStateNormal)];
        }else{
            cell.Cfmbtn.hidden=NO;
            cell.CenterLabel.text=@"Waiting";
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt01"] forState:(UIControlStateNormal)];
            if([self.mode.status isEqualToString:@"Created"])
            {
                
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=YES;
            }else{
                
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=NO;
            }
        }
        cell.leftTitle.text=@"Courier collect";
        
        
    }else if(indexPath.row==1)
    {
       
        if(![self.mode.cleaningUserName isEqual:[NSNull null]])
        {
            cell.CenterLabel.text = [NSString stringWithFormat:@"%@",self.mode.cleaningUserName];
            cell.Cfmbtn.hidden=YES;
            
            
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt07"] forState:(UIControlStateNormal)];
        }else{
            cell.Cfmbtn.hidden=NO;
            cell.CenterLabel.text=@"Waiting";
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt02"] forState:(UIControlStateNormal)];
            if([self.mode.status isEqualToString:@"Courier collect"])
            {
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=YES;
            }else{
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=NO;
            }
        }
        cell.leftTitle.text=@"Cleaning";
    }else if(indexPath.row==2)
    {
       
        if(![self.mode.finishUserName isEqual:[NSNull null]])
        {
            cell.CenterLabel.text = [NSString stringWithFormat:@"%@",self.mode.finishUserName];
            cell.Cfmbtn.hidden=YES;
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt10"] forState:(UIControlStateNormal)];
        }else{
            cell.Cfmbtn.hidden=NO;
            cell.CenterLabel.text=@"Waiting";
            [cell.Imagebtn setImage:[UIImage imageNamed:@"icon_zt05"] forState:(UIControlStateNormal)];
            if([self.mode.status isEqualToString:@"Cleaning"])
            {
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=YES;
            }else{
                cell.Cfmbtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                cell.Cfmbtn.userInteractionEnabled=NO;
            }
        }
        cell.leftTitle.text=@"Finish";
    }
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
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"JieDanHeaderView" owner:nil options:nil];
    JieDanHeaderView *bookView = views.firstObject;
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
//    [self.navigationController pushViewController:vc animated:YES];
}


-(void)CfmTouch:(UITableViewCell *)Cell
{
    NSLog(@"Cell.tag == %ld",(long)Cell.tag);
    
    if(statusInt==5)
    {
        if(Cell.tag==0)
        {
            [self post_confirm_collect];
        }else if(Cell.tag==1)
        {
            [self post_Cleaning];
        }else if(Cell.tag==2)
        {
            [self post_Packed];
        }else if(Cell.tag==3)
        {
            [self postIn_delivery];
        }else if(Cell.tag==4)
        {
            [self post_Finish];
        }
    }else if(statusInt==3)
    {
       if(Cell.tag==0)
        {
            [self post_confirm_collect];
        }else if(Cell.tag==1)
        {
            [self post_Cleaning];
        }else if(Cell.tag==2)
        {
            [self post_Finish];
        }
    }
    NSDictionary * dict =@{@"tag":[NSString stringWithFormat:@"%ld",(long)Cell.tag]};
    //通过通知中心发送通知
    NSNotification *notification =[NSNotification notificationWithName:@"UpdateListAAA" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)post_confirm_collect
{
    
    [HudViewFZ labelExample:self.view];
    NSDictionary*dict=@{@"ordersId":self.mode.articleId,
    };
    [[AFNetWrokingAssistant shareAssistant] PostURL_E_washToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URL:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_confirm_collect] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            NSLog(@"responseObject = %@",responseObject);
            if(statusCode==200)
            {
                NSDictionary * dictM =(NSDictionary *)responseObject;
                [self setInfoMode:dictM];
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
            }
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
                    [HudViewFZ HiddenHud];
        }];
}

-(void)post_Cleaning
{
    [HudViewFZ labelExample:self.view];
    NSDictionary*dict=@{@"ordersId":self.mode.articleId,
    };
    [[AFNetWrokingAssistant shareAssistant] PostURL_E_washToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URL:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_confirm_cleaning] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            NSLog(@"responseObject = %@",responseObject);
            if(statusCode==200)
            {
                NSDictionary * dictM =(NSDictionary *)responseObject;
                [self setInfoMode:dictM];
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
            }
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
                    [HudViewFZ HiddenHud];
        }];
}
-(void)post_Packed
{
    [HudViewFZ labelExample:self.view];
    NSDictionary*dict=@{@"ordersId":self.mode.articleId,
    };
    [[AFNetWrokingAssistant shareAssistant] PostURL_E_washToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URL:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_confirm_packed] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            NSLog(@"responseObject = %@",responseObject);
            if(statusCode==200)
            {
                NSDictionary * dictM =(NSDictionary *)responseObject;
                [self setInfoMode:dictM];
                 
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
            }
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
                    [HudViewFZ HiddenHud];
        }];
}
-(void)postIn_delivery
{
    [HudViewFZ labelExample:self.view];
    NSDictionary*dict=@{@"ordersId":self.mode.articleId,
    };
    [[AFNetWrokingAssistant shareAssistant] PostURL_E_washToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URL:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_confirm_delivery] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            NSLog(@"responseObject = %@",responseObject);
            if(statusCode==200)
            {
                NSDictionary * dictM =(NSDictionary *)responseObject;
                [self setInfoMode:dictM];
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
            }
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
                    [HudViewFZ HiddenHud];
        }];
}
-(void)post_Finish
{
    [HudViewFZ labelExample:self.view];
    NSDictionary*dict=@{@"ordersId":self.mode.articleId,
    };
    [[AFNetWrokingAssistant shareAssistant] PostURL_E_washToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URL:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_confirm_collected] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            NSLog(@"responseObject = %@",responseObject);
            if(statusCode==200)
            {
                NSDictionary * dictM =(NSDictionary *)responseObject;
                [self setInfoMode:dictM];
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
            }
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
                    [HudViewFZ HiddenHud];
        }];
}
-(void)setInfoMode:(NSDictionary*)dictM
{
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
                   self.mode=mode;
                   [self addArrayT];
                   [self.STable reloadData];
}
@end
