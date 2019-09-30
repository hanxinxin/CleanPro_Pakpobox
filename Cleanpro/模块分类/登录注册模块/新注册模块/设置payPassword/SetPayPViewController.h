//
//  SetPayPViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTFCodeView.h"
#import "SetPayPTwoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetPayPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_text;
@property (weak, nonatomic) IBOutlet HQTextField *pay_textfeld;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;
@property (nonatomic, weak) HWTFCodeView   *Code_tuiguang1;
@property (strong, nonatomic) NSString * PayOldPassWordStr;
@property (strong, nonatomic) NSString * PayPassWordStr;
@property (strong, nonatomic) NSString * validateCode;

@property (strong, nonatomic) NSString * payStringOne;

@property (assign, nonatomic) NSInteger index;


@end

NS_ASSUME_NONNULL_END
