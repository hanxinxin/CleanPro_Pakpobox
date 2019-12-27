//
//  ConnectFeedViewController.m
//  Cleanpro
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ConnectFeedViewController.h"
#import "TopCollectionViewCell.h"
#import "LaundrySuccessViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "MyAccountViewController.h"
#import "PhotoCollectionViewCell.h"
#import "ZGQActionSheetView.h"
#import "WCQRCodeScanningVC.h"
#import "AppDelegate.h"

#define CollectionViewCellID @"TopCollectionViewCell"
#define CollectionViewCellID1 @"PhotoCollectionViewCell"
#define cout_Number 15

@interface ConnectFeedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZGQActionSheetViewDelegate>
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
@property (nonatomic,strong)NSMutableArray * imageViewArr;
@property (nonatomic,strong)NSMutableArray * refundIDArr;

//refundReason

@end

@implementation ConnectFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=FGGetStringWithKeyFromTable(@"Refund", @"Language");;
    
    collectionArray=[NSMutableArray arrayWithCapacity:0];
    self.imageViewArr = [NSMutableArray arrayWithCapacity:0];
    self.refundIDArr = [NSMutableArray arrayWithCapacity:0];
//    [collectionArray addObject:@[@"Laundry",@"Dryer",@"Price",@"Quality",@"Use Process",@"Others"]];
    [collectionArray addObject:@[FGGetStringWithKeyFromTable(@"Machine can't start", @"Language"),FGGetStringWithKeyFromTable(@"Failed on machine", @"Language"),FGGetStringWithKeyFromTable(@"Others", @"Language")]];
    [self.Amount_label setText:FGGetStringWithKeyFromTable(@"Select an option", @"Language")];
    [self.Submit_btn setTitle:FGGetStringWithKeyFromTable(@"Confirm", @"Language") forState:(UIControlStateNormal)];
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.loginName = self.ModeUser.loginName;
    self.Submit_btn.layer.cornerRadius = 4;//2.0是圆角的弧度，根据需求自己更改
    self.Submit_btn.layer.borderWidth = 0.f;//设置边框颜色
    self.feedback_textView.layer.cornerRadius = 4;//2.0是圆角的弧度，根据需求自己更改
    self.feedback_textView.layer.borderColor = [UIColor colorWithRed:225/255.0 green:229/255.0 blue:230/255.0 alpha:1].CGColor;//设置边框颜色
    self.feedback_textView.layer.borderWidth = 0.8f;//设置边框颜色
    self.feedback_textView.zw_placeHolder = FGGetStringWithKeyFromTable(@"Add a comment", @"Language");
    NSArray * arr = collectionArray[0];
    self.FKtype = arr[0];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addCollectionView];
        [self addTableView];
    });
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self addtextPhone];
    
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
    CGFloat offset = (self.titleTableMS.top+self.titleTableMS.height+kbHeight) - (self.view.frame.size.height);
    
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
//            self.view.frame = [UIScreen mainScreen].bounds;
            self.view.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    }];
}


-(void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 20;
    // 每一列cell之间的间距
    // flowLayout.minimumInteritemSpacing = 10;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12*autoSizeScaleX, 0, 12*autoSizeScaleX);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if(self.view.frame.size.width==375.000000&& self.view.frame.size.height==812.000000)
    {
        self.collectionView.frame=CGRectMake(0, self.Amount_label.bottom+10, SCREEN_WIDTH, 80);
    }else
    {
        self.collectionView.frame=CGRectMake(0, self.Amount_label.bottom+10, SCREEN_WIDTH, 80);
    }
    self.collectionView.collectionViewLayout=flowLayout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.tag=1000;
    //    NSLog(@"self.ListCollectionView= %@",self.ListCollectionView);
    //水平滚动条隐藏
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    self.topCollection.allowsMultipleSelection = NO;
    NSInteger selectedIndex = 0;//设置默认选中为第几个
    moren_cell=0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TopCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CollectionViewCellID];
    
}

