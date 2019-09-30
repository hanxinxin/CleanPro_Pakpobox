//
//  ZGQTableViewCell.m
//  BBLive
//
//  Created by 小丁 on 2017/7/6.
//  Copyright © 2017年 车互帮. All rights reserved.
//

#import "ZGQTableViewCell.h"

@implementation ZGQTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addViews];
    }
    return self;
}

- (void)addViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithWhite:0.83 alpha:1.000];
    [self.contentView addSubview:self.lineView];
    
}

- (void)layoutSubviews {
    CGFloat contentViewWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat contentViewHeight = CGRectGetHeight(self.contentView.bounds);
    self.titleLabel.frame = CGRectMake(contentViewWidth * 0.2, 0, contentViewWidth * 0.6, contentViewHeight);
    self.lineView.frame = CGRectMake(0, contentViewHeight - 0.3, contentViewWidth, 0.3);

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
