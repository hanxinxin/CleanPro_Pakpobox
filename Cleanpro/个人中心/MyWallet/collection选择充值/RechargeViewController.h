//
//  RechargeViewController.h
//  Cleanpro
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *Amount_label;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *pay_btn;

@end
