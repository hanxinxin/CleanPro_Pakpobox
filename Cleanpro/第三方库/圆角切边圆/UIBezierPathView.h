//
//  UIBezierPathView.h
//  Cleanpro
//
//  Created by mac on 2019/5/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPathView : NSObject

/*设置顶部圆角*/
+ (void)setCornerOnTop:(CGFloat )cornerRadius view_b:(UIView*)view;
/*设置底部圆角*/
+ (void)setCornerOnBottom:(CGFloat )cornerRadius view_b:(UIView*)view;
/*设置左边圆角*/
+ (void)setCornerOnLeft:(CGFloat )cornerRadius view_b:(UIView*)view;
/*设置右边圆角*/
+ (void)setCornerOnRight:(CGFloat )cornerRadius view_b:(UIView*)view;
/*设置四边圆角*/
+ (void)setAllCorner:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
