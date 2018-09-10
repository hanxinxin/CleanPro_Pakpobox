//
//  ViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeGenerateVC.h"
#import "WBQRCodeScanningVC.h"
#import "WCQRCodeScanningVC.h"
#import "LoginViewController.h"
#import "PingLunCollectionViewCell.h"
#import "XLCardSwitchFlowLayout.h"
#import "PriceHomeViewController.h"
#import "locationMapViewController.h"
#import "PromotionViewController.h"

#define kMyCollectionViewCellID @"PingLunCollectionViewCell"

@interface HomeViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView * down_topxView;
    UIView * down_downxView;
    UIView * commentListView;
    UICollectionView *collectionView_L;
}
@property (nonatomic, strong) UIScrollView *Down_Scroller;
@property (nonatomic ,retain) UIPageControl * myPageControl;
@property (nonatomic, weak)NSTimer* rotateTimer;  //让视图自动切换
@end

@implementation HomeViewController
@synthesize GG_Scroller,Down_Scroller;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    //启动定时器
    self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    if (@available(iOS 11.0, *)) {
        GG_Scroller.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏导航栏
    //    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:2.0 sinceDate:[NSDate date]]];
//    self.tabBarController.tabBar.hidden = NO;
//    [self.navigationController.tabBarController.tabBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=@"Cleapro";
    self.navigationController.title=@"Home";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
        if(Down_Scroller!=nil)
        {
            [Down_Scroller removeFromSuperview];
        }
    [self addDownScroller];
    [self add_viewCSH];
    [self Add_commentListView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSLog(@"高度：%f",SCREEN_HEIGHT);
        NSString* TokenError=[[NSUserDefaults standardUserDefaults] objectForKey:@"TokenError"];
        if([TokenError isEqualToString:@"1"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"101" forKey:@"TokenError"];
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *vc=[main instantiateViewControllerWithIdentifier:@"LoginViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    });

//        NSLog(@"selectedIndex = %lu",self.tabBarController.selectedIndex);
//    for (int i =0; i<100; i++) {
//        NSLog(@"19的 %d次方等于 %f",i,pow(19, i));
//    }
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    [self.rotateTimer setFireDate:[NSDate distantFuture]];
    [self.rotateTimer fire];
    [super viewWillDisappear:animated];
}
-(void)add_viewCSH
{
    [self addScrollerView];
    [self add_btnView];
}
/////  加载全局ScrollerView
-(void)addDownScroller
{
    //    NSLog(@"iphoenX= %f,%f",self.view.width,self.view.height);
    //    375.000000,812.000000
    if(self.view.width==375 && self.view.height==812)
    {
        //设置滚动范围
        Down_Scroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+20, self.view.width, self.view.height)];
    }else if(self.view.width==320.f && self.view.height==568.f)
    {
        //设置滚动范围
        Down_Scroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, SCREEN_HEIGHT)];
        Down_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 590.f);
    }else if(self.view.width==375.f && self.view.height==667.f)
    {
        //设置滚动范围
        Down_Scroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, SCREEN_HEIGHT)];
        Down_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 667);
    }else{
        //设置滚动范围
        Down_Scroller =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, SCREEN_HEIGHT)];
        Down_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 736.f);
    }
    //设置分页效果
    //    Down_Scroller.pagingEnabled = YES;
    //水平滚动条隐藏
    Down_Scroller.scrollEnabled = YES;
    Down_Scroller.showsHorizontalScrollIndicator = NO;
    Down_Scroller.showsVerticalScrollIndicator = NO;
    
    
}

-(void)add_btnView
{
    down_topxView=[[UIView alloc] init];
    if(self.view.width==320.f && self.view.height==568.f)
    {
       down_topxView.frame=CGRectMake(0, GG_Scroller.height+15*autoSizeScaleX, SCREEN_WIDTH, 150*autoSizeScaleX);
    }else if(self.view.width==375.f && self.view.height==667.f)
    {
        down_topxView.frame=CGRectMake(0, GG_Scroller.height+15*autoSizeScaleX, SCREEN_WIDTH, 155*autoSizeScaleX);
    }else{
    down_topxView.frame=CGRectMake(0, GG_Scroller.height+15*autoSizeScaleX, SCREEN_WIDTH, 170*autoSizeScaleX);
    }
    down_topxView.backgroundColor=[UIColor whiteColor];
    UILabel * xian_lable=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-1)/2, 0, 1, down_topxView.height)];
    xian_lable.backgroundColor=[UIColor colorWithRed:229.5/255.0 green:229.5/255.0 blue:229.5/255.0 alpha:1];
    UIButton * tt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tt1.userInteractionEnabled=YES;
