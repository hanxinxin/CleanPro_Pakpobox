//
//  PublicLibrary.m
//  Cleanpro
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PublicLibrary.h"
#import <CommonCrypto/CommonCryptor.h>

static const char encodingTable[] ="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

#define LocalStr_None @""//空字符串

@interface HudViewFZ ()

@end
@implementation HudViewFZ
static MBProgressHUD* HUD;
// 步骤3 在initWithFrame:方法中添加子控件
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

///// loading 提示
+(void)labelExample:(UIView *)view {
    HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the label text.
    HUD.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
}

///// 菊花 提示  几秒后关闭
+(void)labelJuHua:(UIView *)view andDelay:(int)timeInt{
    MBProgressHUD * HUD1 = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the label text.
    HUD1.label.text = NSLocalizedString(@"", @"HUD loading title");
    [HUD1 hideAnimated:YES afterDelay:timeInt];
}

//// 隐藏HUD
+(void)HiddenHud
{
    [HUD hideAnimated:YES];
}

+(void)showMessageTitle:(NSString *)title andDelay:(int)timeInt{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    hud.userInteractionEnabled = YES;
    
    hud.backgroundColor = [UIColor clearColor];
    
    hud.animationType = MBProgressHUDAnimationZoomOut;
    
    hud.detailsLabelText = title;
    
    hud.square = NO;
    
    hud.mode = MBProgressHUDModeText;
    
    [hud hide:YES afterDelay:timeInt];
    
}

@end


/**
 加密储存的函数
 */
@implementation jiamiStr
+(NSString *)base64Data_encrypt:(NSString *)key
{
    
    // 获取需要加密文件的二进制数据
    NSData *data =  [key dataUsingEncoding: NSASCIIStringEncoding];
    
    // 或 base64EncodedStringWithOptions
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    // 将加密后的文件存储到桌面
    //    [base64Data writeToFile:@"/Users/wangpengfei/Desktop/IDNumber" atomically:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:base64Data forKey:@"YonghuID"];
    return nil;
}

+(NSString *)base64Data_decrypt
{
    // 获得加密后的二进制数据
    //     NSData *base64Data = [NSData dataWithContentsOfFile:@"/Users/wangpengfei/Desktop/IDNumber"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取账户
    NSData *base64Data = [userDefaults objectForKey:@"YonghuID"];
    
    // 解密 base64 数据
    NSData *baseData = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
    NSString* aStr = [[NSString alloc] initWithData:baseData encoding:NSASCIIStringEncoding];
    return aStr;
    
}


/**
 字典转Json字符串
 
 @param infoDict 字典
 @return 字符串
 */
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

