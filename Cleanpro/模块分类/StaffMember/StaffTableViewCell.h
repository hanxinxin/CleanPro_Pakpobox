//
//  StaffTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol StaffTableViewCellDelegate <NSObject>
@optional

- (void)DetailTouch:(UITableViewCell*)Cell;
- (void)StatusTouch:(UITableViewCell*)Cell;
@end
@interface StaffTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *NoLabel;
@property (strong, nonatomic) IBOutlet UILabel *TypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *PickLabel;
@property (strong, nonatomic) IBOutlet UIButton *StausLabel;
@property (strong, nonatomic) IBOutlet UIButton *PriceLabel;
@property (nonatomic, weak) id<StaffTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
