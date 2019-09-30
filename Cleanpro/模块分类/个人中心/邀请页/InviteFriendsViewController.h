//
//  InviteFriendsViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteFriendsViewController : UIViewController
@property (nonatomic,strong)SaveUserIDMode * ModeUser;

@property (strong, nonatomic) IBOutlet UIView *DownViewShare;
@property (strong, nonatomic) IBOutlet UIButton *whatsAppBtn;
@property (strong, nonatomic) IBOutlet UIButton *FacebookBtn;



@end

NS_ASSUME_NONNULL_END
