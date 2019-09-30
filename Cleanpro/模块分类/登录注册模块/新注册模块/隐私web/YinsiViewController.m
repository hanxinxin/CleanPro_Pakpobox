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
    webView.delegate = self;
//    webView.navigationDelegate = self;
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://cleanpro.pakpobox.com/english.html"]]];
    NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"Privacy.htm"];
    NSString*htmlstring=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlstring baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
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
