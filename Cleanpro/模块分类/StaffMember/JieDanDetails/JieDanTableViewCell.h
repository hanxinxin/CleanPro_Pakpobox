//
//  JieDanTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JieDanTableViewCellDelegate <NSObject>
@optional

- (void)CfmTouch:(UITableViewCell*)Cell;
@end
@interface JieDanTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *Imagebtn;
@property (strong, nonatomic) IBOutlet UILabel *leftTitle;
@property (strong, nonatomic) IBOutlet UILabel *CenterLabel;
@property (strong, nonatomic) IBOutlet UIButton *Cfmbtn;
@property (nonatomic, weak) id<JieDanTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
