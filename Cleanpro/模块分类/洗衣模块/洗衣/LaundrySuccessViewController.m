//
//  LaundrySuccessViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LaundrySuccessViewController.h"
#import "HomeViewController.h"
#import "MyAccountViewController.h"
#import "WCQRCodeScanningVC.h"
#import "ShakeViewController.h"
//#import <luckysdk/utils.h>
#import "AppDelegate.h"

@interface LaundrySuccessViewController ()
@property (nonatomic,strong)NSString * taskCommandStr;
@end

@implementation LaundrySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self presenViewcontroller]; //// 暂时先屏蔽   第二版本开启
//    [self postOrder];
    self.Compelet_btn.layer.cornerRadius = 18;//2.0是圆角的弧度，根据需求自己更改
    [self setimage];
    [self.title_text setText:FGGetStringWithKeyFromTable(@"Success!", @"Language")];
    [self.tips_text setText:FGGetStringWithKeyFromTable(@"Please click start on the machine!", @"Language")];
    [self.Compelet_btn setTitle:FGGetStringWithKeyFromTable(@"Complete", @"Language") forState:(UIControlStateNormal)];
//    [Manager.inst checkConnect];
//    [Manager.inst addLsnr:self];
    self.taskCommandStr=@"";
}
-(void)setimage
{
    if([self.order_c.order_type isEqualToString:@"LAUNDRY"])
    {
        [self.iamge_set setImage:[UIImage imageNamed:@"success_laundry"] forState:UIControlStateNormal];
        self.title =FGGetStringWithKeyFromTable(@"Washer", @"Language");
    }else if([self.order_c.order_type isEqualToString:@"DRYER"])
    {
        [self.iamge_set setImage:[UIImage imageNamed:@"success_dryer"] forState:UIControlStateNormal];
        self.title =FGGetStringWithKeyFromTable(@"Dryer", @"Language");
    }
    
}

-(void)presenViewcontroller
{
    ShakeViewController * avc = [[ShakeViewController alloc] init];
    [self presentViewController:avc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
    //    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [HudViewFZ labelExample:self.view];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [self get_order_task_ZL];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationRead:) name:@"NotificationRead" object:nil];
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

-(void)NotificationRead:(NSNotification *)noti
{
    [HudViewFZ HiddenHud];
    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Data was successfully sent to BLE", @"Language") andDelay:2.5];
}


-(void)get_order_task_ZL
{
    NSLog(@"GetOrder URL = %@",[NSString stringWithFormat:@"%@%@%@/task",FuWuQiUrl,get_order_task,self.orderidStr]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:[NSString stringWithFormat:@"%@%@%@/task",FuWuQiUrl,get_order_task,self.orderidStr] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject=  %@",responseObject);
        
        //        NSDictionary * dictionary = (NSDictionary*)responseObject;
        //
        //        NSArray * resultListArr=[dictionary objectForKey:@"resultList"];
        
        NSDictionary * dictionary = (NSDictionary *)responseObject;
        NSString * taskCommand=[dictionary objectForKey:@"taskCommand"];
        self.taskCommandStr = taskCommand;
        [self sendStrCmd:taskCommand];
//        [self sendDeviceData:@"01017880-0000-0000-83cd-c0bb04840000" taskCommand:taskCommand];
        
//        @"031119190001110e0066";
        
    } failure:^(NSInteger statusCode, NSError *error) {
    
        [HudViewFZ HiddenHud];
   
    }];
}
-(void)sendStrCmd:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@";"];
    for (int i=0; i<array.count; i++) {
        NSString * strCommand = array[i];
        /*
        [self sendDeviceData:@"" taskCommand:strCommand];
         */
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //    [appDelegate.appdelegate1 closeConnected];
        NSString * deviceName = self.arrayList[1];
        NSData * dataAAA = [self getData:strCommand];
        [appDelegate.appdelegate1 dataSendWithNameStr:deviceName dataA:dataAAA];
//    [HudViewFZ HiddenHud];
        if(array.count==1)
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [HudViewFZ HiddenHud];
//                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"未收到Return data", @"Language") andDelay:2.5];
            });
        }else{
        if(i==1)
        {
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [HudViewFZ HiddenHud];
//                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"未收到Return data", @"Language") andDelay:2.5];
            });
            
            break;
        }
            [NSThread sleepForTimeInterval:8.0];
        }
        
    }
}
- (NSData *) getData: (NSString *) t {
    NSString * d = t;
    if (d == nil || d.length == 0) d = @"00";
    
//    NSLog(@"数据 ： = %@",[NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]);
//    return decodeHex([NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]);
    return [self convertHexStrToData:[NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]];
    
}
// 十六进制字符串转换成NSData
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
-(void)sendDeviceData:(NSString*)DeviceStr taskCommand:(NSString *)taskCommand
{
//    UniId *  idA = [UniId fromStr:DeviceStr];
//    //    UniId *  idA = [UniId fromStr:@"01017880-0000-0000-83ce-c017048500c0"];
//    //    idA
//    Device * dev = [Manager.inst getDevice:idA];
//    NSLog(@"dev = %@",dev);
//    [Manager.inst setGPIO:dev :0 :0 :0 :0 :0];
//    Byte byte1[] = {0xaa, 0x55, 0x00, 0x00};
//    Byte byte1[]  = {0x03,0x11,0x19,0x19,0x00,0x01,0x11,0x0e,0x00,0x66};
//    NSData * data = [NSData dataWithBytes:byte1 length:10];
//    NSData *data = [taskCommand dataUsingEncoding:NSUTF8StringEncoding];
//    [Manager.inst sendPureData:dev :data];
    NSLog(@"s发送 = %@",taskCommand);
//    [Manager.inst sendPureData:self.DeviceStr :[self getData:taskCommand]];

}

- (void) onPureData:(int) srcId :(int) destId :(NSData *) data
{
    NSLog(@"data11 = %@",data);
}

- (IBAction)Compelet_touch:(id)sender {
//    [Manager.inst disconnect];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WCQRCodeScanningVC class]]) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.appdelegate1 closeConnected];
            [self.navigationController popToViewController:temp animated:YES];
            
        }
    }
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MyAccountViewController class]]) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.appdelegate1 closeConnected];
            [self.navigationController popToViewController:temp animated:YES];
            ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
        }
    }
    
//    if(![self.taskCommandStr isEqualToString:@""])
//    {
//        [self sendStrCmd:self.taskCommandStr];
//    }
}


// 点击back按钮后调用 引用的他人写的一个extension
- (BOOL)navigationShouldPopOnBackButton {
    NSLog(@"重置密码返回啦");
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WCQRCodeScanningVC class]]) {
//            [Manager.inst disconnect];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.appdelegate1 closeConnected];
            [self.navigationController popToViewController:temp animated:YES];
            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
            
        }
    }
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[MyAccountViewController class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
//        }
//    }
    return YES;
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

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}

//普通字符串转换为十六进制的。

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

@end
