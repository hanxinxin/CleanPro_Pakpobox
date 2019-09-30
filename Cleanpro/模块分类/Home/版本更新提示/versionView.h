//
//  versionView.h
//  Cleanpro
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol versionViewDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
- (void)Buttontouch:(NSInteger)key_Int View:(UIView *)view forcedFlag:(NSString*)forcedFlagStr;  ////0是关 1是开

@end

@interface versionView : UIView
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *Label_Center;
@property (strong, nonatomic) IBOutlet UIButton *Cancel_btn;
@property (strong, nonatomic) IBOutlet UIButton *Update_btn;
@property (strong, readwrite) NSString * forcedFlagStr;
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<versionViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
