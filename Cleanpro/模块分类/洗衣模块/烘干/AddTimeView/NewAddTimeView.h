//
//  NewAddTimeView.h
//  Cleanpro
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NewAddTimeViewDelegate <NSObject>
@optional

- (void)Jia_Jian_Touch:(NSInteger)time;

- (void)NextTouch:(NSString*)jine timeStr:(NSString *)time;
- (void)CloseTouch;
@end

@interface NewAddTimeView : UIView
@property (strong, nonatomic) IBOutlet UILabel *title_top;
@property (strong, nonatomic) IBOutlet UILabel *center_leftLabel;
@property (strong, nonatomic) IBOutlet UIButton *Btn_jia;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIButton *Btn_jian;
@property (strong, nonatomic) IBOutlet UIButton *next_Btn;
@property (nonatomic, weak) id<NewAddTimeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
