//
//  IMessageViewController.h
//  Cleanpro
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableViewT;
@property (assign, nonatomic) NSInteger MessageStyle;
@end

NS_ASSUME_NONNULL_END
