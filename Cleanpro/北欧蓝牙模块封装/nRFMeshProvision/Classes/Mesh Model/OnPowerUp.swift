//
//  OnPowerUp.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 23/08/2019.
//

import Foundation

public enum OnPowerUp: UInt8 {
    case off       = 0x00
    case `default` = 0x01
    case restore   = 0x02
}

extension OnPowerUp: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
        case .off:     return "Off"
        case .default: return "Default"
        case .restore: return "Restore"
        }
    }
    
}