//    [tt1 setBackgroundColor:[UIColor lightGrayColor]];
//        [tt1 setBackgroundImage:[UIImage imageNamed:@"Laundry"] forState:UIControlStateNormal];
    [tt1 setImage:[UIImage imageNamed:@"Laundry"] forState:UIControlStateNormal];
    [tt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tt1.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    tt1.titleLabel.textAlignment=NSTextAlignmentCenter;
    [tt1 addTarget:self action:@selector(btnXiYi:) forControlEvents:UIControlEventTouchDown];
//    [tt1 setTitle:@"Laundry" forState:UIControlStateNormal];
    UIButton * tt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    if(self.view.width==320.f && self.view.height==568.f)
    {
        tt1.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4, 10*autoSizeScaleX, 80*autoSizeScaleX, 110*autoSizeScaleY);
        tt2.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4*3+80*autoSizeScaleX, 10*autoSizeScaleX, 80*autoSizeScaleX, 110*autoSizeScaleY);
    }else if(self.view.width==375 && self.view.height==812)
    {
        tt1.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4, 10*autoSizeScaleX, 85*autoSizeScaleX, 120);
        tt2.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4*3+80*autoSizeScaleX, 10*autoSizeScaleX, 85*autoSizeScaleX, 120);
    }else if(self.view.width==375 && self.view.height==667)
    {
        tt1.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4, 10*autoSizeScaleX, 85*autoSizeScaleX, 100);
        tt2.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4*3+80*autoSizeScaleX, 10*autoSizeScaleX, 85*autoSizeScaleX, 100);
    }else if(self.view.width==414.f && self.view.height==736)
    {
        tt1.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4, 15*autoSizeScaleX, 85*autoSizeScaleX, 120);
        tt2.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4*3+80*autoSizeScaleX, 15*autoSizeScaleX, 85*autoSizeScaleX, 120);
    }else{
        tt1.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4, 10*autoSizeScaleX, 80*autoSizeScaleX, 140*autoSizeScaleY);
        tt2.frame=CGRectMake((SCREEN_WIDTH-160*autoSizeScaleX)/4*3+80*autoSizeScaleX, 10*autoSizeScaleX, 80*autoSizeScaleX, 140*autoSizeScaleY);
    }
    
    
    tt2.userInteractionEnabled=YES;
    //    [tt2 setBackgroundImage:[UIImage imageNamed:@"icon_Dryer"] forState:UIControlStateNormal];
    [tt2 setImage:[UIImage imageNamed:@"icon_Dryer"] forState:UIControlStateNormal];
    tt1.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    tt2.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    [tt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tt2.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    tt2.titleLabel.textAlignment=NSTextAlignmentCenter;
    [tt2 addTarget:self action:@selector(btnHongGan:) forControlEvents:UIControlEventTouchDown];
//    [tt2 setTitle:@"Dryer" forState:UIControlStateNormal];
    UILabel * tt1_label=[[UILabel alloc] initWithFrame:CGRectMake(tt1.left, tt1.bottom, tt1.width, 16) ];
    [tt1_label setText:@"Laundry"];
    [tt1_label setTextColor:[UIColor blackColor]];
    tt1_label.textAlignment=NSTextAlignmentCenter;
    [tt1_label setFont:[UIFont systemFontOfSize:14.f]];
     UILabel * tt2_label=[[UILabel alloc] initWithFrame:CGRectMake(tt2.left, tt2.bottom, tt2.width, 16) ];
    [tt2_label setText:@"Dryer"];
    [tt2_label setTextColor:[UIColor blackColor]];
    tt2_label.textAlignment=NSTextAlignmentCenter;
    [tt2_label setFont:[UIFont systemFontOfSize:14.f]];
    [down_topxView addSubview:xian_lable];
    [down_topxView addSubview:tt1];
    [down_topxView addSubview:tt2];
    [down_topxView addSubview:tt1_label];
    [down_topxView addSubview:tt2_label];
    //    [Down_Scroller addSubview:tt1];
    //    [Down_Scroller addSubview:tt2];
    [Down_Scroller addSubview:down_topxView];
    [self.view addSubview:Down_Scroller];
    
    Down_Scroller.tag = 2000;
    down_downxView=[[UIView alloc] init];
    down_downxView.frame=CGRectMake(0,(down_topxView.bottom+15*autoSizeScaleX), SCREEN_WIDTH, 100*autoSizeScaleX);
    down_downxView.backgroundColor=[UIColor whiteColor];
    for (int i = 0; i< 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton * tt3 = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btn_tttw= 55*autoSizeScaleX;
        CGFloat btn_width = (SCREEN_WIDTH-(btn_tttw*4))/5;
        CGFloat btn_tttw1= 65*autoSizeScaleX;
        CGFloat btn_width1 = (SCREEN_WIDTH-(btn_tttw1*4))/5;
        if(self.view.width==375 && self.view.height==812)
        {
            button.frame=CGRectMake(btn_width*(i+1)+btn_tttw*i, (12*autoSizeScaleX), btn_tttw, btn_tttw);
            tt3.frame=CGRectMake(btn_width1*(i+1)+btn_tttw1*i, (12*autoSizeScaleX+btn_tttw), btn_tttw1+4, 25);
        }else if(self.view.width==320.f && self.view.height==568.f)
        {
            button.frame=CGRectMake(btn_width*(i+1)+btn_tttw*i, (12*autoSizeScaleX), btn_tttw, btn_tttw);
            tt3.frame=CGRectMake(btn_width1*(i+1)+btn_tttw1*i-2, (12*autoSizeScaleX+btn_tttw), btn_tttw1+4, 25);
        }else if(self.view.width==375.f && self.view.height==667.f)
        {
            button.frame=CGRectMake(btn_width*(i+1)+btn_tttw*i, (12*autoSizeScaleX), btn_tttw, btn_tttw);
            tt3.frame=CGRectMake(btn_width1*(i+1)+btn_tttw1*i, (12*autoSizeScaleX+btn_tttw), btn_tttw1+4, 25);
        }else
        {
            button.frame=CGRectMake(btn_width*(i+1)+btn_tttw*i, (12*autoSizeScaleX), btn_tttw, btn_tttw);
            tt3.frame=CGRectMake(btn_width1*(i+1)+btn_tttw1*i, (12*autoSizeScaleX+btn_tttw), btn_tttw1+4, 25);
        }
        
        if (i==0) {
            [button setBackgroundImage:[UIImage imageNamed:@"icon_service"] forState:UIControlStateNormal];
            [tt3 setTitle:FGGetStringWithKeyFromTable(@"Service", @"Language") forState:UIControlStateNormal];
        }else if (i==1)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
            [tt3 setTitle:FGGetStringWithKeyFromTable(@"Location", @"Language") forState:UIControlStateNormal];
        }
        else if (i==2)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"icon_price"] forState:UIControlStateNormal];
            [tt3 setTitle:FGGetStringWithKeyFromTable(@"Price", @"Language") forState:UIControlStateNormal];
        }
        else if (i==3)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"icon_promotion"] forState:UIControlStateNormal];
            [tt3 setTitle:FGGetStringWithKeyFromTable(@"Promotion", @"Language") forState:UIControlStateNormal];
        }
        button.tag=i;
        tt3.tag=i;
        //        [button setBackgroundColor:[UIColor redColor]];
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
        tt3.titleLabel.textAlignment=NSTextAlignmentCenter;
        //        button.titleEdgeInsets = UIEdgeInsetsMake(0,0,-85,0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [tt3.titleLabel setFont:[UIFont systemFontOfSize:11.f]];
        [button addTarget:self action:@selector(btn_list:) forControlEvents:UIControlEventTouchDown];
        [tt3 addTarget:self action:@selector(btn_list:) forControlEvents:UIControlEventTouchDown];
        //        [Down_Scroller addSubview:button];
        //        [Down_Scroller addSubview:tt3];
        [down_downxView addSubview:button];
        [down_downxView addSubview:tt3];
        [Down_Scroller addSubview:down_downxView];
    }
}


