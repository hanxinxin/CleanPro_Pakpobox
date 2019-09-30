//
//  FriendsRViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTFCodeView.h"         // 基础版 - 下划线

NS_ASSUME_NONNULL_BEGIN

@interface FriendsRViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet HQTextField *Code_tuiguang;
//@property (nonatomic ,strong)  TPPasswordTextView * Code_tuiguang1;
@property (nonatomic, weak) HWTFCodeView   *Code_tuiguang1;
@property (weak, nonatomic) IBOutlet UIButton *Skip_btn;
@property (weak, nonatomic) IBOutlet UIButton *complete;

@property (strong, nonatomic) NSString * inviteCode;

@property (strong, nonatomic) userIDMode * Nextmode;


@end

NS_ASSUME_NONNULL_END
