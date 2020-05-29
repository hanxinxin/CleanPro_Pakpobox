//
//  YinsiViewController.m
//  Cleanpro
//
//  Created by mac on 2019/4/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YinsiViewController.h"

@interface YinsiViewController ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>

@end

@implementation YinsiViewController
@synthesize webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = FGGetStringWithKeyFromTable(@"Privacy policy", @"Language");
////    webView.delegate = self;
////    webView.navigationDelegate = self;
////    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://cleanpro.pakpobox.com/english.html"]]];
//    NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
//    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"Privacy.htm"];
//    NSString*htmlstring=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlstring baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
    
    
    //创建网页配置对象
     WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
     
     // 创建设置对象
     WKPreferences *preference = [[WKPreferences alloc]init];
     //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
     preference.minimumFontSize = 0;
     //设置是否支持javaScript 默认是支持的
     preference.javaScriptEnabled = YES;
     // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
     preference.javaScriptCanOpenWindowsAutomatically = YES;
     config.preferences = preference;
     
     // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
     config.allowsInlineMediaPlayback = YES;
     //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.mediaTypesRequiringUserActionForPlayback = YES;
     //设置是否允许画中画技术 在特定设备上有效
     config.allowsPictureInPictureMediaPlayback = YES;
     //设置请求的User-Agent信息中应用程序名称 iOS9后可用
     config.applicationNameForUserAgent = @"ChinaDailyForiPad";
      //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    //初始化
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
     // UI代理
    self.webView.UIDelegate = self;
     // 导航代理
     self.webView.navigationDelegate = self;
     // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
     self.webView.allowsBackForwardNavigationGestures = YES;
     //可返回的页面列表, 存储已打开过的网页
    WKBackForwardList * backForwardList = [self.webView backForwardList];
      NSString *path = [[NSBundle mainBundle] pathForResource:@"Privacy.htm" ofType:nil];
      NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载本地html文件
    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
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
