//
//  ReloadTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ReloadTableViewCell.h"

@implementation ReloadTableViewCell
// - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//     if (self) {
//         self.layer.cornerRadius = 4;
//         self.layer.masksToBounds = YES;
//
//         self.selectionStyle = UITableViewCellSelectionStyleNone;
//     }
//
//     return self;
// }
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
