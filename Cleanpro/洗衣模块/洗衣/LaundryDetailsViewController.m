//
//  LaundryDetailsViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LaundryDetailsViewController.h"
#import "LaundrySuccessViewController.h"
#import "HomeViewController.h"

@interface LaundryDetailsViewController ()<UIGestureRecognizerDelegate>
{
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

@implementation LaundryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settopViewText];
}
- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self hidden_TCview];
    [super viewWillAppear:animated];
    
}

-(void)settopViewText
{
    
    self.machineNo_label.text=[NSString stringWithFormat:@"#%@",self.arrayList[1]];
    self.Temperature_label.text=[self.order_c.goods_info objectForKey:@"temperature"];
//    self.price_label.text=self.order_c.total_amount;
    [self setprice_labelText:self.order_c.total_amount];
}
-(void)setprice_labelText:(NSString *)str
{
     NSString * string= [NSString stringWithFormat:@"RM %@",str];
    NSRange rang_3 = [string rangeOfString:string];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    self.price_label.attributedText = attributStr;
}
- (IBAction)pay_touch:(id)sender {
//
    [self addtextView_view];
//    [self addselect_view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


#pragma mark ------- 全屏View 背景透明 --------

/**
 全屏View 背景透明 //没钱支付的时候提示他需要充值
 */
-(void)addselect_view
{
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
    [miaoshu_lable setText:@"You balance is insufficient,please recharge"];
    miaoshu_lable.font = [UIFont systemFontOfSize:14];
    //文字居中显示
    miaoshu_lable.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    miaoshu_lable.numberOfLines = 0;
    back_btn = [[UIButton alloc] initWithFrame:CGRectMake(29*autoSizeScaleX_6, 80+15, 100, 40)];
    [back_btn setTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language") forState:UIControlStateNormal];
    [back_btn setBackgroundColor:[UIColor whiteColor]];
    [back_btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    back_btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    back_btn.layer.cornerRadius=4;
    back_btn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1].CGColor;//设置边框颜色
    back_btn.layer.borderWidth = 1.0f;//设置边框颜色
    [back_btn addTarget:self action:@selector(Touch_two:) forControlEvents:UIControlEventTouchDown];
    Come_btn = [[UIButton alloc] initWithFrame:CGRectMake(29*autoSizeScaleX_6+(SCREEN_WIDTH-(38*autoSizeScaleX_6*2)-100*2-29*autoSizeScaleX_6*2)+100, 80+15, 100, 40)];
    [Come_btn setTitle:FGGetStringWithKeyFromTable(@"Recharge", @"Language") forState:UIControlStateNormal];
    [Come_btn setBackgroundColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1]];
    [Come_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    Come_btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    Come_btn.layer.cornerRadius=4;
    Come_btn.layer.borderColor = [UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1].CGColor;//设置边框颜色
    Come_btn.layer.borderWidth = 1.0f;//设置边框颜色
    [Come_btn addTarget:self action:@selector(Touch_one:) forControlEvents:UIControlEventTouchDown];
    
    [TC_CenterView addSubview:tisp_lable];
    [TC_CenterView addSubview:miaoshu_lable];
    [TC_CenterView addSubview:Come_btn];
    [TC_CenterView addSubview:back_btn];
    [self.view addSubview:Tuicang_View];
    [self show_TCview];
}

/**
 密码输入框、、、弹出支付框
 */
-(void)addtextView_view
{
    __block LaundryDetailsViewController *  blockSelf = self;
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
            blockSelf.Pay_passwordStr=password;
            [blockSelf JYPayPassword];
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
    vc.order_c=self.order_c;
    [self.navigationController pushViewController:vc animated:YES];
}

//  校验支付密码
-(void)JYPayPassword
{
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"payPassword":self.Pay_passwordStr};
    NSLog(@"dict=== %@",dict);
    __block LaundryDetailsViewController *  blockSelf = self;
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_jiaoyanPayPassword] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"ObjectJY = %@",responseObject);
        NSDictionary * dictObject=(NSDictionary *)responseObject;
        NSNumber * code= [dictObject objectForKey:@"result"];
        NSNumber * statusCodeBer =[dictObject objectForKey:@"statusCode"];
        
        
        if([statusCodeBer intValue] ==401)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TokenError"];
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[HomeViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    
                }
            }
        }else{
        if([code intValue]==0)
        {
            [HudViewFZ showMessageTitle:@"statusCode error" andDelay:2.0];
            [blockSelf->textfiledView clearPassword];
            [blockSelf tisp];
            
        }else
        {

            [blockSelf postOrder];
            
        }
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [blockSelf->textfiledView clearPassword];
        [HudViewFZ HiddenHud];
        if(statusCode==401)
        {
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else{
            [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
            
        }
    }];
}


-(void)postOrder
{
    [HudViewFZ labelExample:self.view];
//    __block LaundryDetailsViewController *  blockSelf = self;
    NSDictionary *dict = @{@"machine_no":self.order_c.machine_no, @"total_amount":self.order_c.total_amount, @"order_type":self.order_c.order_type, @"client_type":self.order_c.client_type, @"goods_info":[jiamiStr convertToJSONData:self.order_c.goods_info]};
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_order] parameters:dict progress:^(id progress) {
        NSLog(@"111  %@",progress);
    } Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        if(statusCode==200)
        {
            
            NSDictionary * resp=(NSDictionary *)responseObject;
            NSNumber * code= [resp objectForKey:@"statusCode"];
            NSString * errorMessage= [resp objectForKey:@"errorMessage"];
            if([code intValue]==500){
                 [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
            }else if([code intValue]==400509)
            {
                [HudViewFZ showMessageTitle:errorMessage andDelay:2.0];
            }else
            {
                [self pushView];
            }
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"3333   %@",error);
        [HudViewFZ HiddenHud];
        if(statusCode==401)
        {
            [HudViewFZ showMessageTitle:@"Token expired" andDelay:2.0];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"tongzhiViewController" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else{
            [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
            
        }
    }];
    
}

-(void)tisp
{
    [HudViewFZ showMessageTitle:@"Wrong password" andDelay:2.0];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
