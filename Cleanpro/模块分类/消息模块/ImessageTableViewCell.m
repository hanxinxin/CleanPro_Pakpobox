//
//  ImessageTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ImessageTableViewCell.h"
@interface ImessageTableViewCell ()<UIScrollViewDelegate>
//@property (nonatomic, strong) UIScrollView *scrollContent;

//@property (nonatomic, strong) UILabel *sureDeleteView;

@end
@implementation ImessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
