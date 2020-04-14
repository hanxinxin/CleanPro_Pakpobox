//
//  NewFirgetPasswordViewController.h
//  Cleanpro
//
//  Created by mac on 2020/4/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewForgetPasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet UIButton *diqu_btn;
@property (weak, nonatomic) IBOutlet HQTextField *phone_textfield;
@property (weak, nonatomic) IBOutlet HQTextField *Verification_textfield;
@property (weak, nonatomic) IBOutlet UIButton *getCode_btn;
@property (weak, nonatomic) IBOutlet UIButton *NextStep;

@end

NS_ASSUME_NONNULL_END
