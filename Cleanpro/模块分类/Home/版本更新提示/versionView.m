//
//  versionView.m
//  Cleanpro
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 mac. All rights reserved.
//

#import "versionView.h"

@implementation versionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)Cancel_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(Buttontouch:View:forcedFlag:)]) {
        [self.delegate Buttontouch:0 View:self forcedFlag:self.forcedFlagStr]; // 回调代理
    }
}

- (IBAction)Update_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(Buttontouch:View:forcedFlag:)]) {
        [self.delegate Buttontouch:1 View:self forcedFlag:self.forcedFlagStr]; // 回调代理
    }
}




@end