-(void)btnXiYi:(id)sender
{
    WCQRCodeScanningVC *WCVC = [[WCQRCodeScanningVC alloc] init];
    WCVC.hidesBottomBarWhenPushed = YES;
    WCVC.tag_int=1;
    [self QRCodeScanVC:WCVC];
    
}
-(void)btnHongGan:(id)sender
{
    //    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Coming soon", @"Language") andDelay:2.0];
//    WBQRCodeScanningVC *WBVC = [[WBQRCodeScanningVC alloc] init];
//    WBVC    .hidesBottomBarWhenPushed = YES;
//    [self QRCodeScanVC:WBVC];
    WCQRCodeScanningVC *WCVC = [[WCQRCodeScanningVC alloc] init];
    WCVC.hidesBottomBarWhenPushed = YES;
    WCVC.tag_int=2;
    [self QRCodeScanVC:WCVC];
}
-(void)btn_list:(id)sender
{
    UIButton * btn=(UIButton*)sender;
    
    if(btn.tag==1)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        locationMapViewController *vc=[main instantiateViewControllerWithIdentifier:@"locationMapViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(btn.tag==2)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PriceHomeViewController *vc=[main instantiateViewControllerWithIdentifier:@"PriceHomeViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(btn.tag==3)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PromotionViewController *vc=[main instantiateViewControllerWithIdentifier:@"PromotionViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)Add_commentListView
{
    commentListView =[[UIView alloc] init];
    commentListView.frame=CGRectMake(0, down_downxView.bottom+15*autoSizeScaleX, SCREEN_WIDTH, 120);
    commentListView.backgroundColor=[UIColor whiteColor];
    UIImageView * backgrounImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, commentListView.width, commentListView.height)];
    backgrounImage.image=[UIImage imageNamed:@"hp_img"];
    [commentListView addSubview:backgrounImage];
//    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
////    layout.itemSize = CGSizeMake(SCREEN_WIDTH-(43*2), 100);
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
////    layout.minimumLineSpacing = 43;
//    // 设置第一个cell和最后一个cell,与父控件之间的间距
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 43, 0, 43);
//    collectionView_L = [[UICollectionView alloc]initWithFrame:CGRectMake(43, 9, SCREEN_WIDTH-(43*2),100) collectionViewLayout:layout];
    XLCardSwitchFlowLayout *flowLayout = [[XLCardSwitchFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    collectionView_L = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 9, SCREEN_WIDTH,100) collectionViewLayout:flowLayout];
    collectionView_L.backgroundColor = [UIColor clearColor];
    collectionView_L.delegate = self;
    collectionView_L.dataSource = self;
//    collectionView_L.scrollsToTop = NO;
    collectionView_L.tag=12000;
    collectionView_L.showsVerticalScrollIndicator = NO;
    collectionView_L.showsHorizontalScrollIndicator = NO;
    NSInteger selectedIndex = 5;//设置默认选中为第几个
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [collectionView_L scrollToItemAtIndexPath:selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [collectionView_L registerNib:[UINib nibWithNibName:@"PingLunCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kMyCollectionViewCellID];
    [commentListView addSubview:collectionView_L];
    [Down_Scroller addSubview:commentListView];
    
    
    [collectionView_L reloadData];
}


/**
 创建滚动轮播图
 */
-(void)addScrollerView
{
    //设置滚动范围
    if(self.view.width==375 && self.view.height==812)
    {
        GG_Scroller.frame=CGRectMake(0, 0, SCREEN_WIDTH, 190);
    }else if(self.view.width==320.f && self.view.height==568.f)
    {
        GG_Scroller.frame=CGRectMake(0, 0, SCREEN_WIDTH, 180*autoSizeScaleX);
    }else if(self.view.width==375.f && self.view.height==667.f)
    {
        GG_Scroller.frame=CGRectMake(0, 0, SCREEN_WIDTH, 180*autoSizeScaleX);
    }else{
        GG_Scroller.frame=CGRectMake(0, 0, SCREEN_WIDTH, 180*autoSizeScaleX);
    }
    
    
//    GG_Scroller.frame=CGRectMake(0, 0, SCREEN_WIDTH, 180*autoSizeScaleX);
    
    //设置分页效果
    GG_Scroller.pagingEnabled = YES;
    //    GG_Scroller.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
    //    GG_Scroller.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);//设置边框颜色
    //    GG_Scroller.layer.borderWidth = 1.0f;//设置边框颜色
    //水平滚动条隐藏
    GG_Scroller.showsHorizontalScrollIndicator = NO;
    //// 给Scroller加一个点击手势
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    tap.numberOfTapsRequired = 1;
    [GG_Scroller addGestureRecognizer:tap];
    

        GG_Scroller.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*4, CGRectGetHeight(self.GG_Scroller.frame));
        //添加三个子视图  UILabel类型
        for (int i = 0; i< 4; i++) {
            UIImageView *imagView = [[UIImageView alloc]init];  imagView.frame=CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.GG_Scroller.frame.size.height);
            if(i==0)
            {
                imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner_1"]];
            }else
            {
                imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner_1"]];
            }
            //        [imagView setContentMode:UIViewContentModeCenter];
            
            //        imagView.clipsToBounds = YES;
            [imagView setClipsToBounds:NO];
            
            [imagView setContentMode:UIViewContentModeRedraw];
            
            [GG_Scroller addSubview:imagView];
            [self.view addSubview:GG_Scroller];
            GG_Scroller.tag = 1000;
            //    X= 375.000000,812.000000
            //    NSLog(@"X= %f,%f",self.view.frame.size.width,self.view.frame.size.height);
            if((self.view.frame.size.width==375) && (self.view.frame.size.height==812))
            {
                self.myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.GG_Scroller.frame)-50+64+20, CGRectGetWidth(self.view.frame), 50)];
            }else
            {
                self.myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 180*autoSizeScaleX-40+64, CGRectGetWidth(self.view.frame), 50)];
            }
            self.myPageControl.numberOfPages = 4;
            self.myPageControl.currentPage = 0;
            self.myPageControl.userInteractionEnabled=NO;
