//
//  LoginViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logo_image;
@property (weak, nonatomic) IBOutlet UITextField *phone_textfiled;
@property (weak, nonatomic) IBOutlet UITextField *verification_textfiled;///密码长度 大于6小于16
@property (weak, nonatomic) IBOutlet UIButton *SignIn_btn;
@property (weak, nonatomic) IBOutlet UIButton *Forget_btn;

@end
