//
//  SaveUserIDMode.h
//  Cleanpro
//
//  Created by mac on 2019/1/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//
//@interface SaveUserIDMode : NSObject
//
//@end
////// 用户登录后返回的数据 。  只用于用户信息
@interface SaveUserIDMode : NSObject <NSCoding>
@property (nonatomic,retain)NSString * phoneNumber;//   手机号码
@property (nonatomic,retain)NSString * loginName;//   与手机号码相同

@property (nonatomic,retain)NSString * yonghuID;//   用户ID
//@property (nonatomic,strong)NSString * randomPassword;//  验证码
//@property (nonatomic,strong)NSString * password;//  登录密码
//@property (nonatomic,strong)NSString * payPassword;//    支付密码
//@property (nonatomic,strong)NSString * registerType;//   注册终端类型 IOS，ANDROID
//@property (nonatomic,strong)NSString * countryCode;//    国家代码 例如：中国:86 (目前传马来固定值)
@property (nonatomic,retain)NSString * firstName;//   first name
@property (nonatomic,retain)NSString * lastName;//   last name
@property (nonatomic,retain)NSString * birthday;//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
@property (nonatomic,retain)NSString * gender;//       MALE:男，FEMALE:女
@property (nonatomic,retain)NSString * postCode;//   Post Code inviteCode
@property (nonatomic,retain)NSString * inviteCode;/////已填写的邀请码，没有填写字段为空;
@property (nonatomic,retain)NSString * myInviteCode;//       我的邀请码
@property (nonatomic,retain)NSString * headImageUrl;//  头像地址
@property (nonatomic,retain)NSString * EmailStr;  /// Email 
@property (nonatomic,retain)NSString * payPassword;  /// 支付密码

@property (nonatomic,retain)NSString * balance;
@property (nonatomic,retain)NSString * credit;
@property (nonatomic,retain)NSString * couponCount;
@end
NS_ASSUME_NONNULL_END
