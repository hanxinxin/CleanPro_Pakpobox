//
//  BagTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2020/3/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "BagTableViewCell.h"

@implementation BagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)jianTouch:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(jianTouch:)]) {
        [self.delegate jianTouch:self];
    }
}
- (IBAction)jiaTouch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jiaTouch:)]) {
        [self.delegate jiaTouch:self];
    }
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
