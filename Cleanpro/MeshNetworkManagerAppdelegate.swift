//
//  MeshNetworkManagerAppdelegate.swift
//  Cleanpro
//
//  Created by mac on 2019/7/29.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Foundation
import os.log
//import

//import
@objc public class MeshNetworkManagerAppdelegate:NSObject{
    public var meshNetworkManager: MeshNetworkManager!
    @objc var connection: NetworkConnection!
    var newOnState:Bool = true
    weak var delegate1: BearerDelegate?
    weak var dataDelegate1: BearerDataDelegate?
    @objc var isConnected:Bool = false
    weak var MeshdataDelegate: MeshNetworkDelegate?
    var dataZong:Array<Any> = []
    var intAGG = 0
    
    private var newAddress: Address? = nil
    private var disableConfigCapabilities: Bool = false
    private var newName: String? = nil
    private var newTtl: UInt8? = nil
    private var newUnicastAddressRange: [AddressRange]? = nil
    private var newGroupAddressRange: [AddressRange]? = nil
    private var newSceneRange: [SceneRange]? = nil
    var adding = false
//    public override init() {
//
//    }
    
    @objc public func instanceMeshApp()->MeshNetworkManagerAppdelegate
    {
        self.setMesh()
        return self
    }
    
    @objc public func setMesh()
    {
        //////  北欧半导体的蓝牙模块初始化
        meshNetworkManager = MeshNetworkManager()
        self.delegate1 = self
        self.dataDelegate1 = self
        self.MeshdataDelegate = self
        meshNetworkManager.delegate = self;
        // Try loading the saved configuration.
        var loaded = false
        do {
            loaded = try meshNetworkManager.load()
        } catch {
            print(error)
            // ignore
        }
        
        // If load failed, create a new MeshNetwork.
        if !loaded {
            createNewMeshNetwork()
        } else {
            let meshNetwork = meshNetworkManager.meshNetwork!
            connection = NetworkConnection(to: meshNetwork)
            meshNetworkManager.delegate = self
            meshNetworkManager.logger = self
            connection!.dataDelegate = self
            connection.delegate = self;
            meshNetworkManager.transmitter = connection
            //            connection!.open()
        }
        
    }
    //    public func get_MeshNetworkManager() -> MeshNetworkManager {
    //        return meshNetworkManager
    //    }
    @objc public func isConnected_to()->Bool
    {
        return isConnected;
    }
    
    @objc public func AddConnected()
    {
        var loaded = false
        do {
            loaded = try meshNetworkManager.load()
        } catch {
            print(error)
            // ignore
        }
        dataZong = []
        // If load failed, create a new MeshNetwork.
        if !loaded {
            createNewMeshNetwork()
        } else {
            let meshNetwork = meshNetworkManager.meshNetwork!
            connection = NetworkConnection(to: meshNetwork)
            meshNetworkManager.delegate = self
            meshNetworkManager.logger = self
            connection!.dataDelegate = self
            connection.delegate = self;
            
            meshNetworkManager.transmitter = connection
            connection!.open()
        }
    }
    
    
    @objc public func closeConnected()
    {
        var loaded = false
        do {
            loaded = try meshNetworkManager.load()
        } catch {
            print(error)
            // ignore
        }
        
        // If load failed, create a new MeshNetwork.
        if !loaded {
            createNewMeshNetwork()
        } else {
            let meshNetwork = meshNetworkManager.meshNetwork!
            connection = NetworkConnection(to: meshNetwork)
//            connection!.dataDelegate = meshNetworkManager
            connection!.dataDelegate = self
            connection.delegate = self;
            meshNetworkManager.transmitter = connection
            connection!.close()
            self.isConnected = false
            print("退出 close")
            
        }
    }
    
    
    public func createNewMeshNetwork() {
        // TODO: Implement creator
        connection?.close()
        
        let provisioner = Provisioner(name: UIDevice.current.name,
                                      allocatedUnicastRange: [AddressRange(0x0001...0x199A)],
                                      allocatedGroupRange:   [AddressRange(0xC000...0xCC9A)],
                                      allocatedSceneRange:   [SceneRange(0x0001...0x3333)])
        _ = meshNetworkManager.createNewMeshNetwork(withName: "nRF Mesh Network", by: provisioner)
        _ = meshNetworkManager.save()
        
        let meshNetwork = meshNetworkManager.meshNetwork!
        connection = NetworkConnection(to: meshNetwork)
//        connection!.dataDelegate = meshNetworkManager
        connection!.dataDelegate = self
        connection.delegate = self;
        meshNetworkManager.transmitter = connection
        //    connection!.open()
    }
    
