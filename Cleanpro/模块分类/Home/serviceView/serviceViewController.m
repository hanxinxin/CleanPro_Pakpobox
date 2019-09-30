//
//  serviceViewController.m
//  Cleanpro
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018 mac. All rights reserved.
//

#import "serviceViewController.h"

@interface serviceViewController ()
{
    
    NSMutableAttributedString * attributedPlaceholder;
    // 读取账户
    NSString * diquStr;
    UIScrollView * ScrollView_Z;
}
@end

@implementation serviceViewController
@synthesize Label_zong;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        ScrollView_Z.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        ScrollView_Z.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        ScrollView_Z.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
    }
    self.title=@"Service";
    self.tagg=0;
    if(SCREEN_HEIGHT==812.f)
    {
        ScrollView_Z = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        ScrollView_Z.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+5);
    }else if(SCREEN_HEIGHT==568.f){
        ScrollView_Z = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        ScrollView_Z.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+140);
    }else if(SCREEN_HEIGHT==736.000000 && SCREEN_WIDTH == 414.000000){
        ScrollView_Z = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        ScrollView_Z.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+20);
    }else if(SCREEN_HEIGHT==667.000000 && SCREEN_WIDTH == 375.000000)
    {
        ScrollView_Z = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        ScrollView_Z.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+30);
    }else{
        ScrollView_Z = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        ScrollView_Z.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+70);
    }
    ScrollView_Z.backgroundColor=[UIColor clearColor];
    //    NSLog(@"SCREEN_HEIGHT=  %f",SCREEN_HEIGHT+30);
    
    //设置分页效果
    ScrollView_Z.pagingEnabled = NO;
    //水平滚动条隐藏
    ScrollView_Z.showsHorizontalScrollIndicator = NO;
    ScrollView_Z.showsVerticalScrollIndicator = NO;
    [self.view addSubview:ScrollView_Z];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取账户
//    diquStr = [userDefaults objectForKey:@"DIQU"];
//    if(DIQU_Number==2300)
//    {
        if(self.tagg==0)
        {
            [self setLabel_text:self.tagg];
        }else if (self.tagg==1)
        {
            [self setLabel_text_New:self.tagg];
        }else if (self.tagg==2)
        {
            [self setLabel_text_New:self.tagg];
        }
//    }else if (DIQU_Number==2200)
//    {
//
//        [self setLabel_text:self.tagg];
//
//    }
    
    
}

