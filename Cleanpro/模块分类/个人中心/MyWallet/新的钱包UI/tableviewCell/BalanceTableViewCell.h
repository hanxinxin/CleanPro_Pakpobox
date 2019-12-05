//
//  BalanceTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BalanceTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *left_Money;
@property (strong, nonatomic) IBOutlet UILabel *left_Balance;
@property (strong, nonatomic) IBOutlet UILabel *Right_Points;
@property (strong, nonatomic) IBOutlet UILabel *Right_Reward;

@end

NS_ASSUME_NONNULL_END
