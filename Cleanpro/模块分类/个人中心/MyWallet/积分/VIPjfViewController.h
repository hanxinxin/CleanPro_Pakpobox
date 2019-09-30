//
//  VIPjfViewController.h
//  Cleanpro
//
//  Created by mac on 2019/1/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VIPjfViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *Donw_tableview;

- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
