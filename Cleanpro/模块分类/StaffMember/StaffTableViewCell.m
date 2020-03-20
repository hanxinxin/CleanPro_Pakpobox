//
//  StaffTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "StaffTableViewCell.h"

@implementation StaffTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.PriceLabel.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
