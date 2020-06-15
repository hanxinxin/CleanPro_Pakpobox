//
//  OrderPageViewController.h
//  Cleanpro
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderPageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *STable;

@property (assign, nonatomic) NSInteger selectLaundry;  //1显示 2不显示

@property (strong, nonatomic) PostOrderMode * OrderMode;
@property (nonatomic,strong)NSMutableArray* CommodityArr; ///已选择的购物商品数组
@property (strong, nonatomic) NSString * TotalStr;

@property (assign, nonatomic) NSInteger PaymentMethodStr; ///1是现金 2是 ipay88 3 是钱包  现在默认是钱包

@end

NS_ASSUME_NONNULL_END
