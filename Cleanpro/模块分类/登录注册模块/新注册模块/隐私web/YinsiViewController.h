//
//  YinsiViewController.h
//  Cleanpro
//
//  Created by mac on 2019/4/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YinsiViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
