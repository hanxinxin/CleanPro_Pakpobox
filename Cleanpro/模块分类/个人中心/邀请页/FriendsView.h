//
//  FriendsView.h
//  Cleanpro
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FriendsViewDelegate <NSObject>
@optional

- (void)setTouch:(NSInteger)tagInteger;

- (void)setTouchText:(NSString*)FieldText;
@end
@interface FriendsView : UIView
@property (strong, nonatomic) IBOutlet UIButton *ShareBtn;
@property (strong, nonatomic) IBOutlet UIButton *InpurBtn;
@property (strong, nonatomic) IBOutlet HQTextField *TextField;
@property (strong, nonatomic) IBOutlet UIButton *comeBtn;
@property (nonatomic, weak) id<FriendsViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
