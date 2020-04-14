//
//  DataModel.h
//  Cleanpro
//
//  Created by mac on 2020/4/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject

@end

@interface productsMode : NSObject
@property (nonatomic,strong)NSMutableArray * attributeList ;
@property (nonatomic,strong)NSString * description;
@property (nonatomic,strong)NSString * descriptionEn;
@property (nonatomic,strong)NSString * imageFileId ;
@property (nonatomic,strong)NSString * productId;
@property (nonatomic,strong)NSString * productName ;
@property (nonatomic,strong)NSString * productNameEn ;
@property (nonatomic,strong)NSMutableArray * productVariantList ;
@property (nonatomic,strong)NSString * serviceId;
@end


@interface attributeListsMode : NSObject
@property (nonatomic,strong)NSString * attributeType;
@property (nonatomic,strong)NSString * name ;
@property (nonatomic,strong)NSString * productAttributeId ;
@property (nonatomic,strong)NSMutableArray * valueList ;
@end

@interface valueListMode : NSObject
@property (nonatomic,strong)NSString * productAttributeValue;
@property (nonatomic,strong)NSString * productAttributeValueId;
@end

@interface productVariantListMode : NSObject
@property (nonatomic,strong)NSString * priceValue;
@property (nonatomic,strong)NSMutableArray * productAttributeValueIds;
@property (nonatomic,strong)NSString * productAttributeValueName ;
@property (nonatomic,strong)NSString * productVariantId ;
@end


@interface CommodityMode : NSObject
@property (nonatomic,strong)NSString * Ctype;  /// 5 Bound 或  10 Bound
@property (nonatomic,strong)NSString * Ctemperature ; ///  从左到右 依次 1是cold，2是 Warm，3是Hot
@property (nonatomic,assign)NSInteger SelectTemperature; ///  从左到右 依次 1是cold，2是 Warm，3是Hot
@property (nonatomic,assign)NSInteger SelectMenuPound; //////0 是 5 Bound 或  1是 10 Bound
@property (nonatomic,strong)productsMode * Mode ;
@end

@interface AddressListMode : NSObject
@property (nonatomic,strong)NSString * siteId ;
@property (nonatomic,strong)NSString * siteName ;
@property (nonatomic,strong)NSString * siteSerialNumber;
@property (nonatomic,strong)NSString * siteType;
@property (nonatomic,strong)NSString * streetAddress;
@property (nonatomic,strong)NSNumber * latitude;
@property (nonatomic,strong)NSNumber * longitude;
@property (nonatomic,strong)NSNumber * distance;
@end

@interface OrderListMode : NSObject
@property (nonatomic,strong)NSString * articleId;
@property (nonatomic,strong)NSString * creationTime;
@property (nonatomic,strong)NSString * itemsName;
@property (nonatomic,strong)NSString * iconFileId ;
@property (nonatomic,strong)NSString * logisticsType ;
@property (nonatomic,strong)NSString * paidCharge;
@property (nonatomic,strong)NSString * fileId;
@property (nonatomic,strong)NSString * paymentMethod;
@property (nonatomic,strong)NSString * paymentPlatform;
@property (nonatomic,strong)NSString * lastUpdatedTime;
@property (nonatomic,strong)NSString * orderNumber;
@property (nonatomic,strong)NSArray * ordersItems;
@property (nonatomic,strong)NSString * recipientAddress;
@property (nonatomic,strong)NSString * recipientMail;
@property (nonatomic,strong)NSString * recipientName;
@property (nonatomic,strong)NSString * recipientPhoneNumber;
@property (nonatomic,strong)NSString * overdueTime;
@property (nonatomic,strong)NSString * qrcodeUnitType;
@property (nonatomic,strong)NSString * serverFunctionType;
@property (nonatomic,strong)NSString * serviceName;
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)NSString * trakingNumber;
//
@property (nonatomic,strong)NSString * cleaningTime;
@property (nonatomic,strong)NSString * cleaningUserId;
@property (nonatomic,strong)NSString * cleaningUserName;
@property (nonatomic,strong)NSString * courierCollectTime;
@property (nonatomic,strong)NSString * courierCollectUserId;
@property (nonatomic,strong)NSString * courierCollectUserName;
@property (nonatomic,strong)NSString * finishTime;
@property (nonatomic,strong)NSString * finishUserId;
@property (nonatomic,strong)NSString * finishUserName;
@property (nonatomic,strong)NSString * inDeliveryTime;
@property (nonatomic,strong)NSString * inDeliveryUserId;
@property (nonatomic,strong)NSString * inDeliveryUserName;
@property (nonatomic,strong)NSString * packedTime;
@property (nonatomic,strong)NSString * packedUserId;
@property (nonatomic,strong)NSString * packedUserName;
@property (nonatomic,strong)NSString * lastUpdatedStaffName;
@property (nonatomic,strong)NSString * siteId;
@property (nonatomic,strong)NSString * siteName;
@property (nonatomic,strong)NSString * siteNameEn;
@property (nonatomic,strong)NSString * siteType;
@end


@interface  itemsSP: NSObject
@property (nonatomic,strong)NSString * productVariantId;
@property (nonatomic,strong)NSString * quantity;
@end


@interface  PostOrderMode: NSObject
@property (nonatomic,strong)NSString * orderNumber;
@property (nonatomic,strong)NSString * expressNumber;
@property (nonatomic,strong)NSString * merchantId;
@property (nonatomic,strong)NSString * ordersId;
@property (nonatomic,strong)NSString * siteId;
@property (nonatomic,strong)NSString * siteMerchantId;
@property (nonatomic,strong)NSString * paymentMethod;
@property (nonatomic,strong)NSString * siteName;
//@property (nonatomic,strong)NSString * siteName;
@property (nonatomic,strong)NSString * siteType;
@property (nonatomic,strong)NSString * unitType;
@property (nonatomic,strong)NSArray * paymentItems;
@end
@interface  paymentItemsMode: NSObject
@property (nonatomic,strong)NSString * amount;
@property (nonatomic,strong)NSString * couponCardId;
@property (nonatomic,strong)NSString * couponCode;
@property (nonatomic,strong)NSString * discountAmount;
@property (nonatomic,strong)NSString * displayPayStatus ;
@property (nonatomic,strong)NSString * fileId;
@property (nonatomic,strong)NSString * orderAmount;
@property (nonatomic,strong)NSString * ordersId;
@property (nonatomic,strong)NSString * outTransNo;
@property (nonatomic,strong)NSString * payStatus;
@property (nonatomic,strong)NSString * payTime;
@property (nonatomic,strong)NSString * paymentItemId ;
@property (nonatomic,strong)NSString * paymentPlatform ;
@property (nonatomic,strong)NSString * priceName;
@property (nonatomic,strong)NSString * showApp;
@property (nonatomic,strong)NSString * valueType;

@end
@interface  OrderSItemsMode: NSObject
@property (nonatomic,strong)NSString * priceValue;
@property (nonatomic,strong)NSString * productVariantId;
@property (nonatomic,strong)NSString * productVariantName;
@property (nonatomic,strong)NSString * quantity;
@end


@interface  E_NessageMode: NSObject
@property (nonatomic,strong)NSString * content;
@property (nonatomic,strong)NSString * messageId;
@property (nonatomic,strong)NSString * title;
@end


NS_ASSUME_NONNULL_END