    //    @objc public var ReturnInstance() -> MeshNetworkManager
    //    {
    //        return meshNetworkManager
    //    }
    //    @objc public var ReturnBearer() -> NetworkConnection
    //    {
    //        return connection
    //    }
    
    @objc func dataSend(NameStr:String,dataA:Data)
    {
        //        print("进入发送ing")
        let network = meshNetworkManager.meshNetwork!
//        let localProvisioner = network.localProvisioner
//        var node:Node;
        for nodeQ:Node in network.nodes {
            if(nodeQ.name == NameStr)
            {
                let node:Node = nodeQ
//                let onoff : ZDYMessage = ZDYMessage.init().setpatloadZDY(newOnState: newOnState, dataA: dataA)
//                onoff.setSeq.incrementSequneceNumber()
//                print("A====== ",node.applicationKeys);
//                meshNetworkManager.send(onoff, to:node.unicastAddress , using: node.applicationKeys[0])
//                let onoff : MeshMessage = SendMessageCommand(parameters: dataA)!
                let onoff : GenericOnOffSet = GenericOnOffSet(parameters: dataA)!
                let meshaddressA = MeshAddress(node.unicastAddress)
                
                do {
                    if(self.dataZong.count == 2){
                        self.dataZong.removeAll()
                        self.intAGG = 0
                    }else
                    {
                        self.dataZong.append(dataA)
                    }
//                    print("数组===  ",(self.dataZong as AnyObject))
                    try meshNetworkManager.send(onoff, to: meshaddressA, using: node.applicationKeys[0])
                } catch {
                    print(error)
                    // ignore
                }
                
//                (onoff, to: node.unicastAddress, using: node.applicationKeys[0])
//                onoff.setSeq.SetSEQ0_Public()
            }
        }
//        let node:Node = network.nodes.filter({ $0.uuid != localProvisioner?.uuid })[0]
//        let onoff : ConfigGenericOnOffMessage = ConfigGenericOnOffMessage.init().setpatload(newOnState: newOnState)
//        onoff.setSeq.incrementSequneceNumber()
        newOnState = !newOnState
    }
    
