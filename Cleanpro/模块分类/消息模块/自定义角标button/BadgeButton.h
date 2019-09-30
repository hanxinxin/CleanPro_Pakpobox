//
//  BadgeButton.h
//  StorHub
//
//  Created by mac on 2018/4/25.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//



#import <UIKit/UIKit.h>
#define SPColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface BadgeButton : UIButton

@property (nonatomic) NSInteger badgeValue;

@property (nonatomic) NSInteger frame_age;

@property (nonatomic, assign) BOOL isRedBall;


@end

