//
//  InviteFriendsViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "FriendsView.h"
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareMessengerURLActionButton.h>
#import <FBSDKShareKit/FBSDKShareMessengerGenericTemplateElement.h>
#import <FBSDKShareKit/FBSDKMessageDialog.h>
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import <FBSDKShareKit/FBSDKShareMessengerGenericTemplateContent.h>
#import <FBSDKShareKit/FBSDKSendButton.h>
#import <FBSDKShareKit/FBSDKShareButton.h>
#import <FBSDKShareKit/FBSDKShareMessengerOpenGraphMusicTemplateContent.h>
@interface InviteFriendsViewController ()<FriendsViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,FBSDKSharingDelegate>
{
    UIImageView * image_top;
    UILabel * Label_top;
    /////// downView
    UILabel * D_label_t;
    UILabel * D_title_t;
    UILabel * D_button_t;
    UIView * D_label_View;
    UILabel * D_label_Donw;
    
    /////全屏透明色view和 button Lable
    UIView * ZheDang_View;
    UITapGestureRecognizer *tapSuperGesture22;
}
@property (nonatomic ,strong) UIScrollView * ZscrollerView;
@property (nonatomic ,strong) UIView * topView;
@property (nonatomic ,strong) UIView * DownView;
@property (nonatomic ,strong) FriendsView * Friends;
@property (nonatomic ,assign) BOOL FriendsBool;
@end

@implementation InviteFriendsViewController
@synthesize ZscrollerView,Friends;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {//解决iOS 10 版本scrollView下滑问题。
        
        ZscrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
     self.navigationController.navigationBar.translucent = YES;
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self addScroller];
    [UIBezierPathView setCornerOnTop:4 view_b:self.DownViewShare];;
//    [self addtopView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTranslucent:NO];
    //    self.title=@"Cleapro";
    self.DownViewShare.hidden=YES;
    self.title=FGGetStringWithKeyFromTable(@"Invite friends", @"Language");
    [self addNoticeForKeyboard];
    [super viewWillAppear:animated];
}


-(void)addScroller
{
    ZscrollerView = [[UIScrollView alloc] init];
    //设置滚动范围
    if(self.view.width==375 && self.view.height==812)
    {
        ZscrollerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 713);
    }else if(self.view.width==320.f && self.view.height==568.f)
    {
        ZscrollerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 713);
    }else if(self.view.width==375.f && self.view.height==667.f)
    {
        ZscrollerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 713);
    }else{
        ZscrollerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 713);
    }
    //设置分页效果
    ZscrollerView.pagingEnabled = NO;
    //水平滚动条隐藏
    ZscrollerView.showsHorizontalScrollIndicator = NO;
    //// 给Scroller加一个点击手势
//    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
//    tap.numberOfTapsRequired = 1;
//    [ZscrollerView addGestureRecognizer:tap];
    ZscrollerView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(ZscrollerView.frame));
    [self.view addSubview:ZscrollerView];
    [self addtopView];
    [self addDownView];
}
-(void)addtopView
{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    self.topView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    image_top  = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-189)/2, 27, 189, 130)];;
    [image_top setImage:[UIImage imageNamed:@"invite-friends_illustration"]];
    Label_top = [[UILabel alloc] initWithFrame:CGRectMake(28, image_top.bottom+19, SCREEN_WIDTH-28*2, 50)];
    Label_top.numberOfLines=0;
    Label_top.lineBreakMode = UILineBreakModeWordWrap;
    Label_top.textAlignment=NSTextAlignmentCenter;
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第一段：placeholder
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:FGGetStringWithKeyFromTable(@"Invite your friends to Cleanpro & get free incentives", @"Language")];
    
    //    NSLog(@"%@",substring1.string);
    [SubStr1 appendAttributedString:substring1];
    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
    //设置文字颜色
    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    //设置文字大小
//    [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:rang];AppleGothic
    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ArialMT" size:20] range:rang];
    [string appendAttributedString:SubStr1];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [Label_top.text length])];
    Label_top.attributedText=string;
    
    [self.topView addSubview:image_top];
    [self.topView addSubview:Label_top];
    [ZscrollerView addSubview:self.topView];
}

