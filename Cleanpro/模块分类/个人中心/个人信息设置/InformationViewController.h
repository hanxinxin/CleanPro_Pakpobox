//
//  InformationViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *topTableview;

@property (nonatomic,strong) UIView * ZDC_View;
@property (nonatomic,strong) UIView * whiteView;
@property (nonatomic,strong) UILabel * xianLabel;
@property (nonatomic,strong) UIButton * CancelBtn;
@property (nonatomic,strong) UIButton * ConfirmBtn;
@property (nonatomic,strong) UIDatePicker * date_picker;



@end

NS_ASSUME_NONNULL_END
