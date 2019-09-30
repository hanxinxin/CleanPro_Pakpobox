//
//  WelcomeViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelcomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *BJ_image;

@property (weak, nonatomic) IBOutlet UIImageView *imageW;
@property (weak, nonatomic) IBOutlet UILabel *come_title;
@property (weak, nonatomic) IBOutlet UILabel *miaoshu_title;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *tispLabel;


@end

NS_ASSUME_NONNULL_END
