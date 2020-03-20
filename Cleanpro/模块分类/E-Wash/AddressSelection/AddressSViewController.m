//
//  AddressSViewController.m
//  Cleanpro
//
//  Created by mac on 2020/3/11.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AddressSViewController.h"
#import "AddressInfoTableViewCell.h"
#import "OrderPageViewController.h"
#define CellID @"AddressInfoTableViewCell"
@interface AddressSViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    UIButton * button;
}
@property(nonatomic,strong)NSMutableArray *arrayTitle;//数据源
@property(nonatomic,assign)BOOL accessoryTypeBool;//数据源
@property (nonatomic,strong)UIButton* OnlinePayBtn;
@property (nonatomic,strong)UIButton* CashBtn;

@property (nonatomic,strong)NSMutableArray *selectorPatnArray;//存放选中数据
@end

@implementation AddressSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    self.arrayTitle = [NSMutableArray arrayWithCapacity:0];
    self.accessoryTypeBool=NO;
    [self addArrayT];
    
    [self AddSTableViewUI];
    [self AddButton];
    
}
-(void)addArrayT
{
    [self.arrayTitle addObject:@"Name"];
    [self.arrayTitle addObject:@"Phone number"];
    [self.arrayTitle addObject:@"Choose the address of the nearest store"];
}
//进入编辑状态
//[self.tableView setEditing:YES animated:YES];
-(void)AddButton
{
    if(self.OnlinePayBtn==nil)
    {
    self.OnlinePayBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.STable.bottom+15, 160, 36)];
            [self.OnlinePayBtn setTitle:FGGetStringWithKeyFromTable(@"Online pay", @"Language") forState:(UIControlStateNormal)];
            [self.OnlinePayBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [self.OnlinePayBtn addTarget:self action:@selector(OnlinePayBtnTouch:) forControlEvents:UIControlEventTouchDown];
            self.OnlinePayBtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            self.OnlinePayBtn.layer.cornerRadius = 4;
        [self.view addSubview:self.OnlinePayBtn];
    }
    if(self.CashBtn==nil)
    {
        self.CashBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160-15, self.STable.bottom+15, 160, 36)];
            [self.CashBtn setTitle:FGGetStringWithKeyFromTable(@"Cash", @"Language") forState:(UIControlStateNormal)];
            [self.CashBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [self.CashBtn addTarget:self action:@selector(CashTouch:) forControlEvents:UIControlEventTouchDown];
            self.CashBtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            self.CashBtn.layer.cornerRadius = 4;
        [self.view addSubview:self.CashBtn];
    }
}
-(void)setBtnTouchFrame
{
    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,(3*50+(self.arrayTitle.count-3)*80));
    self.OnlinePayBtn.frame = CGRectMake(15, self.STable.bottom+15, 160, 36);
    self.CashBtn.frame = CGRectMake(SCREEN_WIDTH-160-15, self.STable.bottom+15, 160, 36);
}
#pragma mark - 点击事件
-(void)OnlinePayBtnTouch:(id)sender
{
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderPageViewController *vc=[main instantiateViewControllerWithIdentifier:@"OrderPageViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)CashTouch:(id)sender
{
    
}
-(void)AddSTableViewUI
{
//    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,(3*50+(self.arrayTitle.count-3)*80));
    _STable.delegate=self;
    _STable.dataSource=self;
    _STable.showsVerticalScrollIndicator=NO;
    _STable.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    //UITableViewCell 左分割线顶格
    self.STable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.STable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_STable registerNib:[UINib nibWithNibName:@"AddressInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayTitle.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.arrayTitle[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//显示最右边的箭头
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0]];

    if(indexPath.row==0)
    {
        
        NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        if(data!=nil)
        {
        SaveUserIDMode * mode  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%@",mode.lastName,mode.firstName]];
        }
    }else if (indexPath.row==1)
    {
        NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
        if(data!=nil)
        {
        SaveUserIDMode * mode  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [cell.detailTextLabel setText:mode.phoneNumber];
        }
    }
    if(indexPath.row>2)
    {
        AddressInfoTableViewCell * cellOne = (AddressInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
        if (cellOne == nil) {
            cellOne= (AddressInfoTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"AddressInfoTableViewCell" owner:self options:nil]  lastObject];
        }
            //cell选中效果
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            cellOne.tag= 500+indexPath.row;
            cellOne.selectBtn.selected=NO;
        return cellOne;
        
    }

    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 不用系统自带的箭头
               if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
                   UIImage *arrowImage = [UIImage imageNamed:@"icon_right12"];
                   UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
                   cell.accessoryView = arrowImageView;
               }
    
        if(indexPath.row==2)
        {
            if(self.accessoryTypeBool==YES)
            {
            // 不用系统自带的箭头
            if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
                UIImage *arrowImage = [UIImage imageNamed:@"icon_rightDown12"];
                UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
                cell.accessoryView = arrowImageView;
            }
            }else
            {
            if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
                UIImage *arrowImage = [UIImage imageNamed:@"icon_right12"];
                UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
                cell.accessoryView = arrowImageView;
            }
            }
        }
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        if(indexPath.row>2)
        {
            return 80;
        }
    return 50;
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row<2)
//    {
//        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//    }else
//    {
//       return UITableViewCellEditingStyleNone;
//    }
//    return UITableViewCellEditingStyleNone;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中数据
//
    if(indexPath.row==2)
    {
        if(self.arrayTitle.count==3)
        {
            [self.arrayTitle addObject:@"1"];
            [self.arrayTitle addObject:@"2"];
            self.accessoryTypeBool=YES;
            [self setBtnTouchFrame];
            [_STable reloadData];
        }else
        {
            [self.arrayTitle removeAllObjects];
            [self addArrayT];
            self.accessoryTypeBool=NO;
            [self setBtnTouchFrame];
            [_STable reloadData];
        }
    }else if(indexPath.row>2)
    {

        for (int i =0; i<self.arrayTitle.count; i++) {
            NSIndexPath * forIndex = [NSIndexPath indexPathForRow:i inSection:0];
            if(i>2)
            {
                AddressInfoTableViewCell*cell = [tableView cellForRowAtIndexPath:forIndex];
                if(indexPath.row!=i)
                {
               
                cell.selectBtn.selected=NO;
                [cell.selectBtn setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
                    
                }else
                {
                    cell.selectBtn.selected=YES;
                    [cell.selectBtn setImage:[UIImage imageNamed:@"check-circle-fill"] forState:(UIControlStateNormal)];
                    [self.selectorPatnArray removeAllObjects];
                    [self.selectorPatnArray addObject:self.arrayTitle[indexPath.row]];
                }
            }
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    if (self.selectorPatnArray.count > 0) {

        [self.selectorPatnArray removeObject:self.arrayTitle[indexPath.row]];
    }
    
        
}
@end
