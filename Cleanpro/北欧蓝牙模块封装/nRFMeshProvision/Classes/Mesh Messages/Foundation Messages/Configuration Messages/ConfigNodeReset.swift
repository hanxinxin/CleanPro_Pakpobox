//
//  ConfigNodeReset.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 19/06/2019.
//

import Foundation

public struct ConfigNodeReset: AcknowledgedConfigMessage {
    public static let opCode: UInt32 = 0x8049
    public static let responseType: StaticMeshMessage.Type = ConfigNodeResetStatus.self
    
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
