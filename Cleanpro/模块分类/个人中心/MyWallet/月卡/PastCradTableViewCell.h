//
//  PastCradTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/6/11.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PastCradTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *LeftTopButton;
@property (strong, nonatomic) IBOutlet UILabel *TitleMS_label;
@property (strong, nonatomic) IBOutlet UILabel *DownMS_label;

@property (strong, nonatomic) IBOutlet UILabel *RightTopPrice_label;
@property (strong, nonatomic) IBOutlet UILabel *DownPrice_label;

@end

NS_ASSUME_NONNULL_END
