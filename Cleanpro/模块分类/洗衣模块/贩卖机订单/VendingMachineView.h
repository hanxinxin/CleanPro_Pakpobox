//
//  VendingMachineView.h
//  Cleanpro
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VendingMachineView : UIView

/** 标题Label */
@property (strong, nonatomic)  UILabel * RetailMachineLabel;

/** 商品列表  */
@property (strong, nonatomic)  UITableView * CommodityView;

/** 总价Label */
@property (strong, nonatomic)  UILabel * PriceLabel;

@property (strong, nonatomic)  NSArray * ListArray;///TableViewCell的个数
- (instancetype) initWithFrame:(CGRect)frame inView:(UIView *)parentView listArray:(NSArray*)array;


/// 设置总价字体
/// @param str 价格
-(void)setLableTextPriceLabel:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
