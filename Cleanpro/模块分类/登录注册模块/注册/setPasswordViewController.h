//
//  setPasswordViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *top_logpassword;
@property (weak, nonatomic) IBOutlet UITextField *log_one_textfiled;///密码长度 大于6小于16
@property (weak, nonatomic) IBOutlet UITextField *log_two_textfiled;///密码长度 大于6小于16



@property (weak, nonatomic) IBOutlet UIView *center_xianview;

@property (weak, nonatomic) IBOutlet UIView *down_paypassword;
@property (weak, nonatomic) IBOutlet UIView *one_payPassword;
@property (weak, nonatomic) IBOutlet UIView *two_payPassword;
@property (nonatomic ,strong)  TPPasswordTextView *one_payPassword1;
@property (nonatomic ,strong)  TPPasswordTextView *two_payPassword2;

@property (weak, nonatomic) IBOutlet UIButton *sing_up;

@property (strong, nonatomic)NSString * PhoneStr;///// 验证码
@property (strong, nonatomic)NSString * VerificationStr;///// 验证码

@property (strong, nonatomic)NSString * pay_passwordOne;///// 支付密码
@property (strong, nonatomic)NSString * pay_passwordTwo;///// 支付密码



@end