-(void)addDownView
{
    self.DownView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, SCREEN_WIDTH, 409)];
    [self.DownView setBackgroundColor:[UIColor whiteColor]];
    D_label_t = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, SCREEN_WIDTH-40*2, 60)];
    D_label_t.numberOfLines=0;
    D_label_t.lineBreakMode = UILineBreakModeWordWrap;
    D_label_t.textAlignment=NSTextAlignmentCenter;
    [self setTEXT_d_label_t];
    /*
    D_title_t=[[UILabel alloc] initWithFrame:CGRectMake(23, D_label_t.bottom+14, SCREEN_WIDTH-23*2, 20)];
    D_title_t.textAlignment=NSTextAlignmentCenter;
    [D_title_t setText:FGGetStringWithKeyFromTable(@"Use your invitation code", @"Language")];
    [D_title_t setFont:[UIFont systemFontOfSize:14]];
    [D_title_t setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
    D_button_t = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, D_title_t.bottom+10, 160, 48)];
    D_button_t.textAlignment = NSTextAlignmentCenter;
    if(self.ModeUser!=nil)
    {
        [D_button_t setText:self.ModeUser.myInviteCode];
        
    }else
    {
        [D_button_t setText:@""];
    }
    [D_button_t setFont:[UIFont fontWithName: @"Helvetica-Bold"size:22 ]];
    [D_button_t setTextColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    D_button_t.layer.borderColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0].CGColor;
    D_button_t.layer.borderWidth = 0.5;
    D_button_t.layer.cornerRadius = 2;
    D_button_t.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [D_button_t addGestureRecognizer:labelTapGestureRecognizer];

//    D_label_Donw = [[UILabel alloc] initWithFrame:CGRectMake(15, D_button_t.bottom+24, SCREEN_WIDTH-15-33, 195)];
//    D_label_Donw.numberOfLines=0;
//    D_label_Donw.lineBreakMode = UILineBreakModeWordWrap;
//    D_label_Donw.textAlignment=NSTextAlignmentCenter;
    D_label_View = [[UIView alloc] initWithFrame:CGRectMake(15, D_button_t.bottom+24, SCREEN_WIDTH-15-33, 195)];
    for (int i= 0; i<4; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 31*i+8*i+3, 12, 15)];
        label.font = [UIFont systemFontOfSize:12.f];
        label.numberOfLines=0;
        [label setTextColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0]];
        UILabel * label_r = [[UILabel alloc] initWithFrame:CGRectMake(12+4, 31*i+8*i, SCREEN_WIDTH-31-20, 31)];
        label_r.font = [UIFont systemFontOfSize:12.f];
        label_r.numberOfLines=0;
        [label_r setTextColor:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0]];
        if(i==0)
        {
            [label setText:@"a)"];
            [label_r setText:FGGetStringWithKeyFromTable(@"The person that share will get RM2 for the 1st person that register", @"Language")];
        }else if(i==1)
        {
            [label setText:@"b)"];
            [label_r setText:FGGetStringWithKeyFromTable(@"The person that share will get RM2 for the 2nd person that register", @"Language")];
        }else if(i==2)
        {
            [label setText:@"c)"];
            [label_r setText:FGGetStringWithKeyFromTable(@"The person that share will get RM7 for the 3rd person that register", @"Language")];
        }else if(i==3)
        {
            [label setText:@"d)"];
            [label_r setText:FGGetStringWithKeyFromTable(@"For the 4th person that register, the structure for the amount of RM that the person that share will reset back to Point a (as above).", @"Language")];
            label_r.frame = CGRectMake(label_r.left, label_r.top, label_r.width, 47);
        }
        [D_label_View addSubview:label];
        [D_label_View addSubview:label_r];
    }
//    [self setTEXT_D_label_Donw];
     */
    [self addFriendsView];
    [self.DownView addSubview:D_label_t];
//    [self.DownView addSubview:D_title_t];
//    [self.DownView addSubview:D_button_t];
//    [self.DownView addSubview:D_label_View];
    [ZscrollerView addSubview:self.DownView];
}

