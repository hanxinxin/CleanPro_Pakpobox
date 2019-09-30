//
//  NetworkPdu.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 27/05/2019.
//

import Foundation

internal struct NetworkPdu {
    /// Raw PDU data.
    let pdu: Data
    /// The Network Key used to decode/encode the PDU.
    let networkKey: NetworkKey
    
    /// Least significant bit of IV Index.
    let ivi: UInt8
    /// Value derived from the NetKey used to identify the Encryption Key
    /// and Privacy Key used to secure this PDU.
    let nid: UInt8
    /// PDU type.
    let type: LowerTransportPduType
    /// Time To Live.
    let ttl: UInt8
    /// Sequence Number.
    let sequence: UInt32
    /// Source Address.
    let source: Address
    /// Destination Address.
    let destination: Address
    /// Transport Protocol Data Unit. It is guaranteed to have 1 to 16 bytes.
    let transportPdu: Data
    
    /// Creates Network PDU object from received PDU. The initiator tries
    /// to deobfuscate and decrypt the data using given Network Key and IV Index.
    ///
    /// - parameter pdu:        The data received from mesh network.
    /// - parameter pduType:    The type of the PDU: `.networkPdu` of `.proxyConfiguration`.
    /// - parameter networkKey: The Network Key to decrypt the PDU.
    /// - returns: The deobfuscated and decided Network PDU object, or `nil`,
    ///            if the key or IV Index don't match.
    init?(decode pdu: Data, ofType pduType: PduType, usingNetworkKey networkKey: NetworkKey) {
        guard pduType == .networkPdu || pduType == .proxyConfiguration else {
            return nil
        }
        self.pdu = pdu
        
        // Valid message must have at least 14 octets.
        guard pdu.count >= 14 else {
            return nil
        }
        
        // The first byte is not obfuscated.
        self.ivi  = pdu[0] >> 7
        self.nid  = pdu[0] & 0x7F
        
        // The NID must match.
        // If the Key Refresh procedure is in place, the received packet might have been
        // encrypted using an old key. We have to try both.
        var keySets: [NetworkKeyDerivaties] = []
        if nid == networkKey.nid {
            keySets.append(networkKey.keys)
        }
        if let oldNid = networkKey.oldNid, nid == oldNid {
            keySets.append(networkKey.oldKeys!)
        }
        guard !keySets.isEmpty else {
            return nil
        }
        
        // IVI should match the LSB bit of current IV Index.
        // If it doesn't, and the IV Update procedure is active, the PDU will be
        // deobfuscated and decoded with IV Index decremented by 1.
        var index = networkKey.ivIndex.index
        if ivi != index & 0x1 {
            if networkKey.ivIndex.updateActive && index > 1 {
                index -= 1
            } else {
                return nil
            }
        }
        
        let helper = OpenSSLHelper()
        for keys in keySets {
            // Deobfuscate CTL, TTL, SEQ and SRC.
            let deobfuscatedData = helper.deobfuscate(pdu, ivIndex: index, privacyKey: keys.privacyKey)!
            
            // First validation: Control Messages have NetMIC of size 64 bits.
            let ctl = deobfuscatedData[0] >> 7
            guard ctl == 0 || pdu.count >= 18 else {
                continue
            }
            
            let type = LowerTransportPduType(rawValue: ctl)!
            let ttl  = deobfuscatedData[0] & 0x7F
            // Multiple octet values use Big Endian.
            let sequence = UInt32(deobfuscatedData[1]) << 16 | UInt32(deobfuscatedData[2]) << 8 | UInt32(deobfuscatedData[3])
            let source   = Address(deobfuscatedData[4]) << 8 | Address(deobfuscatedData[5])
            
            let micOffset = pdu.count - Int(type.netMicSize)
            let destAndTransportPdu = pdu.subdata(in: 7..<micOffset)
            let mic = pdu.subdata(in: micOffset..<pdu.count)
            
            var nonce = Data([pduType.nonceId]) + deobfuscatedData + Data([0x00, 0x00]) + index.bigEndian
            if case .proxyConfiguration = pduType {
                nonce[1] = 0x00 // Pad
            }
            guard let decryptedData = helper.calculateDecryptedCCM(destAndTransportPdu,
                                                                   withKey: keys.encryptionKey,
                                                                   nonce: nonce, andMIC: mic,
                                                                   withAdditionalData: nil) else { continue }
            
            self.networkKey = networkKey
            self.type = type
            self.ttl = ttl
            self.sequence = sequence
            self.source = source
            self.destination = Address(decryptedData[0]) << 8 | Address(decryptedData[1])
            self.transportPdu = decryptedData.subdata(in: 2..<decryptedData.count)
            return
        }
        return nil
    }
    
