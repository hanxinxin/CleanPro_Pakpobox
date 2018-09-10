//
//  ChangeLanguage.h
//  StorHub
//
//  Created by Pakpobox on 2018/2/27.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeLanguage : NSObject

@property(nonatomic, strong)NSString *language;

+(id)sharedInstance;

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param table table
 *
 *  @return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

/**
 *  改变当前语言
 */
-(void)changeNowLanguage;

/**
 *  设置新的语言
 *
 *  @param language 新语言
 */
-(void)setNewLanguage:(NSString*)language;
@end

