//
//  AddressSViewController.h
//  Cleanpro
//
//  Created by mac on 2020/3/11.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressSViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *STable;
@property (assign, nonatomic) NSInteger SelectWay;///1.是 上门取  2.是store  
@property (nonatomic,strong)NSMutableArray* CommodityArr; ///已选择的购物商品数组
@property (strong, nonatomic) NSString * TotalStr;
@end

NS_ASSUME_NONNULL_END
