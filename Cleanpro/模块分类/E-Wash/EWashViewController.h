//
//  EWashViewController.h
//  Cleanpro
//
//  Created by mac on 2020/3/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWashViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *ZScrollView;

@property (assign, nonatomic) NSInteger selectLaundry;  //1显示 2不显示
@end

NS_ASSUME_NONNULL_END
