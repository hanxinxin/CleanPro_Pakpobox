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
#import "Ipay.h"
#import "IpayPayment.h"

#import <AlipaySDK/AlipaySDK.h>

#import "APAuthInfo.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"

#import "WXApi.h"

#import "BraintreeCore.h"
#import "BraintreeDropIn.h"

#define CollectionViewCellID @"TopCollectionViewCell"
#define cout_Number 15

@interface RechargeViewController ()<PaymentResultDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{
    
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
@property (nonatomic, strong) IpayPayment *IPaypayment;
@property (nonatomic, strong) Ipay *paymentSdk;
@property (nonatomic, strong) UIView *paymentView;

@property (nonatomic, strong) NSString * payNumber;
@property (nonatomic, strong) NSMutableArray * collectionArray;
@end

@implementation RechargeViewController
@synthesize IPaypayment,collectionArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title=FGGetStringWithKeyFromTable(@"Reload", @"Language");
    self.Amount_label.text=FGGetStringWithKeyFromTable(@"Amount", @"Language");
    [self.pay_btn setTitle:FGGetStringWithKeyFromTable(@"Pay", @"Language") forState:(UIControlStateNormal)];
    collectionArray=[NSMutableArray arrayWithCapacity:0];
    
//    [collectionArray addObject:@[@"RM10",@"RM20",@"RM30",@"RM50",@"RM100"]];
//    self.payNumber = @"10";
    self.pay_btn.layer.cornerRadius = 4;//2.0是圆角的弧度，根据需求自己更改
    self.pay_btn.layer.borderWidth = 0.f;//设置边框颜色
    
    
}

-(NSString*)ReplacingStr:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"RM" withString:@""];
}
- (void)viewWillAppear:(BOOL)animated {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self get_pay_chongzhiyouhui];
        
    });
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    //    [backBtn setTintColor:[UIColor blackColor]];
//    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
//    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillDisappear:animated];
    
}

-(void)get_pay_chongzhiyouhui
{
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_pay_jine] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject ORder=  %@",responseObject);
//        NSDictionary * dictList=(NSDictionary *)responseObject;
//        NSArray * Array=[dictList objectForKey:@"resultList"];
        NSArray * Array = (NSArray *)responseObject;
        [self->collectionArray removeAllObjects];
        if(Array.count>0)
        {
            NSMutableArray * arr= [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<Array.count; i++) {
            
            NSDictionary * dict = (NSDictionary *)Array[i];
          payChongzhiListMode * mode = [[payChongzhiListMode alloc] init];
            mode.Chongzhiid = [dict objectForKey:@"id"];
            mode.name = [dict objectForKey:@"name"];
            mode.amount = [dict objectForKey:@"amount"];
            mode.giveAmount = [dict objectForKey:@"giveAmount"];
            mode.defaultSelect = [dict objectForKey:@"defaultSelect"];
            mode.createTime = [dict objectForKey:@"createTime"];
            mode.updateTime = [dict objectForKey:@"updateTime"];
            mode.description1 = [dict objectForKey:@"description"];
            [arr addObject:mode];
        }
            
            [self->collectionArray addObject:arr];
            
//            if(self.collectionView!=nil)
//            {
//                [self.collectionView reloadData];
//            }else{
                [self addCollectionView];
//            }
        }else
        {
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error ORder=  %@",error);
//        [self.tableView_top.mj_header endRefreshing];
    }];
}



-(void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 17*autoSizeScaleX;
    // 每一列cell之间的间距
     flowLayout.minimumInteritemSpacing = 8*autoSizeScaleX;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12*autoSizeScaleX, 0, 12*autoSizeScaleX);
