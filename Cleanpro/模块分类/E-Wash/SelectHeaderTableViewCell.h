//
//  SelectHeaderView.h
//  Cleanpro
//
//  Created by mac on 2020/3/17.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectHeaderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *waterLabel;
@property (strong, nonatomic) IBOutlet UILabel *coldLabel;
@property (strong, nonatomic) IBOutlet UILabel *warmLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end

NS_ASSUME_NONNULL_END
