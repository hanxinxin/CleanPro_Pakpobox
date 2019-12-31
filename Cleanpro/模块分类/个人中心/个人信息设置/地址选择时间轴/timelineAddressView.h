//
//  timelineAddressViewController.h
//  BleDemo
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CitySelectMode : NSObject
@property (nonatomic,strong)NSString * cityName ;
@property (nonatomic,assign)NSInteger indexS ;

@end





@protocol timelineDelegate <NSObject>
@optional

- (void)CancelDelegate:(NSInteger)time SelectArray:(NSMutableArray *)array; // 1是取消  2是 保存
- (void)TagTouch;
@end

//@interface timelineAddressViewController : UIViewController
@interface timelineAddressView : UIView
@property (strong, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutlet UIButton *CancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *SaveBtn;


@property (strong, nonatomic) IBOutlet UITableView *tableviewA;
@property (strong, nonatomic) IBOutlet UITableView *tableviewB;


//@property (strong,nonatomic) NSArray * ArrayCity;
@property (strong,nonatomic) NSMutableArray * ArrayCity;
@property (strong,nonatomic) NSMutableArray * OneArray;

@property (nonatomic, weak) id<timelineDelegate> delegate;



-(void)setArrayTable:(NSMutableArray*)arr selectArr:(NSMutableArray *)Selectarray index:(NSInteger)Index;// index 0是没有输入postcode查询 1是输入postcode查询

@end

NS_ASSUME_NONNULL_END
