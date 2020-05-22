//
//  EWashHeader.h
//  Cleanpro
//
//  Created by mac on 2020/4/1.
//  Copyright © 2020 mac. All rights reserved.
//

#ifndef EWashHeader_h
#define EWashHeader_h


//// Cleanpro 2.0  URL
 
//#define E_FuWuQiUrl @"http://192.168.0.119:83" //  测试版服务器
//#define E_FuWuQiUrl @"https://alfred-ewash.pakpobox.com" //  外网服务器
#define E_FuWuQiUrl @"https://cleanpro-api.pakpobox.com"

#define E_register @"/api/member/v1/register" ///注册
//#define E_login @"/api/member/v1/login"  ///登录
#define E_login @"/api/user/v1/login/app"  ///区分用户和快递员

#define E_GetToken @"/api/member/v1/accountInfo"  ///获取用户登录的token 和个人信息
#define E_PostUserInfo @"/api/member/v1/completeProfile" ///修改用户的信息
#define E_PostHeaderImage @"/api/member/v1/uploadHeadImage"///上传用户头像
#define E_DownliadHeaderImage @"/api/member/v1/downloadHeadImage/" ///下载用户头像

#define E_sendSmsCode @"/api/member/v1/sendSmsCode"  ///发送验证码
#define E_verifySmsCode @"/api/member/v1/verifySmsCode" ///校验验证码
#define E_getAccountInfo @"/api/member/v1/accountInfo"
#define E_getDistrict @"/api/user/v1/district/list/query"///地址查询接口
#define E_getaddressInfo @"/api/member/v1/addressInfo"  ///查询个人地址
#define E_PostaddressUpdate @"/api/member/v1/address/update" ///更新个人的地址
#define E_PostInviteCode @"/api/member/v1/usingInviteCode" ///填写邀请码
#define E_GetwalletList @"/api/member/v1/wallet/log/query" ///获取钱包列表

#define E_Getnearby @"/api/user/v1/merchant/nearby"  /// nearby 附近地图



#define E_retrievePassword @"/api/member/v1/retrievePassword"  //修改密码 发送验证码
#define E_retrievePasswordVerify @"/api/member/v1/retrievePasswordVerify"  // 修改密码 校验验证码
#define E_retrievePasswordReset @"/api/member/v1/retrievePasswordReset"  //  修改密码

#define E_existPassword @"/api/member/v1/pay/password/exist"  ///检查用户支付密码是否存在
#define E_setPayPassword @"/api/member/v1/pay/password/set"  ///设置支付密码
#define E_updatePassword @"/api/member/v1/pay/password/update"  ///更新支付密码
#define E_resetPassword @"/api/member/v1/pay/password/reset"    ///忘记密码后设置支付密码

///////   订单获取的
#define E_GetBleInfo @"/api/locker/v1/ble/info/by-site-serial-number/" ///获取蓝牙的信息
#define E_Getquery @"/api/product/v1/commodity/query/clean-pro/by-site-id/" ///获取商品信息
#define E_JYPassword @"/api/orders/v1/member/app/wallet/pay"  ///支付扣钱和校验密码


#define E_MenuList @"/api/product/v1/menu/list"  /// 获取商品菜单
#define E_MenuListMember @"/api/product/v1/commodity/query/member" ///菜单里面的商品
#define E_QueryLocation @"/api/locker/v1/query/member" ///查询E_wash 附近门店
#define E_POSTFile @"/api/file/v1/upload" ///上传图片
#define E_DownFile @"/api/file/v1/download/" ///下载图片
#define E_CreateOrder @"/api/orders/v1/member/app/create"  ///创建订单
#define E_GetOrderList @"/api/orders/v1/member/articles/"  ///查看订单列表
#define E_Ipay88Url @"/api/pay/v1/payment/pay"   ///获取ipay88支付的参数
#define E_refund_application @"/api/orders/v1/member/app/refund/application"  ///机器错误  反馈申请退款
#define E_WasherDryerquery @"/api/orders/v1/member/clean-pro/articles/member/query" ///查看洗衣烘干列表
#define E_Getcommand @"/api/orders/v1/member/app/command" ///获取 蓝牙指令



#define E_articlesE_wash @"/api/orders/v1/report/articles/e-wash" ///抢单大厅 列表
///订单的5个状态
#define E_confirm_collect @"/api/orders/v1/e-wash/confirm-courier-collect"
#define E_confirm_cleaning @"/api/orders/v1/e-wash/confirm-cleaning"
#define E_confirm_packed @"/api/orders/v1/e-wash/confirm-packed"
#define E_confirm_delivery @"/api/orders/v1/e-wash/confirm-in-delivery"
#define E_confirm_collected @"/api/orders/v1/e-wash/confirm-customer-collected"
///////////////

///message
#define E_MessageList @"/api/notify/v1/message/query" /// 获取消息列表
#define E_Messageread @"/api/notify/v1/message/mark/read" //标记已读
#define E_Messagedelete @"/api/notify/v1/message/mark/delete"  //标记删除


///版本更新获取
#define E_GetloadAppVersion @"/api/member/v1/loadAppVersion"  ///获取版本的 
#endif /* EWashHeader_h */
