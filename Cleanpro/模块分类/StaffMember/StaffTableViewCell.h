//
//  StaffTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaffTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *NoLabel;
@property (strong, nonatomic) IBOutlet UILabel *TypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *PickLabel;
@property (strong, nonatomic) IBOutlet UIButton *StausLabel;
@property (strong, nonatomic) IBOutlet UIButton *PriceLabel;

@end

NS_ASSUME_NONNULL_END
