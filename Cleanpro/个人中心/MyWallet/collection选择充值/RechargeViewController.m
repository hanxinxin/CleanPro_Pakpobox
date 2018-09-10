//
//  RechargeViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "RechargeViewController.h"
#import "TopCollectionViewCell.h"
#import "LaundrySuccessViewController.h"


#define CollectionViewCellID @"TopCollectionViewCell"
#define cout_Number 15

@interface RechargeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray * collectionArray;
    NSInteger moren_cell;
    
    
    /////全屏透明色view和 button Lable
    UIView * Tuicang_View;
    UIView * TC_CenterView;
    UILabel * tisp_lable;
    UILabel * miaoshu_lable;
    UIButton * Come_btn;
    UIButton * back_btn;
    UITapGestureRecognizer *tapSuperGesture22;
    
    ///// textfiledView
    TPPasswordTextView *textfiledView;
    UIButton * closeBtn;
    
}
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"My Wallet";
    
    collectionArray=[NSMutableArray arrayWithCapacity:0];
    [collectionArray addObject:@[@"RM10",@"RM20",@"RM30",@"RM50",@"RM100"]];
    
    self.pay_btn.layer.cornerRadius = 25;//2.0是圆角的弧度，根据需求自己更改
    self.pay_btn.layer.borderWidth = 0.f;//设置边框颜色
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addCollectionView];
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillAppear:animated];
}

-(void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 17*autoSizeScaleX;
    // 每一列cell之间的间距
    // flowLayout.minimumInteritemSpacing = 10;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12*autoSizeScaleX, 0, 12*autoSizeScaleX);
    if(self.view.frame.size.width==375.000000&& self.view.frame.size.height==812.000000)
    {
        self.collectionView.frame=CGRectMake(0, self.Amount_label.bottom+10, SCREEN_WIDTH, 140);
    }else
    {
        self.collectionView.frame=CGRectMake(0, self.Amount_label.bottom+10, SCREEN_WIDTH, 140);
    }
    
    self.collectionView.collectionViewLayout=flowLayout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //    NSLog(@"self.ListCollectionView= %@",self.ListCollectionView);
    //水平滚动条隐藏
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    self.topCollection.allowsMultipleSelection = NO;
    NSInteger selectedIndex = 0;//设置默认选中为第几个
    moren_cell=0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TopCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CollectionViewCellID];
}


