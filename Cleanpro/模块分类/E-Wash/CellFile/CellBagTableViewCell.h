//
//  CellBagTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CellBagTableViewCellDelegate <NSObject>
@optional
///  从左到右 依次 1，2，3   //100 代表删除 delete
- (void)SelectTouch:(UITableViewCell*)cell index:(NSInteger)CellIndex;

- (void)DeleteTouch:(UITableViewCell*)cell index:(NSInteger)CellIndex;

- (void)SelectPoubd:(UITableViewCell*)cell index:(NSInteger)CellIndex SelectTemperature:(NSInteger)SelectTemperature;
@end
@interface CellBagTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *PoubdBtn;
@property (strong, nonatomic) IBOutlet UILabel *PriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *RMBLabel;
@property (strong, nonatomic) IBOutlet UIButton *hotBtn;
@property (strong, nonatomic) IBOutlet UIButton *WarmBtn;
@property (strong, nonatomic) IBOutlet UIButton *ColdBtn;
@property (strong, nonatomic) IBOutlet UIButton *DeleteBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *RMBAyout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *priceLetf;


@property (assign, nonatomic)  NSInteger SelectMenuPound;
@property (assign, nonatomic)  NSInteger SelectTemperature;
@property (assign, nonatomic)  NSInteger styleLeft;
@property (nonatomic, weak) id<CellBagTableViewCellDelegate> delegate;
@property (nonatomic,assign)NSArray * DQNumber;
@property (nonatomic,assign)CommodityMode*ModeS;

-(void)set_select;
-(void)setUI:(productsMode*)mode;
-(void)updateMenu:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
