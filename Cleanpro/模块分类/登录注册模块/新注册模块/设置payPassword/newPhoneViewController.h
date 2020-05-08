//
//  newPhoneViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetPayPViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface newPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_text;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet HQTextField *pay_textfeld;
@property (weak, nonatomic) IBOutlet UIButton *getCode_btn;
@property (nonatomic, weak) HWTFCodeView   *Code_tuiguang1;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;
@property (assign, nonatomic) NSInteger index;
@end

NS_ASSUME_NONNULL_END