-(void)setLabel_text:(NSInteger)tagg
{
    if(self.view.height>=812)
    {
        //       q_label.frame=CGRectMake(20, 79, SCREEN_WIDTH-40, SCREEN_HEIGHT-79);
        Label_zong.frame=CGRectMake(20, 0, SCREEN_WIDTH-40, 630);
    }else
    {
        
        //     q_label.frame=CGRectMake(20, 79+20, SCREEN_WIDTH-40, SCREEN_HEIGHT-79-20);
        Label_zong.frame=CGRectMake(20, 0, SCREEN_WIDTH-40, 710);
    }
//    Label_zong.backgroundColor = [UIColor redColor];
    //自动折行设置
    Label_zong.lineBreakMode = UILineBreakModeWordWrap;
    Label_zong.numberOfLines = 0;
    
    
//    if([diquStr isEqualToString:@"2300"])
//    {
        // 富文本用法3 - 图文混排
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        // 第一段：placeholder
        NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
        NSAttributedString *substring1;
        if(self.tagg==0)
        {
            substring1  = [[NSAttributedString alloc] initWithString:@"SELF-SERVICE LAUNDRY MANAGEMENT\n\n"];
        }else if (self.tagg==1)
        {
            substring1  = [[NSAttributedString alloc] initWithString:@"SELF-SERVICE LAUNDRY MANAGEMENT\n\n"];
        }
        //    NSLog(@"%@",substring1.string);
        [SubStr1 appendAttributedString:substring1];
        NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
        //设置文字颜色
        [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
        //设置文字大小
        [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:rang];
        [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang];
        [string appendAttributedString:SubStr1];
        // 第二段：图片
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        if(self.iamge_str!=nil){
            attachment.image =[UIImage imageNamed:self.iamge_str];
        }else
        {
            attachment.image = [UIImage imageNamed:@"img"];
        }
        attachment.bounds = CGRectMake(0, 45, Label_zong.width, 130);
        NSAttributedString *subtring2 = [NSAttributedString attributedStringWithAttachment:attachment];
        [string appendAttributedString:subtring2];
    
    NSMutableAttributedString * SubStrNIL=[[NSMutableAttributedString alloc] init];
    NSString * stringNIL = @"\n";
    NSAttributedString *substringNIL = [[NSAttributedString alloc] initWithString:stringNIL];
    [SubStrNIL appendAttributedString:substringNIL];
    [string appendAttributedString:SubStrNIL];
        
        // 第三段：哈哈
        NSMutableAttributedString * SubStr3=[[NSMutableAttributedString alloc] init];
    NSString * string11 = @"In the year 2010, Cleanpro Laundry Holdings Sdn Bhd adopted the advanced ”Self-service Laundry Management” by an American company, Dexter Laundry. Since then, Cleanpro Laundry Holdings Sdn Bhd has converted its first conventional laundry in Jalan Imbi into the ”Integrated Laundry Services (2 in 1) Concept“.\n\n";
    NSString * price = @"In the year 2010";
    NSAttributedString *substring3 = [[NSAttributedString alloc] initWithString:string11];
    [SubStr3 appendAttributedString:substring3];
    [SubStr3 addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:13.0]
                    range:[string11 rangeOfString:string11]];
    [SubStr3 addAttribute:NSForegroundColorAttributeName
                    value:[UIColor lightGrayColor]
                    range:[string11 rangeOfString:string11]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [SubStr3 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string11 length])];
    //获取需要改变的字符串在完整字符串的范围
    NSRange rang11 = [string11 rangeOfString:price];
    //    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    
    //设置文字大小
    [SubStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang11];
    [SubStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang11];
    [SubStr3 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:14] range:rang11];
    //设置文字背景色
    [SubStr3 addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang11];
    [string appendAttributedString:SubStr3];
    
    // 第三段：哈哈
    NSMutableAttributedString * SubStr4=[[NSMutableAttributedString alloc] init];
//    NSAttributedString *substring4 = [[NSAttributedString alloc] initWithString:@"In early 2011, Cleanpro Laundry Holdings Sdn Bhd has further transformed into ”24/7 No manpower Self-service Laundry Concept” by bringing in and opening up to high-tech equipment, committed to the research and development of a self-planning business model. At this time, the first business model of Cleanpro Express is formed.\n"];
    NSString * string22 = @"In early 2011, Cleanpro Laundry Holdings Sdn Bhd has further transformed into ”24/7 No manpower Self-service Laundry Concept” by bringing in and opening up to high-tech equipment, committed to the research and development of a self-planning business model. At this time, the first business model of Cleanpro Express is formed.\n\n";
    NSString * price22 = @"In early 2011";
    NSAttributedString *substring4 = [[NSAttributedString alloc] initWithString:string22];
    [SubStr4 appendAttributedString:substring4];
    [SubStr4 addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:13.0]
                    range:[string22 rangeOfString:string22]];
    [SubStr4 addAttribute:NSForegroundColorAttributeName
                    value:[UIColor lightGrayColor]
                    range:[string22 rangeOfString:string22]];
    [SubStr4 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string22 length])];
    //获取需要改变的字符串在完整字符串的范围
    NSRange rang22 = [string22 rangeOfString:price22];
    //    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [SubStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang22];
    
    //设置文字大小
    [SubStr4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang22];
    
    //设置文字背景色
    [SubStr4 addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang22];
    [SubStr4 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:14] range:rang22];
    
    [string appendAttributedString:SubStr4];
    
    // 第三段：哈哈
    NSMutableAttributedString * SubStr5=[[NSMutableAttributedString alloc] init];
