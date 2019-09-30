//
//  BGLabel.m
//  Cleanpro
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BGLabel.h"

@implementation BGLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//手动创建

- (instancetype)initWithFrame:(CGRect)frame

{

    if (self = [super initWithFrame:frame]) {
    
//    [self addLongPressGesture];
//        self.layer.cornerRadius=1;
            self.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;//设置边框颜色
            self.layer.borderWidth = 1.0f;//设置边框颜色
//        self.lineBreakMode = UILineBreakModeWordWrap;
        self.textAlignment=NSTextAlignmentCenter;
    }
    
        return self;
}
    





@end
