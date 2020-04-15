//
//  NewPasswordSetViewController.h
//  Cleanpro
//
//  Created by mac on 2020/4/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewPasswordSetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet HQTextField *onePassword_textfield;
@property (weak, nonatomic) IBOutlet HQTextField *twoPassword_textfield;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;

@property (strong, nonatomic) NSString * passwordStr;

@property (strong, nonatomic) userIDMode * Nextmode;


@property (strong, nonatomic) NSString * PhoneStr;
@property (strong, nonatomic) NSString * CodeStr;

@end

NS_ASSUME_NONNULL_END
