//
//  MyAccountViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *background_image;
@property (weak, nonatomic) IBOutlet UIButton *touxiang_btn;
@property (weak, nonatomic) IBOutlet UILabel *name_label;


@property (weak, nonatomic) IBOutlet UITableView *Down_tableView;

@end
