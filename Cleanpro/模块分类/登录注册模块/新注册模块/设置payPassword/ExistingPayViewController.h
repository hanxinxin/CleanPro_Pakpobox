//
//  ExistingPayViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTFCodeView.h"
#import "SetPayPViewController.h"
#import "newPhoneViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExistingPayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_text;
@property (weak, nonatomic) IBOutlet HQTextField *pay_textfeld;
@property (weak, nonatomic) IBOutlet UIButton *forget_pay_btn;
@property (nonatomic, weak) HWTFCodeView   *Code_tuiguang1;
@property (strong, nonatomic) NSString * PayPassWordStr;

@property (weak, nonatomic) IBOutlet UIButton *next_btn;

@property (assign, nonatomic) NSInteger index;

@end

NS_ASSUME_NONNULL_END
