//
//  PriceHomeViewController.h
//  Cleanpro
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

////// Sku_class
@interface SKU_class:NSObject
@property (strong , nonatomic)NSString * Price;
@property (strong , nonatomic)NSString * prop_value1; //
@property (strong , nonatomic)NSString * prop_value2; //
@end


@interface SKU_Dryclass:NSObject
@property (strong , nonatomic)NSString * Price;
@property (strong , nonatomic)NSString * prop_value1; //
@end

@interface PriceHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *StableView;


@property (strong ,nonatomic) NSMutableArray * M_array;///标题

@property (strong ,nonatomic) NSMutableArray * cellTitleArr;///cell标题

@property (strong ,nonatomic) NSMutableArray * value_array;////数值

@property (strong ,nonatomic) NSMutableArray * value_Dryarray;

@end
