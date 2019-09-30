//
//  ConfigModelPublicationVirtualAddressSet.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 04/07/2019.
//

import Foundation
import CoreBluetooth

public struct ConfigModelPublicationVirtualAddressSet: AcknowledgedConfigMessage, ConfigAnyModelMessage {
    public static let opCode: UInt32 = 0x801A
    public static let responseType: StaticMeshMessage.Type = ConfigModelPublicationStatus.self
    
    public var parameters: Data? {
        var data = Data() + elementAddress + publish.publicationAddress.virtualLabel!.data
        data += UInt8(publish.index & 0xFF)
        data += UInt8(publish.index >> 8) | UInt8(publish.credentials << 4)
        data += publish.ttl
        data += (publish.periodSteps & 0x3F) | (publish.periodResolution.rawValue << 6)
        data += (publish.retransmit.count & 0x07) | (publish.retransmit.steps << 3)
        if let companyIdentifier = companyIdentifier {
            return data + companyIdentifier + modelIdentifier
        } else {
            return data + modelIdentifier
        }
    }
    
    public let elementAddress: Address
    public let modelIdentifier: UInt16
    public let companyIdentifier: UInt16?
    /// Publication data.
    public let publish: Publish
    
    public init?(_ publish: Publish, to model: Model) {
        guard publish.publicationAddress.address.isVirtual else {
            // ConfigModelPublicationSet should be used instead.
            return nil
        }
        self.publish = publish
        self.elementAddress = model.parentElement.unicastAddress
        self.modelIdentifier = model.modelIdentifier
        self.companyIdentifier = model.companyIdentifier
    }
    
    public init?(parameters: Data) {
        guard parameters.count == 25 || parameters.count == 27 else {
            return nil
        }
        self.elementAddress = parameters.read(fromOffset: 0)
        
        let label = CBUUID(data: parameters.dropFirst(2).prefix(16)).uuid
        let index: KeyIndex = parameters.read(fromOffset: 18) & 0x0FFF
        let flag = Int((parameters[19] & 0x10) >> 4)
        let ttl = parameters[20]
        let periodSteps = parameters[21] & 0x3F
        let periodResolution = StepResolution(rawValue: parameters[21] >> 6)!
        let count = parameters[22] & 0x07
        let interval = parameters[22] >> 3
        let retransmit = Publish.Retransmit(publishRetransmitCount: count, intervalSteps: interval)
        
        self.publish = Publish(to: label.hex, withKeyIndex: index,
                               friendshipCredentialsFlag: flag, ttl: ttl,
                               periodSteps: periodSteps, periodResolution: periodResolution,
                               retransmit: retransmit)
        if parameters.count == 27 {
            self.companyIdentifier = parameters.read(fromOffset: 23)
            self.modelIdentifier = parameters.read(fromOffset: 25)
        } else {
            self.companyIdentifier = nil
            self.modelIdentifier = parameters.read(fromOffset: 23)
        }
    }
}

