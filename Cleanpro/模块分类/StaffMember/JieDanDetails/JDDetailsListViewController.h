//
//  JDDetailsListViewController.h
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDDetailsListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *STable;
@property (nonatomic, nonatomic) OrderListMode*mode;
@end

NS_ASSUME_NONNULL_END
