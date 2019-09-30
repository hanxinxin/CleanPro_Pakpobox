//
//  ForgetSetPasswordViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetSetPasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet HQTextField *setPassword_textField;
@property (weak, nonatomic) IBOutlet UIButton *Complete;
@property (strong, nonatomic)NSString * TokenString;///// 验证token
@end
