//
//  LaundrySelectTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/17.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LaundrySelectTableViewCellDelegate <NSObject>
@optional

- (void)returnSelect:(NSInteger )selectFlag; /// 1是选择左 2是选择中间 3是选择右
@end

@interface LaundrySelectTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *LeftBag;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;

@property (strong, nonatomic) IBOutlet UIButton *centerBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UILabel *PriceLabel;


@property (nonatomic, weak) id<LaundrySelectTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
