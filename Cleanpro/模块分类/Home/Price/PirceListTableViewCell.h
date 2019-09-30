//
//  PirceListTableViewCell.h
//  wordPirce
//
//  Created by macbook on 2018/7/22.
//  Copyright © 2018年 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PirceListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *left_btn;

@property (weak, nonatomic) IBOutlet UIView *topView_two;
@property (weak, nonatomic) IBOutlet UILabel *title_label_two;
@property (weak, nonatomic) IBOutlet UIButton *left_btn_two;

@end
