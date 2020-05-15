//
//  UITabBar.m
//  Cleanpro
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UITabBar+badge.h"

#define TabbarItemNums 4.0

@implementation UITabBar (badge)

// 显示红点
- (void)showBadgeOnItemIndex:(int)index {
    
    [self removeBadgeOnItemIndex:index];
    // 新建小红点
    UIView *bview = [[UIView alloc]init];
    bview.tag = 888 + index;
    bview.layer.cornerRadius = 5;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    
    float percentX = (index+0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFram.size.width);
    CGFloat y = ceilf(0.1 * tabFram.size.height);
    bview.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}

// 隐藏红点
- (void)hideBadgeOnItemIndex:(int)index {
    
    [self removeBadgeOnItemIndex:index];
}
// 移除控件
- (void)removeBadgeOnItemIndex:(int)index {
    
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}
@end


//最后在子控制器调用就可以啦
//
//#import "UITabBar+badge.h"
//
//[self.tabBarController.tabBar showBadgeOnItemIndex:4];
