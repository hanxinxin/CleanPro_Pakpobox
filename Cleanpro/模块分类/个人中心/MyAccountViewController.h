//
//  MyAccountViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeButton.h"

@interface MyAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *background_image;
@property (weak, nonatomic) IBOutlet UIButton *touxiang_btn;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;

@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *jifen_label;
@property (weak, nonatomic) IBOutlet UIButton *jifen_btn;

@property (weak, nonatomic) IBOutlet BadgeButton *Message_Btn;


@property (weak, nonatomic) IBOutlet UITableView *Down_tableView;

@end