    @objc func setImportMeshNetWork(DataJson:Data)
    {
        
       let Mbool = self.importNetwork_xiugai(DataJson: DataJson)
        if(Mbool==false)
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ImportError"), object:nil, userInfo:["data":"110"])
        }else
        {
            print("数据没有错误")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ImportError"), object:nil, userInfo:["data":"112"])
        }
    }
    
    /// 对安卓的json 文件修改。 然后使iOS可以使用
    func importNetwork_xiugai(DataJson:Data)-> Bool {
        ///屏蔽本地的
//        let path = Bundle.main.path(forResource: "Mesh7_29", ofType: "json")
//        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            
//            let data = try Data(contentsOf: url)
            guard var json_STR = try? JSON(data: DataJson) else {
                print("有错误")
                return false
            }
            var dic:Dictionary = json_STR.dictionary!
            ////第一层修改
            dic["groups"] = []
            dic["timestamp"] = "2019-07-17T06:26:14Z"
            //        print("字典1：",dic)
            ///provisioners 字段里面的修改
//
            guard var provisioners_ARR =  (dic["provisioners"]?.array) else {
                print("有错误")
                return false
            }
            let Count_S = provisioners_ARR.count
            let arrProvisioners = NSMutableArray.init()
            for I in 0...(Count_S-1)
            {
                var P_dicP_t = provisioners_ARR[I]
                var dict1 = P_dicP_t.dictionary
                dict1!["allocatedGroupRange"] = [["lowAddress": "C000","highAddress": "CC9A"]]
                dict1!["allocatedSceneRange"] = [["lastScene": "3333","firstScene": "0001"]]
//                dict1!["allocatedUnicastRange"] = [["lowAddress": "0001","highAddress": "199A"]]
                P_dicP_t.dictionaryObject = dict1!
                arrProvisioners.add(P_dicP_t)
            }
            for J in 0...(arrProvisioners.count-1)
            {
                provisioners_ARR[J] = arrProvisioners[J] as! JSON
            }
            dic["provisioners"]?.arrayObject = provisioners_ARR
            
            ////netKeys  字段修改
            var netKeys_ARR = (dic["netKeys"]?.array)!
            let Count_S11 = netKeys_ARR.count
            let arrnetKeys = NSMutableArray.init()
            for I in 0...(Count_S11-1)
            {
                var netKeys_dicP_t = netKeys_ARR[I]
                var dict1 = netKeys_dicP_t.dictionary
                dict1!["minSecurity"] = "high"
                dict1!["timestamp"] = "2019-07-18T02:17:49Z"
                netKeys_dicP_t.dictionaryObject = dict1!
                arrnetKeys.add(netKeys_dicP_t)
                
            }
            for J in 0...(arrProvisioners.count-1)
            {
                netKeys_ARR[J] = arrnetKeys[J] as! JSON
            }
            dic["netKeys"]?.arrayObject = netKeys_ARR
            
            ////nodes  字段修改
            var nodes_ARR = (dic["nodes"]?.array)!
            let Count_S22 = nodes_ARR.count
            let arrnodes = NSMutableArray.init()
            for I in 0...(Count_S22-1)
            {
                ///// 最外层的key键修改
                var nodes_dicP_t = nodes_ARR[I]
                var dict2 = nodes_dicP_t.dictionary
                let valueTTL = dict2!["ttl"]
                dict2!["ttl"] = nil
                dict2!["defaultTTL"] = valueTTL
                
                
                ////// nodes里面的 netKeys  value字段修改
                var netKeys_ARR = (dict2!["netKeys"]?.array)!
                let Count_S33 = netKeys_ARR.count
                let arrnetKeys = NSMutableArray.init()
                for I in 0...(Count_S33-1)
                {
                    var netKeys_dicP_t = netKeys_ARR[I]
                    var dict3 = netKeys_dicP_t.dictionary
                    dict3!["updated"] = false
                    netKeys_dicP_t.dictionaryObject = dict3!
                    arrnetKeys.add(netKeys_dicP_t)
                }
                for J in 0...(arrnetKeys.count-1)
                {
                    netKeys_ARR[J] = arrnetKeys[J] as! JSON
                }
                dict2!["netKeys"]?.arrayObject = netKeys_ARR
                
                
                ////// nodes里面的 appKeys value字段修改
                var appKeys_ARR = (dict2!["appKeys"]?.array)!
                let Count_S44 = appKeys_ARR.count
                let ArrappKeys = NSMutableArray.init()
                for I in 0...(Count_S44-1)
                {
                    var appKeys_dicP_t = appKeys_ARR[I]
                    var dict4 = appKeys_dicP_t.dictionary
                    dict4!["index"] = 0
                    dict4!["updated"] = false
                    appKeys_dicP_t.dictionaryObject = dict4!
                    ArrappKeys.add(appKeys_dicP_t)
                }
                for J in 0...(ArrappKeys.count-1)
                {
                    appKeys_ARR[J] = ArrappKeys[J] as! JSON
                }
                dict2!["appKeys"]?.arrayObject = appKeys_ARR
                
                ////// elements里面的 appKeys value字段修改
                var elements_ARR = (dict2!["elements"]?.array)!
                let Count_S55 = elements_ARR.count
                let Arrelements = NSMutableArray.init()
                for I in 0...(Count_S55-1)
                {
                    var elements_dicP_t = elements_ARR[I]
                    var dict5 = elements_dicP_t.dictionary
                    /////
                    var models_ARR = (dict5!["models"]?.array)!
                    let Count_S66 = models_ARR.count
                    var arrmodes:[JSON] = []
                    for I in 0...(Count_S66-1)
                    {
                        var models_dicP_t = models_ARR[I]
                        var dict6 = models_dicP_t.dictionary
                        dict6!["bind"] = []
                        dict6!["subscribe"] = []
                        models_dicP_t.dictionaryObject = dict6!
                        arrmodes.append(models_dicP_t)
                    }
                    for J in 0...(arrmodes.count-1)
                    {
                        models_ARR[J] = arrmodes[J]
                    }
                    dict5!["models"]?.arrayObject = models_ARR
                    elements_dicP_t.dictionaryObject = dict5
                    Arrelements.add(elements_dicP_t)
                }
                //                elements 数组里面的赋值
                for J in 0...(Arrelements.count-1)
                {
                    elements_ARR[J] = Arrelements[J] as! JSON
                }
                dict2!["elements"]?.arrayObject = elements_ARR
                
                ///// 最外层赋值
                nodes_dicP_t.dictionaryObject = dict2!
                arrnodes.add(nodes_dicP_t)
            }
            ////周一修改一次
            let dictStr:Dictionary = ["deviceKey":"F7C58A46CC626BC1CE83245270C8EDD4","features":["proxy":2,"friend":2,"relay":2,"lowPower":2],"unicastAddress":"0001","configComplete":true,"netKeys":[["index":0,"updated":false]],"defaultTTL":5,"cid":"004C","appKeys":[],"blacklisted":false,"UUID":UUID().uuidString,"security":"high","name":UIDevice.current.name,"elements":[["models":[["modelId":"0000","subscribe":[],"bind":[]],["modelId":"0001","subscribe":[],"bind":[]],["modelId":"0002","subscribe":[],"bind":[]]],"name":"Primary Element","location":"0000","index":0]]] as [String : Any];
            //    print("node[0]==== ",dictStr)
            for J in 0...(arrnodes.count-1)
            {
                nodes_ARR[J] = arrnodes[J] as! JSON
            }
            let datajs = try! JSONSerialization.data(withJSONObject: dictStr, options: .prettyPrinted)

            let jsStr = try JSON(data: datajs)
            nodes_ARR.append(jsStr)
            /////最后再赋值
            dic["nodes"]?.arrayObject = nodes_ARR

            //         print("字典3：",dic)
            json_STR.dictionaryObject = dic
            
            print("字典4：",json_STR)
            let dataManager = try! json_STR.rawData()
            let manager = meshNetworkManager
            do {
                
                try manager!.import(from: dataManager)
                //    创建单播地址
                //    let provisioner = Provisioner(name: UIDevice.current.name,allocatedUnicastRange: [AddressRange(0x0001...0x199A)],allocatedGroupRange:   [AddressRange(0xC000...0xCC9A)],allocatedSceneRange:   [SceneRange(0x0001...0x3333)])
                //    if((manager.meshNetwork?.isLocalProvisioner(provisioner))!)
                //    {
                //        print("已经存在 ")
                //    }else
                //    {
                //        try? manager.meshNetwork?.add(provisioner:provisioner )
                ////        let address :Address = Address("0006", radix: 16)!
                ////        try? manager.meshNetwork?.add(provisioner: provisioner, withAddress: address)
                ////        let sb = UIStoryboard(name: "Settings", bundle: nil)
                ////        let editpro = sb.instantiateViewController(withIdentifier: "EditProvisionerViewController") as! EditProvisionerViewController
                ////        self.navigationController!.pushViewController(vc, animated: true)
                ////      let editpro =  EditProvisionerViewController.init()
                ////        editpro.setAddressSave()
                ////        try? manager.meshNetwork?.assign(unicastAddress: address, for: provisioner)
                //
                //
                //    }
                let savebool = manager!.save()
                if(savebool)
                {
                    print("保存成功")
                }else
                {
                    print("保存失败")
                }
                let meshNetwork = meshNetworkManager.meshNetwork!
                let ProvisionerMMM = meshNetwork.provisioners[0];
                ProvisionerMMM.meshNetwork = nil
                _ = meshNetwork.remove(provisionerAt: 0)
                if !meshNetworkManager.save() {
                    print("Mesh configuration could not be saved.1112")
                }
                addProvisioner(provisioner: ProvisionerMMM, meshNetworkA: meshNetwork)
                self.AddConnected()

//
                /*
                _ = meshNetwork.remove(provisionerAt: 0)
                if !meshNetworkManager.save() {
                    print("Mesh configuration could not be saved.1112")
                }
                let provisionerA : provisionOBJECT = provisionOBJECT.init()
                let boolP = provisionerA.setAddressSave()
                if(boolP)
                {
                    print("provisioner  保存成功")

                        self.AddConnected()

                }else
                {
                    print("provisioner  保存失败")
                }
                */
            } catch {
                //            self.presentAlert(title: "Error", message: "Importing Mesh Network configuration failed.\nCheck if the file is valid.")
                print("Import failed: \(error)")
                return false
            }
            
        } catch let error as Error? {
            
            print("读取本地数据出现错误!",error as Any)
            return false
        }
        return true
    }
    // JSONString转换为字典
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    
    func addProvisioner (provisioner: Provisioner, meshNetworkA:MeshNetwork){
         do {
//        let address = Address("0008", radix: 16)
//        self.disableConfigCapabilities = false
//        self.newAddress = address
        adding = true
        if adding {
            // Allocate new ranges, had they changed.
            try allocateNewRanges(to: provisioner)
            // And try adding the new Provisioner. This may throw number of errors.
            try meshNetworkA.add(provisioner: provisioner, withAddress: Address.maxUnicastAddress)
//            try meshNetworkA.add(provisioner: provisioner)
        } else {
            
        }
        // When we reached that far, changing the name and TTL is just a formality.
        if let newName = newName {
            provisioner.provisionerName = newName
        }
        if let newTtl = newTtl {
            provisioner.node?.defaultTTL = newTtl
        }
            
            let savebool = self.meshNetworkManager.save()
            if(savebool)
            {
                let provisionerSD = self.meshNetworkManager.meshNetwork?.provisioners[0]
                print("UUID ====   ",provisionerSD?.uuid.uuidString as Any)
                print("Provisioner1 保存成功")
            }else
            {
                print("Provisioner1 保存失败")
            }
        } catch {
            
             switch error as! MeshModelError {
             case .nodeAlreadyExist:
             // A node with the same UUID as the Provisioner has been found.
             // This is very unlikely to happen, as UUIDs are randomly generated.
             // The solution is to go cancel and add another Provisioner, which
             // will have another randomly generated UUID.
             print("A node for this Provisioner already exists.")
             case .overlappingProvisionerRanges:
             print("Provisioner's ranges overlap with another Provisioner.")
             case .invalidRange:
             print("At least one of specified ranges is invalid.")
             case .addressNotInAllocatedRange:
             print("The Provisioner's unicast address is outside of its allocated range.")
             case .addressNotAvailable:
             print("The address is already in use.")
             default:
             print("An error occurred.")
             }
            
        }
    }
    func allocateNewRanges(to provisioner: Provisioner) throws {
        if let newUnicastAddressRange = newUnicastAddressRange {
            provisioner.deallocateUnicastAddressRange(AddressRange.allUnicastAddresses)
            try provisioner.allocateUnicastAddressRanges(newUnicastAddressRange)
        }
        if let newGroupAddressRange = newGroupAddressRange {
            provisioner.deallocateGroupAddressRange(AddressRange.allGroupAddresses)
            try provisioner.allocateGroupAddressRanges(newGroupAddressRange)
        }
        if let newSceneRange = newSceneRange {
            provisioner.deallocateSceneRange(SceneRange.allScenes)
            try provisioner.allocateSceneRanges(newSceneRange)
        }
    }
    
}
extension MeshNetworkManagerAppdelegate:GattBearerDelegate,BearerDataDelegate,MeshNetworkDelegate,LoggerDelegate
{
    public func meshNetworkManager(_ manager: MeshNetworkManager, didReceiveMessage message: MeshMessage, sentFrom source: Address, to destination: Address) {
        print("didReceiveMessage 接收到ble信息")
    }
    
