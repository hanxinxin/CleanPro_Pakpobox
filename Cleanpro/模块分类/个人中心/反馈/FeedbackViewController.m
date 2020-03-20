//
//  FeedbackViewController.m
//  Cleanpro
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018 mac. All rights reserved.
//

#import "FeedbackViewController.h"
#import "TopCollectionViewCell.h"
#import "LaundrySuccessViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "MyAccountViewController.h"

#define CollectionViewCellID @"TopCollectionViewCell"
#define cout_Number 15

@interface FeedbackViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
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
@property (nonatomic,strong)NSString * FKtype;
@property (nonatomic,strong)NSString * FKcontent;
@property (nonatomic,strong)NSString * loginName;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=FGGetStringWithKeyFromTable(@"Feedback", @"Language");;
    
    collectionArray=[NSMutableArray arrayWithCapacity:0];
//    [collectionArray addObject:@[@"Laundry",@"Dryer",@"Price",@"Quality",@"Use Process",@"Others"]];
    [collectionArray addObject:@[FGGetStringWithKeyFromTable(@"Laundry", @"Language"),FGGetStringWithKeyFromTable(@"Dryer", @"Language"),FGGetStringWithKeyFromTable(@"Price", @"Language"),FGGetStringWithKeyFromTable(@"Quality", @"Language"),FGGetStringWithKeyFromTable(@"Use Process", @"Language"),FGGetStringWithKeyFromTable(@"Others", @"Language")]];
    [self.Amount_label setText:FGGetStringWithKeyFromTable(@"Select an option", @"Language")];
    [self.Submit_btn setTitle:FGGetStringWithKeyFromTable(@"Submit", @"Language") forState:(UIControlStateNormal)];
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.loginName = self.ModeUser.loginName;
    self.Submit_btn.layer.cornerRadius = 4;//2.0是圆角的弧度，根据需求自己更改
    self.Submit_btn.layer.borderWidth = 0.f;//设置边框颜色
    self.feedback_textView.layer.cornerRadius = 4;//2.0是圆角的弧度，根据需求自己更改
    self.feedback_textView.layer.borderColor = [UIColor colorWithRed:225/255.0 green:229/255.0 blue:230/255.0 alpha:1].CGColor;//设置边框颜色
    self.feedback_textView.layer.borderWidth = 0.8f;//设置边框颜色
    self.feedback_textView.zw_placeHolder = FGGetStringWithKeyFromTable(@"Add a comment", @"Language");
    self.FKtype = @"Laundry";
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addCollectionView];
    });
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self addtextPhone];
    self.feedback_textView.backgroundColor = [UIColor whiteColor];
    //    设置点击任何其他位置 键盘回收
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
}
-(void)addtextPhone
{
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString * SubStr3=[[NSMutableAttributedString alloc] init];
    NSString * string11 =FGGetStringWithKeyFromTable(@"24 hours Customer Careline: 03-2770 0100", @"Language") ;
    NSString * price = @"03-2770 0100";
    NSAttributedString *substring3 = [[NSAttributedString alloc] initWithString:string11];
    [SubStr3 appendAttributedString:substring3];
    
    //获取需要改变的字符串在完整字符串的范围
    NSRange rang11 = [string11 rangeOfString:price];
    //设置文字大小
    [SubStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang11];
    [SubStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1] range:rang11];
//    [SubStr3 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:14] range:rang11];
    //设置文字背景色
    [SubStr3 addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang11];
    [string appendAttributedString:SubStr3];
    self.down_lable_T.attributedText = string;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //去除导航栏下方的横线
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgnav"]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"bgnav"]];
    [self addNoticeForKeyboard];

    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewWillDisappear:animated];
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //    获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.Submit_btn.top+self.Submit_btn.height+kbHeight) - (self.view.frame.size.height);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
    //        self.view.frame = [UIScreen mainScreen].bounds;
            self.view.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}


-(void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 19*autoSizeScaleX;
    // 每一列cell之间的间距
    // flowLayout.minimumInteritemSpacing = 10;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12*autoSizeScaleX, 0, 12*autoSizeScaleX);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
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


- (IBAction)Submit_touch:(id)sender {
//    [self addtextView_view];
    if(self.loginName!=nil && self.FKtype!=nil && self.feedback_textView.text!=nil)
    {
        self.FKcontent=self.feedback_textView.text;
        [self postUpdateFK];
    }
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
//    cell_coll.selectedBackgroundView = [[UIView alloc] initWithFrame:cell_coll.frame];
//    cell_coll.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1];
    cell_coll.title_lable.hidden=NO;
    cell_coll.down_label.hidden=YES;
    [cell_coll.title_lable setTitle:((NSArray*)collectionArray[indexPath.section])[indexPath.row] forState:UIControlStateNormal];
    if(indexPath.row==moren_cell)
    {
        [cell_coll.title_lable setTitleColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        cell_coll.layer.borderColor =[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1].CGColor;
    }else
    {
        [cell_coll.title_lable setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cell_coll.layer.borderColor =[UIColor lightGrayColor].CGColor;
    }
    if(SCREEN_WIDTH==320)
    {
        [cell_coll.title_lable.titleLabel setFont:[UIFont systemFontOfSize:13]];
    }else
    {
        [cell_coll.title_lable.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    
    
    cell_coll.backgroundColor=[UIColor whiteColor];
    cell_coll.tag=indexPath.row;
    cell_coll.layer.cornerRadius = 18*autoSizeScaleX;//2.0是圆角的弧度，根据需求自己更改
    
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
        
        self.FKtype = arr[indexPath.row];
        TopCollectionViewCell * cell=(TopCollectionViewCell *)[collectionView cellForItemAtIndexPath:selectedIndexPath];
        if(indexPath.row==i)
        {
//            [cell.title_lable setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.title_lable setTitleColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
            cell.layer.borderColor =[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1].CGColor;
            cell.selected=YES;
        }else
        {
//            [cell.title_lable setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [cell.title_lable setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            cell.layer.borderColor =[UIColor lightGrayColor].CGColor;
            cell.selected=NO;
        }
        
    }
    
} 
#pragma mark 设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100*autoSizeScaleX, 36*autoSizeScaleX);
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
    __block FeedbackViewController *  blockSelf = self;
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
    //  背景色 方便  看
    textfiledView.backgroundColor = [UIColor whiteColor];
    //  距离
    textfiledView.elementMargin = 0;
    // 边框宽度
    textfiledView.elementBorderWidth = 1;
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
    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Wrong password", @"Language") andDelay:2.0];
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
    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Payment success", @"Language") andDelay:2.0];
    [self pushView];
}


-(void)postUpdateFK
{
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"loginName":self.loginName,
                          @"type":self.FKtype,
                          @"content":self.FKcontent,
                          };
    NSLog(@"dict=== %@",dict);
    
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,PostCreateFeedback] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary * dict = (NSDictionary *)responseObject;
        NSString * strTime = [dict objectForKey:@"create_time"];
        
        if(statusCode==200)
        {
           if(strTime!=nil)
           {
               [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Feedback successful!", @"Language") andDelay:2.5];
               for (UIViewController *controller in self.navigationController.viewControllers) {
                   if ([controller isKindOfClass:[MyAccountViewController class]]) {
                       
                       [self.navigationController popViewControllerAnimated:NO];
                   }
               }
           }else
           {
               [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
           }
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}



@end
