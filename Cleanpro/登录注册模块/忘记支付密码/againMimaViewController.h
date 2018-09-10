//
//  againMimaViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface againMimaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *miaoshu_label;
@property (weak, nonatomic) IBOutlet UIButton *password_btn;
@property (nonatomic ,strong)  TPPasswordTextView *password_text;


@property (nonatomic ,strong) NSString * payNewPassword;
@property (nonatomic ,strong) NSString * oldPayPassword;

@property (nonatomic ,assign) NSInteger PayOrLog;/////1是输入密码修改  2是验证手机号修改
@property (nonatomic ,strong) NSString * TokenString;

-(void)push_AffirmViewController;
@end