    /// Creates the Network PDU. This method enctypts and obfuscates data
    /// that are to be send to the mesh network.
    ///
    /// - parameter lowerTransportPdu: The data received from higher layer.
    /// - parameter pduType:  The type of the PDU: `.networkPdu` of `.proxyConfiguration`.
    /// - parameter sequence: The SEQ number of the PDU. Each PDU between the source
    ///                       and destination must have strictly increasing sequence number.
    /// - parameter ttl: Time To Live.
    /// - returns: The Network PDU object.
    init(encode lowerTransportPdu: LowerTransportPdu, ofType pduType: PduType,
         withSequence sequence: UInt32, andTtl ttl: UInt8) {
        guard pduType == .networkPdu || pduType == .proxyConfiguration else {
            fatalError("Only .networkPdu and .configurationPdu may be encoded into a NetworkPdu")
        }
        let index = lowerTransportPdu.networkKey.ivIndex.index
        
        self.networkKey = lowerTransportPdu.networkKey
        self.ivi = UInt8(index & 0x1)
        self.nid = networkKey.nid
        self.type = lowerTransportPdu.type
        self.source = lowerTransportPdu.source
        self.destination = lowerTransportPdu.destination
        self.transportPdu = lowerTransportPdu.transportPdu
        self.ttl = ttl
        self.sequence = sequence
        
        let iviNid = (ivi << 7) | (nid & 0x7F)
        let ctlTtl = (type.rawValue << 7) | (ttl & 0x7F)
        
        // Data to be obfuscated: CTL/TTL, Sequence Number, Source Address.
        let seq = (Data() + sequence.bigEndian).dropFirst()
        let deobfuscatedData = Data() + ctlTtl + seq + source.bigEndian
        
        // Data to be encrypted: Destination Address, Transport PDU.
        let decryptedData = Data() + destination.bigEndian + transportPdu
        
        // The key set used for encryption depends on the Key Refresh Phase.
        let keys = networkKey.transmitKeys
        
        let helper = OpenSSLHelper()
        var nonce = Data([pduType.nonceId]) + deobfuscatedData + Data([0x00, 0x00]) + index.bigEndian
        if case .proxyConfiguration = pduType {
            nonce[1] = 0x00 // Pad
        }
        let encryptedData = helper.calculateCCM(decryptedData,
                                                withKey: keys.encryptionKey,
                                                nonce: nonce,
                                                andMICSize: type.netMicSize,
                                                withAdditionalData: nil)!
        let obfuscatedData = helper.obfuscate(deobfuscatedData,
                                              usingPrivacyRandom: encryptedData, ivIndex: index,
                                              andPrivacyKey: keys.privacyKey)!
        
        self.pdu = Data() + iviNid + obfuscatedData + encryptedData
    }
    
    /// This method goes over all Network Keys in the mesh network and tries
    /// to deobfuscate and decode the network PDU.
    ///
    /// - parameter pdu:         The received PDU.
    /// - parameter type:        The type of the PDU: `.networkPdu` of `.proxyConfiguration`.
    /// - parameter meshNetwork: The mesh network for which the PDU should be decoded.
    /// - returns: The deobfuscated and decoded Network PDU, or `nil` if the PDU was not
    ///            signed with any of the Network Keys, the IV Index was not valid, or the
    ///            PDU was invalid.
    static func decode(_ pdu: Data, ofType type: PduType, for meshNetwork: MeshNetwork) -> NetworkPdu? {
        for networkKey in meshNetwork.networkKeys {
            if let networkPdu = NetworkPdu(decode: pdu, ofType: type, usingNetworkKey: networkKey) {
                return networkPdu
            }
        }
        return nil
    }
}

private extension PduType {
    
    var nonceId: UInt8 {
        switch self {
        case .networkPdu:
            return 0x00
        case .proxyConfiguration:
            return 0x03
        default:
            fatalError("Unsupported PDU Type: \(self)")
        }
    }
    
}

private extension LowerTransportPduType {
    
    var netMicSize: UInt8 {
        switch self {
        case .accessMessage:  return 4 // 32 bits
        case .controlMessage: return 8 // 64 bits
        }
    }
    
}

extension NetworkPdu: CustomDebugStringConvertible {
    
    var debugDescription: String {
        let micSize = Int(type.netMicSize)
        let encryptedDataSize = pdu.count - micSize - 9
        let encryptedData = pdu.subdata(in: 9..<9 + encryptedDataSize)
        let mic = pdu.advanced(by: 9 + encryptedDataSize)
        return "Network PDU (ivi: \(ivi), nid: 0x\(nid.hex), ctl: \(type.rawValue), ttl: \(ttl), seq: \(sequence), src: \(source.hex), dst: \(destination.hex), transportPdu: 0x\(encryptedData.hex), netMic: 0x\(mic.hex))"
    }
    
}
