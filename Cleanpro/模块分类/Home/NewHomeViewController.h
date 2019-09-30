//
//  NewHomeViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HButtonView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewHomeViewController : UIViewController
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIView * button_view;
@property (nonatomic,strong)HButtonView * buttonOne;
@property (nonatomic,strong)HButtonView * buttonTwo;
@property (nonatomic,strong)HButtonView * buttonThree;

@property (nonatomic,strong)UIView * downView;
@property (nonatomic,strong)UIView * title_View;
@property (nonatomic,strong)UITableView * tableViewD;
@property (weak, nonatomic) IBOutlet UIScrollView *ShowScrollview;

@property (strong, nonatomic) UIScrollView *globalScrollview;

@property (nonatomic,strong)NSString * IDStr; ///钱包ID
@property (nonatomic,strong)NSString * balanceStr;
@property (nonatomic,strong)NSString * currencyUnitStr;
@property (nonatomic,strong)NSString * creditStr;
@property (nonatomic,strong)NSString * couponCountStr;

@end

NS_ASSUME_NONNULL_END
