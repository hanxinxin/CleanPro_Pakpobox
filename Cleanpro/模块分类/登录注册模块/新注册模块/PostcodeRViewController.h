//
//  PostcodeRViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostcodeRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet HQTextField *textfield;
@property (strong, nonatomic) IBOutlet HQTextField *AreaTextfield;
@property (strong, nonatomic) IBOutlet HQTextField *AddressTextfield;



@property (weak, nonatomic) IBOutlet UIButton *next_btn;
@property (weak, nonatomic) IBOutlet UIButton *Skip_btn;


@property (strong, nonatomic) userIDMode * Nextmode;

@property (assign, nonatomic) NSInteger index;////// 1是正常注册 2是修改用户名

@end

NS_ASSUME_NONNULL_END
