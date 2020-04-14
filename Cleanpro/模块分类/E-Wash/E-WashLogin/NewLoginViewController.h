//
//  NewLoginViewController.h
//  Cleanpro
//
//  Created by mac on 2020/3/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQTextField.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logo_image;

@property (weak, nonatomic) IBOutlet UIButton *quhao_btn;

@property (weak, nonatomic) IBOutlet UIView *topview;

@property (weak, nonatomic) IBOutlet HQTextField *phone_textfiled;
@property (weak, nonatomic) IBOutlet HQTextField *verification_textfiled;///密码长度 大于6小于16
@property (weak, nonatomic) IBOutlet UIButton *SignIn_btn;
@property (weak, nonatomic) IBOutlet UIButton *Forget_btn;
@property (strong, nonatomic) IBOutlet UIButton *Register_btn;

@end
NS_ASSUME_NONNULL_END
