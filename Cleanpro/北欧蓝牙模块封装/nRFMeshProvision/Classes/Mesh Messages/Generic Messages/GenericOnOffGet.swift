//
//  GenericOnOffGet.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 21/08/2019.
//

import Foundation

public struct GenericOnOffGet: AcknowledgedGenericMessage {
    public static let opCode: UInt32 = 0x8201
    public static let responseType: StaticMeshMessage.Type = GenericOnOffStatus.self
    
    public var parameters: Data? {
        return nil
    }
    
    public init() {
        // Empty
    }
    
    public init?(parameters: Data) {
        guard parameters.isEmpty else {
            return nil
        }
    }
    
}
