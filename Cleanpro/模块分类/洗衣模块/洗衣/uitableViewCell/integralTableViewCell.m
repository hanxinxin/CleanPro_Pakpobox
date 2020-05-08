//
//  integralTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2019/1/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "integralTableViewCell.h"

@implementation integralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)Switch_touch:(id)sender {
    
    //判断开关的状态
    if (self.right_switch.on) {
        if ([self.delegate respondsToSelector:@selector(switchtouch:)]) {
            [self.delegate switchtouch:1]; // 回调代理
        }
        NSLog(@"switch is on");
    } else {
        NSLog(@"switch is off");
        if ([self.delegate respondsToSelector:@selector(switchtouch:)]) {
            [self.delegate switchtouch:0]; // 回调代理
        }
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
