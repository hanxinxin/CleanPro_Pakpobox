//
//  HXBleManager.h
//  BleDemo
//
//  Created by mac on 2019/11/13.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define Service_UUID @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define Characteristics1 @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define Characteristics2 @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
NS_ASSUME_NONNULL_BEGIN
@protocol HXBleManagerDelegate <NSObject>
@optional
//MARK: 4.发现设备回调

/**
 发现设备后调用

 @param central 手机设备
 @param peripheral 外设
 @param advertisementData 外设携带数据
 @param RSSI 信号强度
 */
- (void)HXcentralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI;
//MARK: 5.1 外设连接成功
- (void)HXcentralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;

//MARK: 5.2 外设连接失败
- (void)HXcentralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

//MARK: 5.3 丢失连接
- (void)HXcentralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

//MARK: 6.2 发现外设服务回调
- (void)HXperipheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;

//MARK: 7.2 从服务中发现外设特征的回调
- (void)HXperipheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;

//MARK: 8.2 更新描述值回调
- (void)HXperipheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error ;


//MARK: 9.2 更新特征值回调，可以理解为获取蓝牙发回的数据
- (void)HXperipheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

//MARK: 通知状态改变回调
-(void)HXperipheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

//MAKR: 发现外设的特征的描述数组
- (void)HXperipheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error;
@end




@interface HXBleManager : NSObject
/**
 手机设备
 */
@property (nonatomic, strong) CBCentralManager *centralManager;

/**
 外设设备
 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/**
 特征值
 */
@property (nonatomic, strong) CBCharacteristic *characteristic;

/**
 服务
 */
@property (nonatomic, strong) CBService *service;

/**
 描述
 */
@property (nonatomic, strong) CBDescriptor *descriptor;

/**
已扫描到的设备的数组
 */
@property (nonatomic, strong) NSMutableArray * ListArray;//储存返回显示的数组
@property (nonatomic, strong) NSMutableArray * DUIBIList;//对比数组
/**
 蓝牙设备连接状态
 */
@property (nonatomic,assign) BOOL ConnectBoll; //连接状态

@property (nonatomic, strong) NSString * macDZ;///地址
@property (nonatomic, strong) NSString * macName;///名字

@property  (nonatomic, weak) id<HXBleManagerDelegate>  delegate;

+ (id)sharedInstance;
-(void)setAddressName:(NSString*)macDZ;
-(void)setMacName:(NSString*)macName;
//扫描Peripherals
- (void)scanPeripherals;
//连接Peripherals
- (void)connectToPeripheral:(CBPeripheral *)peripheral;
//断开设备连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;
//停止扫描
- (void)cancelScan;
//断开连接
-(void)closeConnected;
//获取当前连接的peripherals
- (NSArray *)findConnectedPeripherals;

//获取当前连接的peripheral
- (CBPeripheral *)findConnectedPeripheral:(NSString *)peripheralName;
//返回连接状态
-(BOOL)returnConnect;
////发送数据
-(void)sendDataToBLE:(NSData *)data;
/**
 sometimes ever，sometimes never.  相聚有时，后会无期
 
 this is center with peripheral's story
 **/
/*
//sometimes ever：添加断开重连接的设备
-  (void)sometimes_ever:(CBPeripheral *)peripheral ;
//sometimes never：删除需要重连接的设备
-  (void)sometimes_never:(CBPeripheral *)peripheral ;
*/
/**
 找到Peripherals的block |  when find peripheral
 */
- (void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;
@property (nonatomic, copy) void (^returnArrayList)(NSMutableArray *MuArray);
@end

NS_ASSUME_NONNULL_END
