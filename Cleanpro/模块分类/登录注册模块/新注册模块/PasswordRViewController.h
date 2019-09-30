//
//  PasswordRViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet HQTextField *onePassword_textfield;
@property (weak, nonatomic) IBOutlet HQTextField *twoPassword_textfield;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;

@property (strong, nonatomic) NSString * passwordStr;

@property (strong, nonatomic) userIDMode * Nextmode;

@end

NS_ASSUME_NONNULL_END
