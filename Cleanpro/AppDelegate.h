//
//  AppDelegate.h
//  Cleanpro
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Cleanpro-Swift.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readwrite, strong) MeshNetworkManagerAppdelegate * appdelegate1;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
+(instancetype)shareAppDelegate;

@end

