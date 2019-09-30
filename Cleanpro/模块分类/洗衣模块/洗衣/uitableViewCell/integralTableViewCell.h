//
//  integralTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2019/1/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol integralTableViewCellCellDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
- (void)switchtouch:(NSInteger)key_Int;  ////0是关 1是开

@end
@interface integralTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UISwitch *right_switch;
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<integralTableViewCellCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
