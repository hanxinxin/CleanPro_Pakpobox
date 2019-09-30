//
//  PromotionViewController.m
//  Cleanpro
//
//  Created by mac on 2018/8/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PromotionViewController.h"
#import "PromotionTableViewCell.h"

#define tableID @"PromotionTableViewCell"
@interface PromotionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PromotionViewController
@synthesize StableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    //    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:2.0 sinceDate:[NSDate date]]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=@"Promotion";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self addSTableview];
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

-(void)addSTableview
{
    //    StableView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    StableView.hidden=NO;
    if(SCREEN_WIDTH==375.000000 && SCREEN_HEIGHT==812.000000)
    {
        StableView.frame=CGRectMake(15, 64+20+8, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-64-20-8);
    }else{
        StableView.frame=CGRectMake(15, 64+8, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-64-8);
    }
    StableView.delegate=self;
    StableView.dataSource=self;
//    StableView.backgroundColor=[UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1];
     StableView.backgroundColor=[UIColor clearColor];
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    StableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [StableView registerNib:[UINib nibWithNibName:@"PromotionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    [self.view addSubview:StableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"PromotionTableViewCell";//这里的cellID就是cell的xib对应的名称
    PromotionTableViewCell *cell = (PromotionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(nil == cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIndentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;///设置无选中状态
    cell.image_P.image=[UIImage imageNamed:@"promotion_img"];
    
    
    return cell;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
    view_c.backgroundColor=[UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 375;
}

//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
    }
    
    
    // 在手指离开的那一刻进行反选中
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
