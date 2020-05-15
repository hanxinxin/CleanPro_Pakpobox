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
#import "TextfieldAddressTableViewCell.h"
#import "ZGQActionSheetView.h"
#import "TZImagePickerController.h"
#import "HQImageEditViewController.h"
#import "Ipay.h"
#import "IpayPayment.h"
#import <AVFoundation/AVFoundation.h>
#import "LocationManager.h"
#import "NewHomeViewController.h"
#import "EwashMyViewController.h"

#define CellID @"AddressInfoTableViewCell"
#define CellID1 @"TextfieldAddressTableViewCell"

static int iCount=0;

@interface AddressSViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,ZGQActionSheetViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HQImageEditViewControllerDelegate,PaymentResultDelegate,LocationManagerDelegate,TextfieldAddressTableViewCellDelegate>
{
//    UIButton * button;
    BOOL DownViewHidden;
    UITapGestureRecognizer *tapSuperGesture22;
    LocationManager * manager;
    
    PostOrderMode * PushOrderMode;
}
@property(nonatomic,strong)NSMutableArray *arrayTitle;//数据源
@property(nonatomic,assign)BOOL accessoryTypeBool;

@property(nonatomic,assign)BOOL updateNO;
@property (nonatomic,strong)UIButton* OnlinePayBtn;
@property (nonatomic,strong)UIButton* CashBtn;

@property (nonatomic, strong) HQTextField *NameTextfield;
@property (nonatomic, strong) HQTextField *PhoneTextfield;
@property (nonatomic,strong)UIImageView* OvucherView;
@property (nonatomic,strong)UIImage* OvucherImage;
@property (nonatomic,strong)UIButton* ConfirmBtn;
@property (nonatomic,strong)NSMutableArray *selectorPatnArray;//存放选中数据
@property (strong, nonatomic) UIScrollView *globalScrollview; //全局滑动

@property(nonatomic,strong)AddressListMode *SelectAddress;//address数据源
@property(nonatomic,strong)NSString *fileIdString;//上传图片后的地址
@property(nonatomic,strong)NSString *AddressString;//输入的地址
/// Payview背景
@property (nonatomic,strong)UIView * IPayView;
@property(nonatomic,strong)UIView *DownView;
@property(nonatomic,strong)UIButton *PayButton;
///Ipay88 view
@property (nonatomic, strong) IpayPayment *IPaypayment;
@property (nonatomic, strong) Ipay *paymentSdk;
@property (nonatomic, strong) UIView *paymentView;
@end

@implementation AddressSViewController
@synthesize IPaypayment,globalScrollview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    self.title=FGGetStringWithKeyFromTable(@"E-Wash", @"Language");
    if (@available(iOS 11.0, *)) {
        globalScrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.arrayTitle = [NSMutableArray arrayWithCapacity:0];
//    self.GetaddressArray=[NSMutableArray arrayWithCapacity:0];
    self.SelectAddress=nil;
    self.OvucherImage=nil;
    self.accessoryTypeBool=NO;
    self.AddressString=@"";
    PushOrderMode=nil;
    DownViewHidden=NO;
    
//    [self AddDownView];
     //    设置点击任何其他位置 键盘回收
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
        tapGesture.delegate=self;
        tapGesture.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapGesture];
    
//    if(self.SelectWay==1)///上门只需要自己填写地址
//    {
//        self.fileIdString=@"";
//    }else if(self.SelectWay==2)///到商店需要定位显示附近商店
//    {
//
//    }
//    manager=[LocationManager sharedInstance];
//    manager.delegate=self;
//    [manager setStartUpdatingLocation];
    iCount=0;
    self.fileIdString=@"";
    
    
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addglobalScrollview];
        [self addArrayT];
        [self AddSTableViewUI];
        [self AddButton];
    });
       
    dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime2, dispatch_get_main_queue(), ^{
    if(self.SelectWay==1)///上门只需要自己填写地址
           {
              
           }else if(self.SelectWay==2)///到商店需要定位显示附近商店
           {
               for (int i =0; i<self.GetaddressArray.count; i++) {
                   [self.arrayTitle addObject:[NSString stringWithFormat:@"%d",i]];
               }
           }else if(self.SelectWay==3)///在洗衣店需要定位显示附近洗衣店
           {
               for (int i =0; i<self.GetaddressArray.count; i++) {
                   [self.arrayTitle addObject:[NSString stringWithFormat:@"%d",i]];
               }
           }
           self->globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), (self.STable.height)+50+140+100+64);
           self.accessoryTypeBool=YES;
           [self setBtnTouchFrame];
           [self->_STable reloadData];
       });
}
-(void)addglobalScrollview
{
    globalScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    globalScrollview.tag=1001;
    globalScrollview.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //设置分页效果
    globalScrollview.pagingEnabled = NO;
    //水平滚动条隐藏
    globalScrollview.showsHorizontalScrollIndicator = YES;
    globalScrollview.delegate=self;
    [self.view addSubview:globalScrollview];
    self->globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), (self.STable.height)+50+140+100+64);
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [self addNoticeForKeyboard];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    self.updateNO=YES;
    [HudViewFZ HiddenHud];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.updateNO=NO;
//    [manager setStopUpdatingLocation];
    iCount=0;
    [super viewWillDisappear:animated];
}
//-(void)keyboardWasShown:(NSNotification *)notif
//{
//
//    NSDictionary *info = [notif userInfo];
//
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//
//    CGSize keyboardSize = [value CGRectValue].size;
//
//    NSLog(@"keyBoard:%f", keyboardSize.height);
//    if (keyboardSize.height>0 && self.last_nameText.secureTextEntry == YES) {
//        //不让换键盘的textField的
//        self.last_nameText.secureTextEntry = NO;
//
//    }
//    if (keyboardSize.height>0 && self.first_nameText.secureTextEntry == YES) {
//        //不让换键盘的textField的
//        self.first_nameText.secureTextEntry = NO;
//
//    }
//}
-(void)returnLoction:(CLLocationCoordinate2D)CLLocation
{
    
    
    if(iCount ==0)
    {
        NSLog(@"longitude = %f    latitude= %f",CLLocation.longitude,CLLocation.latitude);
        if(self.updateNO!=NO)
        {
        [self GetQueryLocation:CLLocation.longitude lat:CLLocation.latitude];
        }
        iCount+=1;
    }
    
}

