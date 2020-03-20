//
//  AddressInfoTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UILabel *TopTitle;
@property (strong, nonatomic) IBOutlet UILabel *DownTitle;
@property (strong, nonatomic) IBOutlet UILabel *JLLabel;

@end

NS_ASSUME_NONNULL_END
