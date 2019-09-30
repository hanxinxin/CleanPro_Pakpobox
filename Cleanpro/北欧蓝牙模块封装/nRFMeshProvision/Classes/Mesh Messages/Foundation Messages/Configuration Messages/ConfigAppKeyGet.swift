//
//  ConfigAppKeyGet.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 27/06/2019.
//

import Foundation

public struct ConfigAppKeyGet: AcknowledgedConfigMessage, ConfigNetKeyMessage {
    public static let opCode: UInt32 = 0x8001
    public static let responseType: StaticMeshMessage.Type = ConfigAppKeyList.self
    
    public var parameters: Data? {
        return encodeNetKeyIndex()
    }
    
    public let networkKeyIndex: KeyIndex
    
    public init(networkKey: NetworkKey) {
        self.networkKeyIndex = networkKey.index
    }
    
    public init?(parameters: Data) {
        guard parameters.count == 2 else {
            return nil
        }
        networkKeyIndex = ConfigAppKeyGet.decodeNetKeyIndex(from: parameters, at: 0)
    }
}
