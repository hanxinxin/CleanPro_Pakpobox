//
//  DetailsListViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView_top;
@property (nonatomic,assign)NSInteger page;//    页码，默认从0开始。默认：0
@property (nonatomic,assign)NSInteger maxCount;  ///每页条数，默认：20

@property (nonatomic,assign)NSNumber * totalCount;// 总个数
@property (nonatomic,assign)NSNumber * totalPage;  ///总页数
@property (nonatomic,assign)CGFloat topHeight;
@end
