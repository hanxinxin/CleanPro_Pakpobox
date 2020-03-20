//
//  DeliveryTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *LeftImage;
@property (strong, nonatomic) IBOutlet UILabel *LeftTitle;
@property (strong, nonatomic) IBOutlet UIButton *RightSelect;

@end

NS_ASSUME_NONNULL_END