- (IBAction)pay_touch:(id)sender {
    [self addtextView_view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return collectionArray.count;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray*)collectionArray[section]).count;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopCollectionViewCell* cell_coll =  [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    if (!cell_coll ) {
        NSLog(@"cell为空,创建cell");
        cell_coll = [[TopCollectionViewCell alloc] init];
        
    }
    cell_coll.selectedBackgroundView = [[UIView alloc] initWithFrame:cell_coll.frame];
    cell_coll.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1];
    [cell_coll.title_lable setTitle:((NSArray*)collectionArray[indexPath.section])[indexPath.row] forState:UIControlStateNormal];
    if(indexPath.row==moren_cell)
    {
        [cell_coll.title_lable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if(SCREEN_WIDTH==320)
    {
        [cell_coll.title_lable.titleLabel setFont:[UIFont systemFontOfSize:13]];
    }else
    {
        [cell_coll.title_lable.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    
    cell_coll.backgroundColor=[UIColor whiteColor];
    cell_coll.tag=indexPath.row;
    cell_coll.layer.cornerRadius = 4;//2.0是圆角的弧度，根据需求自己更改
    cell_coll.layer.borderColor =[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1].CGColor;
    cell_coll.layer.borderWidth = 1.f;//设置边框颜色
    
    //    cell.selectedBackgroundView=[[UIView alloc] initWithFrame:cell.bounds];
    //    cell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:15/255.0 green:180/255.0 blue:146/255.0 alpha:1];
    return cell_coll;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击：%ld",(long)indexPath.row);
    NSArray * arr=collectionArray[indexPath.section];
    for (int i=0; i<arr.count; i++) {
        NSInteger selectedIndex = i;//设置默认选中为第几个
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        TopCollectionViewCell * cell=(TopCollectionViewCell *)[collectionView cellForItemAtIndexPath:selectedIndexPath];
        if(indexPath.row==i)
        {
            [cell.title_lable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            cell.selected=YES;
        }else
        {
            [cell.title_lable setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            cell.selected=NO;
        }
        
    }
    
}
#pragma mark 设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120*autoSizeScaleX, 50*autoSizeScaleX);
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



/**
 密码输入框、、、弹出支付框
 */
-(void)addtextView_view
{
    __block RechargeViewController *  blockSelf = self;
    Tuicang_View=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    [Tuicang_View setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.9]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [Tuicang_View addGestureRecognizer:tapSuperGesture22];
    TC_CenterView = [[UIView alloc] initWithFrame:CGRectMake(38*autoSizeScaleX_6, 220*autoSizeScaleY_6, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 175)];
    [TC_CenterView setBackgroundColor:[UIColor whiteColor]];
    TC_CenterView.layer.cornerRadius=4;
    [Tuicang_View addSubview:TC_CenterView];
    tisp_lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 0)];
    [tisp_lable setText:@""];
    tisp_lable.font = [UIFont systemFontOfSize:14];
    //文字居中显示
    tisp_lable.textAlignment = NSTextAlignmentCenter;
    
    miaoshu_lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 70)];
    [miaoshu_lable setText:@"Please enter payment password"];
    miaoshu_lable.font = [UIFont systemFontOfSize:14];
    //文字居中显示
    miaoshu_lable.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    miaoshu_lable.numberOfLines = 0;
    textfiledView = [[TPPasswordTextView alloc] initWithFrame:CGRectMake((TC_CenterView.width-240)/2, 80+15, 240, 40)];
    textfiledView.elementCount = 6;
    closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(TC_CenterView.width-25, 5, 20, 20)];
    [closeBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //    [closeBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(Touch_two:) forControlEvents:UIControlEventTouchDown];
    [TC_CenterView addSubview:tisp_lable];
    [TC_CenterView addSubview:miaoshu_lable];
    [TC_CenterView addSubview:textfiledView];
    [TC_CenterView addSubview:closeBtn];
    [TC_CenterView addSubview:textfiledView];
    //    [self.view addSubview:view1];
    
    textfiledView.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        if(password.length==6)
        {
            if([password isEqualToString:@"123456"])
            {
                [HudViewFZ labelExample:blockSelf.view];
                [blockSelf postPay];
            }else
            {
                [blockSelf->textfiledView clearPassword];
                [blockSelf tisp];
            }
        }
    };
    [self.view addSubview:Tuicang_View];
    [self show_TCview];
}
-(void)show_TCview
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
        self->Tuicang_View.frame=self.view.bounds;
    }];
    
}
-(void)hidden_TCview
{
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self->Tuicang_View.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        [self->Tuicang_View removeFromSuperview];
    }];
}
- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    
    //    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //    CGPoint location = [gesture locationInView:Tuicang_View];
    //    CGRect rec = [self.view convertRect:TC_CenterView.frame   fromView:Tuicang_View];
    ////    NSLog(@"%@",NSStringFromCGRect(rec));
    //    NSLog(@"location.x== %f,location.y== %f,",location.x,location.y);
    //    NSLog(@"x== %f,y== %f,",rec.origin.x,rec.origin.y);
    //    if(location.x<TC_CenterView.left)
    //    {
    //            [self hidden_TCview];
    //            [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
    //
    //    }
}
-(void)Touch_one:(id)semder
{
    [self hidden_TCview];
    [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addtextView_view];
    });
    
    
}
-(void)Touch_two:(id)semder
{
    [self hidden_TCview];
    [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
}


-(void)pushView
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LaundrySuccessViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundrySuccessViewController"];
    vc.hidesBottomBarWhenPushed = YES;
//    vc.order_c=self.order_c;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)tisp
{
    [HudViewFZ showMessageTitle:@"Wrong password" andDelay:2.0];
}
-(void)postPay
{
    
//    NSDictionary *dict = @{@"machine_no":self.order_c.machine_no, @"total_amount":self.order_c.total_amount, @"order_type":self.order_c.order_type, @"client_type":self.order_c.client_type, @"goods_info":[jiamiStr convertToJSONData:self.order_c.goods_info]};
//    [[AFNetWrokingAssistant shareAssistant] POSTWithCompleteURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_order] parameters:dict progress:^(id progress) {
//        NSLog(@"111  %@",progress);
//    } success:^(id responseObject) {
//        NSLog(@"2222   %@",responseObject);
//        if(responseObject!=nil){
//            //            NSDictionary * code_c=responseObject;
//            //            NSLog(@"code_c= %@",code_c);
//            [HudViewFZ HiddenHud];
//            [self pushView];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"3333   %@",error);
//    }];
    [HudViewFZ HiddenHud];
    [HudViewFZ showMessageTitle:@"Payment success" andDelay:2.0];
    [self pushView];
}



@end
