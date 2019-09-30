//
//  FeedbackViewController.h
//  Cleanpro
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface FeedbackViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *Amount_label;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *feedback_textView;

@property (weak, nonatomic) IBOutlet UIButton *Submit_btn;

@property (weak, nonatomic) IBOutlet UILabel *down_lable_T;

@property (weak, nonatomic) IBOutlet UILabel *down_lable_D;

@property (nonatomic,strong)SaveUserIDMode * ModeUser;

@end

//NS_ASSUME_NONNULL_END
