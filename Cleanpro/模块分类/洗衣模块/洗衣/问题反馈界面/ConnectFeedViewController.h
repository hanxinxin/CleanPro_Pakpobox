//
//  ConnectFeedViewController.h
//  Cleanpro
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectFeedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *Amount_label;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *feedback_textView;

@property (weak, nonatomic) IBOutlet UIButton *Submit_btn;

@property (weak, nonatomic) IBOutlet UILabel *down_lable_T;

@property (weak, nonatomic) IBOutlet UILabel *down_lable_D;
@property (strong, nonatomic) IBOutlet UICollectionView *PhotoListTable;
@property (strong, nonatomic) IBOutlet UILabel *titleTableMS;

@property (nonatomic,strong)SaveUserIDMode * ModeUser;

@property (nonatomic,strong)NSString * orderidStr;

@end

NS_ASSUME_NONNULL_END
