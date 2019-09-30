//
//  BadgeButton1.h
//  StorHub
//
//  Created by mac on 2018/12/19.
//  Copyright © 2018 Pakpobox. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SPColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface BadgeButton1 : UIButton

@property (nonatomic) NSInteger badgeValue;

@property (nonatomic) NSInteger frame_age;

@property (nonatomic, assign) BOOL isRedBall;


@end

NS_ASSUME_NONNULL_END
