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
//#import "CleanproNew-Swift.h"
#import "HXBleManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readwrite, strong) MeshNetworkManagerAppdelegate * appdelegate1;
@property (nonatomic, assign) HXBleManager * ManagerBLE;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIButton * FCViewLabel;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
+(instancetype)shareAppDelegate;

///设置倒计时
-(void)addFCViewSet;
-(void)hiddenFCViewYES;
-(void)hiddenFCViewNO;
@end

