//
//  CustomUINavigationBar.m
//  StorHub
//
//  Created by mac on 2018/3/21.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//
#import "CustomUINavigationBar.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface CustomUINavigationBar()
@property (nonatomic, assign)CGFloat spaceBetweenItems;
@end

@implementation CustomUINavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.spaceBetweenItems = -1024;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        for (UIView *view in self.subviews) {
            for (UIView *subView in view.subviews) {
                if ([NSStringFromClass(subView.class) isEqualToString:@"_UIButtonBarStackView"]) {
                    
                    NSInteger count = 0;
                    for(int i= 1; i<subView.subviews.count; i++) {
                        UIView *t_subview = subView.subviews[i];
                        if ([NSStringFromClass(t_subview.class) isEqualToString:@"_UITAMICAdaptorView"] ) {
                            count ++;
                            if (SCREEN_WIDTH == 414) {
                                t_subview.frame = CGRectMake(t_subview.frame.origin.x - (10-self.spaceBetweenItems), t_subview.frame.origin.y, t_subview.frame.size.width, t_subview.frame.size.height);
                            }else{
                                t_subview.frame = CGRectMake(t_subview.frame.origin.x - (8-self.spaceBetweenItems), t_subview.frame.origin.y, t_subview.frame.size.width, t_subview.frame.size.height);
                            }
                        }
                    }
                    
                    if (SCREEN_WIDTH == 414) {
                        subView.frame = CGRectMake(self.leftValue, subView.frame.origin.y, subView.frame.size.width - (count-1)*(10 - _spaceBetweenItems), subView.frame.size.height);
                    }else{
                        subView.frame = CGRectMake(self.leftValue, subView.frame.origin.y, subView.frame.size.width - (count-1)*(8 - _spaceBetweenItems), subView.frame.size.height);
                    }
                    
                    
                }
            }
            
        }
    }else{
        for (int i=0; i<self.subviews.count; i++) {
            
            UIView *t_view = self.subviews[i];
            NSString *class = NSStringFromClass(t_view.class);
            //_UINavigationBarBackIndicatorView 通过层级结构可以看出有这个view, 在这个不做任何修改，保持系统原样。
            if ([class isEqualToString:@"_UINavigationBarBackIndicatorView"]) {
                return;
            }
            if (i==0) {
                t_view.frame = CGRectMake(self.leftValue, t_view.frame.origin.y, t_view.frame.size.width, t_view.frame.size.height);
            }else{
                if (SCREEN_WIDTH == 414) {
                    t_view.frame = CGRectMake((t_view.frame.origin.x-20+self.leftValue)-(10-self.spaceBetweenItems), t_view.frame.origin.y, t_view.frame.size.width, t_view.frame.size.height);
                }else{
                    t_view.frame = CGRectMake((t_view.frame.origin.x-16+self.leftValue) -(8-self.spaceBetweenItems), t_view.frame.origin.y, t_view.frame.size.width, t_view.frame.size.height);
                }
            }
            
        }
    }
}

-(CGFloat)spaceBetweenItems {
    if (_spaceBetweenItems == -1024) {
        if (SCREEN_WIDTH == 414) {
            return 10;
        } else {
            return 8;
        }
    }else{
        return _spaceBetweenItems;
    }
    
}
- (void)setItemsSpace:(CGFloat)space {
    self.spaceBetweenItems = space;
}
@end