-(void)GetQueryLocation:(CLLocationDegrees)longitude lat:(CLLocationDegrees)latitude
{
    
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@?longitude=%f&latitude=%f",E_FuWuQiUrl,E_QueryLocation,longitude,latitude] parameters:nil progress:^(id progress) {
            //        NSLog(@"请求成功 = %@",progress);
        } success:^(id responseObject) {
            NSLog(@"E_MenuList = %@",responseObject);
            [HudViewFZ HiddenHud];
//            NSArray * array=(NSArray *)responseObject;
            NSDictionary * dictObject= (NSDictionary *)responseObject;
            NSArray * contentarr =[dictObject objectForKey:@"content"];
            if(contentarr.count>0)
            {
                [self.GetaddressArray removeAllObjects];
                for (int i =0; i<contentarr.count; i++) {
                    NSDictionary * dictCon= contentarr[i];
                    AddressListMode* mode = [[AddressListMode alloc] init];
                    
                    mode.siteId =[dictCon objectForKey:@"siteId"];;
                    mode.siteName=[dictCon objectForKey:@"siteName"] ;
                    mode.siteSerialNumber=[dictCon objectForKey:@"siteSerialNumber"];
                    mode.siteType=[dictCon objectForKey:@"siteType"];
                    mode.streetAddress=[dictCon objectForKey:@"streetAddress"];
                    mode.latitude=[dictCon objectForKey:@"latitude"];
                    mode.longitude=[dictCon objectForKey:@"longitude"];
                    mode.distance=[dictCon objectForKey:@"distance"];
                    [self.GetaddressArray addObject:mode];
                }
            }
                if(self.SelectWay==1)///上门只需要自己填写地址
                {
                   
                }else if(self.SelectWay==2)///到商店需要定位显示附近商店
                {
                    for (int i =0; i<self.GetaddressArray.count; i++) {
                        [self.arrayTitle addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                }else if(self.SelectWay==3)///在洗衣店需要定位显示附近洗衣店
                {
                    for (int i =0; i<self.GetaddressArray.count; i++) {
                        [self.arrayTitle addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                }
//            NSLog(@"self.arrayTitle.count*50+50+140+40  1==== %u",((3*50+(self.arrayTitle.count-3)*80))+50+140+40);
            self->globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), (self.STable.height)+50+140+100+64);
            self.accessoryTypeBool=YES;
            [self setBtnTouchFrame];
            [self->_STable reloadData];
                    
            
        } failure:^( NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
            [HudViewFZ HiddenHud];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}
-(void)setDefaults
{
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Token"];
        [userDefaults setObject:@"1" forKey:@"memberId"];
        [userDefaults setObject:@"1" forKey:@"mobile"];
        [jiamiStr base64Data_encrypt:@"1"];
//        [userDefaults setObject:@"1" forKey:@"YHToken"];
        [userDefaults setObject:@"1" forKey:@"phoneNumber"];
        [userDefaults setObject:nil forKey:@"SaveUserMode"];
        [userDefaults setObject:@"1" forKey:@"logCamera"];
        [userDefaults setObject:@"1" forKey:@"userId"];
    //    [defaults synchronize];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tongzhi_UpdateTabbar" object: nil]];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[EwashMyViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[NewHomeViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
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
//    CGFloat offheight = SCREEN_HEIGHT-(kNavBarAndStatusBarHeight);
    CGFloat offset = (self.STable.top+50*3+kbHeight+(kNavBarAndStatusBarHeight)) - SCREEN_HEIGHT;
    NSLog(@"duibi  = %f，%f",SCREEN_HEIGHT,kNavBarAndStatusBarHeight);
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
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
-(void)addArrayT
{
    [self.arrayTitle addObject:@"Name"];
    [self.arrayTitle addObject:@"Phone number"];
    if(self.SelectWay==3)
    {
        [self.arrayTitle addObject:@"Choose the address of the nearest outlet"];
    }else{
        [self.arrayTitle addObject:@"Choose the address of the nearest store"];
    }
    
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
        [globalScrollview addSubview:self.OnlinePayBtn];
    }
    if(self.CashBtn==nil)
    {
        self.CashBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160-15, self.STable.bottom+15, 160, 36)];
        [self.CashBtn setTitle:FGGetStringWithKeyFromTable(@"Cash", @"Language") forState:(UIControlStateNormal)];
        [self.CashBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [self.CashBtn addTarget:self action:@selector(CashTouch:) forControlEvents:UIControlEventTouchDown];
        self.CashBtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
                self.CashBtn.layer.cornerRadius = 4;
            [globalScrollview addSubview:self.CashBtn];
        
        
    }
//    NSLog(@"self.arrayTitle.count*50+50+140+40  ===%u ",self.arrayTitle.count*50+50+140+40);
//    self->globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), ((3*50+(self.arrayTitle.count-3)*80))+50+140+40+64);
    self->globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), (self.STable.height)+50+140+100+64);
    if(self.SelectWay==2)
    {
        [self UpdateBtnStatus];
    }else if(self.SelectWay==3)
    {
        [self UpdateBtnStatus];
    }
}
-(void)UpdateBtnStatus
{
    if(self.SelectAddress != nil)
    {
        self.OnlinePayBtn.userInteractionEnabled=YES;
        self.OnlinePayBtn.backgroundColor =[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
        self.CashBtn.userInteractionEnabled=YES;
        self.CashBtn.backgroundColor =[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    }else
    {
        self.OnlinePayBtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
        self.OnlinePayBtn.userInteractionEnabled=NO;
        self.CashBtn.backgroundColor=[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
        self.CashBtn.userInteractionEnabled=NO;
    }
}
-(void)setBtnTouchFrame
{
    if(self.SelectWay==1)
    {
        
        _STable.frame=CGRectMake(0, 0, SCREEN_WIDTH,(2*50+110));
    }else if(self.SelectWay==2)
    {
        _STable.frame=CGRectMake(0, 0, SCREEN_WIDTH,(3*50+(self.arrayTitle.count-3)*80));
        
    }else if(self.SelectWay==3)
    {
        _STable.frame=CGRectMake(0, 0, SCREEN_WIDTH,(3*50+(self.arrayTitle.count-3)*80));
        
    }
    
    self.OnlinePayBtn.frame = CGRectMake(15, self.STable.bottom+15, 160, 36);
    self.CashBtn.frame = CGRectMake(SCREEN_WIDTH-160-15, self.STable.bottom+15, 160, 36);
    self->globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), (self.STable.height)+50+140+100+64);
}
-(void)AddDownView
{
    if(self.OvucherView==nil)
    {
        self.OvucherView=[[UIImageView alloc] initWithFrame:CGRectMake(15, self.CashBtn.bottom+20, SCREEN_WIDTH-(15*2), 140)];
        [self.OvucherView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PhotoTouch:)];
        tapGestureImage.delegate=self;
        tapGestureImage.cancelsTouchesInView = NO;
        [self.OvucherView addGestureRecognizer:tapGestureImage];
        [self.OvucherView setImage:[UIImage imageNamed:@"tianjiantupian"]];
//        [self.view addSubview:self.OvucherView];
        [globalScrollview addSubview:self.OvucherView];
    }else
    {
        self.OvucherView.frame=CGRectMake(15, self.CashBtn.bottom+20, SCREEN_WIDTH-(15*2), 140);
    }
    if(self.ConfirmBtn==nil)
    {
        self.ConfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.OvucherView.bottom+20, SCREEN_WIDTH-(15*2), 50)];
        [self.ConfirmBtn setTitle:FGGetStringWithKeyFromTable(@"Confirm", @"Language") forState:(UIControlStateNormal)];
            [self.ConfirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [self.ConfirmBtn addTarget:self action:@selector(ConfirmTouch:) forControlEvents:UIControlEventTouchDown];
            self.ConfirmBtn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
            self.ConfirmBtn.layer.cornerRadius = 4;
        [globalScrollview addSubview:self.ConfirmBtn];
    }else
    {
        self.ConfirmBtn.frame=CGRectMake(15, self.OvucherView.bottom+20, SCREEN_WIDTH-(15*2), 50);
    }
    self->globalScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), (self.STable.height)+50+140+100+64);
}
#pragma mark - 点击事件
-(void)OnlinePayBtnTouch:(id)sender
{
//    if()
    [self addIPay88View];
    
    
    
    
}

