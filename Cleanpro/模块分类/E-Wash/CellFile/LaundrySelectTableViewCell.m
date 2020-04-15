//
//  LaundrySelectTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2020/3/17.
//  Copyright © 2020 mac. All rights reserved.
//

#import "LaundrySelectTableViewCell.h"

@implementation LaundrySelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)leftTouch:(id)sender {
    [self.leftBtn setImage:[UIImage imageNamed:@"check-circle-fill"] forState:(UIControlStateNormal)];
                            [self.centerBtn setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
    [self.rightBtn setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
    if ([self.delegate respondsToSelector:@selector(returnSelect:)]) {
        [self.delegate returnSelect:1];
    }
}

- (IBAction)centerTouch:(id)sender {
    [self.leftBtn setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
    [self.centerBtn setImage:[UIImage imageNamed:@"check-circle-fill"] forState:(UIControlStateNormal)];
    [self.rightBtn setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
    if ([self.delegate respondsToSelector:@selector(returnSelect:)]) {
        [self.delegate returnSelect:2];
    }
}
- (IBAction)rightTouch:(id)sender {
    [self.leftBtn setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
    [self.centerBtn setImage:[UIImage imageNamed:@"circleNil"] forState:(UIControlStateNormal)];
    [self.rightBtn setImage:[UIImage imageNamed:@"check-circle-fill"] forState:(UIControlStateNormal)];
    if ([self.delegate respondsToSelector:@selector(returnSelect:)]) {
        [self.delegate returnSelect:3];
    }
}

@end
