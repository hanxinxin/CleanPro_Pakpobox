//
//  EwashMyViewController.h
//  Cleanpro
//
//  Created by mac on 2020/3/30.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface EwashMyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *background_image;
@property (weak, nonatomic) IBOutlet UIButton *touxiang_btn;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;

@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *jifen_label;
@property (weak, nonatomic) IBOutlet UIButton *jifen_btn;

@property (weak, nonatomic) IBOutlet BadgeButton *Message_Btn;


@property (weak, nonatomic) IBOutlet UITableView *Down_tableView;

@property (assign, nonatomic) NSInteger QuAndUser; /// 1是用户，2是店员。

@end
NS_ASSUME_NONNULL_END