-(void)addTableView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置UICollectionView为横向滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 每一行cell之间的间距
        flowLayout.minimumLineSpacing = 20;
        // 每一列cell之间的间距
        // flowLayout.minimumInteritemSpacing = 10;
        // 设置第一个cell和最后一个cell,与父控件之间的间距
    //    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12*autoSizeScaleX, 0, 12*autoSizeScaleX);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if(self.view.frame.size.width==375.000000&& self.view.frame.size.height==812.000000)
        {
            self.PhotoListTable.frame=CGRectMake(0, self.titleTableMS.bottom+8, SCREEN_WIDTH, 100);
        }else
        {
            self.PhotoListTable.frame=CGRectMake(0, self.titleTableMS.bottom+8, SCREEN_WIDTH, 100);
        }
    
        self.PhotoListTable.collectionViewLayout=flowLayout;
        self.PhotoListTable.backgroundColor = [UIColor clearColor];
        self.PhotoListTable.dataSource = self;
        self.PhotoListTable.delegate = self;
        self.PhotoListTable.tag=1200;
        //    NSLog(@"self.ListCollectionView= %@",self.ListCollectionView);
        //水平滚动条隐藏
        self.PhotoListTable.showsHorizontalScrollIndicator = NO;
        //    self.topCollection.allowsMultipleSelection = NO;
        [self.PhotoListTable registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CollectionViewCellID1];
