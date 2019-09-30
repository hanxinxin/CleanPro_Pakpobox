//
//  MyWalletViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *RMB;
//@property (weak, nonatomic) IBOutlet UIImageView *image_b;
@property (weak, nonatomic) IBOutlet UITableView *Down_tableView;


@property (nonatomic,strong) NSNumber * balance;
@property (nonatomic,strong) NSString * currencyUnit;
@end
