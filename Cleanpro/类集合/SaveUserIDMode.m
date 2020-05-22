//
//  SaveUserIDMode.m
//  Cleanpro
//
//  Created by mac on 2019/1/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SaveUserIDMode.h"
#import <objc/runtime.h>
@implementation SaveUserIDMode

//-(void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
//    [aCoder encodeObject:self.loginName forKey:@"loginName"];
//    [aCoder encodeObject:self.yonghuID forKey:@"yonghuID"];
//    [aCoder encodeObject:self.firstName forKey:@"firstName"];
//    [aCoder encodeObject:self.lastName forKey:@"lastName"];
//    [aCoder encodeObject:self.birthday forKey:@"birthday"];
//    [aCoder encodeObject:self.gender forKey:@"gender"];
//    [aCoder encodeObject:self.postCode forKey:@"postCode"];
//    [aCoder encodeObject:self.EmailStr forKey:@"EmailStr"];
//    [aCoder encodeObject:self.inviteCode forKey:@"inviteCode"];
//    [aCoder encodeObject:self.myInviteCode forKey:@"myInviteCode"];
//    [aCoder encodeObject:self.headImageUrl forKey:@"headImageUrl"];
//    [aCoder encodeObject:self.payPassword forKey:@"payPassword"];
//    [aCoder encodeObject:self.balance forKey:@"balance"];
//    [aCoder encodeObject:self.credit forKey:@"credit"];
//    [aCoder encodeObject:self.couponCount forKey:@"couponCount"];
//}
//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//
//        self.phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
//        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
//        self.yonghuID = [aDecoder decodeObjectForKey:@"yonghuID"];
//        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
//        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
//        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
//        self.gender = [aDecoder decodeObjectForKey:@"gender"];
//        self.postCode = [aDecoder decodeObjectForKey:@"postCode"];
//        self.EmailStr = [aDecoder decodeObjectForKey:@"EmailStr"];
//        self.inviteCode = [aDecoder decodeObjectForKey:@"inviteCode"];
//        self.myInviteCode = [aDecoder decodeObjectForKey:@"myInviteCode"];
//        self.headImageUrl = [aDecoder decodeObjectForKey:@"headImageUrl"];
//        self.payPassword = [aDecoder decodeObjectForKey:@"payPassword"];
//        self.balance = [aDecoder decodeObjectForKey:@"balance"];
//        self.credit = [aDecoder decodeObjectForKey:@"credit"];
//        self.couponCount = [aDecoder decodeObjectForKey:@"couponCount"];
//
//    }
//
//    return self;
//}



 
- (void)encodeWithCoder:(NSCoder *)encoder
 
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([SaveUserIDMode class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    free(ivars);
}
 
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([SaveUserIDMode class], &count);
        for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
       // 归档
       NSString *key = [NSString stringWithUTF8String:name];
      id value = [decoder decodeObjectForKey:key];
       // 设置到成员变量身上
        [self setValue:value forKey:key];
            
        }
        free(ivars);
    }
    return self;
}

@end