    public func meshNetworkManager(_ manager: MeshNetworkManager,
                            didSendMessage message: MeshMessage,
                            from localElement: Element, to destination: Address){
        let onoff : GenericOnOffSet = message as! GenericOnOffSet
        print("didSendMessage接收到发出的命令 = ",onoff.parameters?.hex as Any)
        for dataAA in self.dataZong
        {
            let dataL : Data = dataAA as! Data
//            dataL.i
            let bl1:String = dataL.hex
            let bl2:String = onoff.parameters!.hex
//            let newStr :String = String(data: dataL, encoding: String.Encoding.utf8)!
//            let newStr1 :String = String(data: onoff.parameters!, encoding: String.Encoding.utf8)!
//            print("data 对比= ",newStr,newStr1)
            if(bl1 == bl2)
            {
                
                self.intAGG += 1
                if(self.intAGG == self.dataZong.count)
                {
                    print("对比成功")
                    print("接受 Data  ====",onoff.parameters?.hex as Any);
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"NotificationRead"), object:nil, userInfo:nil)
                }
            }
        }
    }
    public func meshNetworkManager(_ manager: MeshNetworkManager,
                            failedToSendMessage message: MeshMessage,
                            from localElement: Element, to destination: Address,
                            error: Error)
    {
        print("未发送成功通知 error = ",error)
        /*
        let onoff : GenericOnOffSet = message as! GenericOnOffSet
        print("未发送成功通知 = ",onoff.parameters?.hex as Any)
        for dataAA in self.dataZong
        {
            let dataL : Data = dataAA as! Data
            //            dataL.i
            let bl1:String = dataL.hex
            let bl2:String = onoff.parameters!.hex
            //            let newStr :String = String(data: dataL, encoding: String.Encoding.utf8)!
            //            let newStr1 :String = String(data: onoff.parameters!, encoding: String.Encoding.utf8)!
            //            print("data 对比= ",newStr,newStr1)
            if(bl1 == bl2)
            {
                print("对比成功")
                self.intAGG += 1
                if(self.intAGG == self.dataZong.count)
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"NotificationRead"), object:nil, userInfo:nil)
                    self.intAGG=0;
                }
            }
        }
 */
    }
    public func bearerDidConnect(_ bearer: Bearer)
    {
        
//        print("正在连接蓝牙11")
        isConnected = false;
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"bearerDidConnect"), object:nil, userInfo:["bearer":bearer])
        
    }
    public func bearer(_ bearer: Bearer, didClose error: Error?) {
        print("蓝牙连接关闭11")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"bearerClose"), object:nil, userInfo:["bearer":bearer])
        isConnected = false;
    }
    
    public func bearer(_ bearer: Bearer, didDeliverData data: Data, ofType type: PduType) {
//            print("接收到数据  准备解析")
//        meshNetworkManager.bearerDidDeliverData(data, ofType: type)
        meshNetworkManager.bearerDidDeliverData(data, ofType: type)
//        print("PduType = %d,  data========== ",type,data);
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"bearerDeliverData"), object:nil, userInfo:["bearer":bearer,"data":data])
        
        }
    public func meshNetwork(_ meshNetwork: MeshNetwork, didDeliverMessage message: MeshMessage, from source: Address)
    {
        print("meshNetwork.message ====  ",message)
        
    }
    public func bearerDidOpen(_ bearer: Bearer) {
        
        print("蓝牙连接成功11 开启通知")
        isConnected = true;
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"bearerDidOpen"), object:nil, userInfo:["bearer":bearer])
    }
    
    public func log(message: String, ofCategory category: LogCategory, withLevel level: LogLevel) {
        if #available(iOS 10.0, *) {
          os_log("Log===  %{public}@", log: category.log, type: level.type, message)
        } else {
            NSLog("%@", message)
        }
    }
    
}

extension LogLevel {
    
    /// Mapping from mesh log levels to system log types.
    var type: OSLogType {
        switch self {
        case .debug:       return .debug
        case .verbose:     return .debug
        case .info:        return .info
        case .application: return .default
        case .warning:     return .error
        case .error:       return .fault
        }
    }
    
}

extension LogCategory {
    
    var log: OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier!, category: rawValue)
    }
    
}
