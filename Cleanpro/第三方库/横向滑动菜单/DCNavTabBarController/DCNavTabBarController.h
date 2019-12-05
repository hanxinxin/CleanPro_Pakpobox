//
//  ViewController.h
//  父子控制器
//
//  Created by 戴川 on 16/6/3.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import <UIKit/UIKit.h>
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol DCNavTabBarControllerDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)SelectInt:(NSInteger)intager;
@end


@interface DCNavTabBarController : UIViewController
-(instancetype)initWithSubViewControllers:(NSArray *)subViewControllers;

@property(nonatomic,copy)UIColor *btnTextNomalColor;
@property(nonatomic,copy)UIColor *btnTextSeletedColor;
@property(nonatomic,copy)UIColor *sliderColor;
@property(nonatomic,copy)UIColor *topBarColor;

// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<DCNavTabBarControllerDelegate> delegate;




@end

