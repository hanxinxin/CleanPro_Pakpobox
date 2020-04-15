//
//  BagTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BagTableViewCellDelegate <NSObject>
@optional

- (void)jiaTouch:(UITableViewCell*)Cell;
- (void)jianTouch:(UITableViewCell*)Cell;
@end



@interface BagTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *leftImage;
@property (strong, nonatomic) IBOutlet UILabel *LeftTitle;
@property (strong, nonatomic) IBOutlet UIButton *rightJia;
@property (strong, nonatomic) IBOutlet UILabel *RightTitle;
@property (strong, nonatomic) IBOutlet UIButton *RightJian;



@property (nonatomic, weak) id<BagTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