-(void)textViewText:(NSString *)text
{
    self.AddressString =text;
}
#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.NameTextfield) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                //                NSLog(@"CCCC =  %d",self.phone_textfiled.text.length );
                if (self.NameTextfield.text.length == 9 || self.NameTextfield.text.length ==10 || self.NameTextfield.text.length ==11) {
                    
                }else{
                    
                }
            });
            return YES;
        }
        //so easy
        else if (self.NameTextfield.text.length >= 49) {
            self.NameTextfield.text = [[textField.text stringByAppendingString:string] substringToIndex:50];
//            NSLog(@"self.phone_textfiled.text =  %ld",self.phone_textfiled.text.length );
            
            return NO;
        }else
        {
            
        }
    }else if (textField == self.PhoneTextfield) {
            //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
            if (range.length == 1 && string.length == 0) {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    //                NSLog(@"CCCC =  %d",self.phone_textfiled.text.length );
                    if (self.PhoneTextfield.text.length == 9 || self.PhoneTextfield.text.length ==10 || self.PhoneTextfield.text.length ==11) {
                        
                    }else{
                        
                    }
                });
                return YES;
            }//so easy
                    else if (self.PhoneTextfield.text.length >= 10) {
                        self.PhoneTextfield.text = [[textField.text stringByAppendingString:string] substringToIndex:11];
                        return NO;
                    }else
            {
                
            }
        }
    
    return YES;
}
-(void)pushView:(id)Mode PaymentMethodStr:(NSInteger)PaymentMethodStr
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderPageViewController *vc=[main instantiateViewControllerWithIdentifier:@"OrderPageViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.OrderMode=(PostOrderMode*)Mode;
    vc.TotalStr=self.TotalStr;
    vc.CommodityArr=self.CommodityArr;
    vc.PaymentMethodStr=PaymentMethodStr;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)CashTouch:(id)sender
{
    if(self.SelectWay==1)///上门不需要上传图片
    {

        if(![self.AddressString isEqualToString:@""] && ![self.AddressString isEqualToString:@"Please enter your address"])
        {
            if(self.NameTextfield.text!=nil && ![self.NameTextfield.text isEqualToString:@""])
            {
                if(self.PhoneTextfield.text!=nil && ![self.PhoneTextfield.text isEqualToString:@""])
                {
                    [self postOrder:2];
                }else
                {
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Phoen cannot be empty", @"Language") andDelay:2.0];
                }
            }else{
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Name cannot be empty", @"Language") andDelay:2.0];
            }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please enter home address", @"Language") andDelay:2.0];
        }
    }else if(self.SelectWay==2)///到商店可以上传图片
    {
    if(DownViewHidden==NO)
    {
        self.OvucherView.hidden=NO;
        self.ConfirmBtn.hidden=NO;
        [self AddDownView];
        DownViewHidden=!DownViewHidden;
    }else
    {
        self.OvucherView.hidden=YES;
        self.ConfirmBtn.hidden=YES;
        DownViewHidden=!DownViewHidden;
    }
    }else if(self.SelectWay==3)///到商店可以上传图片
    {
        if(self.SelectAddress!=nil)
        {
        if(self.NameTextfield.text!=nil && ![self.NameTextfield.text isEqualToString:@""])
        {
            if(self.PhoneTextfield.text!=nil && ![self.PhoneTextfield.text isEqualToString:@""])
            {
                [self postOrder:3];
            }else{
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Phone cannot be empty", @"Language") andDelay:2.0];
            }
            
        }else{
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Name cannot be empty", @"Language") andDelay:2.0];
        }
        }else{
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please select a store address", @"Language") andDelay:2.0];
        }
    }
    
}

-(void)PhotoTouch:(id)sender
{
    [self ShowProfilePhoto];
}
-(void)ConfirmTouch:(id)sender
{
    if(self.SelectAddress!=nil)
    {
    if(_OvucherImage!=nil)
    {
        if(self.NameTextfield.text!=nil && ![self.NameTextfield.text isEqualToString:@""])
        {
            if(self.PhoneTextfield.text!=nil && ![self.PhoneTextfield.text isEqualToString:@""])
            {
                [self postfilePhotot:_OvucherImage];
            }else{
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Phone cannot be empty", @"Language") andDelay:2.0];
            }
            
        }else{
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Name cannot be empty", @"Language") andDelay:2.0];
        }
        
    }else
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please upload credentials", @"Language") andDelay:2.0];
    }
        }else{
                   [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please select a store address", @"Language") andDelay:2.0];
               }
}

