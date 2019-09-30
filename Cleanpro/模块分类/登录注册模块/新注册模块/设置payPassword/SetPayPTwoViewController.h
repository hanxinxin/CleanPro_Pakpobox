//
//  SetPayPTwoViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTFCodeView.h" 
NS_ASSUME_NONNULL_BEGIN

@interface SetPayPTwoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_text;
@property (weak, nonatomic) IBOutlet HQTextField *pay_textfeld;
@property (nonatomic, weak) HWTFCodeView   *Code_tuiguang1;
@property (strong, nonatomic) NSString * PayPassWordStr;
@property (strong, nonatomic) NSString * PayOldPassWordStr;

@property (strong, nonatomic) NSString * validateCode;

@property (strong, nonatomic) NSString * payStringOne;
@property (strong, nonatomic) NSString * payStringTwo;

@property (assign, nonatomic) NSInteger index; ////index==1 是 手机号设置  2是旧密码验证

@property (weak, nonatomic) IBOutlet UIButton *next_btn;


@end

NS_ASSUME_NONNULL_END
