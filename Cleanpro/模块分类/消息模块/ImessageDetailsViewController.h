//
//  ImessageDetailsViewController.h
//  Cleanpro
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImessageDetailsViewController : UIViewController

@property (nonatomic,strong)messageMode * mode_Message;
@property (nonatomic,strong)E_NessageMode * mode;
@property (assign, nonatomic) NSInteger MessageStyle;
@end

NS_ASSUME_NONNULL_END