//    collectionArray.count
    NSArray * arr = (NSArray*)collectionArray[0];
    if(self.view.frame.size.width==375.000000&& self.view.frame.size.height==812.000000)
    {
        
        self.collectionView.frame=CGRectMake(0, self.Amount_label.bottom+10, SCREEN_WIDTH, 60*(arr.count/3)+5*3);
        
    }else
    {
        self.collectionView.frame=CGRectMake(0, self.Amount_label.bottom+10, SCREEN_WIDTH, 60*(arr.count/3)+5*3);
    }
    
    self.collectionView.collectionViewLayout=flowLayout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //    NSLog(@"self.ListCollectionView= %@",self.ListCollectionView);
    //水平滚动条隐藏
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    self.topCollection.allowsMultipleSelection = NO;
    NSArray * arr1=self->collectionArray[0];
    BOOL sel = NO;
    for (int i = 0; i<arr1.count; i++) {
        payChongzhiListMode * mode = arr1[i];
        if([mode.defaultSelect integerValue]==1){
        NSInteger selectedIndex = [mode.defaultSelect integerValue];//设置默认选中为第几个
        self->moren_cell=selectedIndex;
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        self.payNumber = mode.amount;
            sel= YES;
        }
        if(i==arr1.count-1)
        {
            if(sel==NO)
            {
                payChongzhiListMode * mode1 = arr1[0];
            NSInteger selectedIndex = 0;//设置默认选中为第几个
            self->moren_cell=selectedIndex;
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            self.payNumber = mode1.amount;
            }
        }
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"TopCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CollectionViewCellID];
    [self.tisp_label setFrame:CGRectMake(16, self.collectionView.bottom+8, (self.view.width-16*2), 40)];
    [self.tisp_label setText:FGGetStringWithKeyFromTable(@"*There is no refundable after payment", @"Language")];
    [self.pay_btn setFrame:CGRectMake(16, self.tisp_label.bottom+50, self.tisp_label.width, 50)];
}


- (IBAction)pay_touch:(id)sender {
    
    ///5.21日屏蔽
//    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
//    SaveUserIDMode * ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    [self post_pay_chongzhi_touch:self.payNumber member_id:ModeUser.yonghuID];
    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Stay tuned", @"Language") andDelay:1.0];
    
    
////    ///// 用于测试PayPal支付页面
////    NSString *clientToken = @"CLIENT_TOKEN_FROM_SERVER";
////    [self showDropIn:clientToken];
}

