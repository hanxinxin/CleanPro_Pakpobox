//
//  CelladdTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2020/3/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CelladdTableViewCell.h"

@implementation CelladdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [_centerBtn setImage:[UIImage imageNamed:@"plus_unavailable"] forState:UIControlStateNormal];
    [_centerBtn setTitle:FGGetStringWithKeyFromTable(@"Add bag", @"Language") forState:(UIControlStateNormal)];
    [_centerBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:UIControlStateNormal];
//    [_centerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _centerBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    //设置button图片的偏移量，距(top, left, bottom, right)的像素点为(5, 10, 5, 60)
    _centerBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 60);
    //设置button标题的偏移量，这个偏移量是相对于图片的
    _centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}
- (IBAction)centerTouch:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
