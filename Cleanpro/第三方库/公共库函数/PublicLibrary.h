//
//  PublicLibrary.h
//  Cleanpro
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
/////HUDview
@interface HudViewFZ : UIView
//@property (nonatomic,strong)

+(void)labelExample:(UIView *)view;
+(void)HiddenHud;
+(void)showMessageTitle:(NSString *)title andDelay:(int)timeInt;
@end

/**
 加密储存的函数
 */
@interface jiamiStr :NSObject
+(NSString *)base64Data_encrypt:(NSString *)key;
+(NSString *)base64Data_decrypt;
//+ (AFSecurityPolicy*)customSecurityPolicy;

//AES加密和解密

+(NSString*)AesEncrypt:(NSString*)str;

+(NSString*)AesDecrypt:(NSString*)str;



/**
 字典转Json字符串
 
 @param infoDict 字典
 @return 字符串
 */
+ (NSString*)convertToJSONData:(id)infoDict;
/**
 JSON字符串转化为字典
 
 @param jsonString 字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

////公共类
@interface PublicLibrary : NSObject

+(NSString *)timeString:(NSString*)timeStampString;

@end