-(void)post_pay_chongzhi_touch:(NSString*)amount member_id:(NSString*)member_id
{
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"member_id":member_id,//会员ID
                          @"amount":amount,//金额
                          @"client_type":@"IOS",//客户端类型 （ANDROID, IOS）
                          @"trade_type":@"RECHARGE",//(固定）RECHARGE：充值
                          @"pay_platform":@"IPAY88",//支付平台, IPAY88：IPAY88
                          @"pay_method":@"PAGE",//支付方式, (固定)PAGE
                          };
    
    NSLog(@"dict=== %@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_pay_chongzhi] parameters:dict progress:^(id progress) {
         NSLog(@"请求成功 = %@",progress);
    } Success:^(NSInteger statusCode, id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSString * statusCodeStr = [dictObject objectForKey:@"statusCode"];
        NSString * errorMessageStr = [dictObject objectForKey:@"errorMessage"];
        if(statusCode==200)
        {
            if(statusCodeStr!=nil && [statusCodeStr intValue]==0)
            {
            
            NSString * RefNo = [dictObject objectForKey:@"pay_req_no"];
            NSString * Url = [dictObject objectForKey:@"notify_url"];
            NSString * Remark = [dictObject objectForKey:@"pay_req_no"];
            
            [self push_IPay:RefNo UrlStr:Url Remark:Remark Amount:self.payNumber];
            }else
            {
                [HudViewFZ showMessageTitle:errorMessageStr andDelay:2.5];
            }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}



-(void)push_IPay:(NSString*)RefNo UrlStr:(NSString *)Url Remark:(NSString *)Remark Amount:(NSString *)Amount
{
    self.paymentSdk=nil;
    IPaypayment=nil;
    self.paymentSdk = [[Ipay alloc] init];
    self.paymentSdk.delegate = self;
    IPaypayment = [[IpayPayment alloc] init];
    [IPaypayment setPaymentId:@""];
    [IPaypayment setMerchantKey:@"KqeL5dOvy5"];
    [IPaypayment setMerchantCode:@"M13405"];
    [IPaypayment setRefNo:RefNo];
//    [IPaypayment setAmount:@"1.0"]; /////暂时先填写为1元
    [IPaypayment setAmount:Amount]; /////暂时先填写为1元
    [IPaypayment setCurrency:@"MYR"];
    [IPaypayment setProdDesc:@"Recharge"];
    [IPaypayment setUserName:@"John Woo"];
    [IPaypayment setUserEmail:@"johnwoo@yahoo.com"];
    [IPaypayment setUserContact:@"0123456789"];
    [IPaypayment setRemark:Remark];
    //    [IPaypayment setRemark:@"ORD11881"];
    [IPaypayment setLang:@"ISO-8859-1"];
    [IPaypayment setCountry:@"MY"];
    [IPaypayment setBackendPostURL:Url];
    self.paymentView = [self.paymentSdk checkout:IPaypayment];
    self.paymentView.frame = self.view.bounds;
    [self.view addSubview:self.paymentView];
    
}
#pragma mark ------- Ipay 代理
//付款成功
- (void)paymentSuccess:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withAuthCode:(NSString *)authCode
{
    NSLog(@"paymentSuccess = %@",refNo);
    [self.paymentView removeFromSuperview];
    [self pushView];
}
//付款失败
- (void)paymentFailed:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc
{
    NSLog(@"paymentFailed refNo= %@ ,transId = %@ ,amount  = %@ ,remark = %@ ,errDesc = %@ ,",refNo,transId,amount,remark,errDesc);
}
//// 取消付款
- (void)paymentCancelled:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc
{
    NSLog(@"paymentCancelled = %@",refNo);
}
//重新查询成功
- (void)requerySuccess:(NSString *)refNo withMerchantCode:(NSString *)merchantCode withAmount:(NSString *)amount withResult:(NSString *)result
{
    NSLog(@"requerySuccess = %@",refNo);
}
//重新查询失败
- (void)requeryFailed:(NSString *)refNo withMerchantCode:(NSString *)merchantCode withAmount:(NSString *)amount withErrDesc:(NSString *)errDesc
{
    NSLog(@"requeryFailed = %@",refNo);
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
    payChongzhiListMode * mode = ((NSArray*)collectionArray[indexPath.section])[indexPath.row];
//    [cell_coll.title_lable setTitle:[self ReplacingStr:mode.name] forState:UIControlStateNormal];
//    cell_coll.down_label.numberOfLines=0;
//    cell_coll.down_label.lineBreakMode = UILineBreakModeWordWrap;
//    cell_coll.down_label.textAlignment=NSTextAlignmentCenter;
    if(mode.giveAmount!=nil && mode.description1 !=nil)
    {
//        cell_coll.down_label.attributedText=[self settitleLabel:cell_coll.down_label topText:[self ReplacingStr:mode.name] downText:[NSString stringWithFormat:@"%.f",[mode.amount doubleValue]+[mode.giveAmount doubleValue]] tagG:0];
        cell_coll.down_label.attributedText=[self settitleLabel:cell_coll.down_label topText:[self ReplacingStr:mode.name] downText:@"" tagG:0];
    }else
    {
//        cell_coll.down_label.attributedText=[self settitleLabel:cell_coll.down_label topText:[self ReplacingStr:mode.name] downText:[NSString stringWithFormat:@""] tagG:0];
        cell_coll.down_label.attributedText=[self settitleLabel:cell_coll.down_label topText:[self ReplacingStr:mode.name] downText:@"" tagG:0];
    }
    if(indexPath.row==moren_cell)
    {
//        [cell_coll.title_lable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell_coll.down_label.attributedText=[self settitleLabel:cell_coll.down_label topText:[self ReplacingStr:mode.name] downText:[NSString stringWithFormat:@"%.f",[mode.amount doubleValue]+[mode.giveAmount doubleValue]] tagG:1];
        cell_coll.down_label.attributedText=[self settitleLabel:cell_coll.down_label topText:[self ReplacingStr:mode.name] downText:@"" tagG:1];
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        cell_coll.title_lable.frame=CGRectMake(0, 0, cell_coll.width, cell_coll.height);
        
    });
    
    cell_coll.backgroundColor=[UIColor whiteColor];
    cell_coll.tag=indexPath.row;
    cell_coll.layer.cornerRadius = 4;//2.0是圆角的弧度，根据需求自己更改
    cell_coll.layer.borderColor =[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1].CGColor;
    cell_coll.layer.borderWidth = 1.f;//设置边框颜色
    
    //    cell.selectedBackgroundView=[[UIView alloc] initWithFrame:cell.bounds];
    //    cell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:15/255.0 green:180/255.0 blue:146/255.0 alpha:1];
    return cell_coll;
}

