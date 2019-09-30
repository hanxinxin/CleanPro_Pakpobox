//
//  ConfigModelAppUnbind.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 02/07/2019.
//

import Foundation

public struct ConfigModelAppUnbind: AcknowledgedConfigMessage, ConfigAppKeyMessage, ConfigAnyModelMessage {
    public static let opCode: UInt32 = 0x803F
    public static let responseType: StaticMeshMessage.Type = ConfigModelAppStatus.self
    
    public var parameters: Data? {
        let data = Data() + elementAddress + applicationKeyIndex
        if let companyIdentifier = companyIdentifier {
            return data + companyIdentifier + modelIdentifier
        } else {
            return data + modelIdentifier
        }
    }
    
    public let applicationKeyIndex: KeyIndex
    public let elementAddress: Address
    public let modelIdentifier: UInt16
    public let companyIdentifier: UInt16?
    
    public init(applicationKey: ApplicationKey, to model: Model) {
        self.applicationKeyIndex = applicationKey.index
        self.elementAddress = model.parentElement.unicastAddress
        self.modelIdentifier = model.modelIdentifier
        self.companyIdentifier = model.companyIdentifier
    }
    
    public init?(parameters: Data) {
        guard parameters.count == 6 || parameters.count == 8 else {
            return nil
        }
        elementAddress = parameters.read(fromOffset: 0)
        applicationKeyIndex = parameters.read(fromOffset: 2)
        if parameters.count == 8 {
            companyIdentifier = parameters.read(fromOffset: 4)
            modelIdentifier = parameters.read(fromOffset: 6)
        } else {
            companyIdentifier = nil
            modelIdentifier = parameters.read(fromOffset: 4)
        }
    }  
}
