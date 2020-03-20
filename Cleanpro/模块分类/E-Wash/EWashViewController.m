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
#import "LaundrySelectTableViewCell.h"

#define tableID1 @"BagTableViewCell"
#define tableID2 @"DeliveryTableViewCell"
//#define tableID3 @"LaundrySelectTableViewCell"
@interface EWashViewController ()<UITableViewDelegate,UITableViewDataSource,BagTableViewCellDelegate>
{
    
}
@property (nonatomic,strong)UIImageView* TopImage;
@property (nonatomic,strong)UITableView* DownTable;
@property (nonatomic,strong)NSMutableArray* ArrayTable;
@property (nonatomic,strong)UIButton* NextButton;
@property (assign, nonatomic) NSInteger CountInt1;///数量计数器
@property (assign, nonatomic) NSInteger CountInt2;///数量计数器
@property (assign, nonatomic) NSInteger SelectWay;///1.是store  2.是 上门取
@end

@implementation EWashViewController
@synthesize DownTable,ArrayTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.CountInt1=2;
    self.CountInt2=2;
    self.SelectWay=1;
    self.title=FGGetStringWithKeyFromTable(@"E-Wash", @"Language");
    _TopImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, 170)];
    [_TopImage setImage:[UIImage imageNamed:@"banner-EWASH"]];
    [self.view addSubview:_TopImage];
    self.ArrayTable=[NSMutableArray arrayWithCapacity:0];
    [ArrayTable addObject:@[FGGetStringWithKeyFromTable(@"Bag type", @"Language"),FGGetStringWithKeyFromTable(@"10 Poubd", @"Language"),FGGetStringWithKeyFromTable(@"5 Poubd", @"Language")]];

    [ArrayTable addObject:@[FGGetStringWithKeyFromTable(@"Delivery", @"Language"),FGGetStringWithKeyFromTable(@"Residence", @"Language"),FGGetStringWithKeyFromTable(@"Store", @"Language")]];
    [ArrayTable addObject:@[FGGetStringWithKeyFromTable(@"Total", @"Language")]];
    [ArrayTable addObject:@[FGGetStringWithKeyFromTable(@"Next", @"Language")]];
    [self addDowntableUI];
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
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EWashNextViewController *vc=[main instantiateViewControllerWithIdentifier:@"EWashNextViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.DownTable reloadData];
}
#pragma mark -------- Tableview -------
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return ArrayTable.count; /////设置多少个组
}
/////cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = ArrayTable[section];
    return arr.count;
//    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strCellID= [NSString stringWithFormat:@"cellID%ld%ld",(long)indexPath.section,indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strCellID];
        //            cell.contentView.backgroundColor = [UIColor blueColor];
    }
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * arr = ArrayTable[indexPath.section];
    if(indexPath.row==0)
    {
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    }
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    
    if(indexPath.section==0)
    {
        if(indexPath.row>0)
        {
        BagTableViewCell * cellOne = (BagTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID1];
        if (cellOne == nil) {
            cellOne= (BagTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"BagTableViewCell" owner:self options:nil]  lastObject];
        }
            
            //cell选中效果
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            cellOne.LeftTitle.text= [arr objectAtIndex:indexPath.row];
            cellOne.delegate=self;
            cellOne.tag= 500+indexPath.row;
        return cellOne;
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
                }else if(indexPath.row==2)
                {
                    [cellOne.RightSelect setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
                }
            }else if(self.SelectWay==2){
                if(indexPath.row==1)
                {
                    [cellOne.RightSelect setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
                }else if(indexPath.row==2)
                {
                    [cellOne.RightSelect setImage:[UIImage imageNamed:@"check-circle-fill"] forState:(UIControlStateNormal)];
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
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
       cell.detailTextLabel.text = @"36";
    }else if(indexPath.section==3)
    {
        cell.textLabel.text=@"";
        cell.detailTextLabel.text=@"";
        [self AddButtonNext];
        [self.NextButton setTitle:[arr objectAtIndex:indexPath.row] forState:(UIControlStateNormal)];
        [cell addSubview:self.NextButton];
        cell.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);//去掉cell的分割线
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
    
    return 51;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row====== %ld",indexPath.row);
    if(indexPath.section==(ArrayTable.count-1))
    {
        [self pushNext];
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
        [cellA.RightTitle setText:[NSString stringWithFormat:@"%ld",self.CountInt1]];
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
        [cellA.RightTitle setText:[NSString stringWithFormat:@"%ld",self.CountInt2]];
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
        [cellA.RightTitle setText:[NSString stringWithFormat:@"%ld",self.CountInt1]];
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
        [cellA.RightTitle setText:[NSString stringWithFormat:@"%ld",self.CountInt2]];
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




@end
