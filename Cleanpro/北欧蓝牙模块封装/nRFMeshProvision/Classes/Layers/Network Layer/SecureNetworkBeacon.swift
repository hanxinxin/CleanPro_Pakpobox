//
//  SecureNetworkBeacon.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 01/06/2019.
//

import Foundation

internal struct SecureNetworkBeacon: BeaconPdu {
    let pdu: Data
    let beaconType: BeaconType = .secureNetwork
    
    /// The Network Key related to this Secure Network Beacon.
    let networkKey: NetworkKey
    /// Key Refresh flag value.
    ///
    /// When this flag is active, the Node shall set the Key Refresh
    /// Phase for this Network Key to `.finalizing`. When in this phase,
    /// the Node shall only transmit messages and Secure Network beacons
    /// using the new keys, shall receive messages using the old keys
    /// and the new keys, and shall only receive Secure Network beacons
    /// secured using the new Network Key.
    let keyRefreshFlag: Bool
    /// This flag is set to `true` if IV Update procedure is active.
    let ivUpdateActive: Bool
    /// Contains the value of the Network ID.
    let networkId: Data
    /// Contains the current IV Index.
    let ivIndex: UInt32
    
    /// Creates USecure Network beacon PDU object from received PDU.
    ///
    /// - parameter pdu: The data received from mesh network.
    /// - parameter networkKey: The Network Key to validate the beacon.
    /// - returns: The beacon object, or `nil` if the data are invalid.
    init?(decode pdu: Data, usingNetworkKey networkKey: NetworkKey) {
        self.pdu = pdu
        guard pdu.count == 22, pdu[0] == 1 else {
            return nil
        }
        keyRefreshFlag = pdu[1] & 0x01 != 0
        ivUpdateActive = pdu[1] & 0x02 != 0
        networkId = pdu.subdata(in: 2..<10)
        ivIndex = CFSwapInt32BigToHost(pdu.read(fromOffset: 10))
        
        // Authenticate beacon using given Network Key.
        let helper = OpenSSLHelper()
        if networkId == networkKey.networkId {
            let authenticationValue = helper.calculateCMAC(pdu.subdata(in: 1..<14), andKey: networkKey.keys.beaconKey)!
            guard authenticationValue.subdata(in: 0..<8) == pdu.subdata(in: 14..<22) else {
                return nil
            }
            self.networkKey = networkKey
        } else if let oldNetworkId = networkKey.oldNetworkId, networkId == oldNetworkId {
            let authenticationValue = helper.calculateCMAC(pdu.subdata(in: 1..<14), andKey: networkKey.oldKeys!.beaconKey)!
            guard authenticationValue.subdata(in: 0..<8) == pdu.subdata(in: 14..<22) else {
                return nil
            }
            self.networkKey = networkKey
        } else {
            return nil
        }
    }
}

internal extension SecureNetworkBeacon {
    
    /// This method goes over all Network Keys in the mesh network and tries
    /// to parse the beacon.
    ///
    /// - parameter pdu:         The received PDU.
    /// - parameter meshNetwork: The mesh network for which the PDU should be decoded.
    /// - returns: The beacon object.
    static func decode(_ pdu: Data, for meshNetwork: MeshNetwork) -> SecureNetworkBeacon? {
        guard pdu.count > 1 else {
            return nil
        }
        let beaconType = BeaconType(rawValue: pdu[0])
        switch beaconType {
        case .some(.secureNetwork):
            for networkKey in meshNetwork.networkKeys {
                if let beacon = SecureNetworkBeacon(decode: pdu, usingNetworkKey: networkKey) {
                    return beacon
                }
            }
            return nil
        default:
            return nil
        }
    }
    
}

extension SecureNetworkBeacon: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "Secure Network Beacon (Network ID: \(networkId.hex), IV Index: \(ivIndex), Key Refresh Flag: \(keyRefreshFlag), IV Update active: \(ivUpdateActive))"
    }
    
}
