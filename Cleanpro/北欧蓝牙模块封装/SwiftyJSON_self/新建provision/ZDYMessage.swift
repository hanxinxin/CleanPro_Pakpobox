//
//  ZDYMessage.swift
//  Cleanpro
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Foundation
//import nRFMeshProvision


public struct ZDYMessage{
    static var opCode: UInt32 = 0x8202
    var setSeq : SequenceNumber = SequenceNumber.init()
    //    public var opcode : Data = Data([])
    //    public var newOnState = false
    public var payload : Data!
    public var parameters: Data? {
        return payload
    }
    public init(withTargetState aTargetState: Data, transitionTime aTransitionTime: Data, andTransitionDelay aTransitionDelay: Data) {
        
        payload = aTargetState
        //Sequence number used as TID
        print("tid.str === ",[SequenceNumber().sequenceData().last!])
        let tid = Data([SequenceNumber().sequenceData().last!])
        print("tid === ",String(data: tid, encoding: .utf8) as Any)
        payload.append(tid)
        payload.append(aTransitionTime)
        payload.append(aTransitionDelay)
        //        return self
    }
    
    public var isSegmented: Bool {
        return false
    }
    public func setpatload(newOnState:Bool) -> ZDYMessage
    {
//        payload = newOnState ? Data([0x01]) : Data([0x00])
//        let tid = Data([SequenceNumber().sequenceData().last!])
//        payload.append(tid)
        
        return self
    }
    public mutating func setpatloadZDY(newOnState:Bool,dataA:Data) -> ZDYMessage
    {
//        payload = newOnState ? Data([0x07]) : dataA  ///后续会修改
        payload = dataA  ///暂时修改为  赋值为传入的值
//        let tid = Data([SequenceNumber().sequenceData().last!])
//        payload.append(tid)
        
        return self
    }
    public init() {
        // Empty
    }
    
//    required public init?(parameters: Data) {
//        guard parameters.isEmpty else {
//            return nil
//        }
//    }
    public func sequenceData() -> Data {
        return convertToData(aNumber: 0)
    }
    private func convertToData(aNumber: UInt32) -> Data {
        let octet1 = UInt8((aNumber & 0x00FF0000) >> 16)
        let octet2 = UInt8((aNumber & 0x0000FF00) >> 8)
        let octet3 = UInt8(aNumber & 0x000000FF)
        return Data([octet1, octet2, octet3])
    }
    
}


/*
 /// 对安卓的json 文件修改。 然后使iOS可以使用
 func importNetwork_xiugai(DataJson:Data) {
 let path = Bundle.main.path(forResource: "android_mesh1122", ofType: "json")
 let url = URL(fileURLWithPath: path!)
 // 带throws的方法需要抛异常
 do {
 /*
 * try 和 try! 的区别
 * try 发生异常会跳到catch代码中
 * try! 发生异常程序会直接crash
 */
 
 let data = try Data(contentsOf: url)
 var json_STR = try! JSON(data: data)
 var dic:Dictionary = json_STR.dictionary!
 ////第一层修改
 dic["groups"] = []
 dic["timestamp"] = "2019-07-17T06:26:14Z"
 //        print("字典1：",dic)
 ///provisioners 字段里面的修改
 var provisioners_ARR = (dic["provisioners"]?.array)!
 let Count_S = provisioners_ARR.count
 let arrProvisioners = NSMutableArray.init()
 for I in 0...(Count_S-1)
 {
 var P_dicP_t = provisioners_ARR[I]
 var dict1 = P_dicP_t.dictionary
 dict1!["allocatedGroupRange"] = [["lowAddress": "C000","highAddress": "CC9A"]]
 dict1!["allocatedSceneRange"] = [["lastScene": "3333","firstScene": "0001"]]
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
 for J in 0...(arrnodes.count-1)
 {
 nodes_ARR[J] = arrnodes[J] as! JSON
 }
 /////最后再赋值
 dic["nodes"]?.arrayObject = nodes_ARR
 
 //        print("字典3：",dic)
 json_STR.dictionaryObject = dic
 
 //        print("字典4：",json_STR)
 let dataManager = try! json_STR.rawData()
 let manager = MeshNetworkManager.instance
 do {
 
 try manager.import(from: dataManager)
 
 //            self.presentAlert(title: "Success", message: "Mesh Network configuration imported.")
 } catch {
 //            self.presentAlert(title: "Error", message: "Importing Mesh Network configuration failed.\nCheck if the file is valid.")
 print("Import failed: \(error)")
 }
 
 } catch let error as Error? {
 print("读取本地数据出现错误!",error as Any)
 }
 }
 */