//    [self.view addSubview:self.PhotoListTable];
}
- (IBAction)Submit_touch:(id)sender {
    if(self.imageViewArr.count>0)
    {
        if(self.feedback_textView.text!=nil)
        {
            if(self.FKtype!=nil)
            {
                [self.refundIDArr removeAllObjects];
                for (int i=0; i<self.imageViewArr.count; i++) {
                    
                    [self postUploadHeadImage:self.imageViewArr[i]];
//                    [self postUploadHeadImage:self.imageViewArr];
                }
            }
            
        }
    }
    /*
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WCQRCodeScanningVC class]]) {
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate.appdelegate1 closeConnected];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.ManagerBLE closeConnected];
            [appDelegate hiddenFCViewNO];
            [self.navigationController popToViewController:temp animated:YES];
            
        }
    }
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MyAccountViewController class]]) {
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate.appdelegate1 closeConnected];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.ManagerBLE closeConnected];
            [appDelegate hiddenFCViewNO];
            [self.navigationController popToViewController:temp animated:YES];
            ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
        }
    }
     */
}
/*
// 点击back按钮后调用 引用的他人写的一个extension
- (BOOL)navigationShouldPopOnBackButton {
    NSLog(@"重置密码返回啦");
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WCQRCodeScanningVC class]]) {
//            [Manager.inst disconnect];
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate.appdelegate1 closeConnected];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.ManagerBLE closeConnected];
            [self.navigationController popToViewController:temp animated:YES];
            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
            
        }
    }

    return YES;
}
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    NSLog(@"tagggggg2--===== %ldcoount =%ld",collectionView.tag,collectionArray.count);
    if(collectionView.tag==1000)
    {
        return collectionArray.count;
    }else if(collectionView.tag==1200)
    {
        return 1;
    }
    return 0;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"tagggggg1--===== %ld   coount =%ld",collectionView.tag,((NSArray*)collectionArray[section]).count);
    if(collectionView.tag==1000)
    {
        return ((NSArray*)collectionArray[section]).count;
    }else if(collectionView.tag==1200)
    {
        if(self.imageViewArr.count==0)
        {
            return 1;
        }else
        {
            if(self.imageViewArr.count<3)
            {
                return self.imageViewArr.count+1;
            }else{
                return self.imageViewArr.count;
            }
        }
    }
     return 0;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"tagggggg--===== %ld",collectionView.tag);
    if(collectionView.tag==1000)
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
    cell_coll.title_lable.titleLabel.numberOfLines = 0;
    if(indexPath.row==moren_cell)
    {
        [cell_coll.title_lable setTitleColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        cell_coll.layer.borderColor =[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1].CGColor;
    }else
    {
        [cell_coll.title_lable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    cell_coll.layer.cornerRadius = 8;//2.0是圆角的弧度，根据需求自己更改
    
    cell_coll.layer.borderWidth = 1.f;//设置边框颜色
    
    //    cell.selectedBackgroundView=[[UIView alloc] initWithFrame:cell.bounds];
    //    cell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:15/255.0 green:180/255.0 blue:146/255.0 alpha:1];
    return cell_coll;
        
    }else if(collectionView.tag==1200)
    {
            PhotoCollectionViewCell* cell1 =  [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID1 forIndexPath:indexPath];
                if (!cell1 ) {
                    NSLog(@"cell为空,创建cell");
                    cell1 = [[PhotoCollectionViewCell alloc] init];
                    
                }
NSLog(@"select111 ==== %ld,%ld",(long)indexPath.row,(long)indexPath.section);
        if(self.imageViewArr.count==0)
        {
            cell1.Imagephoto.image = [UIImage imageNamed:@"tianjiantupian"];
        }else
        {
            if(self.imageViewArr.count<3)
            {
                if(indexPath.row<=(self.imageViewArr.count-1))
                {
                    cell1.Imagephoto.image = self.imageViewArr[indexPath.row];
                }else
                {
                    cell1.Imagephoto.image = [UIImage imageNamed:@"tianjiantupian"];
                }
            }else{
                cell1.Imagephoto.image = self.imageViewArr[indexPath.row];
            }
        }
        return cell1;
        }
    return nil;
}




#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击：%ld",(long)indexPath.row);
    if(collectionView.tag==1000)
    {
    
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
            [cell.title_lable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cell.layer.borderColor =[UIColor lightGrayColor].CGColor;
            cell.selected=NO;
        }
        
    }
        
        
    }else if(collectionView.tag==1200)
        {
//            if
            NSLog(@"select ==== %ld,%ld",(long)indexPath.row,(long)indexPath.section);
                if(self.imageViewArr.count==0)
                {
                    [self openSuccWith:@"AV"];
                }else
                {
                    if(self.imageViewArr.count<3)
                    {
                        if(indexPath.row<=(self.imageViewArr.count-1))
                        {
                            [self setSelectImage:indexPath.row+200];
                        }else
                        {
                            [self openSuccWith:@"AV"];
                        }
                    }else{
                        [self setSelectImage:indexPath.row+200];
                    }
                }
            
        }
    
}

-(void)setSelectImage:(NSInteger)SelectTag
{
    NSArray *optionArray = @[FGGetStringWithKeyFromTable(@"Delete", @"Language")];
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray];
    sheetView.tag=SelectTag;
    sheetView.delegate = self;
    [sheetView show];
}

- (void)ZGQActionSheetView:(ZGQActionSheetView *)sheetView didSelectRowAtIndex:(NSInteger)index text:(NSString *)text {
    NSLog(@"%zd,%@",index,text);
    
        if (index==0) {
            [self.imageViewArr removeObjectAtIndex:(sheetView.tag-200)];
            [self.PhotoListTable reloadData];
        }
}

#pragma mark 设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==1000){
        
    return CGSizeMake((SCREEN_WIDTH-(20*4))/3, 60*autoSizeScaleX);
    }else if(collectionView.tag==1200)
    {
      return CGSizeMake(100, 100);
    }
    return CGSizeMake(0, 0);
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
    __block ConnectFeedViewController *  blockSelf = self;
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


// 打开相机/相册
- (void)openSuccWith:(NSString *)flag{
    
    UIImagePickerController *photoPicker = [UIImagePickerController new];
    photoPicker.delegate = self;
    photoPicker.allowsEditing = NO;
    
    if ([flag isEqualToString:@"AV"]) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    if ([flag isEqualToString:@"PH"]) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:photoPicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
//相机选的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 关闭相册\相机
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"MMMM= %@",info[UIImagePickerControllerOriginalImage]);
  
//    [self postUploadHeadImage:];
//    [ConnectFeedViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200]
    [self.imageViewArr addObject:[ConnectFeedViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200]];
    [self.PhotoListTable reloadData];
}


+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

-(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>2*1024*1024) {//2M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.05);
        }else if (data.length>1024*1024) {//1M-2M
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.4);
        }
    }
    return data;
}






-(void)postUploadHeadImage:(UIImage *)image
//-(void)postUploadHeadImage:(NSArray *)arr
{
        
        [HudViewFZ labelExample:self.view];
//        NSDictionary * dict=@{@"file":gender,};
//        NSLog(@"dict=== %@",dict);
    NSArray * arr = [NSArray arrayWithObjects:image, nil];
    
    
    [[AFNetWrokingAssistant shareAssistant] uploadImagesWihtImgArr:arr url:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_refund_Image] Tokenbool:YES parameters:nil block:^(id objc, BOOL success) {
        NSLog(@"objc=====  %@",objc);
        NSDictionary *dict= (NSDictionary*)objc;
        NSString * idStr = [dict objectForKey:@"id"];
//        NSString * displayName = [dict objectForKey:@"displayName"];
        
        if(idStr!=nil)
        {
//            [HudViewFZ HiddenHud];
            [self.refundIDArr addObject:idStr];
            if(self.refundIDArr.count == self.imageViewArr.count)
            {
                [self post_refund_feed:self.refundIDArr];
            }
        }else
        {
            if(success==NO)
            {
                [HudViewFZ HiddenHud];
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }
 
                NSString * strResult = [dict objectForKey:@"errorMessage"];
                [HudViewFZ HiddenHud];
                [HudViewFZ showMessageTitle:strResult andDelay:2.0];
        }
    }blockprogress:^(id progress) {
        
    }];
}

-(void)post_refund_feed:(NSMutableArray*)arr
{
    NSDictionary * dict =@{@"orderNo":self.orderidStr,
                           @"client_type":@"IOS",
                           @"refundReason":self.FKtype,
                           @"comment":self.feedback_textView.text,
                           @"pictureIds":arr
    };
    NSLog(@"dict ====  %@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_refund_apply] parameters:dict progress:^(id progress) {
            NSLog(@"111  %@",progress);
        } Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            NSLog(@"responseObject = %@",responseObject);
    //        [HudViewFZ HiddenHud];
            if(statusCode==200)
            {
                NSDictionary *dict= (NSDictionary*)responseObject;
                NSString * idStr = [dict objectForKey:@"id"];
                if(idStr!=nil)
                {
                    [self submit_Alt];
                }else
                {
                    NSString * strResult = [dict objectForKey:@"errorMessage"];
                    [HudViewFZ HiddenHud];
                    [HudViewFZ showMessageTitle:strResult andDelay:2.0];
                }
            }else
            {
                
                    [HudViewFZ HiddenHud];
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }
            
        } failure:^(NSInteger statusCode, NSError *error) {
            NSLog(@"3333   %@",error);
            [HudViewFZ HiddenHud];
            if(statusCode==401)
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Token expired", @"Language") andDelay:2.0];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
            }else{
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
                
            }
        }];
}


-(void)submit_Alt
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Submit Success" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
                                   if ([temp isKindOfClass:[WCQRCodeScanningVC class]]) {
                           //            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                           //            [appDelegate.appdelegate1 closeConnected];
                                       AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                       [appDelegate.ManagerBLE closeConnected];
                                       [appDelegate hiddenFCViewNO];
                                       [self.navigationController popToViewController:temp animated:YES];
                                       
                                   }
                               }
                               for (UIViewController *temp in self.navigationController.viewControllers) {
                                   if ([temp isKindOfClass:[MyAccountViewController class]]) {
                           //            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                           //            [appDelegate.appdelegate1 closeConnected];
                                       AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                       [appDelegate.ManagerBLE closeConnected];
                                       [appDelegate hiddenFCViewNO];
                                       [self.navigationController popToViewController:temp animated:YES];
                                       ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
                                   }
                               }
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
