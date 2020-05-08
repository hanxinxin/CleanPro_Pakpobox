//
//  EwashMessageTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/30.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMSwipeCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface EwashMessageTableViewCell : TMSwipeCell
@property (strong, nonatomic) IBOutlet UILabel *TopTitle;
@property (strong, nonatomic) IBOutlet UILabel *ContentTitle;

@end

NS_ASSUME_NONNULL_END
