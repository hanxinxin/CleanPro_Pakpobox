//
//  CradPayTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/6/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface CradPayTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *imageBtn;
@property (strong, nonatomic) IBOutlet UILabel *topTitle;
@property (strong, nonatomic) IBOutlet UILabel *downTitle;
@property (strong, nonatomic) IBOutlet UILabel *TispLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@end

NS_ASSUME_NONNULL_END
