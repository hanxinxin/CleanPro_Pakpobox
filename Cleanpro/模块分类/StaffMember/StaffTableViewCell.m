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

- (IBAction)Status_Touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(StatusTouch:)]) {
        [self.delegate StatusTouch:self];
    }
}
- (IBAction)detail_Touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DetailTouch:)]) {
        [self.delegate DetailTouch:self];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
