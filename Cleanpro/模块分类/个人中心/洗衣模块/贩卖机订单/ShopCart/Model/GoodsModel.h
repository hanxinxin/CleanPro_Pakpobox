//
//  HxShopCartViewController.h
//  BleDemo
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//
//  商品模型

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

/** 商品编号 */
@property (copy, nonatomic) NSString *goodsID;

/** 商品图标 */
@property (copy, nonatomic) NSString *goodsIcon;

/** 商品名称 */
@property (copy, nonatomic) NSString *goodsName;

/** 商品定价（原价） */
@property (assign, nonatomic) double goodsOriginalPrice;

/** 商品售价 */
@property (assign, nonatomic) double goodsSalePrice;

/** 商品库存数量 */
@property (assign, nonatomic) int goodsStock;

/** 商品订单数量 */
@property (assign, nonatomic) int orderCount;

/** 商品简介 */
@property (copy, nonatomic) NSString *goodsDesc;

@end