-(void)postfilePhotot:(UIImage*)image
{
   
        
        [HudViewFZ labelExample:self.view];
        UIImage * YSimage=[AddressSViewController compressImageQuality:image toByte:12800];
        NSArray * arr = [NSArray arrayWithObjects:YSimage, nil];
        [[AFNetWrokingAssistant shareAssistant] uploadImagesWihtImgArr:arr url:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_POSTFile] Tokenbool:YES parameters:nil block:^(id objc, BOOL success) {
            NSLog(@"objc=====  %@",objc);
            NSDictionary *dict= (NSDictionary*)objc;
            NSString * fileIdStr = [dict objectForKey:@"fileId"];
    //        NSString * displayName = [dict objectForKey:@"displayName"];
            [HudViewFZ HiddenHud];
            if(fileIdStr!=nil)
            {
                self.fileIdString=fileIdStr;
    //            [HudViewFZ HiddenHud];
//                [self.refundIDArr addObject:idStr];
//                if(self.refundIDArr.count == self.imageViewArr.count)
//                {
//                    [self post_refund_feed:self.refundIDArr];
                    
//                }
                
                [self postOrder:1];
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

-(NSArray*)returnProductVariantId
{
    NSMutableArray * arrid=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<self.CommodityArr.count; i++) {
    CommodityMode*modeMMM=self.CommodityArr[i];
    productsMode* mode=modeMMM.Mode;
         for (int i = 0; i<mode.attributeList.count; i++) {
                attributeListsMode * attmode= mode.attributeList[i];
                for (int j=0; j<attmode.valueList.count; j++) {
                    valueListMode * modeValue =attmode.valueList[j];
                    if([modeValue.productAttributeValue isEqualToString:modeMMM.Ctemperature])
                    {
                        for (int k=0; k<mode.productVariantList.count; k++) {
                            productVariantListMode * modePro = mode.productVariantList[k];
                            for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                                NSString * ValueId= modePro.productAttributeValueIds[M];
                                if([ValueId isEqualToString:modeValue.productAttributeValueId] && [modeValue.productAttributeValue isEqualToString:modeMMM.Ctemperature])
                                {
                                    NSLog(@"111   %@ , %@     mmmm==== %@   ,%@",modeValue.productAttributeValue,modeMMM.Ctemperature,ValueId,modeValue.productAttributeValueId);
                                    [arrid addObject:modePro.productVariantId];
                                    break;
                                }
                            }
                            
                        }
                    }else if([modeValue.productAttributeValue isEqualToString:@"Warm"])
                    {
                        for (int k=0; k<mode.productVariantList.count; k++) {
                            productVariantListMode * modePro = mode.productVariantList[k];
//                            return modePro.productVariantId;
                            for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                                NSString * ValueId= modePro.productAttributeValueIds[M];
                                if([ValueId isEqualToString:modeValue.productAttributeValueId]&& [modeValue.productAttributeValue isEqualToString:modeMMM.Ctemperature])
                                {
                                    NSLog(@"222   %@ , %@     mmmm==== %@   ,%@",modeValue.productAttributeValue,modeMMM.Ctemperature,ValueId,modeValue.productAttributeValueId);
                                    [arrid addObject:modePro.productVariantId];
                                    break;
                                }
                            }
                        }
                    }else if([modeValue.productAttributeValue isEqualToString:@"Hot"])
                    {
                        for (int k=0; k<mode.productVariantList.count; k++) {
                            productVariantListMode * modePro = mode.productVariantList[k];
//                            return modePro.productVariantId;
                            for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                                NSString * ValueId= modePro.productAttributeValueIds[M];
                                if([ValueId isEqualToString:modeValue.productAttributeValueId]&& [modeValue.productAttributeValue isEqualToString:modeMMM.Ctemperature])
                                {
                                    NSLog(@"3333   %@ , %@     mmmm==== %@   ,%@",modeValue.productAttributeValue,modeMMM.Ctemperature,ValueId,modeValue.productAttributeValueId);
                                    [arrid addObject:modePro.productVariantId];
                                    break;
                                }
                            }
                        }
                    }
                }
                
            }
    }
    
    NSMutableArray * arrDict= [NSMutableArray arrayWithCapacity:0];
    for (int KM=0; KM<arrid.count; KM++) {
        int QW=0;
        if(arrDict.count>0)
        {
            
        for (int JJ=0; JJ<arrDict.count; JJ++) {
            NSString * strID=arrid[KM];
            itemsSP*mode=arrDict[JJ];
            if([strID isEqualToString:mode.productVariantId])
            {
                mode.quantity=[NSString stringWithFormat:@"%d",[mode.quantity intValue]+1];
                QW+=1;
                break;
            }
        }
            if(QW==0)
            {
                itemsSP*mode=[[itemsSP alloc] init];
                mode.productVariantId=arrid[KM];
                mode.quantity=@"1";
                [arrDict addObject:mode];
                QW=0;
            }
        }else{
            itemsSP*mode=[[itemsSP alloc] init];
            mode.productVariantId=arrid[KM];
            mode.quantity=@"1";
            [arrDict addObject:mode];
        }
    }
    NSMutableArray * returnArr=[NSMutableArray arrayWithCapacity:0];
    for (int Cocoa=0; Cocoa<arrDict.count; Cocoa++) {
        itemsSP*mode=arrDict[Cocoa];
        NSDictionary * dcitA=@{
            @"productVariantId":mode.productVariantId,//商品id
            @"quantity":mode.quantity,//商品数量
        };
        [returnArr addObject:dcitA];
    }
    
    
    return returnArr;
}
-(void)postOrder:(NSInteger )SelectWayOrder
//-(void)postOrder
{
    
//        NSDictionary*dcitA=@{
//            @"productVariantId":[self returnProductVariantId],//商品id
//            @"quantity":@"1"//商品数量
//        };
//    NSMutableArray * arrmu=[NSMutableArray arrayWithCapacity:0];
//    [arrmu addObject:dcitA];
    NSArray * returnArrM=[self returnProductVariantId];
    
    NSString * logisticsType;
    if(self.SelectWay==1)
    {
        logisticsType=@"DOORSTEP_DELIVERY";
    }else if(self.SelectWay==2)
    {
        logisticsType=@"SELF_PICKUP";
    }else if(self.SelectWay==3)
    {
        logisticsType=@"LAUNDRY_OUTLET";
    }
    NSDictionary *dict;
    if(SelectWayOrder==1)///上门需要上传图片
    {
        dict=@{@"clientType":@"IOS",///客户端类型 IOS 苹果、ANDROID：安卓
                                  @"siteId":self.SelectAddress.siteId,
                                  @"items":returnArrM,
                                  @"logisticsType":logisticsType,
                                  @"fileId":self.fileIdString,
        //                          @"recipientAddress":self.SelectAddress.siteName,
                                  @"paymentPlatform" :@"CASH_PAY",
               @"recipientName":self.NameTextfield.text,
               @"recipientPhoneNumber":self.PhoneTextfield.text,
            };
    }else if(SelectWayOrder==2) ///上门不需要上传图片
    {
        AddressListMode* mode = self.GetaddressArray[0];
        dict=@{@"clientType":@"IOS",///客户端类型 IOS 苹果、ANDROID：安卓
               @"siteId":mode.siteId,
               @"recipientAddress":self.AddressString,
               @"items":returnArrM,
               @"logisticsType":logisticsType,
        //                          @"recipientAddress":self.SelectAddress.siteName,
               @"paymentPlatform" :@"CASH_PAY",
               @"recipientName":self.NameTextfield.text,
               @"recipientPhoneNumber":self.PhoneTextfield.text,
            };
        
    }else if(SelectWayOrder==3)///洗衣店不需要
    {
        dict=@{@"clientType":@"IOS",///客户端类型 IOS 苹果、ANDROID：安卓
               @"siteId":self.SelectAddress.siteId,
               @"items":returnArrM,
               @"logisticsType":logisticsType,
               @"paymentPlatform" :@"CASH_PAY",
               @"recipientName":self.NameTextfield.text,
               @"recipientPhoneNumber":self.PhoneTextfield.text,
            };
    }
    NSLog(@"dict=== %@    url === %@",dict,[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_CreateOrder]);
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] PostURL_E_washToken_error:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URL:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_CreateOrder] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            
            NSDictionary *dict= (NSDictionary*)responseObject;
            PostOrderMode * mode = [[PostOrderMode alloc] init];
            
            NSString * siteId = [dict objectForKey:@"siteId"];
            if(siteId!=nil)
            {

                mode.orderNumber = [dict objectForKey:@"orderNumber"];
                mode.siteId=siteId;
                mode.expressNumber = [dict objectForKey:@"expressNumber"];
                mode.merchantId = [dict objectForKey:@"merchantId"];
                mode.ordersId = [dict objectForKey:@"ordersId"];
                mode.siteMerchantId = [dict objectForKey:@"siteMerchantId"];
                mode.siteName = [dict objectForKey:@"siteName"];
                mode.siteType = [dict objectForKey:@"siteType"];
                mode.unitType = [dict objectForKey:@"unitType"];
                NSArray * payItemarr = [dict objectForKey:@"paymentItems"];
                NSMutableArray * payItemMutableArr=[NSMutableArray arrayWithCapacity:0];
                for (int i=0; i<payItemarr.count; i++) {
                    paymentItemsMode*modePay=[[paymentItemsMode alloc] init];
                    NSDictionary * ditPay=payItemarr[i];
                    modePay.amount = [ditPay objectForKey:@"amount"];
                    modePay.couponCardId = [ditPay objectForKey:@"couponCardId"];
                    modePay.couponCode = [ditPay objectForKey:@"couponCode"];
                    modePay.discountAmount = [ditPay objectForKey:@"discountAmount"];
                    modePay.displayPayStatus = [ditPay objectForKey:@"displayPayStatus"];
                    modePay.fileId = [ditPay objectForKey:@"fileId"];
                    modePay.orderAmount = [ditPay objectForKey:@"orderAmount"];
                    modePay.ordersId = [ditPay objectForKey:@"ordersId"];
                    modePay.outTransNo = [ditPay objectForKey:@"outTransNo"];
                    modePay.payStatus = [ditPay objectForKey:@"payStatus"];
                    modePay.payTime = [ditPay objectForKey:@"payTime"];
                    modePay.paymentItemId = [ditPay objectForKey:@"paymentItemId"];
                    modePay.paymentPlatform = [ditPay objectForKey:@"paymentPlatform"];
                    modePay.priceName = [ditPay objectForKey:@"priceName"];
                    modePay.showApp = [ditPay objectForKey:@"showApp"];
                    modePay.valueType = [ditPay objectForKey:@"valueType"];
                    [payItemMutableArr addObject:modePay];
                }
                mode.paymentItems=payItemMutableArr;
                self->PushOrderMode=mode;
                [self pushView:mode PaymentMethodStr:1];
            }
            
            
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(id receive, NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        if(statusCode==401)
        {
            [self setDefaults];
        }
        NSString * errorMessage = (NSString *)receive;
        [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
            [HudViewFZ HiddenHud];
//                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
}

-(void)postIpay88Order:(NSInteger)SelectWayOrder
{
    NSArray * returnArrM=[self returnProductVariantId];
    
    NSString * logisticsType;
    NSDictionary * dict;
//    private String recipientName; //客户收件人姓名
//    private String recipientMail; //客户收件人邮箱
//    private String recipientPhoneNumber;//客户收件人电话
//    private String recipientAddress; //客户收件人地址
    if(self.SelectWay==1)
    {///上门要输入地址
        logisticsType=@"DOORSTEP_DELIVERY";
        AddressListMode* mode = self.GetaddressArray[0];
        
        dict=@{@"clientType":@"IOS",///客户端类型 IOS 苹果、ANDROID：安卓
                              @"recipientAddress":self.AddressString,
                              @"siteId":mode.siteId,
                              @"items":returnArrM,
                              @"logisticsType":logisticsType,
               @"recipientName":self.NameTextfield.text,
               @"recipientPhoneNumber":self.PhoneTextfield.text,
        };
    }else if(self.SelectWay==2)
    {///到商店要选择地址
        logisticsType=@"SELF_PICKUP";
        dict=@{@"clientType":@"IOS",///客户端类型 IOS 苹果、ANDROID：安卓
                              @"siteId":self.SelectAddress.siteId,
                              @"items":returnArrM,
                              @"logisticsType":logisticsType,
               @"recipientName":self.NameTextfield.text,
               @"recipientPhoneNumber":self.PhoneTextfield.text,
        };
    }else if(self.SelectWay==3)
    {///到商店要选择地址
        logisticsType=@"LAUNDRY_OUTLET";
        dict=@{@"clientType":@"IOS",///客户端类型 IOS 苹果、ANDROID：安卓
                              @"siteId":self.SelectAddress.siteId,
                              @"items":returnArrM,
                              @"logisticsType":logisticsType,
               @"recipientName":self.NameTextfield.text,
               @"recipientPhoneNumber":self.PhoneTextfield.text,
        };
    }
//    NSDictionary * dict=@{@"clientType":@"IOS",///客户端类型 IOS 苹果、ANDROID：安卓
//                          @"siteId":self.SelectAddress.siteId,
//                          @"items":returnArrM,
//                          @"logisticsType":logisticsType,
//    };
    
    NSLog(@"dict=== %@    url === %@",dict,[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_CreateOrder]);
    [HudViewFZ labelExample:self.view];
        [[AFNetWrokingAssistant shareAssistant] PostURL_E_washToken_error:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URL:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_CreateOrder] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
//        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            
           NSDictionary *dict= (NSDictionary*)responseObject;
            PostOrderMode * mode = [[PostOrderMode alloc] init];
            
            NSString * siteId = [dict objectForKey:@"siteId"];
            if(siteId!=nil)
            {

                mode.orderNumber = [dict objectForKey:@"orderNumber"];
                mode.siteId=siteId;
                mode.expressNumber = [dict objectForKey:@"expressNumber"];
                mode.merchantId = [dict objectForKey:@"merchantId"];
                mode.ordersId = [dict objectForKey:@"ordersId"];
                mode.siteMerchantId = [dict objectForKey:@"siteMerchantId"];
                mode.siteName = [dict objectForKey:@"siteName"];
                mode.siteType = [dict objectForKey:@"siteType"];
                mode.unitType = [dict objectForKey:@"unitType"];
                NSArray * payItemarr = [dict objectForKey:@"paymentItems"];
                
                NSMutableArray * payItemMutableArr=[NSMutableArray arrayWithCapacity:0];
                NSString * paymentItemIdsStr =@"";
                NSString * amountStr =@"0";
                for (int i=0; i<payItemarr.count; i++) {
                    paymentItemsMode*modePay=[[paymentItemsMode alloc] init];
                    NSDictionary * ditPay=payItemarr[i];
                    modePay.amount = [ditPay objectForKey:@"amount"];
                    modePay.couponCardId = [ditPay objectForKey:@"couponCardId"];
                    modePay.couponCode = [ditPay objectForKey:@"couponCode"];
                    modePay.discountAmount = [ditPay objectForKey:@"discountAmount"];
                    modePay.displayPayStatus = [ditPay objectForKey:@"displayPayStatus"];
                    modePay.fileId = [ditPay objectForKey:@"fileId"];
                    modePay.orderAmount = [ditPay objectForKey:@"orderAmount"];
                    modePay.ordersId = [ditPay objectForKey:@"ordersId"];
                    modePay.outTransNo = [ditPay objectForKey:@"outTransNo"];
                    modePay.payStatus = [ditPay objectForKey:@"payStatus"];
                    modePay.payTime = [ditPay objectForKey:@"payTime"];
                    modePay.paymentItemId = [ditPay objectForKey:@"paymentItemId"];
                    modePay.paymentPlatform = [ditPay objectForKey:@"paymentPlatform"];
                    modePay.priceName = [ditPay objectForKey:@"priceName"];
                    modePay.showApp = [ditPay objectForKey:@"showApp"];
                    modePay.valueType = [ditPay objectForKey:@"valueType"];
//                    paymentItemIdsStr=[ stringByAppendingString: modePay.paymentItemId];
                    if(i==0)
                    {
                        paymentItemIdsStr=[NSString stringWithFormat:@"%@",modePay.paymentItemId];
                        
                    }else{
                        paymentItemIdsStr=[NSString stringWithFormat:@"%@,%@",paymentItemIdsStr,modePay.paymentItemId];
                    }
                    amountStr=[NSString stringWithFormat:@"%.2f",[modePay.amount floatValue]+[amountStr floatValue]];
                    [payItemMutableArr addObject:modePay];
                }
                mode.paymentItems=payItemMutableArr;
                
                NSLog(@"paymentItemIdsStr ===  %@",paymentItemIdsStr);
                self->PushOrderMode=mode;
                if(SelectWayOrder==1)///上门需要上传图片
                {
                    if(self->PushOrderMode!=nil)
                    {
                        [self pushView:self->PushOrderMode PaymentMethodStr:1];
                    }
                }else if(SelectWayOrder==2) ///上门不需要上传图片
                {
                    [self PostIpay88:mode.ordersId PaymentItemId:paymentItemIdsStr amount:amountStr];
                }else if(SelectWayOrder==3) ///洗衣店不需要上传图片也不需要支付
                {
                    if(self->PushOrderMode!=nil)
                    {
                        [self pushView:self->PushOrderMode PaymentMethodStr:1];
                    }
                }
                
            }
            
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(id receive, NSInteger statusCode, NSError *error) {
            NSLog(@"error = %@",error);
            if(statusCode==401)
            {
                [self setDefaults];
            }
            NSString * errorMessage = (NSString *)receive;
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
                [HudViewFZ HiddenHud];
    //                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        }];
}


-(void)PostIpay88:(NSString*)OrderID PaymentItemId:(NSString*)PaymentItemId amount:(NSString*)amount
{
    NSDictionary * dict=@{@"amount":@"1",
//                          @"amount":amount,
                          @"client_type":@"IOS",///客户端类型 IOS 苹果、ANDROID：安卓
                          @"currency_unit":@"MYR",
                          @"pay_method":@"PAGE",
                          @"pay_platform":@"IPAY88",
                          @"trade_type":@"RECHARGE",
                          @"menber_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"],
                          @"order_id":OrderID,
                          @"paymentItemId":PaymentItemId,
        };
        
        NSLog(@"E_Ipay88Url Dict=== %@    url === %@",dict,[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_Ipay88Url]);
        
            [[AFNetWrokingAssistant shareAssistant] PostURL_E_washToken_error:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] URL:[NSString stringWithFormat:@"%@%@",E_FuWuQiUrl,E_Ipay88Url] parameters:dict progress:^(id progress) {
            NSLog(@"请求成功 = %@",progress);
        }Success:^(NSInteger statusCode,id responseObject) {
            [HudViewFZ HiddenHud];
            NSLog(@"responseObject = %@",responseObject);
            if(statusCode==200)
            {
                
               NSDictionary *dictObject= (NSDictionary*)responseObject;
                NSString * RefNo = [dictObject objectForKey:@"pay_req_no"];
                NSString * Url = [dictObject objectForKey:@"notify_url"];
                NSString * Remark = [dictObject objectForKey:@"pay_req_no"];
                 [self push_IPay:RefNo UrlStr:Url Remark:Remark Amount:amount];
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
            }
        } failure:^(id receive, NSInteger statusCode, NSError *error) {
                NSLog(@"error = %@",error);
                if(statusCode==401)
                {
                    [self setDefaults];
                }
                NSString * errorMessage = (NSString *)receive;
                [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
                    [HudViewFZ HiddenHud];
        //                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }];
}

-(void)addIPay88View
{
    self.IPayView=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(kNavBarAndStatusBarHeight))];
    self.IPayView.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        [self.IPayView setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.3]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [self.IPayView addGestureRecognizer:tapSuperGesture22];
    [self.view addSubview:self.IPayView];
   
    self.DownView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-(kNavBarAndStatusBarHeight)-125, SCREEN_WIDTH, 125)];
    [self.DownView setBackgroundColor:[UIColor whiteColor]];
    [self.IPayView addSubview:self.DownView];
    self.PayButton=[[UIButton alloc] initWithFrame:CGRectMake((self.DownView.width-130)/2, (125-54)/2, 130, 54)];
    [self.PayButton setTintColor:[UIColor whiteColor]];
    [self.PayButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [self.PayButton setTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language") forState:(UIControlStateNormal)];
    [self.PayButton setImage:[UIImage imageNamed:@"ipay88_logo_wide"] forState:(UIControlStateNormal)];
    [self.PayButton addTarget:self action:@selector(PayButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.DownView addSubview:self.PayButton];
    [self show_TCview];
}
-(void)show_TCview
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
//        self.ShelterView.frame=self.view.bounds;
        self.IPayView.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    }];