/**
  JSON字符串转化为字典

 @param jsonString 字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


//AES加密

+(NSString*)AesEncrypt:(NSString*)str{
    
    NSString*key=@"s8fPakpoE1j676v6";//密钥
    
    NSData*data=[str dataUsingEncoding:NSUTF8StringEncoding];//待加密字符转为NSData型
    
    char keyPtr[kCCKeySizeAES128+1];
    
    memset(keyPtr,0,sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr)encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void*buffer =malloc(bufferSize);
    
    size_t numBytesCrypted =0;
    
    CCCryptorStatus cryptStatus =CCCrypt(
                                        kCCEncrypt, //  加密    kCCDecrypt解密
                                         kCCAlgorithmAES128, //填充方式
                                         kCCOptionPKCS7Padding|kCCOptionECBMode, //工作模式
                                         keyPtr,//AES的密钥长度有128字节、192字节、256字节几种，这里举出可能存在的最大长度
                                         kCCBlockSizeAES128,//密文长度+补位长度
                                         nil,//偏移量，由于是对称加密，用不到
                                         [data bytes],//字节大小
                                         dataLength, //字节长度
                                         buffer,
                                         bufferSize,
                                         &numBytesCrypted);
    
    if(cryptStatus ==kCCSuccess) {
        
        NSData*resultData=[NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        NSString*result =[self base64EncodedStringFrom:resultData];
        
        return result;
        
    }
    
    free(buffer);
    
    return str;
    
}

//解密操作：

+(NSString*)AesDecrypt:(NSString*)str{
    
    NSString*key=@"s8fPakpoE1j676v6";//密钥
    
    NSData*data=[self dataWithBase64EncodedString:str];// base4解码
    
    char keyPtr[kCCKeySizeAES128+1];
    
    memset(keyPtr,0,sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr)encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength +kCCBlockSizeAES128;
    
    void*buffer =malloc(bufferSize);
    
    size_t numBytesCrypted =0;
    
    CCCryptorStatus cryptStatus =CCCrypt(kCCDecrypt,kCCAlgorithmAES128,kCCOptionPKCS7Padding|kCCOptionECBMode,keyPtr,kCCBlockSizeAES128,nil,[data bytes],dataLength,buffer,bufferSize,&numBytesCrypted);
    
    if(cryptStatus ==kCCSuccess) {
        NSData*resultData=[NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString*result =[[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
        return result;
    }
    free(buffer);
    return str;
    
}




+ (NSString*)base64StringFromText:(NSString*)text

{
    
    if(text && ![text isEqualToString:LocalStr_None]) {
        
        NSData*data = [text dataUsingEncoding:NSUTF8StringEncoding];
        
        return[self base64EncodedStringFrom:data];
        
    }
    
    else{
        
        return LocalStr_None;
        
    }
    
}

+ (NSString*)textFromBase64String:(NSString*)base64

{
    
    if(base64 && ![base64 isEqualToString:LocalStr_None]) {
        
        NSData*data = [self dataWithBase64EncodedString:base64];
        
        return[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    else{
        
        return LocalStr_None;
        
    }
    
}

+ (NSData*)dataWithBase64EncodedString:(NSString*)string

{
    
    if(string ==nil)
        
        [NSException raise:NSInvalidArgumentException format:nil];
    
    if([string length] ==0)
        
        return[NSData data];
    
    static char*decodingTable =NULL;
    
    if(decodingTable ==NULL)
        
    {
        
        decodingTable =malloc(256);
        
        if(decodingTable ==NULL)
            
            return nil;
        
        memset(decodingTable,CHAR_MAX,256);
        
        NSUInteger i;
        
        for(i =0; i <64; i++)
            
            decodingTable[(short)encodingTable[i]] = i;
        
    }
    
    const char*characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    if(characters ==NULL)//Not an ASCII string!
        
        return nil;
    
    char*bytes =malloc((([string length] +3) /4) *3);
    
    if(bytes ==NULL)
        
        return nil;
    
    NSUInteger length =0;
    
    NSUInteger i =0;
    
    while(YES)
        
    {
        
        char buffer[4];
        
        short bufferLength;
        
        for(bufferLength =0;bufferLength<4;i++)
            
        {
            
            if(characters[i] =='\0')
                
                break;
            
            if(isspace(characters[i]) || characters[i] =='=')
                
                continue;
            
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            
            if(buffer[bufferLength++] ==CHAR_MAX)//Illegal character!
                
            {
                
                free(bytes);
                
                return nil;
                
            }
            
        }
        
        if(bufferLength ==0)
            
            break;
        
        if(bufferLength ==1)//At least two characters are needed to produce one byte!
            
        {
            
            free(bytes);
            
            return nil;
            
        }
        
        //Decode the characters in the buffer to bytes.
        
        bytes[length++] = (buffer[0] <<2) | (buffer[1] >>4);
        
        if(bufferLength >2)
            
            bytes[length++] = (buffer[1] <<4) | (buffer[2] >>2);
        
        if(bufferLength >3)
            
            bytes[length++] = (buffer[2] <<6) | buffer[3];
        
    }
    
    bytes =realloc(bytes, length);
    
    return[NSData dataWithBytesNoCopy:bytes length:length];
    
}

+ (NSString*)base64EncodedStringFrom:(NSData*)data

{
    
    if([data length] ==0)
        
        return @"";
    
    char*characters =malloc((([data length] +2) /3) *4);
    
    if(characters ==NULL)
        
        return nil;
    
    NSUInteger length =0;
    
    NSUInteger i =0;
    
    while(i < [data length])
        
    {
        
        char buffer[3] = {0,0,0};
        
        short bufferLength =0;
        
        while(bufferLength <3&& i < [data length])
            
            buffer[bufferLength++] = ((char*)[data bytes])[i++];
        
        //Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        
        characters[length++] =encodingTable[(buffer[0] &0xFC) >>2];
        
        characters[length++] =encodingTable[((buffer[0] &0x03) <<4) | ((buffer[1] &0xF0) >>4)];
        
        if(bufferLength >1)
            
            characters[length++] =encodingTable[((buffer[1] &0x0F) <<2) | ((buffer[2] &0xC0) >>6)];
        
        else characters[length++] ='=';
        
        if(bufferLength >2)
            
            characters[length++] =encodingTable[buffer[2] &0x3F];
        
        else characters[length++] ='=';
        
    }
//    -(id)initWithBytesNoCopy:(void *)bytes length:(NSUInteger)length freeWhenDone:(BOOL)flag
    return [[NSString alloc]initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
    
}


@end

@implementation PublicLibrary

+(NSString *)timeString:(NSString*)timeStampString
{
    // timeStampString 是服务器返回的13位时间戳
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    
//    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}
@end