-(NSMutableAttributedString *)settitleLabel:(UILabel*)Label topText:(NSString *)topText downText:(NSString *)downText tagG:(NSInteger)tagG
{
    Label.numberOfLines=0;
//    Label.lineBreakMode = UILineBreakModeWordWrap;
    [Label setTextAlignment:NSTextAlignmentCenter];
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第一段：placeholder
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",topText]];
    
    //    NSLog(@"%@",substring1.string);
    [SubStr1 appendAttributedString:substring1];
    NSRange rang1 =[SubStr1.string rangeOfString:SubStr1.string];
    //设置文字颜色
    if(tagG==0)
    {
        [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] range:rang1];
    }else
    {
        [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rang1];
    }
    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ArialMT" size:17] range:rang1];
    [string appendAttributedString:SubStr1];
    // 第一段：placeholder
    NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",downText]];
    [SubStr2 appendAttributedString:substring2];
    NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
    //设置文字颜色
    if(tagG==0)
    {
        [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:105/255.0 green:175/255.0 blue:220/255.0 alpha:1.0] range:rang2];
    }else
    {
        [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rang2];
    }
    
    [SubStr2 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:13] range:rang2];
    [string appendAttributedString:SubStr2];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:5];
//    Label.text = string.string;
//    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [Label.text length])];
    Label.attributedText=string;
    return string;
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
            cell.selected=YES;
            payChongzhiListMode * mode = arr[indexPath.row];
            self.payNumber = mode.amount;
//             cell.down_label.attributedText=[self settitleLabel:cell.down_label topText:[self ReplacingStr:mode.name] downText:[NSString stringWithFormat:@"%.f",[mode.amount doubleValue]+[mode.giveAmount doubleValue]] tagG:1];
            cell.down_label.attributedText=[self settitleLabel:cell.down_label topText:[self ReplacingStr:mode.name] downText:@"" tagG:1];
        }else
        {
            payChongzhiListMode * mode = arr[i];
//            cell.down_label.attributedText=[self settitleLabel:cell.down_label topText:[self ReplacingStr:mode.name] downText:[NSString stringWithFormat:@"%.f",[mode.amount doubleValue]+[mode.giveAmount doubleValue]] tagG:0];
            cell.down_label.attributedText=[self settitleLabel:cell.down_label topText:[self ReplacingStr:mode.name] downText:@"" tagG:0];
            cell.selected=NO;
        }
        
    }
    
}
#pragma mark 设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120*autoSizeScaleX, 60*autoSizeScaleX);
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
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    LaundrySuccessViewController *vc=[main instantiateViewControllerWithIdentifier:@"LaundrySuccessViewController"];
//    vc.hidesBottomBarWhenPushed = YES;
////    vc.order_c=self.order_c;
//    [self.navigationController pushViewController:vc animated:YES];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Tisp" message:@"Top-up success" preferredStyle:UIAlertControllerStyleActionSheet];
    
    /*
     typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
     UIAlertActionStyleDefault = 0,
     UIAlertActionStyleCancel,         取消按钮
     UIAlertActionStyleDestructive     破坏性按钮，比如：“删除”，字体颜色是红色的
     } NS_ENUM_AVAILABLE_IOS(8_0);
     
     */
    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了按钮1，进入按钮1的事件");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [self presentViewController:actionSheet animated:YES completion:nil];
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






