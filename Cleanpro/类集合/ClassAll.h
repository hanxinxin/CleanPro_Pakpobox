//
//  ClassAll.h
//  Cleanpro
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassAll : NSObject

@end

@interface CreateOrder : NSObject
@property (nonatomic,strong)NSString * machine_no;//    机器编号
@property (nonatomic,strong)NSDictionary * goods_info;//   温度和时间 {“temperature”:”Warm”}
@property (nonatomic,strong)NSString * total_amount;//  总金额
@property (nonatomic,strong)NSString * client_type;//   客户端类型 （ANDROID, IOS）
@property (nonatomic,strong)NSString * order_type;//    订单类型： LAUNDRY：干洗
@end


@interface OrderListClass : NSObject
@property (nonatomic,strong)NSString * machine_no;//    机器编号
@property (nonatomic,strong)NSString * goods_info;//   温度和时间 {“temperature”:”Warm”}
@property (nonatomic,strong)NSNumber * total_amount;//  总金额
@property (nonatomic,strong)NSString * client_type;//   客户端类型 （ANDROID, IOS）
@property (nonatomic,strong)NSString * order_type;//    订单类型： LAUNDRY：干洗
@property (nonatomic,strong)NSNumber * create_time;////订单时间
@property (nonatomic,strong)NSString * OrderId;//    ID

@end

@interface WalletListClass : NSObject
@property (nonatomic,strong)NSNumber * amount;//   支付金额
@property (nonatomic,strong)NSNumber * balance;//   支付完成后的金额
@property (nonatomic,strong)NSNumber * createTime;//  支付发生时间
@property (nonatomic,strong)NSString * WalletId;//   id
@property (nonatomic,strong)NSString * incomeType;//    收入类型
@property (nonatomic,strong)NSString * paymentType;//   付款类型
@property (nonatomic,strong)NSString * tradeType;//    交易类型
@property (nonatomic,strong)NSString * transactionType;//   洗衣类型

@end
