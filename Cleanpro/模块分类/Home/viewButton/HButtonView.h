//
//  HButtonView.h
//  Cleanpro
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HButtonView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title_lable;
@property (weak, nonatomic) IBOutlet UIButton *left_btn;
@property (weak, nonatomic) IBOutlet UILabel *Number_lable;
@property (weak, nonatomic) IBOutlet UILabel *down_label;

@end

NS_ASSUME_NONNULL_END