//    self.IPayView.hidden=YES;
}
-(void)hidden_TCview
{
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self.IPayView.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        [self.IPayView removeFromSuperview];
    }];
//    self.IPayView.hidden=NO;
}
- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    [self hidden_TCview];
}
-(void)PayButtonTouch:(id)sender
{
    if(self.SelectWay==1)
    {
        if(![self.AddressString isEqualToString:@""] && ![self.AddressString isEqualToString:@"Please enter your address"])
        {
            if(self.NameTextfield.text!=nil && ![self.NameTextfield.text isEqualToString:@""])
            {
                
                if(self.PhoneTextfield.text!=nil && ![self.PhoneTextfield.text isEqualToString:@""])
                {
                    [self postIpay88Order:2];
                }else{
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Phone cannot be empty", @"Language") andDelay:2.0];
                }
            }else{
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Name cannot be empty", @"Language") andDelay:2.0];
            }
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please enter home address", @"Language") andDelay:2.0];
        }
        
    }else if(self.SelectWay==2)
    {
        if(self.SelectAddress!=nil)
        {
            
            if(self.NameTextfield.text!=nil && ![self.NameTextfield.text isEqualToString:@""])
            {
                if(self.PhoneTextfield.text!=nil && ![self.PhoneTextfield.text isEqualToString:@""])
                {
                    [self postIpay88Order:2];
                }else{
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Phone cannot be empty", @"Language") andDelay:2.0];
                }
            }else{
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Name cannot be empty", @"Language") andDelay:2.0];
            }
//            [self postOrder];
        }else{
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please select a store address", @"Language") andDelay:2.0];
        }
    }else if(self.SelectWay==3)
        {
            if(self.SelectAddress!=nil)
            {
                
                if(self.NameTextfield.text!=nil && ![self.NameTextfield.text isEqualToString:@""])
                {
                    if(self.PhoneTextfield.text!=nil && ![self.PhoneTextfield.text isEqualToString:@""])
                    {
                        [self postIpay88Order:2];
                    }else{
                        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Phone cannot be empty", @"Language") andDelay:2.0];
                    }
                }else{
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Name cannot be empty", @"Language") andDelay:2.0];
                }
    //            [self postOrder];
            }else{
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please select a store address", @"Language") andDelay:2.0];
            }
        }
    
    
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
    [IPaypayment setAmount:@"1.0"];/////暂时定为1元
//    [IPaypayment setAmount:Amount];/////暂时定为1元
    [IPaypayment setCurrency:@"MYR"];
    [IPaypayment setProdDesc:[NSString stringWithFormat:@"%@%@",@"Payment for ",Remark]];
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
    if(self->PushOrderMode!=nil)
    {
        [self pushView:self->PushOrderMode PaymentMethodStr:2];
    }
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




-(void)AddSTableViewUI
{
//    _STable.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    if(self.SelectWay==1)
    {
        
        _STable.frame=CGRectMake(0, 0, SCREEN_WIDTH,(2*50+110));
    }else if(self.SelectWay==2)
    {
        _STable.frame=CGRectMake(0, 0, SCREEN_WIDTH,(3*50+(self.arrayTitle.count-3)*80));
        
    }else if(self.SelectWay==3)
    {
        _STable.frame=CGRectMake(0, 0, SCREEN_WIDTH,(3*50+(self.arrayTitle.count-3)*80));
        
    }
    _STable.delegate=self;
    _STable.dataSource=self;
    _STable.showsVerticalScrollIndicator=NO;

    _STable.scrollEnabled = NO;
    _STable.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    //UITableViewCell 左分割线顶格
    self.STable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.STable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_STable registerNib:[UINib nibWithNibName:@"AddressInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
    [_STable registerNib:[UINib nibWithNibName:@"TextfieldAddressTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID1];
    [globalScrollview addSubview:_STable];
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
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
//        SaveUserIDMode * mode  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%@",mode.lastName,mode.firstName]];
            
        }
        NSLog(@"nickname=== %@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"]]);
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"]]];
//        cell.detailTextLabel.hidden=YES;
        if(self.NameTextfield==nil)
        {
        self.NameTextfield = [[HQTextField alloc] init];
//        self.NameTextfield.frame = CGRectMake(cell.width-120, 0, 120, cell.height);
//        NSLog(@"cell.width== %f",cell.width);
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            NSLog(@"cell.textLabel=  %f",cell.textLabel.right);
//            self.NameTextfield.frame = CGRectMake(cell.accessoryView.left-120, 0, 130, cell.height);
            self.NameTextfield.frame = CGRectMake(cell.textLabel.right, 0, cell.width-cell.textLabel.right-(18), cell.height);
            self.NameTextfield.textAlignment=NSTextAlignmentRight;
            self.NameTextfield.text= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"]];
            [self.NameTextfield setFont:[UIFont systemFontOfSize:16]];
            self.NameTextfield.textColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
            self.NameTextfield.delegate=self;
            
            
        });
        [cell addSubview: self.NameTextfield];
        }
