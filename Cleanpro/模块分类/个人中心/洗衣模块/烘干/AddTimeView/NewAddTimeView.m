//
//  NewAddTimeView.m
//  Cleanpro
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NewAddTimeView.h"

@implementation NewAddTimeView

-(void)awakeFromNib
{
    //说明文档里说必须调用父类的awakeFromNib，以防出现意外，详细说明见文档
//    self.next_Btn.layer.cornerRadius=4;
    [super awakeFromNib];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//
//}
- (IBAction)jia_touch:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(Jia_Jian_Touch:)]) {
        [self.delegate Jia_Jian_Touch:101];
    }
}
- (IBAction)jian_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(Jia_Jian_Touch:)]) {
        [self.delegate Jia_Jian_Touch:102];
    }
}
- (IBAction)next_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(NextTouch:timeStr:)]) {
        [self.delegate NextTouch:@"" timeStr:@""];
    }
}
- (IBAction)close_touch:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(CloseTouch)]) {
        [self.delegate CloseTouch];
    }
}

@end
