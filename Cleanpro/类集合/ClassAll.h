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
@property (nonatomic,strong)NSString * pay_amount;//    需要支付金额
@property (nonatomic,strong)NSString * credits;//    使用积分
@property (nonatomic,strong)NSString * coupon_code;//    优惠券编码
@property (nonatomic,strong)NSString * payment_platform;//    支付平台。 钱包:WALLET, iPay88:IPAY88
@end


@interface OrderListClass : NSObject
@property (nonatomic,strong)NSString * machine_no;//    机器编号
@property (nonatomic,strong)NSString * goods_info;//   温度和时间 {“temperature”:”Warm”}
@property (nonatomic,strong)NSString * order_no;   //Order NO
@property (nonatomic,strong)NSNumber * total_amount;//  总金额
@property (nonatomic,strong)NSString * client_type;//   客户端类型 （ANDROID, IOS）
@property (nonatomic,strong)NSString * order_type;//    订单类型： LAUNDRY：干洗
@property (nonatomic,strong)NSString * pay_status; //订单支付状态
@property (nonatomic,strong)NSNumber * create_time;////订单时间
@property (nonatomic,strong)NSString * OrderId;//    ID
@property (nonatomic,strong)NSString * LocationName;  ///门店名称


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
////// 用户注册时  要上传的类。
@interface userIDMode : NSObject
@property (nonatomic,strong)NSString * phoneNumber;//   手机号码
@property (nonatomic,strong)NSString * loginName;//   与手机号码相同
@property (nonatomic,strong)NSString * randomPassword;//  验证码
@property (nonatomic,strong)NSString * password;//  登录密码
@property (nonatomic,strong)NSString * payPassword;//    支付密码
@property (nonatomic,strong)NSString * registerType;//   注册终端类型 IOS，ANDROID
@property (nonatomic,strong)NSString * countryCode;//    国家代码 例如：中国:86 (目前传马来固定值)
@property (nonatomic,strong)NSString * firstName;//   first name
@property (nonatomic,strong)NSString * lastName;//   last name
@property (nonatomic,strong)NSString * birthday;//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
@property (nonatomic,strong)NSString * gender;//       MALE:男，FEMALE:女
@property (nonatomic,strong)NSString * postCode;//   Post Code inviteCode
@property (nonatomic,strong)NSString * inviteCode;//       邀请码
@end

@interface messageMode : NSObject


@property (nonatomic,strong)NSString * sendTime ;
@property (nonatomic,strong)NSString * message ;
@property (nonatomic,strong)NSString * ID ;
@property (nonatomic,strong)NSString * messageType ; /// 1是洗衣，2是烘衣 3是充值
@property (nonatomic,strong)NSString * sendTo ;
@property (nonatomic,strong)NSString * pushStatus ;
@property (nonatomic,strong)NSString * header ;
@property (nonatomic,strong)NSString * memberId ;
@property (nonatomic,strong)NSString * createTime ;
@property (nonatomic,strong)NSString * deleted ;
@property (nonatomic,strong)NSString * status ;
@property (nonatomic,strong)NSString * generatedDateTime ;
@end


@interface Message_order : NSObject


@property (nonatomic,strong)NSString * boxCode ;
@property (nonatomic,strong)NSString * location ;
@property (nonatomic,strong)NSString * machineNo ;
@property (nonatomic,strong)NSString * machineType ;
@property (nonatomic,strong)NSString * orderNo ;
@property (nonatomic,strong)NSString * orderType ;
@end


@interface payChongzhiListMode : NSObject


@property (nonatomic,strong)NSString * Chongzhiid ;
@property (nonatomic,strong)NSString * name ;
@property (nonatomic,strong)NSString * amount ;
@property (nonatomic,strong)NSString * giveAmount ;
@property (nonatomic,strong)NSString * defaultSelect ;
@property (nonatomic,strong)NSString * createTime ;
@property (nonatomic,strong)NSString * updateTime ;
@property (nonatomic,strong)NSString * description1;

@end


@interface bannerMode : NSObject
@property (nonatomic,strong)NSString * advertType ;
@property (nonatomic,strong)NSDictionary * mainPage ;
@property (nonatomic,strong)NSString * pageName ;
@property (nonatomic,strong)NSString * sequence ;
@property (nonatomic,strong)NSString * subPageType ;
@property (nonatomic,strong)NSDictionary * picture ;
@end

@interface OneCityMode : NSObject
@property (nonatomic,strong)NSString * idStr ;
@property (nonatomic,strong)NSString * regionLevel ;
@property (nonatomic,strong)NSString * regionName ;
@property (nonatomic,strong)NSString * regionShortName ;

@end

@interface TwoCityMode : NSObject
@property (nonatomic,strong)NSString * idStrTwo ;
@property (nonatomic,strong)OneCityMode * parentRegion ;
@property (nonatomic,strong)NSString * regionLevel ;
@property (nonatomic,strong)NSString * regionName ;
@end

