//
//  StaffViewController.h
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaffViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *STable;
@property (assign, nonatomic) NSInteger StatusList; ///1是抢单大厅，2是用户未完成列表 3是 快递员个人抢单列表 4是 用户的History历史完成订单
@end

NS_ASSUME_NONNULL_END
