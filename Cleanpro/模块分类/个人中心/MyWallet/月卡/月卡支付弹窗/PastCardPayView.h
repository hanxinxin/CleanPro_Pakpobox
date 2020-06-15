//
//  PastCardPayView.h
//  Cleanpro
//
//  Created by mac on 2020/6/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PastCardPayViewDelegate <NSObject>
@optional
///   //100 代表删除 Close  101表示 Pay
//- (void)SelectTouch:(NSInteger)CellIndex;
-(void)SelectTouch:(NSInteger)CellIndex selectArr:(NSMutableArray*)selectArr;
///选择的支付方式
- (void)SelectCell:(NSInteger)CellIndex;
@end
@interface PastCardPayView : UIView
@property (strong, nonatomic) IBOutlet UILabel *TopTitle;
@property (strong, nonatomic) IBOutlet UIButton *CloseBtn;
@property (strong, nonatomic) IBOutlet UILabel *xian_label;

@property (strong, nonatomic) IBOutlet UITableView *Centertableview;
@property (strong, nonatomic) IBOutlet UIButton *PayBtn;

@property (nonatomic, weak) id<PastCardPayViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame array:(NSArray*)CArray balance:(NSNumber*)balance totalAmount:(NSNumber*)totalAmount;
@end

NS_ASSUME_NONNULL_END
