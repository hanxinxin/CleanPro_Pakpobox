//
//  RegisterViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *phone_region;
@property (weak, nonatomic) IBOutlet UIImageView *image_top;
@property (weak, nonatomic) IBOutlet UITextField *phone_number;
@property (weak, nonatomic) IBOutlet UIButton *getCodebtn;
@property (weak, nonatomic) IBOutlet UITextField *Verification_number;
@property (weak, nonatomic) IBOutlet UIButton *NextStep;


@end
