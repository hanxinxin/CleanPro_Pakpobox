//
//  PastCardOrderTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/6/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PastCardOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *left_btn;
@property (strong, nonatomic) IBOutlet UILabel *topTitle;
@property (strong, nonatomic) IBOutlet UILabel *centerTitle;
@property (strong, nonatomic) IBOutlet UILabel *downTitle;
@property (strong, nonatomic) IBOutlet UILabel *TopPrice;
@property (strong, nonatomic) IBOutlet UILabel *CenterPrice;
@property (strong, nonatomic) IBOutlet UIButton *State_btn;



@end

NS_ASSUME_NONNULL_END
