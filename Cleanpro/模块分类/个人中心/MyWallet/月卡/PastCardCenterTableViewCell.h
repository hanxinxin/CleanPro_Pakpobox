//
//  PastCardCenterTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/6/11.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PastCardCenterTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *CenterButton;
@property (strong, nonatomic) IBOutlet UILabel *title_label;
@property (strong, nonatomic) IBOutlet UILabel *topPrice_label;
@property (strong, nonatomic) IBOutlet UILabel *DownPrice_label;

@end

NS_ASSUME_NONNULL_END
