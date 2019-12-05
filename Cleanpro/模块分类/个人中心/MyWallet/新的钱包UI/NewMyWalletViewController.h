//
//  NewMyWalletViewController.h
//  Cleanpro
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewMyWalletViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) IBOutlet UIImageView *TouxiangImage;
@property (strong, nonatomic) IBOutlet UILabel *UserName;


@property (nonatomic,strong) NSNumber * balance;
@property (nonatomic,strong) NSString * currencyUnit;

@end

NS_ASSUME_NONNULL_END