@interface ThreeCityMode : NSObject
@property (nonatomic,strong)NSString * idStrThree ;
@property (nonatomic,strong)TwoCityMode * parentRegion ;
@property (nonatomic,strong)NSString * postcode ;
@property (nonatomic,strong)NSString * regionLevel ;
@property (nonatomic,strong)NSString * regionName ;
@end

@interface CitySelectMode : NSObject
@property (nonatomic,strong)NSString * cityName ;
@property (nonatomic,assign)NSInteger indexS ;

@end


@interface upperGradeOneMode : NSObject
@property (nonatomic,strong)NSString * districtId;
@property (nonatomic,strong)NSString * enName;
@property (nonatomic,strong)NSString * endGrade;
@property (nonatomic,strong)NSString * grade;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * postCode;
@property (nonatomic,strong)NSDictionary * upperGrade;
@property (nonatomic,strong)NSString * upperGradeId;
@end


@interface NewWalletListClass : NSObject

@property (nonatomic,strong)NSString * comment;
@property (nonatomic,strong)NSNumber * creationTime;
@property (nonatomic,strong)NSNumber * creditAmount;
@property (nonatomic,strong)NSNumber * lastUpdatedTime;
@property (nonatomic,strong)NSString * memberWalletTransactionLogId;
@property (nonatomic,strong)NSNumber * tradingTime;
@property (nonatomic,strong)NSNumber * transactionAmount;
@property (nonatomic,strong)NSNumber * transactionNumber;
@property (nonatomic,strong)NSString * incomeType;
@property (nonatomic,strong)NSString * transactionType;
@end


@interface NewOrderList : NSObject
@property (nonatomic,strong)NSString * merchantId;//
@property (nonatomic,strong)NSString * cleanProItemName;//
@property (nonatomic,strong)NSString * merchantName;//
@property (nonatomic,strong)NSString * orderNumber;//
@property (nonatomic,strong)NSString * ordersId;//
@property (nonatomic,strong)NSArray * ordersItems;//
@property (nonatomic,strong)NSString * paidCharge;//
@property (nonatomic,strong)NSString * siteAddress;//
@property (nonatomic,strong)NSString * siteNumber;//
@property (nonatomic,strong)NSString * siteSerialNumber;//
@property (nonatomic,strong)NSString * siteType;
@property (nonatomic,strong)NSString * timeCreated;//
@end

@interface PastCardMode : NSObject
@property (nonatomic,strong)NSNumber * count;
@property (nonatomic,strong)NSString * creationTime;
@property (nonatomic,strong)NSNumber * currentCost;
@property (nonatomic,strong)NSNumber * dayInterval;
@property (nonatomic,strong)NSNumber * deleteFlag;
@property (nonatomic,strong)NSString * description1;
@property (nonatomic,strong)NSString * enDescription;
@property (nonatomic,strong)NSString * lastUpdatedTime;
@property (nonatomic,strong)NSString * monthCardId;
@property (nonatomic,strong)NSString * monthCardType;
@property (nonatomic,strong)NSNumber * originalCost;
@property (nonatomic,strong)NSNumber * timeInterval;
@end
@interface PastCardListMode : NSObject
@property (nonatomic,strong)NSNumber * buyTime ;
@property (nonatomic,strong)NSNumber * count ;
@property (nonatomic,strong)NSNumber * currentCost;
@property (nonatomic,strong)NSNumber * dayInterval;
@property (nonatomic,strong)NSString * description1;
@property (nonatomic,strong)NSString * enDescription;
@property (nonatomic,strong)NSNumber * expireTime ;
@property (nonatomic,strong)NSString * monthCardId ;
@property (nonatomic,strong)NSString * monthCardType ;
@property (nonatomic,strong)NSNumber * originalCost ;
@property (nonatomic,strong)NSNumber * residueCount ;
@property (nonatomic,strong)NSNumber * timeInterval ;
@property (nonatomic,strong)NSNumber * useCurrentCost ;
@end

@interface PastCardInfoMonthCardLogMode : NSObject
@property (nonatomic,strong)NSNumber *buyTime;
@property (nonatomic,strong)NSNumber *count;
@property (nonatomic,strong)NSNumber *currentCost;
@property (nonatomic,strong)NSNumber *deleteFlags;
@property (nonatomic,strong)NSNumber *dayInterval;
@property (nonatomic,strong)NSString * description1;
@property (nonatomic,strong)NSString * enDescription;
@property (nonatomic,strong)NSNumber *expireTime;
@property (nonatomic,strong)NSString *monthCardId ;
@property (nonatomic,strong)NSString * monthCardType;
@property (nonatomic,strong)NSNumber *originalCost ;
@property (nonatomic,strong)NSNumber *residueCount ;
@property (nonatomic,strong)NSString *timeInterval ;
@property (nonatomic,strong)NSNumber *useCurrentCost ;
@end
