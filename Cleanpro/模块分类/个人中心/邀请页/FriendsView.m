//
//  FriendsView.m
//  Cleanpro
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "FriendsView.h"
@interface FriendsView ()<UIGestureRecognizerDelegate>

@end
@implementation FriendsView


-(void)awakeFromNib
{
    //说明文档里说必须调用父类的awakeFromNib，以防出现意外，详细说明见文档
    [super awakeFromNib];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}

- (IBAction)ShareTouch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setTouch:)]) {
        [self.delegate setTouch:101];
    }
}
- (IBAction)InputTouch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setTouch:)]) {
        [self.delegate setTouch:102];
    }
}
- (IBAction)ComeTouch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setTouch:)]) {
        [self.delegate setTouchText:self.TextField.text];
    }
}

@end