//    NSAttributedString *substring5 = [[NSAttributedString alloc] initWithString:@"Since then, Cleanpro Express has fully carried this concept into a franchising business model that later changed the laundry industry in this region into a new era.\n\n\n"];
    NSString * string33 = @"Since then, Cleanpro Express has fully carried this concept into a franchising business model that later changed the laundry industry in this region into a new era.\n";
    NSString * price33 = @"Since then";
    NSAttributedString *substring5 = [[NSAttributedString alloc] initWithString:string33];
    [SubStr5 appendAttributedString:substring5];
    [SubStr5 addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:13.0]
                    range:[string33 rangeOfString:string33]];
    [SubStr5 addAttribute:NSForegroundColorAttributeName
                    value:[UIColor lightGrayColor]
                    range:[string33 rangeOfString:string33]];
    [SubStr5 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string33 length])];
    //获取需要改变的字符串在完整字符串的范围
    NSRange rang33 = [string33 rangeOfString:price33];
    //    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [SubStr5 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang33];
    
    //设置文字大小
    [SubStr5 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang33];
    [SubStr5 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:14] range:rang33];
    //设置文字背景色
    [SubStr5 addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang33];
    
    [string appendAttributedString:SubStr5];
        
        attributedPlaceholder = string;
        Label_zong.attributedText = attributedPlaceholder;
//    }else if([diquStr isEqualToString:@"2200"])
//    {
//
//        // 富文本用法3 - 图文混排
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
//        // 第一段：placeholder
//        NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
//        NSAttributedString *substring1;
//        if(self.tagg==0)
//        {
//            substring1  = [[NSAttributedString alloc] initWithString:@"3款特价仓位，5折年前特惠！\n\n\n"];
//        }else if (self.tagg==1)
//        {
//            substring1  = [[NSAttributedString alloc] initWithString:@"￥0入住\n\n\n"];
//        }
//        //    NSLog(@"%@",substring1.string);
//        [SubStr1 appendAttributedString:substring1];
//        NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
//        //设置文字颜色
//        [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
//        //设置文字大小
//        [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:rang];
//        [string appendAttributedString:SubStr1];
//        // 第二段：图片
//        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//        if(self.iamge_str!=nil){
//            attachment.image =[UIImage imageNamed:self.iamge_str];
//        }else
//        {
//            attachment.image = [UIImage imageNamed:@"img_promotion_details"];
//        }
//        attachment.bounds = CGRectMake(0, 45, q_label.width, 224);
//        NSAttributedString *subtring2 = [NSAttributedString attributedStringWithAttachment:attachment];
//        [string appendAttributedString:subtring2];
//
//
//
//        // 第三段：哈哈
//        NSMutableAttributedString * SubStr3=[[NSMutableAttributedString alloc] init];
//        NSAttributedString *substring3 = [[NSAttributedString alloc] initWithString:@"活动规则：\n满足一下条件的用户到趣存寄存，即可享受三个月5折租金优惠新用户首次租仓\n· 三个月起租\n· 本次优惠不已店铺其他优惠同享\n· 活动时间：2018年1月19日 ~ 2月14日"];
//        [SubStr3 appendAttributedString:substring3];
//        [string appendAttributedString:SubStr3];
//        NSMutableAttributedString * SubStr4=[[NSMutableAttributedString alloc] init];
//        NSAttributedString *substring4 = [[NSAttributedString alloc] initWithString:@"\n\n\n\n春节特价仓，名额有限，先到先得哦！"];
//        [SubStr4 appendAttributedString:substring4];
//        NSRange rang4 =[SubStr4.string rangeOfString:SubStr4.string];
//        //设置文字颜色
//        [SubStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:rang4];
//        //设置文字大小
//        [SubStr4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:rang4];
//        [string appendAttributedString:SubStr4];
//        NSMutableAttributedString * SubStr5=[[NSMutableAttributedString alloc] init];
//        NSAttributedString *substring5 = [[NSAttributedString alloc] initWithString:@"\n\n\n本次活动最终解释权归趣存所有。"];
//        [SubStr5 appendAttributedString:substring5];
//        [string appendAttributedString:SubStr5];
//
//        attributedPlaceholder = string;
//        q_label.attributedText = attributedPlaceholder;
//
//    }
    
    [ScrollView_Z addSubview:Label_zong];
}





