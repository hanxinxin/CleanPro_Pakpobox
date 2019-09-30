//
//  ForgetPasswordViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet UIButton *diqu_btn;
@property (weak, nonatomic) IBOutlet HQTextField *phone_textfield;
@property (weak, nonatomic) IBOutlet HQTextField *Verification_textfield;
@property (weak, nonatomic) IBOutlet UIButton *getCode_btn;
@property (weak, nonatomic) IBOutlet UIButton *NextStep;

@end