//        contentView
        
    }else if (indexPath.row==1)
    {
        if(self.PhoneTextfield==nil)
        {
            self.PhoneTextfield = [[HQTextField alloc] init];
        //        self.NameTextfield.frame = CGRectMake(cell.width-120, 0, 120, cell.height);
        //        NSLog(@"cell.width== %f",cell.width);
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                NSLog(@"cell.textLabel2=  %f",cell.textLabel.right);
        //            self.NameTextfield.frame = CGRectMake(cell.accessoryView.left-120, 0, 130, cell.height);
                self.PhoneTextfield.frame = CGRectMake(cell.textLabel.right, 0, cell.width-cell.textLabel.right-(18), cell.height);
                self.PhoneTextfield.textAlignment=NSTextAlignmentRight;
                self.PhoneTextfield.text= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"]];
                [self.PhoneTextfield setFont:[UIFont systemFontOfSize:16]];
                self.PhoneTextfield.textColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                self.PhoneTextfield.delegate=self;
                self.PhoneTextfield.keyboardType = UIKeyboardTypeNumberPad;
                    
                });
                [cell addSubview: self.PhoneTextfield];
                }
//        NSLog(@"mobile=== %@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"]]);
    }else if(indexPath.row>=2)
    {
    if(self.SelectWay==1)
    {
           TextfieldAddressTableViewCell * cellOne = (TextfieldAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellID1];
           if (cellOne == nil) {
               cellOne= (TextfieldAddressTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"TextfieldAddressTableViewCell" owner:self options:nil]  lastObject];
           }
               //cell选中效果
               cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
               cellOne.tag= 500+indexPath.row;
        cellOne.delegate=self;
           return cellOne;
        }else if(self.SelectWay==2)
        {
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
                       AddressListMode* mode = self.GetaddressArray[(indexPath.row-3)];
                       cellOne.TopTitle.text=mode.siteName;
                       cellOne.DownTitle.text=mode.streetAddress;
                       if([mode.distance doubleValue]>1000)
                       {
                           cellOne.JLLabel.text=[NSString stringWithFormat:@"%.2fkm",[mode.distance doubleValue]/1000.0];
                       }else{
                           cellOne.JLLabel.text=[NSString stringWithFormat:@"%.2fm",[mode.distance doubleValue]];
                       }
                       return cellOne;
                       
                   }
        }else if(self.SelectWay==3)
        {
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
                       AddressListMode* mode = self.GetaddressArray[(indexPath.row-3)];
                       cellOne.TopTitle.text=mode.siteName;
                       cellOne.DownTitle.text=mode.streetAddress;
                       if([mode.distance doubleValue]>1000)
                       {
                           cellOne.JLLabel.text=[NSString stringWithFormat:@"%.2fkm",[mode.distance doubleValue]/1000.0];
                       }else{
                           cellOne.JLLabel.text=[NSString stringWithFormat:@"%.2fm",[mode.distance doubleValue]];
                       }
                       return cellOne;
                       
                   }
        }
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
        if(self.SelectWay==1)
        {
                if(indexPath.row==2)
                {
                    return 110;
                    
                }else{
                    return 50;
                }
        }else if(self.SelectWay==2)
        {
            
            if(indexPath.row>2)
                {
                    return 80;
                }
            return 50;
        }else if(self.SelectWay==3)
        {
            
            if(indexPath.row>2)
                {
                    return 80;
                }
            return 50;
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
    if(self.SelectWay==1)
    {
    
        
    }else if(self.SelectWay==2)
    {
            
            if(indexPath.row==2)
            {
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
                self.SelectAddress=(AddressListMode*)self.GetaddressArray[(indexPath.row-3)];
                
            }
        if(self.SelectWay==2)
        {
            [self UpdateBtnStatus];
        }
    }else if(self.SelectWay==3)
    {
            
            if(indexPath.row==2)
            {
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
                self.SelectAddress=(AddressListMode*)self.GetaddressArray[(indexPath.row-3)];
                
            }
        if(self.SelectWay==3)
        {
            [self UpdateBtnStatus];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    if (self.selectorPatnArray.count > 0) {

        [self.selectorPatnArray removeObject:self.arrayTitle[indexPath.row]];
    }
    
        
}




-(void)ShowProfilePhoto
{
    
    //    optionArray = [NSArray array];
    NSArray *optionArray = @[FGGetStringWithKeyFromTable(@"Take New Profile Picture", @"Language"),FGGetStringWithKeyFromTable(@"Select Profile Picture", @"Language")];
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray];
    sheetView.tag=101;
    sheetView.delegate = self;
    [sheetView show];
}


- (void)ZGQActionSheetView:(ZGQActionSheetView *)sheetView didSelectRowAtIndex:(NSInteger)index text:(NSString *)text {
    NSLog(@"%zd,%@",index,text);
    if(sheetView.tag==101)
    {
        if (index==0) {
            [self openCamera];
        }else if (index==1)
        {
            [self openAlbum];
        }
    }
}
- (void)openCamera
{
    //判断是否已授权
    //    AVAuthorizationStatus autjStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:FGGetStringWithKeyFromTable(@"Tisp", @"Language")
                                                                           message:FGGetStringWithKeyFromTable(@"Allow StorHub to access camera in Settings-Privacy",@"Language") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                //响应事件
                NSLog(@"action = %@", action);
                [self dismissViewControllerAnimated:YES completion:nil];
                //                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else
        {
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = self;
            [self.navigationController presentViewController:ipc animated:YES completion:nil];
            //        [self.navigationController pushViewController:ipc animated:YES];
        }
    }
}

