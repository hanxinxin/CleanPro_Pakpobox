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
    [self addArrayT];
    [self AddSTableViewUI];
}

-(void)addArrayT
{
    [self.arrayTitle addObject:@"Label"];
    [self.arrayTitle addObject:@"Type"];
    [self.arrayTitle addObject:@"Qty"];
    [self.arrayTitle addObject:@"Price"];
    [self.arrayTitle addObject:@"Payment"];
    [self.arrayTitle addObject:@"Name"];
    [self.arrayTitle addObject:@"Address"];
    [self.arrayTitle addObject:@"Phone"];
    [self.arrayTitle addObject:@"0"];
    [self.arrayTitle addObject:@"0"];
}
-(void)AddSTableViewUI
{
//    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    _STable.frame=CGRectMake(15, kNavBarAndStatusBarHeight+10, SCREEN_WIDTH-(15*2),SCREEN_HEIGHT-(kNavBarAndStatusBarHeight+10));
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
    if(self.CallButton == nil)
    {
        self.CallButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 17, 100, 36)];
        [self.CallButton setTitle:FGGetStringWithKeyFromTable(@"Call", @"Language") forState:(UIControlStateNormal)];
        [self.CallButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.CallButton addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchDown];
        self.CallButton.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
        self.CallButton.tag=200;
        self.CallButton.layer.cornerRadius = 4;
    }
    if(self.GoogleButton == nil)
        {
            self.GoogleButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-(15*2))/2-(100/2), 17, 100, 36)];
            [self.GoogleButton setTitle:FGGetStringWithKeyFromTable(@"Google", @"Language") forState:(UIControlStateNormal)];
            [self.GoogleButton.titleLabel setTextColor:[UIColor whiteColor]];
            [self.GoogleButton addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchDown];
            self.GoogleButton.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            self.GoogleButton.tag=201;
            self.GoogleButton.layer.cornerRadius = 4;
        }
    if(self.MessageButton == nil)
        {
            self.MessageButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-(15*2)-100), 17, 100, 36)];
            [self.MessageButton setTitle:FGGetStringWithKeyFromTable(@"Message", @"Language") forState:(UIControlStateNormal)];
            [self.MessageButton.titleLabel setTextColor:[UIColor whiteColor]];
            [self.MessageButton addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchDown];
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
        
    }else if(btn.tag==201)
    {
        
    }else if(btn.tag==202)
    {
        
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
    if(indexPath.row==8)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, self.STable.width-(16*2), 140)];
        [imageView setImage:[UIImage imageNamed:@"timg"]];
        [cell addSubview:imageView];
        
    }else if(indexPath.row==9)
    {
        [self AddButtonNext];
        [cell addSubview:self.CallButton];
        [cell addSubview:self.GoogleButton];
        [cell addSubview:self.MessageButton];
        cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    }else
    {
        cell.textLabel.text = self.arrayTitle[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:157/255.0 green:175/255.0 blue:178/255.0 alpha:1];
    }
    
//    cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);//去掉某个cell的分割线
    
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       if(indexPath.row==8)
       {
           return 160;
       }else if(indexPath.row==9)
       {
           return 60;
       }
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
}

@end
