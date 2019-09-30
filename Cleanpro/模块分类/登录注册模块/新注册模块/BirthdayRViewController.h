//
//  BirthdayRViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BirthdayRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIPickerView *DatepickerView;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;
@property (weak, nonatomic) IBOutlet UIButton *Skip_btn;

@property (weak, nonatomic) IBOutlet UIDatePicker *date_picker;

@property (strong, nonatomic) NSString * DateStr;;

@property (strong, nonatomic) userIDMode * Nextmode;

@end

NS_ASSUME_NONNULL_END