-(void)setLabel_text_New:(NSInteger)tagg
{
    if(self.view.width==375 && self.view.height==812)
    {
        //       q_label.frame=CGRectMake(20, 79, SCREEN_WIDTH-40, SCREEN_HEIGHT-79);
        Label_zong.frame=CGRectMake(20, 10, SCREEN_WIDTH-40, ScrollView_Z.height);
    }else
    {
        
        //     q_label.frame=CGRectMake(20, 79+20, SCREEN_WIDTH-40, SCREEN_HEIGHT-79-20);
        
        Label_zong.frame=CGRectMake(20, 10, SCREEN_WIDTH-40, ScrollView_Z.height+10);
    }
    //自动折行设置
    Label_zong.lineBreakMode = UILineBreakModeWordWrap;
    Label_zong.numberOfLines = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取账户
//    diquStr = [userDefaults objectForKey:@"DIQU"];
//    if([diquStr isEqualToString:@"2300"])
//    {
        // 富文本用法3 - 图文混排
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        // 第一段：placeholder
        NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
        NSAttributedString *substring1;
        if(self.tagg==1)
        {
            substring1  = [[NSAttributedString alloc] initWithString:@"NEW! Value-Added Service!\n\n"];
        }else if (self.tagg==2)
        {
            substring1  = [[NSAttributedString alloc] initWithString:@"Store. Work. Connect\n\n"];
        }
        //    NSLog(@"%@",substring1.string);
        [SubStr1 appendAttributedString:substring1];
        NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
        //设置文字颜色
        [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
        //设置文字大小
        [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang];
        //        [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:16] range:rang];
        [string appendAttributedString:SubStr1];
        // 第二段：图片
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        if(self.iamge_str!=nil){
            attachment.image =[UIImage imageNamed:self.iamge_str];
        }else
        {
            attachment.image = [UIImage imageNamed:@"zuxiaoh.png"];
        }
        attachment.bounds = CGRectMake(0, 45, Label_zong.width, 224);
        NSAttributedString *subtring2 = [NSAttributedString attributedStringWithAttachment:attachment];
        [string appendAttributedString:subtring2];
        
        
        
        if(self.tagg==1)
        {
            //            NSMutableAttributedString * SubStrTitle=[[NSMutableAttributedString alloc] init];
            //            NSAttributedString *SubStrTitle_str;
            //            SubStrTitle_str  = [[NSAttributedString alloc] initWithString:@"NEW! Value-Added Service!\n\n"];
            //            //    NSLog(@"%@",substring1.string);
            //            [SubStrTitle appendAttributedString:SubStrTitle_str];
            //            NSRange rang_title =[SubStrTitle.string rangeOfString:SubStrTitle.string];
            //            //设置文字颜色
            //            [SubStrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_title];
            //            //设置文字大小
            ////            [SubStrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:rang_title];
            //            [SubStrTitle addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:16] range:rang_title];
            //            [string appendAttributedString:SubStrTitle];
        }else if (self.tagg==2)
        {
            //            NSMutableAttributedString * SubStrTitle=[[NSMutableAttributedString alloc] init];
            //            NSAttributedString *SubStrTitle_str;
            //            SubStrTitle_str  = [[NSAttributedString alloc] initWithString:@"Store. Work. Connect\n\n"];
            //            //    NSLog(@"%@",substring1.string);
            //            [SubStrTitle appendAttributedString:SubStrTitle_str];
            //            NSRange rang_title =[SubStrTitle.string rangeOfString:SubStrTitle.string];
            //            //设置文字颜色
            //            [SubStrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_title];
            //            //设置文字大小
            ////            [SubStrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:rang_title];
            //            [SubStrTitle addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:16] range:rang_title];
            //            [string appendAttributedString:SubStrTitle];
        }
        
        // 第三段：哈哈
        NSMutableAttributedString * SubStr3=[[NSMutableAttributedString alloc] init];
        NSAttributedString *substring3;
        if(self.tagg==1)
        {
            substring3 = [[NSAttributedString alloc] initWithString:@"Simply pack, drop your parcel at our reception office and start tracking!\nOffering you local delivery of documents and parcel from $6 onward for all StorHub customer.\nCome visit us and experience the convenience with storing with StorHub.\n\n"];
            [SubStr3 appendAttributedString:substring3];
            NSRange string_3_title =[SubStr3.string rangeOfString:SubStr3.string];
            [SubStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:string_3_title];
            [string appendAttributedString:SubStr3];
            ScrollView_Z.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
            Label_zong.frame=CGRectMake(20, 0, SCREEN_WIDTH-40, 540);
        }else if (self.tagg==2)
        {
            substring3  = [[NSAttributedString alloc] initWithString:@"Exclusive offering at StorHub Kallang!\nConveniently located next to PIE, with ample parking space, StorHub Kallang takes the concept of storage to a new frontier.\nCheck out some of our new value-added service curated exclusive for our customer.\n\n"];
            [SubStr3 appendAttributedString:substring3];
            NSRange string_3_title =[SubStr3.string rangeOfString:SubStr3.string];
            [SubStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:string_3_title];
            [string appendAttributedString:SubStr3];
            NSMutableAttributedString * SubStrTitle=[[NSMutableAttributedString alloc] init];
            NSAttributedString *SubStrTitle_str;
            SubStrTitle_str  = [[NSAttributedString alloc] initWithString:@"WORK . STORE . CONNECT\n"];
            //    NSLog(@"%@",substring1.string);
            [SubStrTitle appendAttributedString:SubStrTitle_str];
            NSRange rang_title =[SubStrTitle.string rangeOfString:SubStrTitle.string];
            //设置文字颜色
            [SubStrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_title];
            //设置文字大小
            [SubStrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:rang_title];
            //            [SubStrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:rang_title];
            [string appendAttributedString:SubStrTitle];
            
            // 第三段：哈哈
            NSMutableAttributedString * SubStr4=[[NSMutableAttributedString alloc] init];
            NSAttributedString *substring4;
            substring4 = [[NSAttributedString alloc] initWithString:@"•    \tFREE access to communal space with workspace\n•    \tMailbox service available\n•    \tOffice spaces available\n•    \tAccessible Location\n•    \tWide range of storage sizes to cater for all needs\n•    \tAmple parking space\n•    \tWide loading/unloading bay\nCall 6848 8126 for more information or simply book a storage in Kallang today to enjoy free use of communal space.\n\n\n"];
            
            [SubStr4 appendAttributedString:substring4];
            NSRange string_4_title =[SubStr4.string rangeOfString:SubStr4.string];
            [SubStr4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:string_4_title];
            [string appendAttributedString:SubStr4];
            
            ScrollView_Z.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+80);
            Label_zong.frame=CGRectMake(20, 10, SCREEN_WIDTH-40, ScrollView_Z.height+65);
        }
        
        
        
        
        
        attributedPlaceholder = string;
        Label_zong.attributedText = attributedPlaceholder;
//        Label_zong.attributedText = attributedPlaceholder;
    [ScrollView_Z addSubview:Label_zong];
}

- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillAppear:animated];
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

@end
