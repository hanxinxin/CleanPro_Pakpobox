//
//  ContactViewController.m
//  Cleanpro
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()
{
    UIScrollView * ScrollView_Z;
}
@property (nonatomic ,strong)NSArray * arrTitle;
@end

@implementation ContactViewController
@synthesize Label_Z,arrTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    CLEANPRO EXPRESS SDN BHD
    
    Address
    No. 24, Jalan Puchong Permai 2,
    Taman Puchong Permai,
    47150 Puchong,
    Selangor Darul Ehsan Malaysia.
    
    Tel
    +6 03-5879 1228 / 03-5879 1268
    
    Careline Number
    +603-2770 0100
    
    Email
    info@cleanproexpress.com
     */
    if (@available(iOS 11.0, *)) {
        ScrollView_Z.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        ScrollView_Z.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        ScrollView_Z.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
    }
    if(SCREEN_HEIGHT==812.f)
    {
        ScrollView_Z = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH,360)];
    }else{
        ScrollView_Z = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH,360)];
    }
    ScrollView_Z.backgroundColor=[UIColor whiteColor];
    //    NSLog(@"SCREEN_HEIGHT=  %f",SCREEN_HEIGHT+30);
    ScrollView_Z.contentSize = CGSizeMake(SCREEN_WIDTH, 360);
    //设置分页效果
    ScrollView_Z.pagingEnabled = NO;
    //水平滚动条隐藏
    ScrollView_Z.showsHorizontalScrollIndicator = NO;
    ScrollView_Z.showsVerticalScrollIndicator = NO;
    [self.view addSubview:ScrollView_Z];
//    arrTitle =  [NSArray arrayWithObjects:@[@"Address\n",@"No. 24, Jalan Puchong Permai 2,\nTaman Puchong Permai,\n47150 Puchong,\nSelangor Darul Ehsan Malaysia.\n\n"],@[@"Tel\n",@"+6 03-5879 1228 / 03-5879 1268\n\n"],@[@"Careline Number\n",@"+603-2770 0100\n\n"],@[@"Email\n",@"info@cleanproexpress.com\n\n"],nil];
    arrTitle =  [NSArray arrayWithObjects:@[FGGetStringWithKeyFromTable(@"Address\n", @"Language"),FGGetStringWithKeyFromTable(@"No. 24, Jalan Puchong Permai 2,\nTaman Puchong Permai,\n47150 Puchong,\nSelangor Darul Ehsan Malaysia.\n\n", @"Language")],@[FGGetStringWithKeyFromTable(@"Tel\n", @"Language"),FGGetStringWithKeyFromTable(@"+6 03-5879 1228 / 03-5879 1268\n\n", @"Language")],@[FGGetStringWithKeyFromTable(@"Careline Number\n", @"Language"),FGGetStringWithKeyFromTable(@"+603-2770 0100\n\n", @"Language")],@[FGGetStringWithKeyFromTable(@"Email\n", @"Language"),FGGetStringWithKeyFromTable(@"info@cleanproexpress.com\n\n", @"Language")],nil];
    
    [self setlabelText];
    
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.title=@"Cleapro";
    self.title=FGGetStringWithKeyFromTable(@"Settings", @"Language");
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-15*2, 50)];
    labelTitle.backgroundColor=[UIColor whiteColor];
    labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
    labelTitle.numberOfLines = 0;
//    [labelTitle setVerticalAlignment:VerticalAlignmentTop];
    labelTitle.textAlignment=NSTextAlignmentLeft;
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] init];
    // 标题
    NSMutableAttributedString * SubStr3=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring3 = [[NSAttributedString alloc] initWithString:FGGetStringWithKeyFromTable(@"CLEANPRO EXPRESS SDN BHD\n", @"Language")];
    [SubStr3 appendAttributedString:substring3];
    NSRange rang3 =[SubStr3.string rangeOfString:SubStr3.string];
    //设置文字颜色
    [SubStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang3];
    //设置文字大小
    [SubStr3 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang3];
    [string3 appendAttributedString:SubStr3];
    labelTitle.attributedText=string3;
    [ScrollView_Z addSubview:labelTitle];
    
    
    Label_Z.frame = CGRectMake(15, labelTitle.bottom+8, SCREEN_WIDTH-15*2, 310);
//    Label_Z.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    Label_Z.backgroundColor=[UIColor whiteColor];
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
//            [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
            //设置文字大小
//            [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:14] range:rang];
//            [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang];
            //设置文字颜色
            [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
            //设置文字大小
            [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang];
            [string appendAttributedString:SubStr1];
            // 第二段：placeholder
            NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
            NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:arr[1]];
            [SubStr2 appendAttributedString:substring2];
            NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
            //设置文字颜色
            [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0] range:rang2];
            //设置文字大小
            [SubStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang2];//AppleGothic
            [string appendAttributedString:SubStr2];
            
        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [Label_Z.text length])];
    Label_Z.attributedText=string;
    [ScrollView_Z addSubview:Label_Z];
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
