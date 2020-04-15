//
//  JieDanTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "JieDanTableViewCell.h"

@implementation JieDanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Cfmbtn.layer.cornerRadius = 4;
    
}
- (IBAction)Cfm_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(CfmTouch:)]) {
        [self.delegate CfmTouch:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
