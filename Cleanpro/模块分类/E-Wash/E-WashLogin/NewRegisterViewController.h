//
//  NewRegisterViewController.h
//  Cleanpro
//
//  Created by mac on 2020/3/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIView *NoView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIButton *diqu_btn;

@property (weak, nonatomic) IBOutlet HQTextField *phone_Textfield;
@property (weak, nonatomic) IBOutlet HQTextField *verification_textfield;
@property (weak, nonatomic) IBOutlet UIButton *getCode_btn;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;

@property (strong, nonatomic) NSString * countryCodeStr;

@property (strong, nonatomic) userIDMode * Nextmode;



@end

NS_ASSUME_NONNULL_END
