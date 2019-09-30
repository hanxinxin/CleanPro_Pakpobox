//
//  GenericOnPowerUpSet.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 23/08/2019.
//

import Foundation

public struct GenericOnPowerUpSet: AcknowledgedGenericMessage {
    public static let opCode: UInt32 = 0x8213
    public static let responseType: StaticMeshMessage.Type = GenericOnPowerUpStatus.self
    
    public var parameters: Data? {
        return Data([state.rawValue])
    }
    
    /// The value of the Generic OnPowerUp state.
    public let state: OnPowerUp
    
    /// Creates the Generic On Power Up Set message.
    ///
    /// - parameter transitionTime: The value of the Generic OnPowerUp state.
    public init(state: OnPowerUp) {
        self.state = state
    }
    
    public init?(parameters: Data) {
        guard parameters.count == 1 else {
            return nil
        }
        guard let state = OnPowerUp(rawValue: parameters[0]) else {
            return nil
        }
        self.state = state
    }
    
}
