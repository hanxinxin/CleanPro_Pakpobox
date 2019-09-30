//
//  PassWordTextView.h
//  TextFieldTest
//
//  Created by Tpphha on 15/12/16.
//  Copyright © 2015年 Tpphha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPPasswordTextView : UIView

/**
 block  密码
 */
@property (nonatomic, copy) void(^passwordDidChangeBlock)(NSString *password);


/**
   密码框个数
 */
@property (nonatomic, assign) NSInteger elementCount;


/**
 设置元素的颜色,默认是黑色的颜色
 */
@property (nonatomic, strong) UIColor *elementBorderColor;


/**
   间距  默认是 4
 */
@property (nonatomic, assign) CGFloat elementMargin;


/**
   判断是否 隐藏键盘   默认是yes      yes 隐藏
 */
@property (nonatomic, assign) BOOL autoHideKeyboard;


/**
 边框 宽度 默认是1
 */
@property (nonatomic, assign) CGFloat elementBorderWidth;


/**
    清除所有密码
 */
- (void)clearPassword;

/**
  显示键盘
 */
- (void)showKeyboard;


/**
   隐藏键盘
 */
- (void)hideKeyboard;


@end
