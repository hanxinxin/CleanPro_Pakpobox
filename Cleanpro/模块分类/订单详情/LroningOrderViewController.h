//
//  LroningOrderViewController.h
//  Cleanpro
//
//  Created by mac on 2020/6/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LroningOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableViewTop;
@property (weak, nonatomic) IBOutlet UIView *nilView;

@property (nonatomic,assign)NSInteger page;//    页码，默认从0开始。默认：0
@property (nonatomic,assign)NSInteger maxCount;  ///每页条数，默认：20

@property (nonatomic,assign)NSNumber * totalCount;// 总个数
@property (nonatomic,assign)NSNumber * totalPage;  ///总页数

@property (nonatomic,assign)CGFloat topHeight;
@end

NS_ASSUME_NONNULL_END
