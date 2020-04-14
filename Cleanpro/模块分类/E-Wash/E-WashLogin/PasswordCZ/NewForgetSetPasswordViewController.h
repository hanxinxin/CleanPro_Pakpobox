//
//  NewForgetSetPasswordViewController.h
//  Cleanpro
//
//  Created by mac on 2020/4/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewForgetSetPasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet HQTextField *setPassword_textField;
@property (weak, nonatomic) IBOutlet UIButton *Complete;
@property (strong, nonatomic)NSString * TokenString;///// 验证token

@property (strong, nonatomic)NSString * YZMStr;///// 验证码

@property (strong, nonatomic)NSString * NewPhone;///// 验证码
@end

NS_ASSUME_NONNULL_END