#pragma mark   ==============点击订单模拟支付行为==============
//
// 选中商品调用支付宝极简支付
//
- (void)doAPPay
{
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"缺少appId或者私钥,请检查参数设置"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{ }];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}
#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}






#pragma mark 微信支付方法
- (void)WXPay:(NSDictionary*)DictOder{
    NSString * appid = [DictOder objectForKey:@"appid"];
//    NSString * device_info = [DictOder objectForKey:@"device_info"];
    NSString * partnerid = [DictOder objectForKey:@"partnerid"];
    NSString * noncestr = [DictOder objectForKey:@"noncestr"];
    NSString * prepayid = [DictOder objectForKey:@"prepayid"];
//    NSString * result_code = [DictOder objectForKey:@"result_code"];
    NSString * package = [DictOder objectForKey:@"package"];
//    NSString * return_msg = [DictOder objectForKey:@"return_msg"];
    NSString * sign = [DictOder objectForKey:@"sign"];
//    NSString * trade_type = [DictOder objectForKey:@"trade_type"];
     NSString * timestamp = [DictOder objectForKey:@"timestamp"];
//     NSString * trade_type = [DictOder objectForKey:@"trade_type"];
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = appid;
    
    // 商家id，在注册的时候给的
    req.partnerId = partnerid;
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = prepayid;
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package   = package;
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = noncestr;
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
//    NSString *stamp = [NSString stringWithFormat:@"%f", a];//转为字符型
    // 这个是时间戳，也是在后台生成的，为了验证支付的
//    NSString * stamp = @"";
    req.timeStamp = timestamp.intValue;
    
    // 这个签名也是后台做的
    req.sign = sign;
    
    //发送请求到微信，等待微信返回onResp
//    [WXApi sendReq:req];
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}




#pragma mark    ----------- Paypal -----------
- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey {
//    BTDropInRequest *request = [[BTDropInRequest alloc] init];
//    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:clientTokenOrTokenizationKey request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
//
//        if (error != nil) {
//            NSLog(@"ERROR");
//        } else if (result.cancelled) {
//            NSLog(@"CANCELLED");
//        } else {
//            // Use the BTDropInResult properties to update your UI
//            // result.paymentOptionType
//            // result.paymentMethod
//            // result.paymentIcon
//            // result.paymentDescription
//        }
//    }];
//    [self presentViewController:dropIn animated:YES completion:nil];
    
    BTDropInRequest *dropInRequest = [[BTDropInRequest alloc] init];
    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:@"sandbox_9dbg82cq_dcpspy2brwdjr3qn" request:dropInRequest handler:^(BTDropInController * _Nonnull dropInController, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            
            NSLog(@"Error: %@", error);
        } else if (result.isCancelled) {
            NSLog(@"Cancelled🎲");
        } else {
            if (result.paymentOptionType == BTUIKPaymentOptionTypeApplePay) {
//                self.progressBlock(@"Ready for checkout...");
                NSLog(@"Ready for checkout...1");
            } else {
//                self.useApplePay = NO;
//                self.selectedNonce = result.paymentMethod;
//                self.progressBlock(@"Ready for checkout...");
//                [self updatePaymentMethod:self.selectedNonce];
                NSLog(@"Ready for checkout...2");
            }
        }
        [dropInController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:dropIn animated:YES completion:nil];
}
@end
