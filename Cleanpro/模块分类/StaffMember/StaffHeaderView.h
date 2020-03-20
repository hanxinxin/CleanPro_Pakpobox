//
//  StaffHeaderView.h
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaffHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *NoTitle;
@property (strong, nonatomic) IBOutlet UILabel *TypeTitle;
@property (strong, nonatomic) IBOutlet UILabel *PickTitle;
@property (strong, nonatomic) IBOutlet UILabel *StausTitle;
@property (strong, nonatomic) IBOutlet UILabel *PriceTitle;

@end

NS_ASSUME_NONNULL_END
