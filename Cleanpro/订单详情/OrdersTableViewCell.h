//
//  OrdersTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UILabel *Order_type;
@property (weak, nonatomic) IBOutlet UILabel *OrderNo;
@property (weak, nonatomic) IBOutlet UILabel *Paid;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;

@end
