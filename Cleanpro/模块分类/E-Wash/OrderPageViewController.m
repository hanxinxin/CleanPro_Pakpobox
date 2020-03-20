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
@property(nonatomic,strong)NSMutableArray *arrayTitle;//数据源
@property (nonatomic,strong)UIButton* CancelBtn;
@end

@implementation OrderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    self.arrayTitle = [NSMutableArray arrayWithCapacity:0];
    [self addArrayT];
    [self AddSTableViewUI];
}
-(void)addArrayT
{
    [self.arrayTitle addObject:@"0"];
    [self.arrayTitle addObject:@"Current status"];
    [self.arrayTitle addObject:@"Bag type"];
    [self.arrayTitle addObject:@"Payment time"];
    [self.arrayTitle addObject:@"Payment method"];
    [self.arrayTitle addObject:@"Store name"];
    [self.arrayTitle addObject:@"6"];
}

-(void)AddSTableViewUI
{
//    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    _STable.frame=CGRectMake(15, kNavBarAndStatusBarHeight, SCREEN_WIDTH-15*2,(5*50+296+70));
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
        [self.CancelBtn setTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language") forState:(UIControlStateNormal)];
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
        return cellOne;
        
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

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        if(indexPath.row==0)
        {
            return 296;
        }else if (indexPath.row==6)
        {
            return 70;
        }
    return 50;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中数据
    
    
}
@end
