//
//  SelectTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2019/1/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *left_btn;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIButton *right_btn;

@end

NS_ASSUME_NONNULL_END