-(void)addFriendsView
{
    UINib *nib = [UINib nibWithNibName:@"FriendsView" bundle:nil];
    NSArray *objs = [nib instantiateWithOwner:nil options:nil];
    Friends=objs[0];
    Friends.frame=CGRectMake(0 , D_label_t.bottom+10, SCREEN_WIDTH, 130);
    [Friends.ShareBtn setTitle:FGGetStringWithKeyFromTable(@"Share", @"Language") forState:(UIControlStateNormal)];
    [Friends.ShareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    Friends.ShareBtn.layer.borderColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0].CGColor;
    Friends.ShareBtn.layer.borderWidth = 0.5;
    Friends.ShareBtn.layer.cornerRadius = 4;
    
    [Friends.InpurBtn setTitle:FGGetStringWithKeyFromTable(@"Input", @"Language") forState:(UIControlStateNormal)];
    [Friends.InpurBtn setTitleColor:[UIColor darkTextColor] forState:(UIControlStateNormal)];
    
    Friends.InpurBtn.layer.borderColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0].CGColor;
    Friends.InpurBtn.layer.borderWidth = 0.5;
    Friends.InpurBtn.layer.cornerRadius = 4;
    self.FriendsBool=YES;
    [Friends.ShareBtn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [Friends.InpurBtn setBackgroundColor:[UIColor whiteColor]];
    [Friends.TextField setFont:[UIFont fontWithName:@"courer-Bold" size:22.f]];
    Friends.TextField.textColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    Friends.TextField.text=self.ModeUser.myInviteCode;
    Friends.TextField.delegate=self;
    Friends.TextField.layer.borderColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0].CGColor;
    Friends.TextField.layer.borderWidth = 0.5;
    Friends.TextField.keyboardType = UIKeyboardTypeASCIICapable;
    Friends.TextField.layer.cornerRadius = 4;
    [Friends.comeBtn setTitle:FGGetStringWithKeyFromTable(@"Share", @"Language") forState:(UIControlStateNormal)];
    Friends.comeBtn.layer.cornerRadius = 4;
    Friends.delegate =self;
    if(self.ModeUser.inviteCode == nil)
    {
        
    }else
    {
        Friends.InpurBtn.hidden=YES;
    }
    [self.DownView addSubview:Friends];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。//点击空白处取消TextField的第一响应
    [self.view addGestureRecognizer:tapGesture];
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
}
-(void)setTouch:(NSInteger)tagInteger
{
    if(tagInteger==101)
    {
        Friends.TextField.text=self.ModeUser.myInviteCode;
        self.FriendsBool=YES;
        [Friends.ShareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [Friends.ShareBtn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
        [Friends.InpurBtn setTitleColor:[UIColor darkTextColor] forState:(UIControlStateNormal)];
        [Friends.InpurBtn setBackgroundColor:[UIColor whiteColor]];
        [Friends.comeBtn setTitle:FGGetStringWithKeyFromTable(@"Share", @"Language") forState:(UIControlStateNormal)];
    }else if(tagInteger==102)
    {
        self.FriendsBool=NO;
        [Friends.InpurBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [Friends.InpurBtn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
        [Friends.ShareBtn setTitleColor:[UIColor darkTextColor] forState:(UIControlStateNormal)];
        [Friends.ShareBtn setBackgroundColor:[UIColor whiteColor]];
        [Friends.comeBtn setTitle:FGGetStringWithKeyFromTable(@"Input", @"Language") forState:(UIControlStateNormal)];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(self.FriendsBool==NO)
    {
        return YES;
    }else
    {
        NSLog(@"这里返回为NO。则为禁止编辑");
        return NO;
    }
    return YES;
}

-(void)setTouchText:(NSString *)FieldText
{
    NSLog(@"text==== %@",FieldText);
    if(self.FriendsBool==NO)
    {
        ///填写注册码
        [self sendInviteCode:FieldText];
    }else
    {
        ///分享
        [self addselect_view:1];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Copy successful!", @"Language") andDelay:1.5];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = Friends.TextField.text;
    }
}
-(void)addselect_view:(NSInteger)index
{
    if(ZheDang_View==nil)
    {
    ZheDang_View=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    [ZheDang_View setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.3]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [ZheDang_View addGestureRecognizer:tapSuperGesture22];
    self.DownViewShare.hidden=NO;
    [self.view addSubview:ZheDang_View];
        [self show_TCview];
    }else{
        
        [self show_TCview];
    }
}
- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    [self hidden_TCview];
//    [ZheDang_View removeGestureRecognizer:tapSuperGesture22 ];
}
-(void)show_TCview
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
        
        self->ZheDang_View.frame=self.view.bounds;
        self.DownViewShare.frame=CGRectMake(0, SCREEN_HEIGHT-125, SCREEN_WIDTH, 125);
        [self->ZheDang_View addSubview:self.DownViewShare];
    }completion:^(BOOL finished) {
        self.DownViewShare.hidden=NO;
    }];
    
}
-(void)hidden_TCview
{
    
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self.DownViewShare.hidden=YES;
        self.DownViewShare.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        
        self->ZheDang_View.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        
        
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        
        
    }];
}
-(void)sendInviteCode:(NSString *)inviteCode
{
    
    NSDictionary *dict = @{@"inviteCode":inviteCode
                           };
    NSLog(@"dict ====%@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_inviteCodeSend] parameters:dict progress:^(id progress) {
        NSLog(@"111  %@",progress);
    } Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSString *errorMessage = [dictObject objectForKey:@"errorMessage"];
//        NSNumber *statusCode1 = [dictObject objectForKey:@"statusCode"];
        if(errorMessage==nil)
        {
        
        if(statusCode==200)
        {
            
            
//            [HudViewFZ showMessageTitle:errorMessage andDelay:2.5];
            //            用来储存用户信息
            
            SaveUserIDMode * mode = [[SaveUserIDMode alloc] init];
            
            mode.phoneNumber = [dictObject objectForKey:@"phoneNumber"];//   手机号码
            mode.loginName = [dictObject objectForKey:@"loginName"];//   与手机号码相同
            mode.yonghuID = [dictObject objectForKey:@"id"]; ////用户ID
            //            mode.randomPassword = [dictObject objectForKey:@"randomPassword"];//  验证码
            //            mode.password = [dictObject objectForKey:@"password"];//  登录密码
            //            mode.payPassword = [dictObject objectForKey:@"payPassword"];//    支付密码
            mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
            mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
            NSNumber * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
            mode.birthday = [birthdayNum stringValue];
            mode.gender = [dictObject objectForKey:@"gender"];//       MALE:男，FEMALE:女
            mode.postCode = [dictObject objectForKey:@"postCode"];//   Post Code inviteCode
            mode.EmailStr = [dictObject objectForKey:@"email"];//   email
            mode.inviteCode = [dictObject objectForKey:@"inviteCode"];//       我填写的邀请码
            mode.myInviteCode = [dictObject objectForKey:@"myInviteCode"];//       我的邀请码
            mode.headImageUrl = [dictObject objectForKey:@"headImageUrl"];
            mode.payPassword = [dictObject objectForKey:@"payPassword"];
            ////个人中心需要用到积分
            NSDictionary * wallet = [dictObject objectForKey:@"wallet"];
            NSNumber * ba = [wallet objectForKey:@"balance"];
            NSNumber * credit = [wallet objectForKey:@"credit"];
            NSNumber * coupon = [dictObject objectForKey:@"couponCount"];
            mode.credit = [credit stringValue];
            mode.balance = [ba stringValue];
            mode.couponCount = [coupon stringValue];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
            
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            [jiamiStr base64Data_encrypt:mode.yonghuID];
            [self updateFri];
        }
        }else
        {
            [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
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

-(void)updateFri
{
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self setTouch:101];
    if(self.ModeUser.inviteCode == nil)
    {
        
    }else
    {
        Friends.InpurBtn.hidden=YES;
    }
}
- (IBAction)WhatsAppTouch:(id)sender {
    
     /////whatsApp分享
     NSString *msg = @"https://apps.apple.com/us/app/cleanpro/id1464618101?l=zh&ls=1";
     NSString *url = [NSString stringWithFormat:@"whatsapp://send?text=%@", [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
     NSURL *whatsappURL = [NSURL URLWithString: url];
     
     if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
     [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:^(BOOL success) {
     
     }];
     } else {
     // Cannot open whatsapp
     }
     
    
}
- (IBAction)FacebookTouch:(id)sender {
    /////Facebook分享
//     Example content. Replace with content from your app.
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:@"https://apps.apple.com/us/app/cleanpro/id1464618101?l=zh&ls=1"];
    
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.fromViewController = self;
        dialog.shareContent = content;
        dialog.delegate = self;
        dialog.mode = FBSDKShareDialogModeNative;
        [dialog show];
}
#pragma mark - FaceBook Share Delegate
/**
 Sent to the delegate when the share completes without error or cancellation.
 @param sharer The FBSDKSharing that completed.
 @param results The results from the sharer.  This may be nil or empty.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary<NSString *, id> *)results
{
    
    NSString *postId = results[@"postId"];
    FBSDKShareDialog *dialog = (FBSDKShareDialog *)sharer;
    if (dialog.mode == FBSDKShareDialogModeNative && (postId == nil || [postId isEqualToString:@""])) {
        // 如果使用webview分享的，但postId是空的，
        // 这种情况是用户点击了『完成』按钮，并没有真的分享
        //        [self showHUDWithModelText:NSLocalizedString(@"Share_canceled", nil)];
        NSLog(@"分享了，但是没有点击发送");
    } else {
        //分享成功
        //            [self showHUDWithModelText:NSLocalizedString(@"Share_successfully", nil)];
        NSLog(@"分享成功");
    }
    
}
/**
 Sent to the delegate when the sharer encounters an error.
 @param sharer The FBSDKSharing that completed.
 @param error The error.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"分享发生错误");
}

/**
 Sent to the delegate when the sharer is cancelled.
 @param sharer The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"取消了分享");
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
    CGFloat offset = (self.DownView.top+250+kbHeight) - (SCREEN_HEIGHT);
    
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
        self.view.frame = [UIScreen mainScreen].bounds;
    }];
}

#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"length===  %ld",Friends.TextField.text.length);
    if (textField == Friends.TextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
            });
            return YES;
        }else if (Friends.TextField.text.length <= 5) {
            
        }else
        {
            return NO;
        }
    }
    return YES;
}


-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Copy successful!", @"Language") andDelay:2.0];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = D_button_t.text;
}

-(void)setTEXT_d_label_t
{
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第一段：placeholder\n
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:FGGetStringWithKeyFromTable(@"Earn 100 points by inviting your friends You’ll earn 100 points for each invited friend", @"Language")];
    
    //    NSLog(@"%@",substring1.string);
    [SubStr1 appendAttributedString:substring1];
    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
    //设置文字颜色
    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] range:rang];
    //设置文字大小
        [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang];//AppleGothic
//    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ArialMT" size:14] range:rang];
    [string appendAttributedString:SubStr1];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [D_label_t.text length])];
    D_label_t.attributedText=string;
}

-(void)setTEXT_D_label_Donw
{
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第一段：placeholder
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:FGGetStringWithKeyFromTable(@"a) The person that share will get RM2 for the 1st person that register", @"Language")];
    
    //    NSLog(@"%@",substring1.string);
    [SubStr1 appendAttributedString:substring1];
    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
    //设置文字颜色
    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:rang];
    //设置文字大小
    [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:rang];//AppleGothic
    //    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ArialMT" size:14] range:rang];
    [string appendAttributedString:SubStr1];
    
    // 第二段：placeholder
    NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:FGGetStringWithKeyFromTable(@"\nb) The person that share will get RM2 for the 2nd person that register", @"Language")];
    
    //    NSLog(@"%@",substring1.string);
    [SubStr2 appendAttributedString:substring2];
    NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
    //设置文字颜色
    [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:rang2];
    //设置文字大小
    [SubStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:rang2];//AppleGothic
    //    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ArialMT" size:14] range:rang];
    [string appendAttributedString:SubStr2];
    
    // 第三段：placeholder
    NSMutableAttributedString * SubStr3=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring3 = [[NSAttributedString alloc] initWithString:FGGetStringWithKeyFromTable(@"\nc) The person that share will get RM7 for the 3rd person that register", @"Language")];
    
    //    NSLog(@"%@",substring1.string);
    [SubStr3 appendAttributedString:substring3];
    NSRange rang3 =[SubStr3.string rangeOfString:SubStr3.string];
    //设置文字颜色
    [SubStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:rang3];
    //设置文字大小
    [SubStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:rang3];//AppleGothic
    //    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ArialMT" size:14] range:rang];
    [string appendAttributedString:SubStr3];
    
    // 第四段：placeholder
    NSMutableAttributedString * SubStr4=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring4 = [[NSAttributedString alloc] initWithString:FGGetStringWithKeyFromTable(@"\nd) For the 4th person that register, the structure for the amount of RM that the person that share will reset back to Point a (as above).", @"Language")];
    
    //    NSLog(@"%@",substring1.string);
    [SubStr4 appendAttributedString:substring4];
    NSRange rang4 =[SubStr4.string rangeOfString:SubStr4.string];
    //设置文字颜色
    [SubStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0] range:rang4];
    //设置文字大小
    [SubStr4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:rang4];//AppleGothic
    //    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ArialMT" size:14] range:rang];
    [string appendAttributedString:SubStr4];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:1];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [D_label_Donw.text length])];
    D_label_Donw.attributedText=string;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 根据字符串计算label高度
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}


@end
