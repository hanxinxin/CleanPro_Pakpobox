//
//  EWashHeader.h
//  Cleanpro
//
//  Created by mac on 2020/4/1.
//  Copyright © 2020 mac. All rights reserved.
//

#ifndef EWashHeader_h
#define EWashHeader_h
//#define E_FuWuQiUrl @"http://192.168.0.119:83" //  测试版服务器
#define E_FuWuQiUrl @"https://alfred-ewash.pakpobox.com" //  外网服务器

#define E_register @"/api/member/v1/register" ///注册
//#define E_login @"/api/member/v1/login"  ///登录
#define E_login @"/api/user/v1/login/app"  ///区分用户和快递员
#define E_sendSmsCode @"/api/member/v1/sendSmsCode"
#define E_verifySmsCode @"/api/member/v1/verifySmsCode"
#define E_getAccountInfo @"/api/member/v1/accountInfo"

#define E_retrievePassword @"/api/member/v1/retrievePassword"  //修改密码 发送验证码
#define E_retrievePasswordVerify @"/api/member/v1/retrievePasswordVerify"  // 修改密码 校验验证码
#define E_retrievePasswordReset @"/api/member/v1/retrievePasswordReset"  //  修改密码


#define E_MenuList @"/api/product/v1/menu/list"  /// 获取商品菜单
#define E_MenuListMember @"/api/product/v1/commodity/query/member" ///菜单里面的商品
#define E_QueryLocation @"/api/locker/v1/query/member" ///查询附近门店
#define E_POSTFile @"/api/file/v1/upload" ///上传图片
#define E_DownFile @"/api/file/v1/download/" ///下载图片
#define E_CreateOrder @"/api/orders/v1/member/app/create"  ///创建订单

#define E_GetOrderList @"/api/orders/v1/member/articles/"  ///查看订单列表

#define E_Ipay88Url @"/api/pay/v1/payment/pay"   ///获取ipay88支付的参数




#define E_articlesE_wash @"/api/orders/v1/report/articles/e-wash" ///抢单大厅 列表

///订单的5个状态
#define E_confirm_collect @"/api/orders/v1/e-wash/confirm-courier-collect"
#define E_confirm_cleaning @"/api/orders/v1/e-wash/confirm-cleaning"
#define E_confirm_packed @"/api/orders/v1/e-wash/confirm-packed"
#define E_confirm_delivery @"/api/orders/v1/e-wash/confirm-in-delivery"
#define E_confirm_collected @"/api/orders/v1/e-wash/confirm-customer-collected"
///////////////

#define E_MessageList @"/api/notify/v1/message/query"

#endif /* EWashHeader_h */
