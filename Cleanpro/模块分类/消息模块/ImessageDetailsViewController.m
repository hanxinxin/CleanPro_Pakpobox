//
//  ImessageDetailsViewController.m
//  Cleanpro
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ImessageDetailsViewController.h"
#import "ViewOrder.h"
#import "tipsView.h"
#import "titleView.h"
@interface ImessageDetailsViewController ()
@property (weak,nonatomic) MBProgressHUD* HUD;
@property (nonatomic,strong) Message_order * mode_O;
@end

@implementation ImessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.title=FGGetStringWithKeyFromTable(@"Messages", @"Language");
    [self.navigationController.navigationBar setTranslucent:NO];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self getURL];
    });
//   [self addStrLabel];
    
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.title=@"Cleapro";
    self.title = FGGetStringWithKeyFromTable(@"Inbox", @"Language");
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    返回按钮的颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationController.navigationBar.translucent = NO;
    
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    sendMessage(@"ReturnMessage")
    [super viewWillDisappear:animated];
}

-(void)getURL
{
    [self labelExample];
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    SaveUserIDMode *ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self get_read_Message:self.mode_Message.ID YonghuID:ModeUser.yonghuID];
}

-(void)addStrLabel
{
    
    if(self.mode_Message != nil)
    {
    if([self.mode_Message.messageType intValue]==1 || [self.mode_Message.messageType intValue]==2){
        titleView *titleView1 = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([titleView class]) owner:nil options:nil] lastObject];
        titleView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 108);
        titleView1.title_label.text = [NSString stringWithFormat:@"%@",self.mode_Message.message];
        titleView1.time_label.text = [NSString stringWithFormat:@"%@",self.mode_Message.generatedDateTime];
        
        [self.view addSubview:titleView1];
        
        ViewOrder *ViewOrder1 = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ViewOrder class]) owner:nil options:nil] lastObject];
        ViewOrder1.frame = CGRectMake(0, titleView1.bottom+1, SCREEN_WIDTH, 128);
        if(self.mode_O!=nil)
        {
            [ViewOrder1 setLabelText_OrderNo:self.mode_O.orderNo];
            [ViewOrder1 setLabelText_Location:self.mode_O.location];
            [ViewOrder1 setLabelText_MachineNo:[self getString:self.mode_O.machineNo]];
        }else
        {
            [ViewOrder1 setLabelText_OrderNo:@""];
            [ViewOrder1 setLabelText_Location:@""];
            [ViewOrder1 setLabelText_MachineNo:@""];
        }
        [self.view addSubview:ViewOrder1];
        
        tipsView *tipsView1 = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([tipsView class]) owner:nil options:nil] lastObject];
        tipsView1.frame = CGRectMake(0, ViewOrder1.bottom+1, SCREEN_WIDTH, 68);
        [self.view addSubview:tipsView1];
    }else if ([self.mode_Message.messageType intValue]==3)
    {
        titleView *titleView1 = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([titleView class]) owner:nil options:nil] lastObject];
        titleView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 108);
        titleView1.title_label.text = [NSString stringWithFormat:@"%@",self.mode_Message.message];
        titleView1.time_label.text = [NSString stringWithFormat:@"%@",self.mode_Message.generatedDateTime];
        [self.view addSubview:titleView1];
        
        tipsView *tipsView1 = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([tipsView class]) owner:nil options:nil] lastObject];
        tipsView1.frame = CGRectMake(0, titleView1.bottom+1, SCREEN_WIDTH, 68);
        [tipsView1.right_Label setText:FGGetStringWithKeyFromTable(@"Thank you for washing clothes with Cleanpro !", @"Language")];
        [self.view addSubview:tipsView1];
    }
    
    }
}

-(NSString *)getString:(NSString *) str
{
    NSArray *array = [str componentsSeparatedByString:@"#"];
    NSString * getStr = array[1];
    return getStr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)get_read_Message:(NSString *)messageID YonghuID:(NSString*)YonghuID
{
    
    NSLog(@"URL = %@",[NSString stringWithFormat:@"%@%@/%@?memberId=%@",FuWuQiUrl,get_readMessage,messageID,YonghuID]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@/%@?memberId=%@",FuWuQiUrl,get_readMessage,messageID,YonghuID] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"成功kkk =%@",responseObject);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        NSDictionary * responseDictionart=(NSDictionary*)responseObject;
                NSDictionary * body = [responseDictionart objectForKey:@"body"];
        if(body!=nil)
        {
            NSString * content = [body objectForKey:@"content"];
            NSDictionary * contentDic = [ImessageDetailsViewController dictionaryWithJsonString:content];
            self->_mode_O = [[Message_order alloc] init];
            self->_mode_O.boxCode = [contentDic objectForKey:@"boxCode"];
            self->_mode_O.location = [contentDic objectForKey:@"location"];
            self->_mode_O.machineNo = [contentDic objectForKey:@"machineNo"];
            self->_mode_O.machineType = [contentDic objectForKey:@"machineType"];
            self->_mode_O.orderNo = [contentDic objectForKey:@"orderNo"];
            self->_mode_O.orderType = [contentDic objectForKey:@"orderType"];
            [self addStrLabel];
        }else
        {
//                NSString * content = [body objectForKey:@"content"];
//                NSDictionary * contentDic = [ImessageDetailsViewController dictionaryWithJsonString:content];
            NSDictionary * contentDic=(NSDictionary*)responseObject;
                self->_mode_O = [[Message_order alloc] init];
                self->_mode_O.boxCode = [contentDic objectForKey:@"boxCode"];
                self->_mode_O.location = [contentDic objectForKey:@"location"];
                self->_mode_O.machineNo = [contentDic objectForKey:@"machineNo"];
                self->_mode_O.machineType = [contentDic objectForKey:@"machineType"];
                self->_mode_O.orderNo = [contentDic objectForKey:@"orderNo"];
                self->_mode_O.orderType = [contentDic objectForKey:@"orderType"];
                [self addStrLabel];
            
        }
        
        
    } failure:^(NSError *error) {
        //        [self textExample:@"请求失败!"];
        NSLog(@"error =  %@",error);
        if(self.HUD!=nil){
            [self.HUD hideAnimated:YES];
        }
        // 结束刷新状态
//        [self.tableViewT.mj_header  endRefreshing];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Request timed out!", @"Language") andDelay:1.5];
    }];
}




///// 登录HUD提示
- (void)labelExample {
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    self.HUD.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
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

@end
