//
//  PriceWashTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceWashTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageTX;
@property (strong, nonatomic) IBOutlet UILabel *MSTitle;
@property (strong, nonatomic) IBOutlet UILabel *PriceTitle;

@end

NS_ASSUME_NONNULL_END