//            self.myPageControl.pageIndicatorTintColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];        //设置未激活的指示点颜色
            self.myPageControl.pageIndicatorTintColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1]; 
            self.myPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];     //设置当前页指示点颜色
            //    self.myPageControl.g
            [self.view addSubview:self.myPageControl];
            //    [GG_Scroller addSubview:self.myPageControl];
            
            //为滚动视图指定代理
            GG_Scroller.delegate = self;
            self.myPageControl.hidden=YES;
    }
    
    
    [Down_Scroller addSubview:GG_Scroller];
    [Down_Scroller addSubview:self.myPageControl];
}
#pragma mark -- 滚动视图的代理方法
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//        NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    
    
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
//        NSLog(@"Begin   X= %f,Y= %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if(scrollView.tag==1000)
    {
        [self.rotateTimer setFireDate:[NSDate distantFuture]];
    }
//    else  if(scrollView.tag==12000)
//    {
//        collectionView_L.alpha=0.8;
//    }
    
}

//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//        NSLog(@"8888888");
//        NSLog(@"End    X= %f,Y= %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    //    NSLog(@"几倍？= %f",(scrollView.contentOffset.x)/(self.view.frame.size.width));
    if(scrollView.tag==1000)
    {
        self.myPageControl.currentPage =(int)(scrollView.contentOffset.x)/(self.view.frame.size.width);
        //视图静止之后，过1.5秒在开启定时器
        //    [NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]  返回值为从现在时刻开始 再过1.5秒的时刻。
//        NSLog(@"开启定时器");
        [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]];
    }
