//
//  GenderRViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GenderRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIView *left_View;
@property (weak, nonatomic) IBOutlet UIView *right_View;
@property (weak, nonatomic) IBOutlet UIButton *LimageBtn;
@property (weak, nonatomic) IBOutlet UILabel *LSex_lebel;
@property (weak, nonatomic) IBOutlet UIButton *RimageBtn;
@property (weak, nonatomic) IBOutlet UILabel *RSex_label;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;
@property (weak, nonatomic) IBOutlet UIButton *Skip_btn;

@property (nonatomic, strong)  NSString * sex_str;

@property (strong, nonatomic) userIDMode * Nextmode;

@end

NS_ASSUME_NONNULL_END
