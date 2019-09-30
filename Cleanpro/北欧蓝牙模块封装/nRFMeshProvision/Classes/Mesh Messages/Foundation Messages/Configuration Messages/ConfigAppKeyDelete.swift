//
//  ConfigAppKeyDelete.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 27/06/2019.
//

import Foundation

public struct ConfigAppKeyDelete: AcknowledgedConfigMessage, ConfigNetAndAppKeyMessage {
    public static let opCode: UInt32 = 0x8000
    public static let responseType: StaticMeshMessage.Type = ConfigAppKeyStatus.self
    
    public var parameters: Data? {
        return encodeNetAndAppKeyIndex()
    }
    
    public let networkKeyIndex: KeyIndex
    public let applicationKeyIndex: KeyIndex
    
    public init(applicationKey: ApplicationKey) {
        self.applicationKeyIndex = applicationKey.index
        self.networkKeyIndex = applicationKey.boundNetworkKey.index
    }
    
    public init?(parameters: Data) {
        guard parameters.count == 3 else {
            return nil
        }
        (networkKeyIndex, applicationKeyIndex) = ConfigAppKeyAdd.decodeNetAndAppKeyIndex(from: parameters, at: 0)
    }
    
}
