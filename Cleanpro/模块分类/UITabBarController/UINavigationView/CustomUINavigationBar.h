//
//  CustomUINavigationBar.h
//  StorHub
//
//  Created by mac on 2018/3/21.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomUINavigationBar : UINavigationBar
@property (nonatomic,assign) CGFloat leftValue;
- (void)setItemsSpace:(CGFloat)space;
@end
