//
//  ImessageTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019 mac. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "TMSwipeCell.h"
#import "BadgeButton1.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImessageTableViewCell : TMSwipeCell
@property (weak, nonatomic) IBOutlet BadgeButton1 *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;

@end

NS_ASSUME_NONNULL_END