-(void)openSDKHQImageEdit:(UIImage*)imageBD
{
     HQImageEditViewController *vc = [[HQImageEditViewController alloc] init];
        vc.originImage = imageBD;
        vc.delegate = self;
        vc.maskViewAnimation = YES;
    //    vc.editViewSize = CGSizeMake(300, 200);
    //    [self presentViewController:vc animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - HQImageEditViewControllerDelegate
- (void)editController:(HQImageEditViewController *)vc finishiEditShotImage:(UIImage *)image originSizeImage:(UIImage *)originSizeImage {
//    self.imageView.image = originSizeImage;
//    [vc dismissViewControllerAnimated:YES completion:nil];
//    [self.OvucherView setImage:originSizeImage];
//    self.OvucherImage=originSizeImage;
    UIImage * imageCC = [self imageCompress:originSizeImage];
    [self.OvucherView setImage:imageCC];
    self.OvucherImage=imageCC;
}

- (void)editControllerDidClickCancel:(HQImageEditViewController *)vc {
//    [vc dismissViewControllerAnimated:YES completion:nil];
    [vc.navigationController popViewControllerAnimated:YES];
}


- (void)openAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        //        [self presentViewController:imagePickerVc animated:YES completion:nil];
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        //            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        [self.navigationController presentViewController:ipc animated:YES completion:nil];
    }else{
        //        [self showHint:@"请打开允许访问相册权限"];
        NSLog(@"请打开允许访问相册权限");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:FGGetStringWithKeyFromTable(@"Tisp", @"Language")
                                                                       message:FGGetStringWithKeyFromTable(@"Allow StorHub to access album in Settings-Privacy",@"Language") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
            [self dismissViewControllerAnimated:YES completion:nil];
            //                [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
//相机选的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 关闭相册\相机
    [picker dismissViewControllerAnimated:YES completion:nil];
    //     [self.navigationController popViewControllerAnimated:NO];
    // 往数据数组拼接图片
    //    [self.dataArr addObject:info[UIImagePickerControllerOriginalImage]];
    NSLog(@"MMMM= %@",info[UIImagePickerControllerOriginalImage]);
//    [self openSDKHQImageEdit:[InformationViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200]];
    
//    [self.OvucherView setImage:[AddressSViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200]];
//    self.OvucherImage=[AddressSViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200];
    UIImage * image = [self imageCompress:info[UIImagePickerControllerOriginalImage]];
    [self.OvucherView setImage:image];
    self.OvucherImage=image;
}
//取消按钮
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picke{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *dict = @{FGGetStringWithKeyFromTable(@"Dismiss", @"Language"):@"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNext" object:nil userInfo:dict];
}
// 相册选的图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
//    [self postUploadHeadImage:[InformationViewController compressImageQuality:(UIImage*)photos[0] toByte:51200]];
//    [self openSDKHQImageEdit:[AddressSViewController compressImageQuality:(UIImage*)photos[0] toByte:51200]];
//     [self.OvucherView setImage:[AddressSViewController compressImageQuality:(UIImage*)photos[0] toByte:51200]];
//    self.OvucherImage=[AddressSViewController compressImageQuality:(UIImage*)photos[0] toByte:51200];
    UIImage * image = [self imageCompress:(UIImage*)photos[0]];
    [self.OvucherView setImage:image];
    self.OvucherImage=image;
}



-(NSData *)compressWithMaxLength:(NSUInteger)maxLength image_P:(UIImage *)imageVV{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(imageVV, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(imageVV, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
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
-(UIImage *)imageCompress:(UIImage *)myimage
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
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

@end
