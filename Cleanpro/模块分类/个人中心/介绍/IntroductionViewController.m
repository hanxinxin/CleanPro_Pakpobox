//
//  IntroductionViewController.m
//  Cleanpro
//
//  Created by mac on 2019/2/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "IntroductionViewController.h"

@interface IntroductionViewController ()
{
    
}
@property (nonatomic ,strong)NSArray * arrTitle;
@end

@implementation IntroductionViewController
@synthesize Label_Z,arrTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    arrTitle =  [NSArray arrayWithObjects:@[@"Q1: How to use machine?\n",@"There is a QR code attached on the machine,click “scan” function at the bottom of HomePage,just scan the QR code.\n\n"],@[@"Q2: How to recharge?\n",@"There is a wallet in My Account, you can recharge by using  IPay 88.\n\n"],@[@"Q3: How to set payment password?\n",@"In wallet, you can set your payment password,If you forget or want to change it, still here.\n\n"],@[@"Q4: How to add extra time for dryer machine?\n",@"In  orders, click the order of dryer, there is a button that you can add time.\n\n"],nil];
    arrTitle =  [NSArray arrayWithObjects:@[FGGetStringWithKeyFromTable(@"Q1: How to use machine?\n", @"Language"),FGGetStringWithKeyFromTable(@"There is a QR code attached on the machine,click “scan” function at the bottom of HomePage,just scan the QR code.\n\n", @"Language")],@[FGGetStringWithKeyFromTable(@"Q2: How to recharge?\n", @"Language"),FGGetStringWithKeyFromTable(@"There is a wallet in My Account, you can recharge by using  IPay 88.\n\n", @"Language")],@[FGGetStringWithKeyFromTable(@"Q3: How to set payment password?\n", @"Language"),FGGetStringWithKeyFromTable(@"In wallet, you can set your payment password,If you forget or want to change it, still here.\n\n", @"Language")],@[FGGetStringWithKeyFromTable(@"Q4: How to add extra time for dryer machine?\n", @"Language"),FGGetStringWithKeyFromTable(@"In  orders, click the order of dryer, there is a button that you can add time.\n\n", @"Language")],nil];
    
    [self setlabelText];
    
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.title=@"Cleapro";
    self.title=FGGetStringWithKeyFromTable(@"Introduction", @"Language");
//    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    });
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}
-(void)setlabelText
{
    Label_Z.frame = CGRectMake(15, 20, SCREEN_WIDTH-15*2, SCREEN_HEIGHT);
    Label_Z.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    Label_Z.lineBreakMode = NSLineBreakByCharWrapping;
    Label_Z.numberOfLines = 0;
    [Label_Z setVerticalAlignment:VerticalAlignmentTop];
    Label_Z.textAlignment=NSTextAlignmentLeft;
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    if(arrTitle.count>0)
    {
        
        for (int i = 0; i<arrTitle.count; i++) {
            NSArray * arr= arrTitle[i];
    // 第一段：placeholder
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:arr[0]];
    [SubStr1 appendAttributedString:substring1];
    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
    //设置文字颜色
    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    //设置文字大小
    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang];
    [string appendAttributedString:SubStr1];
    // 第二段：placeholder
    NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:arr[1]];
    [SubStr2 appendAttributedString:substring2];
    NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
    //设置文字颜色
    [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] range:rang2];
    //设置文字大小
        [SubStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang2];//AppleGothic
    [string appendAttributedString:SubStr2];

        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [Label_Z.text length])];
    Label_Z.attributedText=string;
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
