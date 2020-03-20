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


#define CellID @"StaffTableViewCell"
@interface StaffViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *arrayTitle;//数据源
@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    self.arrayTitle = [NSMutableArray arrayWithCapacity:0];
    [self addTabbarItem];
    [self addArrayT];
    [self AddSTableViewUI];
}
-(void)addTabbarItem
{
    //两个按钮的父类view

    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];

    //历史浏览按钮

    UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];

    [rightButtonView addSubview:historyBtn];

    [historyBtn setImage:[UIImage imageNamed:@"nav_bell"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(historyBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    #pragma mark >>>>>主页搜索按钮

    //主页搜索按钮

    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 50, 50)];

    [rightButtonView addSubview:mainAndSearchBtn];

    [mainAndSearchBtn setImage:[UIImage imageNamed:@"message_bear"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(mainAndSearchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    //把右侧的两个按钮添加到rightBarButtonItem

    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];

    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;

}
-(void)historyBtnEvent:(id)sender
{
    NSLog(@"11111111");
}
-(void)mainAndSearchBtnEvent:(id)sender
{
    NSLog(@"22222222");
}
-(void)addArrayT
{
    [self.arrayTitle addObject:@"0"];
    [self.arrayTitle addObject:@"1"];
    [self.arrayTitle addObject:@"2"];
    [self.arrayTitle addObject:@"3"];
    [self.arrayTitle addObject:@"4"];
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
    [_STable registerNib:[UINib nibWithNibName:@"StaffTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
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
 
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JDDetailsListViewController *vc=[main instantiateViewControllerWithIdentifier:@"JDDetailsListViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