//    else  if(scrollView.tag==12000)
//    {
//        collectionView_L.alpha=1;
//    }
}


//定时器的回调方法   切换界面
- (void)changeView{

        //得到scrollView
        UIScrollView *scrollView = [self.view viewWithTag:1000];
        //通过改变contentOffset来切换滚动视图的子界面
        float offset_X = scrollView.contentOffset.x;
        //每次切换一个屏幕
        offset_X += CGRectGetWidth(self.view.frame);
        
        //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
        if (offset_X == CGRectGetWidth(self.view.frame)*4) {
            scrollView.contentOffset = CGPointMake(0, 0);
            offset_X = 0;
        }
        //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
        if (offset_X == CGRectGetWidth(self.view.frame)*4) {
            self.myPageControl.currentPage = 0;
        }else{
            self.myPageControl.currentPage = offset_X/CGRectGetWidth(self.view.frame);
        }
        
        //得到最终的偏移量
        CGPoint resultPoint = CGPointMake(offset_X, 0);
        //切换视图时带动画效果
        //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
        if (offset_X >CGRectGetWidth(self.view.frame)*4) {
            self.myPageControl.currentPage = 1;
            [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
        }else{
            [scrollView setContentOffset:resultPoint animated:YES];
        }
    
    
}
//点击
-(void)doTapChange:(UITapGestureRecognizer *)sender{
//    NSLog(@"点击了第%ld个",(long)self.myPageControl.currentPage);
}




/**
 扫描二维码 需要先检测相机

 @param scanVC UIViewController
 */
- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:scanVC animated:YES];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - Cleanpro] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PingLunCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:kMyCollectionViewCellID forIndexPath:indexPath];
        if (!cell ) {
            NSLog(@"cell为空,创建cell");
            cell = [[PingLunCollectionViewCell alloc] init];
           
        }
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    cell.tag=indexPath.row;
    [cell.name_label setText:[NSString stringWithFormat:@"Beckham%ld",(long)indexPath.row]];
//    NSLog(@"row==== %ld",indexPath.row);
    // 需要配置的代码
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    return cell;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    return CGSizeMake(75, 40);
    return CGSizeMake(SCREEN_WIDTH-(43*2), 100);
}
#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"点击：%ld",(long)indexPath.row);
    PingLunCollectionViewCell * cell = (PingLunCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [UIView animateWithDuration:0.1 animations:^{
            cell.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                //这里实现点击cell后要实现的内容
            }];
        }];
        
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
       NSLog(@"CCCCC：%ld",(long)indexPath.row);
    
    
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




@end
