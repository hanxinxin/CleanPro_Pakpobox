//
//  PastCardPayView.m
//  Cleanpro
//
//  Created by mac on 2020/6/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PastCardPayView.h"
#import "CradPayTableViewCell.h"
#define tableID @"CradPayTableViewCell"
@interface PastCardPayView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGRect SetFrame;
}
@property (nonatomic,strong)NSArray* cellArray;
@property (nonatomic,strong)NSMutableArray* SelectcellArray;
@property (nonatomic,strong)NSNumber * credit;////积分
@property (nonatomic,strong)NSNumber * balance;///余额
@property (nonatomic,strong)NSNumber * totalAmount;///总金额
@end

@implementation PastCardPayView

  //1-在初始化的时候添加 子Views
- (instancetype)initWithFrame:(CGRect)frame
{
     if (self = [super initWithFrame:frame]) {
     // add subviews
         self =[[NSBundle mainBundle] loadNibNamed:@"PastCardPayView" owner:nil options:nil].firstObject;
         SetFrame=frame;
         [self addTableviewA];
     }
 return self;
 }

//- (instancetype)initWithFrame:(CGRect)frame array:(NSArray*)CArray
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray*)CArray balance:(NSNumber*)balance totalAmount:(NSNumber*)totalAmount
{
     if (self = [super initWithFrame:frame]) {
     // add subviews
         self =[[NSBundle mainBundle] loadNibNamed:@"PastCardPayView" owner:nil options:nil].firstObject;
         SetFrame=frame;
         self.cellArray=CArray;
         self.credit=[[NSNumber alloc] initWithInt:0];
         self.SelectcellArray=[NSMutableArray arrayWithCapacity:0];
         self.balance=balance;
         self.totalAmount=totalAmount;
         if(self.cellArray.count>0)
         {
             [self.SelectcellArray addObject:self.cellArray[0]];
         }
         self.PayBtn.layer.cornerRadius=4;
         [self addTableviewA];
     }
 return self;
 }


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
   
    self.frame=SetFrame;
}
 
- (IBAction)Close_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SelectTouch:selectArr:)]) {
        [self.delegate SelectTouch:100 selectArr:[NSMutableArray arrayWithCapacity:0]];
    }
}
- (IBAction)Pay_touchA:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SelectTouch:selectArr:)]) {
        [self.delegate SelectTouch:101 selectArr:self.SelectcellArray];
    }
}


-(void)addTableviewA
{

    self.Centertableview.delegate=self;
    self.Centertableview.dataSource=self;
//        self.Centertableview.backgroundColor=rgba(243, 243, 243, 1);
    self.Centertableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.Centertableview.backgroundColor = [UIColor clearColor];
    [self.Centertableview registerNib:[UINib nibWithNibName:@"CradPayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.cellArray.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CradPayTableViewCell *cell = (CradPayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (CradPayTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"CradPayTableViewCell" owner:self options:nil]  lastObject];
    }
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * str=self.SelectcellArray[0];
    NSString * strA=self.cellArray[indexPath.row];
    if([self.balance floatValue]>[self.totalAmount floatValue])
    {
        self.PayBtn.userInteractionEnabled=YES;
        cell.TispLabel.hidden=YES;
        [self.PayBtn setBackgroundColor:rgba(26, 149, 229, 1)];
        if([str isEqualToString:strA])
        {
            [cell.selectBtn setImage:[UIImage imageNamed:@"check-circle-fill.png"] forState:(UIControlStateNormal)];
        }else
        {
            [cell.selectBtn setImage:[UIImage imageNamed:@"circleNil.png"] forState:(UIControlStateNormal)];
        }
    }else
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        cell.TispLabel.hidden=NO;
        self.PayBtn.userInteractionEnabled=NO;
        [self.PayBtn setBackgroundColor:rgba(152, 169, 179, 1)];
    }
    cell.downTitle.text=[NSString stringWithFormat:@"available:%.2f",[self.balance floatValue]];
    return cell;

}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

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

    return 80;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.SelectcellArray removeAllObjects];
    [self.SelectcellArray addObject:self.cellArray[indexPath.row]];
//    if ([self.delegate respondsToSelector:@selector(SelectCell:)]) {
//        [self.delegate SelectCell:indexPath.row];
//    }
}





@end
