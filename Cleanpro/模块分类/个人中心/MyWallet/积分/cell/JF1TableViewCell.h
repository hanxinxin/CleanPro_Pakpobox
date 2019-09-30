//
//  JF1TableViewCell.h
//  Cleanpro
//
//  Created by mac on 2019/1/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JF1TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *left_image;
@property (weak, nonatomic) IBOutlet UIButton *right_image;
@property (weak, nonatomic) IBOutlet UILabel *Jifen_label;

@end

NS_ASSUME_NONNULL_END
