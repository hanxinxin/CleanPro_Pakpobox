//
//  ReloadTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReloadTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageLeft;
@property (strong, nonatomic) IBOutlet UILabel *centerTitle;
@property (strong, nonatomic) IBOutlet UIButton *ReloadBtn;

@end

NS_ASSUME_NONNULL_END
