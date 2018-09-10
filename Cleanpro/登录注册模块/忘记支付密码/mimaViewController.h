//
//  mimaViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mimaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *miaoshu_label;
@property (weak, nonatomic) IBOutlet UIButton *password_btn;
@property (nonatomic ,strong)  TPPasswordTextView *password_text;
@property (nonatomic ,strong) NSString * Pay_passwordStr;
-(void)push_againMimaViewController;
@end
